import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:shared/shared.dart';

part 'on_db.g.dart';

// dart run build_runner build --delete-conflicting-outputs
@Database(
  entities: [DbImage, DbRecord, BirdList, Track],
  version: 1,
)
@TypeConverters([XidConverter, DateTimeConverter, StringListConverter])
abstract class OnDb extends FloorDatabase {
  DbImageDao get imageDao;
  BirdListDao get birdListDao;
  DbRecordDao get recordDao;
  TrackDao get trackDao;
}
