import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geoxml/geoxml.dart';
import 'package:latlong2/latlong.dart';

import '../map_util/birdart_tiles.dart';

class HotspotSelectPage extends StatelessWidget {
  const HotspotSelectPage({super.key, required this.initLatLng});

  final Wpt initLatLng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track route preview'),
      ),
      body: FutureBuilder(
        future: getSpots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            final data = snapshot.data;
            if (data!= null) {
              return FlutterMap(
                options: MapOptions(
                  initialCameraFit: CameraFit.coordinates(
                    coordinates: data,
                    maxZoom: 15,
                    minZoom: 13,
                  ),
                  maxZoom: 18.0,
                  minZoom: 2,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag | InteractiveFlag.doubleTapZoom,
                  ),
                ),
                children: [
                  ...BirdartTiles.agolTile(context),
                  MarkerLayer(
                      markers: data.map((e) => Marker(point: e, child: Icon(Icons.add))).toList()
                  )
                ],
              );
            }
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  Future<List<LatLng>> getSpots() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      LatLng(initLatLng.lat! - Random().nextDouble() * 0.1, initLatLng.lon! - Random().nextDouble() * 0.1),
      LatLng(initLatLng.lat! - Random().nextDouble() * 0.1, initLatLng.lon! + Random().nextDouble() * 0.1),
      LatLng(initLatLng.lat! + Random().nextDouble() * 0.1, initLatLng.lon! + Random().nextDouble() * 0.1),
      LatLng(initLatLng.lat! + Random().nextDouble() * 0.1, initLatLng.lon! - Random().nextDouble() * 0.1),
    ];
  }
}
