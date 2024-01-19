import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:shared/shared.dart';

part 'on_db.g.dart';

// dart run build_runner build --delete-conflicting-outputs
@Database(
  entities: [Bird, Hotspot, DbImage, DbRecord, Checklist, Track],
  version: 2,
)
@TypeConverters([DateTimeConverter, StringListConverter])
abstract class OnDb extends FloorDatabase {
  DbImageDao get imageDao;
  BirdListDao get birdListDao;
  DbRecordDao get recordDao;
  TrackDao get trackDao;
  BirdDao get birdSpeciesDao;
  HotspotDao get hotspotDao;
}
