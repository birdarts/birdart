import 'package:drift/drift.dart';
import 'package:shared/model/track.dart';
import 'package:uuid/uuid.dart';

import '../db/drift_db.dart';
import 'checklist.drift.dart';

// @UseRowClass(_Checklist)
class Checklist extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get author => text()();
  TextColumn get notes => text()();
  TextColumn get type => text()(); // list type
  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get updateTime => dateTime()();
  IntColumn get time => integer()(); // in minutes
  IntColumn get birders => integer()(); // birder amount
  RealColumn get distance => real()(); // in kilometers
  BoolColumn get complete => boolean()(); // is complete record or not
  BoolColumn get sync => boolean()(); // if already uploaded.
  TextColumn get track => text().references(Track, #id)();
  TextColumn get comment => text()();

  static ChecklistData empty(String author, String track) => ChecklistData(
        id: Uuid().v1(),
        author: author,
        track: track,
        notes: '',
        createTime: DateTime.now(),
        updateTime: DateTime.now(),
        sync: false,
        comment: '',
        type: '',
        time: 0,
        birders: 1,
        distance: 0,
        complete: true,
      );
}

@DriftAccessor(tables: [Checklist])
class ChecklistDao extends DatabaseAccessor<BirdartDB> with $ChecklistDaoMixin {
  // 构造方法是必需的，这样主数据库可以创建这个对象的实例。
  ChecklistDao(super.db);

  Future<int> insertOne(ChecklistData checklist) =>
      into(db.checklist).insertOnConflictUpdate(checklist);

  Future<void> insertList(List<ChecklistData> checklists) => batch((batch) {
        batch.insertAllOnConflictUpdate(db.checklist, checklists);
      });

  Future<int> deleteOne(ChecklistData checklist) =>
      (delete(db.checklist)..whereSamePrimaryKey(checklist)).go();

  Future<void> deleteList(List<ChecklistData> checklists) =>
      (delete(db.checklist)..where((tbl) => tbl.id.isIn(checklists.map((e) => e.id)))).go();

  Future<int> updateOne(ChecklistData checklist) =>
      (update(db.checklist)..whereSamePrimaryKey(checklist)).write(checklist);

  Future<void> updateList(List<ChecklistData> checklists) => batch((batch) {
        checklists.map((e) => batch.update(db.checklist, e));
      });

  Future<List<ChecklistData>> getAll() => (select(db.checklist)).get();

  Future<ChecklistData> getById(String checklistId) =>
      (select(db.checklist)..where((tbl) => tbl.id.equals(checklistId))).getSingle();
}
