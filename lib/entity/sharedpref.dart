import 'package:shared_preferences/shared_preferences.dart';

class Shared {
  static SharedPreferences? _pref;

  static init() async {
    _pref = await SharedPreferences.getInstance();
  }

  static get pref => _pref!;

  static bool get inited => _pref != null;
}
