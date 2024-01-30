import 'package:shared/src/uuid_gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../entity/sharedpref.dart';

class UserProfile {
  static String? _id;
  static String? _phone;
  static String? _password;
  static String? _email;
  static String? _name;
  static String _session = '';
  static String? _role;
  static int? _status;
  static int? _number;
  static int? _project;
  static int? _record;
  static int? _image;
  static int? _track;

  static late SharedPreferences _pref;
  static bool inited = false;

  static init() {
    _pref = SharedPref.pref;
    _id = _pref.getString('id') ?? uuid.v1(); // TODO remove `uuid.v1()` when the backend is ready
    _phone = _pref.getString('phone');
    _password = _pref.getString('password');
    _email = _pref.getString('email');
    _name = _pref.getString('name');
    _session = _pref.getString('session').toString();
    _role = _pref.getString('role');
    _status = _pref.getInt('status');
    _number = _pref.getInt('number');
    _project = _pref.getInt('project');
    _record = _pref.getInt('record');
    _image = _pref.getInt('image');
    _track = _pref.getInt('track');
    inited = true;
  }

  static get logged =>
      inited &&
      (_id != null) &&
      (_phone != null) &&
      (_password != null) &&
      (_email != null) &&
      (_name != null) &&
      (_role != null) &&
      (_status != null) &&
      (_number != null);

  static get hasData =>
      (_project != null) &&
      (_record != null) &&
      (_image != null) &&
      (_track != null);

  static set id(String value) {
    _id = value;
    _pref.setString('id', value.toString());
  }

  static set phone(String value) {
    _phone = value;
    _pref.setString('phone', value);
  }

  static set password(String value) {
    _password = value;
    _pref.setString('password', value);
  }

  static set email(String value) {
    _email = value;
    _pref.setString('email', value);
  }

  static set name(String value) {
    _name = value;
    _pref.setString('name', value);
  }

  static set session(String value) {
    _session = value;
    _pref.setString('session', value);
  }

  static set role(String value) {
    _role = value;
    _pref.setString('role', value);
  }

  static set status(int value) {
    _status = value;
    _pref.setInt('status', value);
  }

  static set number(int value) {
    _number = value;
    _pref.setInt('number', value);
  }

  static set project(int value) {
    _project = value;
    _pref.setInt('project', value);
  }

  static set record(int value) {
    _record = value;
    _pref.setInt('record', value);
  }

  static set image(int value) {
    _image = value;
    _pref.setInt('image', value);
  }

  static set track(int value) {
    _track = value;
    _pref.setInt('track', value);
  }

  static String get id => _id!;

  static String get phone => _phone!;

  static String get password => _password!;

  static String get email => _email!;

  static String get name => _name!;

  static String get session => _session;

  static String get role => _role!;

  static int get status => _status!;

  static int get number => _number!;

  static int get project => _project ?? 0;

  static int get record => _record ?? 0;

  static int get image => _image ?? 0;

  static int get track => _track ?? 0;

  static clear() {
    _id = null;
    _phone = null;
    _password = null;
    _email = null;
    _name = null;
    _session = '';
    _role = null;
    _status = null;
    _number = null;
    _project = null;
    _record = null;
    _image = null;
    _track = null;

    _pref.remove('id');
    _pref.remove('phone');
    _pref.remove('password');
    _pref.remove('email');
    _pref.remove('name');
    _pref.remove('session');
    _pref.remove('role');
    _pref.remove('status');
    _pref.remove('number');
    _pref.remove('project');
    _pref.remove('record');
    _pref.remove('image');
    _pref.remove('track');
  }
}
