import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File, Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geoxml/geoxml.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:objectid/objectid.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../db/db_manager.dart';
import '../db/track.dart';
import '../db/on_db.dart';
import '../entity/app_dir.dart';
import '../entity/server.dart';
import '../entity/color_scheme.dart';
import '../tool/track_tool.dart';
import '../widget/app_bars.dart';
import '../widget/track_circle_animation.dart';

class TrackPage extends StatefulWidget {
  const TrackPage({Key? key}) : super(key: key);

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`
  late Future _future;
  OnDb db = DbManager.db;

  @override
  void initState() {
    _future = db.trackDao.getAll();
    permissionCheck();
    super.initState();
  }

  androidBatteryCheck() {
    if (Platform.isAndroid) {
      OptimizeBattery.isIgnoringBatteryOptimizations().then((onValue) {
        if (!onValue) {
          showDialog(
            context: context,
            builder: (dContext) {
              return AlertDialog(
                title: const Text('忽略电池优化'),
                content: const Text(
                    '轨迹记录功能需要应用保持后台运行，如要继续使用，请忽略电池优化，如您的手机对应用有其它后台运行限制，请手动关闭。'),
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
                      OptimizeBattery.openBatteryOptimizationSettings();
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
    await permissionRequester(Permission.notification, '通知权限', '发送通知以保持后台运行');
    await permissionRequester(Permission.locationAlways, '后台定位权限', '应用保持后台定位');
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
                    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: anAppBar(
        title: const Text('轨迹记录'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          if (TrackTool.subscription != null) {
            showDialog(
                context: context,
                builder: (dContext) => AlertDialog(
                  title: const Text('结束轨迹记录'),
                  content:
                  const Text('轨迹记录在后台运行中，点击结束轨迹记录，结束后可将其上传至服务器。'),
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
                  content: const Text(
                      '即将开始轨迹记录，轨迹记录服务将在后台持续运行，轨迹记录结束后可将其上传至服务器。'),
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
        child: Icon(TrackTool.subscription == null ? Icons.play_arrow : Icons.stop),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            if (TrackTool.subscription != null) getOngoingTrackCard(),
            Expanded(
                child: FutureBuilder(
                  future: _future,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final tracks = snapshot.data;
                      if (tracks != null) {
                        return ListView.builder(
                            itemCount: tracks.length,
                            itemBuilder: (context, index) =>
                                getTrackItem(tracks[index]));
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
                TextButton(onPressed: () {}, child: const Text('点击查看已记录轨迹'))
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
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timeline_rounded,
                      color: accentColor,
                    ),
                    Expanded(
                      child: Text(
                        track.id.hexString,
                        style: TextStyle(fontSize: 14, color: accentColor),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.cloud_upload_rounded,
                      color: accentColor,
                    ),
                    Expanded(
                      child: Text(
                        track.sync ? '已上传' : '未上传',
                        style: TextStyle(fontSize: 14, color: accentColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget getBottom(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10.0,
            offset: Offset(0, 5.0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // 将空白空间均匀地分配在子组件之间和两端
        children: [
          getBottomItem(Icons.timeline_rounded, accentColor, '开始轨迹记录', () {
          }),
          getBottomItem(Icons.stop_circle_rounded, Colors.red, '结束轨迹记录', () {
            if (TrackTool.subscription != null) {

            } else {
              showDialog(
                  context: context,
                  builder: (dContext) => AlertDialog(
                        title: const Text('结束轨迹记录'),
                        content: const Text('轨迹记录未在后台运行。'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(dContext);
                              },
                              child: const Text('取消')),
                        ],
                      ));
            }
          }),
          getBottomItem(Icons.cloud_upload_rounded, Colors.purple, '上传轨迹', () {
            uploadTrack();
          }),
        ],
      ),
    );
  }

  uploadTrack() => db.trackDao.getUnsynced().then((list) {
        for (var track in list) {
          Dio dio = Server.dio;

          var formData = FormData();

          for (var entry in track.toJson().entries) {
            formData.fields.add(MapEntry(entry.key, entry.value.toString()));
          }

          formData.files.add(MapEntry(
              'kml',
              MultipartFile.fromBytes(
                File(track.file).readAsBytesSync(),
                filename: track.file.split('/').last.split('\\').last,
              )));

          // Send the FormData object to the server using dio.post method
          dio.post(
            '/user/track/save',
            data: formData,
            onSendProgress: (int sent, int total) {
              if (kDebugMode) {
                print('$sent/$total');
              }
            },
          ).then((response) {
            if (response.statusCode == 200) {
              Map<String, dynamic> data = jsonDecode(response.toString());
              if (data['success'] = true) {
                track.sync = true;
                db.trackDao.insertOne(track);
                Fluttertoast.showToast(msg: '轨迹${track.id.hexString}上传成功');
                setState(() {
                  _future = db.trackDao.getAll();
                });
                return;
              }
            }
            Fluttertoast.showToast(msg: '轨迹上传失败');
          });
        }
      });

  Widget getBottomItem(
      IconData icon, Color color, String text, Function onTap) {
    return InkWell(
      onTap: () {
        onTap.call();
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          Text(text),
        ],
      ),
    );
  }

  Future<LocationSettings> getLocationSettings() async {
    var prefs = await SharedPreferences.getInstance();
    int interval = prefs.getInt('track_interval') ?? 10;
    if (kDebugMode) {
      interval = 1;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final availability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability();
      return AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 1,
          forceLocationManager:
              availability != GooglePlayServicesAvailability.success,
          intervalDuration: Duration(seconds: interval),
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "正在运行后台轨迹记录",
            notificationTitle: "园林卫士",
            notificationIcon: AndroidResource(name: 'ic_map'),
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
    TrackTool.track = Track.empty();
    TrackTool.track.id = ObjectId();

    TrackTool.geoxml = GeoXml();
    TrackTool.geoxml.creator = 'Wuhan Plant Protection';
    TrackTool.geoxml.wpts = [];
    TrackTool.subscription = Geolocator.getPositionStream(
            locationSettings: await getLocationSettings())
        .listen((Position locationData) async {
      DateTime? time;
      if (locationData.timestamp != null) {
        time = locationData.timestamp;
      }
      if (kDebugMode) {
        print(time);
      }
      // create gpx object
      TrackTool.geoxml.wpts.add(Wpt(
        lat: locationData.latitude,
        lon: locationData.longitude,
        ele: locationData.altitude,
        time: time,
      ));
      if (TrackTool.track.startTime.millisecondsSinceEpoch == 0) {
        TrackTool.track.startLat = locationData.latitude;
        TrackTool.track.startLon = locationData.longitude;
        TrackTool.track.startEle = locationData.altitude;
        TrackTool.track.startTime = time ?? DateTime.now();
      }

      TrackTool.track.endLat = locationData.latitude;
      TrackTool.track.endLon = locationData.longitude;
      TrackTool.track.endEle = locationData.altitude;
      TrackTool.track.endTime = time ?? DateTime.now();
      TrackTool.track.pointCount++;
    });

    if (mounted) {
      setState(() {
        TrackTool.subscription;
      });
    }
  }

  endTrack() async {
    final subscription = TrackTool.subscription;
    if (subscription != null) {
      await subscription.cancel();
      TrackTool.subscription = null;
      if (mounted) {
        setState(() {
          TrackTool.subscription;
        });
      }
      if (TrackTool.track.pointCount == 0) {
        Fluttertoast.showToast(msg: '轨迹记录期间未收到任何位置信息，请检查定位服务。');
        return;
      }
      var gpxString = TrackTool.geoxml.toGpxString(pretty: true);
      TrackTool.track.file = path.join(
        AppDir.data.path,
        'files',
        '${TrackTool.track.id.hexString}.gpx',
      );
      final file = File(TrackTool.track.file);
      Directory parent = file.parent;
      if (!await parent.exists()) {
        await parent.create(recursive: true);
      }
      await file.create();
      file.writeAsStringSync(gpxString);
      await db.trackDao.insertOne(TrackTool.track);
      setState(() {
        _future = db.trackDao.getAll();
      });
    }
  }
}
