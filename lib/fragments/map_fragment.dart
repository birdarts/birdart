import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:naturalist/entity/tianditu.dart';
import 'package:naturalist/view/location_marker_layer.dart';

class MapFragment extends StatefulWidget {
  MapFragment({Key? key}) : super(key: key);

  Stream<Position> positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  ));

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
    position: null,
  );

  @override
  bool get wantKeepAlive => true; // 覆写`wantKeepAlive`返回`true`

  @override
  void initState() {
    widget.positionStream.listen((Position position) {
      setState(() => {
            _locationText = '经度: ${position.longitude.toStringAsFixed(6)}\n'
                '纬度: ${position.latitude.toStringAsFixed(6)}\n'
                '海拔: ${position.altitude.toStringAsFixed(3)}',
            _currentLocationLayer = LocationMarker(position: position),
          });
    });
    super.initState();
  }

  @override
  void dispose() {
    // onDestroy()
    //something.dispose();
    super.dispose();
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
            // Your logic here. `hasGesture` dictates whether the change
            // was due to a user interaction or something else. `position` is
            // the new position of the map.
          }),
      mapController: _mapController,
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(source: '天地图'),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 15, 0),
          alignment: Alignment.topRight,
          child: FloatingActionButton.small(
            backgroundColor: Colors.white,
            onPressed: () => {_getCurrentPosition(context, animate: true)},
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

  Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition(BuildContext context,
      {animate = false}) async {
    final hasPermission = await _handleLocationPermission(context);

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => {
            _locationText = '经度: ${position.longitude.toStringAsFixed(6)}\n'
                '纬度: ${position.latitude.toStringAsFixed(6)}\n'
                '海拔: ${position.altitude.toStringAsFixed(3)}',
            _currentLocationLayer = LocationMarker(
              position: position,
            ),
            if (animate)
              {
                _mapController.move(
                    LatLng(position.latitude, position.longitude), 15)
              }
          });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
