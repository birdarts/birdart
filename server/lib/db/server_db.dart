import 'dart:async';

import 'package:floor/floor.dart' hide FloorDatabase, sqfliteDatabaseFactory;
import 'package:shared/shared.dart';

import 'postgresql_implementation.dart' as sqflite;
import 'postgresql_implementation.dart' show FloorDatabase, sqfliteDatabaseFactory;

part 'server_db.g.dart';

// dart run build_runner build --delete-conflicting-outputs
@Database(
  entities: [Bird, Hotspot, DbImage, DbRecord, Checklist, Track, User],
  version: 2,
)
@TypeConverters([DateTimeConverter, StringListConverter, MapConverter, StatusConverter, RoleConverter])
abstract class ServerDb extends FloorDatabase {
  DbImageDao get imageDao;
  BirdListDao get birdListDao;
  DbRecordDao get recordDao;
  TrackDao get trackDao;
  BirdDao get birdSpeciesDao;
  HotspotDao get hotspotDao;
  UserDao get userDao;
}
