import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:geolocator/geolocator.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../entity/sharedpref.dart';
import '../pages/track_page.dart';
import '../tianditu/tianditu.dart';
import '../tool/coordinator_tool.dart';
import '../tool/location_tool.dart';
import '../widget/location_marker_layer.dart';

class MapFragment extends StatefulWidget {
  const MapFragment({Key? key}) : super(key: key);

  @override
  State<MapFragment> createState() => _MapFragmentState();
}

class _MapFragmentState extends State<MapFragment>
    with AutomaticKeepAliveClientMixin {
  static const _edgeInsets = EdgeInsets.fromLTRB(8, 8, 8, 8);
  var _locationText = '经度: \n纬度: \n海拔: ';
  List<Widget> tileList = TianDiTu.vecTile;
  final MapController _mapController = MapController();
  LocationMarker _currentLocationLayer = const LocationMarker(
    locationData: null,
  );
  final prefs = Shared.pref;
  StreamSubscription? subscription;

  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`

  @override
  void initState() {
    _getMapStates();

    _getCurrentLocation(context, animate: true);
    startSubscription();
    super.initState();
  }

  Future<LocationSettings> getLocationSettings() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final availability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability();
      return AndroidSettings(
        forceLocationManager:
        availability != GooglePlayServicesAvailability.success,
      );
    } else {
      return const LocationSettings();
    }
  }

  startSubscription() async {
    subscription = Geolocator.getPositionStream(
        locationSettings: await getLocationSettings())
        .listen((position) {
      _setMapLocation(position);
    });
  }

  stopSubscription() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  Future<void> dispose() async {
    // onDestroy()
    //something.dispose();
    if (kDebugMode) {
      print("dispose");
    }
    stopSubscription();
    LatLng center = _mapController.center;
    double zoom = _mapController.zoom;
    Position? locationData = _currentLocationLayer.locationData;
    await _saveMapStates(center, zoom, locationData);
    super.dispose();
  }

  Future<void> _saveMapStates(
      LatLng center, double zoom, Position? locationData) async {
    if (locationData != null) {
      final prefs = Shared.pref!;

      await prefs.setDouble('center_latitude', center.latitude);
      await prefs.setDouble('center_longitude', center.longitude);
      await prefs.setDouble('zoom', zoom);
      await prefs.setDouble('latitude', locationData.latitude);
      await prefs.setDouble('longitude', locationData.longitude);
      await prefs.setDouble('heading', locationData.heading);
    }
  }

  void _getMapStates() {
    try {
      _mapController.move(
          LatLng(prefs.getDouble('center_latitude')!,
              prefs.getDouble('center_longitude')!),
          prefs.getDouble('zoom')!);
    } catch (e) {
      log(e.toString());
    }
    _setMapLocation(Position.fromMap({
      'latitude': prefs.getDouble('latitude') ?? 0.0,
      'longitude': prefs.getDouble('longitude') ?? 0.0,
      'heading': prefs.getDouble('heading') ?? 0.0
    }));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FlutterMap(
      options: MapOptions(
        center: LatLng(30, 120),
        zoom: 10,
        maxZoom: 18.0,
        minZoom: 2,
        keepAlive: true,
        rotation: 0,
        interactiveFlags: InteractiveFlag.pinchZoom |
        InteractiveFlag.drag |
        InteractiveFlag.doubleTapZoom,
        onPositionChanged: (MapPosition position, bool hasGesture) {},
      ),
      mapController: _mapController,
      nonRotatedChildren: [
        const RichAttributionWidget(attributions: [TextSourceAttribution('天地图')],),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 15, 0),
          alignment: Alignment.topRight,
          child: FloatingActionButton.small(
            heroTag: Icons.my_location_outlined,
            backgroundColor: Colors.white,
            onPressed: () => {_getCurrentLocation(context, animate: true)},
            shape: const CircleBorder(),
            child: const IconTheme(
              data: IconThemeData(color: Colors.black54),
              child: Icon(Icons.my_location_outlined),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 75, 15, 0),
          alignment: Alignment.topRight,
          child: PopupMenuButton<List<Widget>>(
            // Callback that sets the selected popup menu item.
              onSelected: (List<Widget> list) {
                setState(() {
                  tileList = list;
                });
              },
              child: const FloatingActionButton.small(
                heroTag: Icons.layers_outlined,
                backgroundColor: Colors.white,
                onPressed: null,
                shape: CircleBorder(),
                child: IconTheme(
                  data: IconThemeData(color: Colors.black54),
                  child: Icon(Icons.layers_outlined),
                ),
              ),
              itemBuilder: (BuildContext context) =>
              <PopupMenuEntry<List<Widget>>>[
                PopupMenuItem<List<Widget>>(
                  value: TianDiTu.vecTile,
                  child: const Text('街道图'),
                ),
                PopupMenuItem<List<Widget>>(
                  value: TianDiTu.imgTile,
                  child: const Text('卫星图'),
                ),
              ]),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 130, 15, 0),
          alignment: Alignment.topRight,
          child: FloatingActionButton.small(
            heroTag: Icons.timeline_rounded,
            backgroundColor: Colors.white,
            onPressed: () {
              stopSubscription();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrackPage()))
                  .then((value) => startSubscription());
            },
            shape: const CircleBorder(),
            child: const IconTheme(
              data: IconThemeData(color: Colors.black54),
              child: Icon(Icons.timeline_rounded),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70, borderRadius: BorderRadius.circular(8)),
            padding: _edgeInsets,
            margin: _edgeInsets,
            transformAlignment: Alignment.bottomLeft,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              direction: Axis.vertical,
              children: [
                Text(
                  _locationText,
                  textAlign: TextAlign.left,
                  key: const Key('location_text'),
                ),
              ],
            ),
          ),
        ),
      ],
      children: [
        ...tileList,
        _currentLocationLayer,
      ],
    );
  }

  void _setMapLocation(Position locationData, {animate = false}) {
    setState(() => {
      _locationText =
      '经度: ${CoordinateTool().degreeToDms(locationData.longitude.toString())}\n'
          '纬度: ${CoordinateTool().degreeToDms(locationData.latitude.toString())}\n'
          '海拔: ${locationData.altitude.toStringAsFixed(3)}',
      _currentLocationLayer = LocationMarker(locationData: locationData),
      if (animate)
        {
          _mapController.move(
              LatLng(locationData.latitude, locationData.longitude), 15)
        }
    });
  }

  Future<void> _getCurrentLocation(BuildContext context,
      {animate = false}) async {
    Position? locationData = await getCurrentLocation(context);
    if (locationData != null) {
      _setMapLocation(locationData, animate: animate);
    }
  }
}
