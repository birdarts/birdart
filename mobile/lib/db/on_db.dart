import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'image.dart';
import 'bird_list.dart';
import 'record.dart';
import 'track.dart';
import 'type_converter.dart';

part 'on_db.g.dart';

// dart run build_runner build --delete-conflicting-outputs
@Database(
  entities: [
    DbImage,
    DbRecord,
    BirdList,
    Track
  ],
  version: 1,
)
@TypeConverters([ObjectIdDbConverter, DateTimeDbConverter, StringListDbConverter])
abstract class OnDb extends FloorDatabase {
  DbImageDao get imageDao;
  BirdListDao get birdListDao;
  DbRecordDao get recordDao;
  TrackDao get trackDao;
}
