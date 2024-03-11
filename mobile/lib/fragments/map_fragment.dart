import 'dart:async';
import 'dart:developer';

import 'package:birdart/tool/device_tool.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Suitable for most situations
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' show LatLng;

import '../l10n/l10n.dart';
import '../entity/sharedpref.dart';
import '../map_util/birdart_tiles.dart';
import '../tool/coordinator_tool.dart';
import '../tool/location_tool.dart';
import '../widget/location_marker_layer.dart';

class MapFragment extends StatefulWidget {
  const MapFragment({super.key});

  @override
  State<MapFragment> createState() => _MapFragmentState();
}

class _MapFragmentState extends State<MapFragment>
    with AutomaticKeepAliveClientMixin {
  static const _edgeInsets = EdgeInsets.fromLTRB(8, 8, 8, 8);
  var _locationText = BdL10n.current.mapCoordinate('', '', '');
  late TilesGetter tileList;
  final MapController _mapController = MapController();

  LocationMarker _currentLocationLayer = const LocationMarker(
    locationData: null,
  );
  final prefs = SharedPref.pref;
  StreamSubscription? subscription;

  @override
  bool get wantKeepAlive => true; // this is must

  @override
  void initState() {
    tileList = BirdartTiles.vecTile;

    // _getMapStates();

    _getCurrentLocation(context, animate: true);
    startSubscription();
    super.initState();
  }

  Future<LocationSettings> getLocationSettings() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidSettings(
        forceLocationManager: await DeviceTool().isGoogleAval,
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
    LatLng center = _mapController.camera.center;
    double zoom = _mapController.camera.zoom;
    Position? locationData = _currentLocationLayer.locationData;
    await _saveMapStates(center, zoom, locationData);
    super.dispose();
  }

  Future<void> _saveMapStates(
      LatLng center, double zoom, Position? locationData) async {
    if (locationData != null) {
      final prefs = SharedPref.pref!;

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
          LatLng(prefs.getDouble('center_latitude') ?? 0.0,
              prefs.getDouble('center_longitude') ?? 0.0),
          prefs.getDouble('zoom') ?? 4);
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
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

    return Scaffold(
      appBar: AppBar(
        title: Text(BdL10n.current.exploreTitle),
        //bottom: const PreferredSize(
        //  preferredSize: Size.zero,
        //  child: Text("Title 2", style: TextStyle(color: Colors.white),)
        //),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(0, 0),
          initialZoom: 4,
          maxZoom: 18.0,
          minZoom: 2,
          cameraConstraint: const CameraConstraint.unconstrained(),
          keepAlive: true,
          initialRotation: 0,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag | InteractiveFlag.doubleTapZoom,
          ),
          onPositionChanged: (MapPosition position, bool hasGesture) {},
          backgroundColor: Colors.transparent,
        ),
        mapController: _mapController,
        children: [
          // rotated children
          ...tileList.call(context),
          _currentLocationLayer,
          // non-rotated children
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(BdL10n.current.mapNameTDT),
              TextSourceAttribution(BdL10n.current.mapNameOSM),
            ],
          ),
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
            child: PopupMenuButton<TilesGetter>(
                // Callback that sets the selected popup menu item.
                onSelected: (TilesGetter list) {
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
                    <PopupMenuEntry<TilesGetter>>[
                      PopupMenuItem<TilesGetter>(
                        value: BirdartTiles.vecTile,
                        child: Text(BdL10n.current.mapNameTDT),
                      ),
                      PopupMenuItem<TilesGetter>(
                        value: BirdartTiles.imgTile,
                        child: Text(BdL10n.current.mapNameSat),
                      ),
                      PopupMenuItem<TilesGetter>(
                        value: BirdartTiles.osmTile,
                        child: Text(BdL10n.current.mapNameOSM),
                      ),
                      PopupMenuItem<TilesGetter>(
                        value: BirdartTiles.agolTile,
                        child: Text(BdL10n.current.mapNameAgol),
                      ),
                      PopupMenuItem<TilesGetter>(
                        value: BirdartTiles.stamenTerrain,
                        child: Text(BdL10n.current.mapNameStamenTerrain),
                      ),
                    ]),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(8)),
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
      ),
    );
  }

  void _setMapLocation(Position locationData, {animate = false}) {
    setState(() {
          _locationText = BdL10n.current.mapCoordinate(
              CoordinateTool.degreeToDms(locationData.longitude.toString()),
              CoordinateTool.degreeToDms(locationData.latitude.toString()),
              locationData.altitude.toStringAsFixed(3));
          _currentLocationLayer = LocationMarker(locationData: locationData);
          if (animate)
            {
              _mapController.move(
                  LatLng(locationData.latitude, locationData.longitude), 15);
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
