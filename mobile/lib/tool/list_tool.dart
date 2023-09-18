import 'dart:async';

import 'package:geoxml/geoxml.dart';
import 'package:shared/shared.dart';

import '../entity/user_profile.dart';

class ListTool {
  static StreamSubscription? subscription;
  static GeoXml geoxml = GeoXml();
  static Track track = Track.empty(UserProfile.id);
  static BirdList? birdList;
  static List<DbRecord> records = [];
}
