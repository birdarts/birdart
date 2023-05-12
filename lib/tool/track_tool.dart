import 'dart:async';

import 'package:geoxml/geoxml.dart';

import '../db/track.dart';

class TrackTool {
  static StreamSubscription? subscription;
  static GeoXml geoxml = GeoXml();
  static Track track = Track.empty();
}
