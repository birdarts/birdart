import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../db/drift_db.dart';
import 'track.drift.dart';

// @UseRowClass(_Track)
class Track extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get author => text()();
  TextColumn get filePath => text()();

  RealColumn get startLon => real()();
  RealColumn get startLat => real()();
  RealColumn get startEle => real()();
  RealColumn get endLon => real()();
  RealColumn get endLat => real()();
  RealColumn get endEle => real()();

  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();

  IntColumn get pointCount => integer()();
  RealColumn get distance => real()();
  BoolColumn get sync => boolean()();

  static TrackData empty(String author) => TrackData(
        id: Uuid().v1(),
        startTime: DateTime.fromMicrosecondsSinceEpoch(0),
        endTime: DateTime.fromMicrosecondsSinceEpoch(0),
        sync: false,
        author: author,
        filePath: '',
        startLon: 0.0,
        startLat: 0.0,
        startEle: 0.0,
        endLon: 0.0,
        endLat: 0.0,
        endEle: 0.0,
        pointCount: 0,
        distance: 0.0,
      );
}

@DriftAccessor(tables: [Track])
class TrackDao extends DatabaseAccessor<BirdartDB> with $TrackDaoMixin {
  // 构造方法是必需的，这样主数据库可以创建这个对象的实例。
  TrackDao(super.db);

  Future<int> insertOne(TrackData track) => into(db.track).insertOnConflictUpdate(track);

  Future<void> insertList(List<TrackData> tracks) => batch((batch) {
        batch.insertAllOnConflictUpdate(db.track, tracks);
      });

  Future<int> deleteOne(TrackData track) => (delete(db.track)..whereSamePrimaryKey(track)).go();

  Future<void> deleteList(List<TrackData> tracks) =>
      (delete(db.track)..where((tbl) => tbl.id.isIn(tracks.map((e) => e.id)))).go();

  Future<int> deleteById(String trackId) =>
      (delete(db.track)..where((tbl) => tbl.id.equals(trackId))).go();

  Future<int> updateOne(TrackData track) =>
      (update(db.track)..whereSamePrimaryKey(track)).write(track);

  Future<void> updateList(List<TrackData> tracks) => batch((batch) {
        tracks.map((e) => batch.update(db.track, e));
      });

  Future<List<TrackData>> getAll() => (select(db.track)).get();

  Future<TrackData?> getById(String trackId) =>
      (select(db.track)..where((tbl) => tbl.id.equals(trackId))).getSingleOrNull();

  Future<List<TrackData>> getUnsynced() =>
      (select(db.track)..where((tbl) => tbl.sync.equals(false))).get();

  Future<List<TrackData>> getByDate(String date) =>
      (select(db.track)..where((tbl) => tbl.startTime.equals(DateTime.parse(date)))).get();
}
