import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:naturalist/view/triangle_clipper.dart';

class LocationMarker extends StatefulWidget {
  const LocationMarker({Key? key, required this.position}) : super(key: key);
  final Position? position;

  @override
  State<LocationMarker> createState() => _LocationMarkerState();
}

class _LocationMarkerState extends State<LocationMarker> {
  @override
  Widget build(BuildContext context) {
    var position = widget.position;
    if (position == null) {
      return Container();
    }
    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(position.latitude, position.longitude),
          builder: (context) => Transform.rotate(
            angle: 180 + position.heading,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  width: 15,
                  height: 15,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 10,
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 23,
                  child: ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      color: Colors.blueAccent,
                      height: 7,
                      width: 7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
