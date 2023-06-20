import 'dart:async';

import 'package:geoxml/geoxml.dart';

import '../db/bird_list.dart';
import '../db/record.dart';
import '../db/track.dart';

class ListTool {
  static StreamSubscription? subscription;
  static GeoXml geoxml = GeoXml();
  static Track track = Track.empty();
  static BirdList? birdList;
  static List<DbRecord> records = [];
}
