import 'package:drift/drift.dart';
import 'package:shared/model/record.drift.dart';
import 'package:shared/shared.dart';
import 'package:uuid/uuid.dart';

// @UseRowClass(_DbRecord)
class DbRecord extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();

  TextColumn get checklist => text()();

  TextColumn get author => text()();

  TextColumn get species => text()();

  TextColumn get speciesRef => text()();

  TextColumn get tags => text().map(StringListConverter())();

  TextColumn get notes => text()();

  IntColumn get amount => integer()();

  TextColumn get appendix => text().map(MapConverter())();

  BoolColumn get sync => boolean()();

  DateTimeColumn get createTime => dateTime()();

  DateTimeColumn get updateTime => dateTime()();

  static DbRecordData add({
    required String checklist,
    required String species,
    required String speciesRef,
    required String author,
  }) =>
      DbRecordData(
        id: Uuid().v1(),
        checklist: checklist,
        species: species,
        speciesRef: speciesRef,
        author: author,
        sync: false,
        amount: 1,
        appendix: {},
        notes: '',
        tags: [],
        createTime: DateTime.now(),
        updateTime: DateTime.now(),
      );
}

extension RecordExt on DbRecordData {
  String get oil => appendix[RecordKeys.oil] ?? '';

  set oil(String value) {
    appendix[RecordKeys.oil] = value;
  }

  Map<String, Map<String, int>> get ageSex {
    appendix[RecordKeys.ageSex] = appendix[RecordKeys.ageSex] ??
        {
          RecordKeys.nestling: {RecordKeys.male: 0, RecordKeys.female: 0, RecordKeys.undefined: 0},
          RecordKeys.juvenile: {RecordKeys.male: 0, RecordKeys.female: 0, RecordKeys.undefined: 0},
          RecordKeys.adult: {RecordKeys.male: 0, RecordKeys.female: 0, RecordKeys.undefined: 0},
          RecordKeys.undefined: {RecordKeys.male: 0, RecordKeys.female: 0, RecordKeys.undefined: 0},
        };

    return appendix[RecordKeys.ageSex];
  }

  set ageSex(Map<String, Map<String, int>> value) {
    appendix[RecordKeys.ageSex] = value;
  }

  String get behaviour => appendix[RecordKeys.behaviour] ?? '';

  set behaviour(String value) {
    appendix[RecordKeys.behaviour] = value;
  }
}

@DriftAccessor(tables: [DbRecord])
class DbRecordDao extends DatabaseAccessor<BirdartDB> with $DbRecordDaoMixin {
  // 构造方法是必需的，这样主数据库可以创建这个对象的实例。
  DbRecordDao(super.db);

  Future<int> insertOne(DbRecordData dbRecord) =>
      into(db.dbRecord).insertOnConflictUpdate(dbRecord);

  Future<void> insertList(List<DbRecordData> dbRecords) => batch((batch) {
        batch.insertAllOnConflictUpdate(db.dbRecord, dbRecords);
      });

  Future<int> deleteOne(DbRecordData dbRecord) =>
      (delete(db.dbRecord)..whereSamePrimaryKey(dbRecord)).go();

  Future<void> deleteList(List<DbRecordData> dbRecords) =>
      (delete(db.dbRecord)..where((tbl) => tbl.id.isIn(dbRecords.map((e) => e.id)))).go();

  Future<int> deleteById(String dbRecordId) =>
      (delete(db.dbRecord)..where((tbl) => tbl.id.equals(dbRecordId))).go();

  Future<int> deleteByChecklist(String checklistId) =>
      (delete(db.dbRecord)..where((tbl) => tbl.checklist.equals(checklistId))).go();

  Future<int> updateOne(DbRecordData dbRecord) =>
      (update(db.dbRecord)..whereSamePrimaryKey(dbRecord)).write(dbRecord);

  Future<void> updateList(List<DbRecordData> dbRecords) => batch((batch) {
        dbRecords.map((e) => batch.update(db.dbRecord, e));
      });

  Future<List<DbRecordData>> getAll() => (select(db.dbRecord)).get();

  Future<DbRecordData> getById(String dbRecordId) =>
      (select(db.dbRecord)..where((tbl) => tbl.id.equals(dbRecordId))).getSingle();

  Future<List<DbRecordData>> getUnsynced() =>
      (select(db.dbRecord)..where((tbl) => tbl.sync.equals(false))).get();

  Future<List<DbRecordData>> getByDate(String date) =>
      (select(db.dbRecord)..where((tbl) => tbl.createTime.equals(DateTime.parse(date)))).get();

  Future<List<DbRecordData>> getByChecklist(String checklistId) =>
      (select(db.dbRecord)..where((tbl) => tbl.checklist.equals(checklistId))).get();

  Future<List<DbRecordData>> getByChecklistUnsynced(String checklistId) => (select(db.dbRecord)
        ..where((tbl) => tbl.checklist.equals(checklistId))
        ..where((tbl) => tbl.sync.equals(false)))
      .get();
}
