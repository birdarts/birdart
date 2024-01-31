import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:shared/db/drift_db.dart';
import 'package:json_annotation/json_annotation.dart' as j;

import 'bird_species.drift.dart';

@j.JsonSerializable()
class Bird extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get scientific => text()();
  TextColumn get vernacular => text()();
  TextColumn get ordo => text()();
  TextColumn get familia => text()();
  TextColumn get genus => text()();
}

// _TodosDaoMixin 会被 drift 创建。
// 它包含表需要的所有必要字段。
// <MyDatabase> 类型注释是数据库类，会使用这个 DAO。
@DriftAccessor(tables: [Bird])
class BirdDao extends DatabaseAccessor<BirdartDB> with $BirdDaoMixin {
  // 构造方法是必需的，这样主数据库可以创建这个对象的实例。
  BirdDao(super.db);

  Future<int> insertOne(BirdData bird) => into(db.bird).insertOnConflictUpdate(bird);

  Future<void> insertList(List<BirdData> birds) => batch((batch) {
    batch.insertAllOnConflictUpdate(db.bird, birds);
  });

  Future<int> deleteOne(BirdData bird) => (delete(db.bird)..whereSamePrimaryKey(bird)).go();

  Future<void> deleteList(List<BirdData> birds) =>
      (delete(db.bird)..where((tbl) => tbl.id.isIn(birds.map((e) => e.id)))).go();

  Future<int> updateOne(BirdData bird) => (update(db.bird)..whereSamePrimaryKey(bird)).write(bird);

  Future<void> updateList(List<BirdData> birds) => batch((batch) {
    birds.map((e) => batch.update(db.bird, e));
  });

  Future<List<BirdData>> getAll() => (select(db.bird)).get();
}