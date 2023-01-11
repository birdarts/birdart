import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:location/location.dart';
import 'package:naturalist/entity/shared_pref_manager.dart';
import 'package:naturalist/entity/tianditu.dart';
import 'package:naturalist/view/location_marker_layer.dart';

class MapFragment extends StatefulWidget {
  MapFragment({Key? key}) : super(key: key);

  Location location = Location();

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
  final prefs = SharedPrefManager.pref!;

  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`

  @override
  void initState() {
    _getMapStates();

    _getCurrentLocation(context, animate: true);

    //widget.location.enableBackgroundMode(enable: true);

    widget.location.onLocationChanged.listen((LocationData locationData) {
      _setMapLocation(locationData);
    });

    super.initState();
  }

  @override
  Future<void> dispose() async {
    // onDestroy()
    //something.dispose();
    print("dispose");
    LatLng center = _mapController.center;
    double zoom = _mapController.zoom;
    LocationData? locationData = _currentLocationLayer.locationData;
    await _saveMapStates(center, zoom, locationData);
    super.dispose();
  }

  Future<void> _saveMapStates(LatLng center, double zoom, LocationData? locationData) async {
    if (locationData != null &&
        locationData.latitude != null &&
        locationData.longitude != null &&
        locationData.heading != null){
      final prefs = SharedPrefManager.pref!;

      await prefs.setDouble('center_latitude', center.latitude);
      await prefs.setDouble('center_longitude', center.longitude);
      await prefs.setDouble('zoom', zoom);
      await prefs.setDouble('latitude', locationData.latitude!);
      await prefs.setDouble('longitude', locationData.longitude!);
      await prefs.setDouble('heading', locationData.heading!);
    }
  }

  void _getMapStates() {
    try {
      _mapController.move(LatLng(prefs.getDouble('center_latitude')!, prefs.getDouble('center_longitude')!), prefs.getDouble('zoom')!);
    } catch (e){
      log(e.toString());
    }
    _setMapLocation(LocationData.fromMap({
      'latitude': prefs.getDouble('latitude'), 'longitude': prefs.getDouble('longitude'), 'heading': prefs.getDouble('heading')
    }));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FlutterMap(
      options: MapOptions(
          center: LatLng(0, 120),
          zoom: 2,
          maxZoom: 18.0,
          minZoom: 2,
          maxBounds: LatLngBounds(
            LatLng(-90, -180),
            LatLng(90, 180),
          ),
          keepAlive: true,
          rotation: 0,
          interactiveFlags: InteractiveFlag.pinchZoom |
              InteractiveFlag.drag |
              InteractiveFlag.doubleTapZoom,
          onPositionChanged: (MapPosition position, bool hasGesture) {

          },
      ),
      mapController: _mapController,
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(source: '天地图'),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 15, 0),
          alignment: Alignment.topRight,
          child: FloatingActionButton.small(
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
                    PopupMenuItem<List<Widget>>(
                      value: TianDiTu.terTile,
                      child: const Text('地形图'),
                    ),
                  ]),
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
        tileList[0],
        tileList[1],
        _currentLocationLayer,
      ],
    );
  }

  void _setMapLocation(LocationData locationData, {animate = false}) {
    setState(() => {
          if (locationData.latitude != null &&
              locationData.longitude != null &&
              locationData.heading != null)
            {
              _locationText =
                  '经度: ${locationData.longitude?.toStringAsFixed(6)}\n'
                      '纬度: ${locationData.latitude?.toStringAsFixed(6)}\n'
                      '海拔: ${locationData.altitude?.toStringAsFixed(3)}',
              _currentLocationLayer =
                  LocationMarker(locationData: locationData),
              if (animate)
                {
                  _mapController.move(
                      LatLng(locationData.latitude!, locationData.longitude!),
                      15)
                }
            }
        });
  }

  Future<bool> _locationAvailabilityChecker() async {
    bool serviceEnabled = await widget.location.serviceEnabled();
    if (!serviceEnabled && mounted) {
      return false;
    }
    if (!serviceEnabled) {
      serviceEnabled = await widget.location.requestService();
      if (!serviceEnabled && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location services are disabled. Please enable the services')));
        return false;
      }
    }

    PermissionStatus permission = await widget.location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await widget.location.requestPermission();
      if (permission == PermissionStatus.denied && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }

    if (permission == PermissionStatus.grantedLimited) {
      permission = await widget.location.requestPermission();
      if (permission == PermissionStatus.grantedLimited && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('High accuracy location permissions are denied')));
        return false;
      }
    }

    if (permission == PermissionStatus.deniedForever && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }

    return true;
  }

  Future<void> _getCurrentLocation(BuildContext context,
      {animate = false}) async {
    final locationAvailable = await _locationAvailabilityChecker();
    if (!locationAvailable) return;

    LocationData locationData = await Location().getLocation();
    _setMapLocation(locationData, animate: animate);
  }
}
