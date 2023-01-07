import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:location/location.dart';
import 'package:naturalist/view/triangle_clipper.dart';

class LocationMarker extends StatefulWidget {
  const LocationMarker({Key? key, required this.locationData})
      : super(key: key);
  final LocationData? locationData;

  @override
  State<LocationMarker> createState() => _LocationMarkerState();
}

class _LocationMarkerState extends State<LocationMarker> {
  @override
  Widget build(BuildContext context) {
    var locationData = widget.locationData;
    if (locationData == null ||
        locationData.latitude == null ||
        locationData.longitude == null ||
        locationData.heading == null) {
      return Container();
    }
    return MarkerLayer(
      markers: [
        Marker(
          point: LatLng(locationData.latitude!, locationData.longitude!),
          builder: (context) => Transform.rotate(
            angle: 180 + locationData.heading!,
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
