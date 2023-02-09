import 'dart:async';

import 'package:gpx/gpx.dart';

import '../db/track.dart';

class TrackTool {
  static StreamSubscription? subscription;
  static Gpx gpx = Gpx();
  static Track track = Track.empty();
}
