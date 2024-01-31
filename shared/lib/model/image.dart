import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../db/drift_db.dart';
import 'image.drift.dart';

// @UseRowClass(_DbImage)
class DbImage extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get record => text()();
  TextColumn get author => text()();
  TextColumn get imagePath => text()();
  TextColumn get imageId => text()();
  TextColumn get exif => text()();
  IntColumn get imageSize => integer()();
  DateTimeColumn get createTime => dateTime()();
  BoolColumn get sync => boolean()();

  static DbImageData add(
          {required String record,
          required String imagePath,
          required String imageId,
          required int imageSize,
          required String exif,
          required String author}) =>
      DbImageData(
        id: Uuid().v1(),
        sync: false,
        record: record,
        imagePath: imagePath,
        imageId: imageId,
        imageSize: imageSize,
        exif: exif,
        author: author,
        createTime: DateTime.now(),
      );
}

@DriftAccessor(tables: [DbImage])
class DbImageDao extends DatabaseAccessor<BirdartDB> with $DbImageDaoMixin {
  // 构造方法是必需的，这样主数据库可以创建这个对象的实例。
  DbImageDao(super.db);

  Future<int> insertOne(DbImageData dbImage) => into(db.dbImage).insertOnConflictUpdate(dbImage);

  Future<void> insertList(List<DbImageData> dbImages) => batch((batch) {
        batch.insertAllOnConflictUpdate(db.dbImage, dbImages);
      });

  Future<int> deleteOne(DbImageData dbImage) =>
      (delete(db.dbImage)..whereSamePrimaryKey(dbImage)).go();

  Future<void> deleteList(List<DbImageData> dbImages) =>
      (delete(db.dbImage)..where((tbl) => tbl.id.isIn(dbImages.map((e) => e.id)))).go();

  Future<int> deleteById(String dbImageId) =>
      (delete(db.dbImage)..where((tbl) => tbl.id.equals(dbImageId))).go();

  Future<int> updateOne(DbImageData dbImage) =>
      (update(db.dbImage)..whereSamePrimaryKey(dbImage)).write(dbImage);

  Future<void> updateList(List<DbImageData> dbImages) => batch((batch) {
        dbImages.map((e) => batch.update(db.dbImage, e));
      });

  Future<List<DbImageData>> getAll() => (select(db.dbImage)).get();

  Future<DbImageData> getById(String dbImageId) =>
      (select(db.dbImage)..where((tbl) => tbl.id.equals(dbImageId))).getSingle();

  Future<List<DbImageData>> getUnsynced() =>
      (select(db.dbImage)..where((tbl) => tbl.sync.equals(false))).get();

  Future<List<DbImageData>> getByDate(String date) =>
      (select(db.dbImage)..where((tbl) => tbl.createTime.equals(DateTime.parse(date)))).get();
}
