import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'image.dart';
import 'project.dart';
import 'record.dart';
import 'track.dart';
import 'type_converter.dart';

part 'on_db.g.dart';

// dart run build_runner build --delete-conflicting-outputs
@Database(
  entities: [
    DbImage,
    DbRecord,
    Project,
    Track
  ],
  version: 1,
)
@TypeConverters([ObjectIdConverter, DateTimeConverter])
abstract class OnDb extends FloorDatabase {
  DbImageDao get imageDao;
  ProjectDao get projectDao;
  DbRecordDao get recordDao;
  TrackDao get trackDao;
}
