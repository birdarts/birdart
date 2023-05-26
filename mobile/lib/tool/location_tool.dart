import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_availability/google_api_availability.dart';

Future<bool> locationAvailabilityChecker(BuildContext context) async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location services are disabled. Please enable the services')));
    return false;
  }

  if (!serviceEnabled) {
    return false;
  }

  LocationPermission locationPermission = await Geolocator.checkPermission();
  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
    if (locationPermission == LocationPermission.denied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
      }
      return false;
    }
  }

  if (locationPermission == LocationPermission.deniedForever &&
      context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.')));
    return false;
  }

  return true;
}

Future<Position?> getCurrentLocation(BuildContext context) async {
  final locationAvailable = await locationAvailabilityChecker(context);
  if (!locationAvailable) {
    return null;
  }
  final availability = await GoogleApiAvailability.instance
      .checkGooglePlayServicesAvailability();

  return await Geolocator.getCurrentPosition(
    forceAndroidLocationManager:
        availability != GooglePlayServicesAvailability.success,
  );
}
