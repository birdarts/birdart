import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

// Merge service unavailability to LocationPermission.unableToDetermine
Future<LocationPermission> locationAvailabilityChecker(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location services are disabled. Please enable the services')));
    return LocationPermission.unableToDetermine;
  }

  if (!serviceEnabled) {
    return LocationPermission.unableToDetermine;
  }

  LocationPermission locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions.')));      }
      return locationPermission;
    }
  }

  if (locationPermission == LocationPermission.deniedForever && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return locationPermission;
  }

  return locationPermission;
}

Future<Position?> getCurrentLocation(BuildContext context) async {
  final locationAvailable = await locationAvailabilityChecker(context);
  if (locationAvailable.isFalse()) {
    return null;
  }

  return await Geolocator.getCurrentPosition(
    forceAndroidLocationManager: true,
  );
}

extension ToBool on LocationPermission {
  isTrue() {
    return [
      LocationPermission.whileInUse,
      LocationPermission.denied,
    ].contains(this);
  }

  isFalse() {
    return [
      LocationPermission.denied,
      LocationPermission.deniedForever,
      LocationPermission.unableToDetermine,
    ].contains(this);
  }
}
