import 'package:birdart/widget/app_bars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../tianditu/tianditu.dart';

class TrackMapPage extends StatelessWidget {
  TrackMapPage({super.key, required this.layer});

  final List<Widget> tileList = TianDiTu.vecTile;
  final PolylineLayer layer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: anAppBar(),
      body: FlutterMap(
        options: MapOptions(
          bounds: boundEnlarge(layer.polylines[0].boundingBox, 0.075),
          maxZoom: 18.0,
          minZoom: 2,
          interactiveFlags: InteractiveFlag.pinchZoom |
          InteractiveFlag.drag |
          InteractiveFlag.doubleTapZoom,
        ),
        children: [
          ...tileList,
          layer,
        ],
      ),
    );
  }
  
  LatLngBounds boundEnlarge(LatLngBounds bound, double scale){
    return LatLngBounds(
      LatLng(
          bound.north + scale * (bound.north - bound.south),
          bound.west - scale * (bound.east - bound.west)),
      LatLng(
          bound.south - scale * (bound.north - bound.south),
          bound.east + scale * (bound.east - bound.west)
      ),
    );
  }
}
