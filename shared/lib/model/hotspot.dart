import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../db/drift_db.dart';
import 'hotspot.drift.dart';

// @UseRowClass(_Hotspot)
class Hotspot extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get author => text()();
  TextColumn get name => text()();
  RealColumn get lon => real()();
  RealColumn get lat => real()();
  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get updateTime => dateTime()();

  TextColumn get country => text()();
  TextColumn get province => text()();
  TextColumn get city => text()();
  TextColumn get county => text()();

  TextColumn get countryId => text()();
  TextColumn get provinceId => text()();
  TextColumn get cityId => text()();
  TextColumn get countyId => text()();

  BoolColumn get sync => boolean()();

  static HotspotData empty(String author) => HotspotData(
        author: author,
        id: Uuid().v1(),
        name: '',
        lon: 0.0,
        lat: 0.0,
        createTime: DateTime.now(),
        updateTime: DateTime.now(),
        country: '',
        province: '',
        city: '',
        county: '',
        countryId: '',
        provinceId: '',
        cityId: '',
        countyId: '',
        sync: false,
      );
}

@DriftAccessor(tables: [Hotspot])
class HotspotDao extends DatabaseAccessor<BirdartDB> with $HotspotDaoMixin {
  // 构造方法是必需的，这样主数据库可以创建这个对象的实例。
  HotspotDao(super.db);

  Future<int> insertOne(HotspotData hotspot) => into(db.hotspot).insertOnConflictUpdate(hotspot);

  Future<void> insertList(List<HotspotData> hotspots) => batch((batch) {
        batch.insertAllOnConflictUpdate(db.hotspot, hotspots);
      });

  Future<int> deleteOne(HotspotData hotspot) =>
      (delete(db.hotspot)..whereSamePrimaryKey(hotspot)).go();

  Future<void> deleteList(List<HotspotData> hotspots) =>
      (delete(db.hotspot)..where((tbl) => tbl.id.isIn(hotspots.map((e) => e.id)))).go();

  Future<int> deleteById(String hotspotId) =>
      (delete(db.hotspot)..where((tbl) => tbl.id.equals(hotspotId))).go();

  Future<int> updateOne(HotspotData hotspot) =>
      (update(db.hotspot)..whereSamePrimaryKey(hotspot)).write(hotspot);

  Future<void> updateList(List<HotspotData> hotspots) => batch((batch) {
        hotspots.map((e) => batch.update(db.hotspot, e));
      });

  Future<List<HotspotData>> getAll() => (select(db.hotspot)).get();

  Future<HotspotData?> getById(String hotspotId) =>
      (select(db.hotspot)..where((tbl) => tbl.id.equals(hotspotId))).getSingleOrNull();

  Future<List<HotspotData>> getUnsynced() =>
      (select(db.hotspot)..where((tbl) => tbl.sync.equals(false))).get();

  Future<List<HotspotData>> getByDate(String date) =>
      (select(db.hotspot)..where((tbl) => tbl.createTime.equals(DateTime.parse(date)))).get();
}
