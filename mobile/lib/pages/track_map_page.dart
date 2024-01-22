import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../map_util/birdart_tiles.dart';

class TrackMapPage extends StatelessWidget {
  const TrackMapPage({super.key, required this.layer});

  final PolylineLayer layer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track route preview'),
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCameraFit: CameraFit.bounds(
            bounds: boundEnlarge(layer.polylines[0].boundingBox, 0.075),
          ),
          maxZoom: 18.0,
          minZoom: 2,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag | InteractiveFlag.doubleTapZoom,
          ),
        ),
        children: [
          ...BirdartTiles.agolTile(context),
          layer,
        ],
      ),
    );
  }

  LatLngBounds boundEnlarge(LatLngBounds bound, double scale) {
    return LatLngBounds(
      LatLng(bound.north + scale * (bound.north - bound.south),
          bound.west - scale * (bound.east - bound.west)),
      LatLng(bound.south - scale * (bound.north - bound.south),
          bound.east + scale * (bound.east - bound.west)),
    );
  }
}
