import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File, Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoxml/geoxml.dart';
import 'package:latlong2/latlong.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared/shared.dart';

import '../entity/user_profile.dart';
import '../pages/track_map_page.dart';
import '../db/db_manager.dart';
import '../db/on_db.dart';
import '../entity/app_dir.dart';
import '../l10n/l10n.dart';
import 'coordinator_tool.dart';
import 'device_tool.dart';
import 'location_tool.dart';
import '../widget/track_circle_animation.dart';

class Tracker {
  Tracker({required this.context}) {
    _future = db.trackDao.getAll();
    permissionCheck();
  }

  late Future _future;
  OnDb db = DbManager.db;
  BuildContext context;

  StreamSubscription? subscription;
  GeoXml geoxml = GeoXml();
  Track track = Track.empty(UserProfile.id);

  bool get mounted => context.mounted;
  VoidCallback? callback;

  androidBatteryCheck() {
    if (Platform.isAndroid) {
      OptimizeBattery.isIgnoringBatteryOptimizations().then((onValue) {
        if (!onValue) {
          showDialog(
            context: context,
            builder: (dContext) {
              return AlertDialog(
                title: const Text('忽略电池优化'),
                content: const Text('轨迹记录功能需要应用保持后台运行，如要继续使用，请忽略电池优化，如您的手机对应用有其它后台运行限制，请手动关闭。'),
                actions: [
                  TextButton(
                    child: const Text('取消'),
                    onPressed: () {
                      Navigator.pop(dContext);
                    },
                  ),
                  TextButton(
                    child: const Text('确认'),
                    onPressed: () async {
                      Navigator.pop(dContext);
                      if (await DeviceTool().isGoogleAval) {
                        OptimizeBattery.openBatteryOptimizationSettings();
                      } else {
                        OptimizeBattery.stopOptimizingBatteryUsage();
                      }
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  permissionCheck() async {
    if (Platform.isAndroid) {
      await permissionRequester(Permission.locationAlways, '后台定位权限', '应用保持后台定位');
      await permissionRequester(Permission.notification, '通知权限', '发送通知以保持后台运行');
      androidBatteryCheck();
    } else if (Platform.isIOS) {
      await permissionRequesterIos('后台定位权限', '应用保持后台定位');
    }
  }

  permissionRequesterIos(String name, String usage) async {
    final avail = await locationAvailabilityChecker(context);
    if (avail == LocationPermission.whileInUse) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (dContext) {
            return AlertDialog(
              title: Text(name),
              content: Text('轨迹记录功能需要$usage，如要继续使用，请授予$name。'),
              actions: [
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.pop(dContext);
                  },
                ),
                TextButton(
                  child: const Text('确认'),
                  onPressed: () {
                    Navigator.pop(dContext);
                    Geolocator.openLocationSettings();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  permissionRequester(Permission permission, String name, String usage) async {
    if (await permission.isDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (dContext) {
            return AlertDialog(
              title: Text(name),
              content: Text('轨迹记录功能需要$usage，如要继续使用，请授予$name。'),
              actions: [
                TextButton(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.pop(dContext);
                  },
                ),
                TextButton(
                  child: const Text('确认'),
                  onPressed: () {
                    Navigator.pop(dContext);
                    permission.request();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('轨迹记录'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (subscription != null) {
            showDialog(
                context: context,
                builder: (dContext) => AlertDialog(
                      title: const Text('结束轨迹记录'),
                      content: const Text('轨迹记录在后台运行中，点击结束轨迹记录，结束后可将其上传至服务器。'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(dContext);
                            },
                            child: const Text('取消')),
                        TextButton(
                            onPressed: () {
                              endTrack();
                              Navigator.pop(dContext);
                            },
                            child: const Text('结束')),
                      ],
                    ));
          } else {
            showDialog(
                context: context,
                builder: (dContext) => AlertDialog(
                      title: const Text('开始轨迹记录'),
                      content: const Text('即将开始轨迹记录，轨迹记录服务将在后台持续运行，轨迹记录结束后可将其上传至服务器。'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(dContext);
                            },
                            child: const Text('取消')),
                        TextButton(
                            onPressed: () {
                              startTrack();
                              Navigator.pop(dContext);
                            },
                            child: const Text('开始')),
                      ],
                    ));
          }
        },
        child: Icon(subscription == null ? Icons.play_arrow : Icons.stop),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            if (subscription != null) getOngoingTrackCard(),
            Expanded(
                child: FutureBuilder(
              future: _future,
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final tracks = snapshot.data;
                  if (tracks != null) {
                    return ListView.builder(
                        itemCount: tracks.length,
                        itemBuilder: (context, index) => getTrackItem(tracks[index]));
                  }
                  return const Center(child: Text('数据库错误'));
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget getOngoingTrackCard() => Card(
        child: Row(
          children: [
            const SizedBox(
              height: 120,
              width: 120,
              child: TrackCircleAnimation(),
            ),
            Column(
              children: [
                const Text('轨迹记录正在进行中'),
                TextButton(
                  onPressed: () {
                    List<LatLng> latlngList = List.generate(
                        geoxml.wpts.length,
                        (index) => LatLng(
                            geoxml.wpts[index].lat!, geoxml.wpts[index].lon!));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TrackMapPage(layer: getLayer(latlngList))));
                  },
                  child: const Text('查看已记录轨迹'),
                ),
              ],
            )
          ],
        ),
      );

  Widget getTrackItem(Track track) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timeline_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Expanded(
                      child: Text(
                        track.id.toString(),
                        style:
                            TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.cloud_upload_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Expanded(
                      child: Text(
                        track.sync ? '已上传' : '未上传',
                        style:
                            TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    final geoxml = await GeoXml.fromGpxStream(
                        File(track.file).openRead().transform(utf8.decoder));
                    List<LatLng> latlngList = List.generate(geoxml.wpts.length,
                        (index) => LatLng(geoxml.wpts[index].lat!, geoxml.wpts[index].lon!));
                    if (mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TrackMapPage(layer: getLayer(latlngList))));
                    }
                  },
                  child: const Text('查看已记录轨迹'),
                ),
              ],
            ),
          ),
        ),
      );

  Future<LocationSettings> getLocationSettings() async {
    var prefs = await SharedPreferences.getInstance();
    int interval = prefs.getInt('track_interval') ?? 10;
    if (kDebugMode) {
      interval = 1;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
          forceLocationManager: await DeviceTool().isGoogleAval,
          intervalDuration: Duration(seconds: interval),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationText: "正在运行后台轨迹记录",
            notificationTitle: BdL10n.current.appName,
            notificationIcon: const AndroidResource(name: 'ic_map'),
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      return AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 1,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: true,
      );
    } else {
      return const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      );
    }
  }

  startTrack() async {
    track = Track.empty(UserProfile.id);
    track.id = uuid.v1();

    geoxml = GeoXml();
    geoxml.creator = BdL10n.current.appName;
    geoxml.wpts = [];
    subscription =
        Geolocator.getPositionStream(locationSettings: await getLocationSettings())
            .listen((Position locationData) async {
      DateTime? time;
      time = locationData.timestamp;
      if (kDebugMode) {
        print(time);
      }
      // create gpx object
      geoxml.wpts.add(Wpt(
        lat: locationData.latitude,
        lon: locationData.longitude,
        ele: locationData.altitude,
        time: time,
      ));
      if (track.startTime.millisecondsSinceEpoch == 0) {
        track.startLat = locationData.latitude;
        track.startLon = locationData.longitude;
        track.startEle = locationData.altitude;
        track.startTime = time;
        track.distance = 0;
      } else {
        track.distance += CoordinateTool.distance(track.endLat,
            track.endLon, locationData.latitude, locationData.longitude);
      }

      track.endLat = locationData.latitude;
      track.endLon = locationData.longitude;
      track.endEle = locationData.altitude;
      track.endTime = time;
      track.pointCount++;

      callback?.call();
    });
  }

  endTrack() async {
    await subscription?.cancel();
    subscription = null;
    if (track.pointCount == 0) {
      Fluttertoast.showToast(msg: '轨迹记录期间未收到任何位置信息，请检查定位服务。');
      return;
    }
    var gpxString = geoxml.toGpxString(pretty: true);
    track.file = path.join(
      AppDir.data.path,
      'files',
      '${track.id.toString()}.gpx',
    );
    final file = File(track.file);
    Directory parent = file.parent;
    if (!await parent.exists()) {
      await parent.create(recursive: true);
    }
    file.create().then((value) {
      file.writeAsStringSync(gpxString);
      //Insert database records after saving the file
      db.trackDao.insertOne(track);
    });
  }
}

PolylineLayer getLayer(List<LatLng> latlngList) {
  return PolylineLayer(
    polylineCulling: true,
    polylines: [
      Polyline(
        points: latlngList,
        color: Colors.blue,
        strokeWidth: 3,
      ),
    ],
  );
}