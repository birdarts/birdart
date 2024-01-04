import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:google_api_availability/google_api_availability.dart';

class DeviceTool {
  bool? _isWahway;

  Future<bool> get isWahway async {
    if (_isWahway == null) {
      if (Platform.isAndroid) {
        final brand = (await DeviceInfoPlugin().androidInfo).brand.toLowerCase();
        _isWahway = brand == "huawei" || brand == "honor";
      } else {
        _isWahway = false;
      }
    }

    return _isWahway!;
  }

  bool? _isGoogleAval;

  Future<bool> get isGoogleAval async {
    // Some Huawei devices will return success for unknown reasons, even though they do not have GMS.
    _isGoogleAval ??= await GoogleApiAvailability.instance.checkGooglePlayServicesAvailability() ==
        GooglePlayServicesAvailability.success;

    return (await isWahway) || !_isGoogleAval!;
  }
}
