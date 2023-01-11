import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefManager {
  static SharedPreferences? pref;
  SharedPreferences get() {
    return pref!;
  }

  static init() async {
    pref = await SharedPreferences.getInstance();
  }
}
