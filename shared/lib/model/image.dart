import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

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
  BoolColumn get sync => boolean()();
}

// @Entity(tableName: 'IMAGE')
class _DbImage {
  // @primaryKey
  String id;
  String record;
  String author;
  String imagePath;
  String imageId;
  String exif;
  int imageSize;
  bool sync;

  _DbImage({
    required this.id,
    required this.record,
    required this.author,
    required this.imagePath,
    required this.imageId,
    required this.imageSize,
    required this.exif,
    required this.sync,
  });

  factory _DbImage.fromJson(Map<String, dynamic> json) => _DbImage(
        id: json['_id'],
        record: json['record'],
        author: json['author'],
        imagePath: json['imagePath'],
        imageId: json['imageId'],
        imageSize: json['imageSize'],
        exif: json['exif'],
        sync: true,
      );

  Map<String, dynamic> toJson() => {
        '_id': id.toString(),
        'record': record.toString(),
        'author': author.toString(),
        'imagePath': imagePath,
        'imageId': imageId,
        'imageSize': imageSize,
        'exif': exif,
      };

  _DbImage.add(
      {required this.record,
      required this.imagePath,
      required this.imageId,
      required this.imageSize,
      required this.exif,
      required this.author})
      : id = Uuid().v1(),
        sync = false;
}

// @dao
abstract class DbImageDao {
  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(_DbImage image);

  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<_DbImage> images);

  // @delete
  Future<int> deleteOne(_DbImage image);

  // @delete
  Future<int> deleteList(List<_DbImage> images);

  // @Query("DELETE FROM image WHERE id = :imageId")
  Future<int?> deleteById(String imageId);

  // @Query("DELETE FROM image WHERE record = :recordId")
  Future<int?> deleteByRecord(String recordId);

  // @Query("DELETE FROM image WHERE project = :projectId")
  Future<int?> deleteByProject(String projectId);

  // @update
  Future<int> updateOne(_DbImage image);

  // @update
  Future<int> updateList(List<_DbImage> images);

  // @Query("SELECT * FROM image")
  Future<List<_DbImage>> getAll();

  // @Query("SELECT * FROM image WHERE project = :projectArg")
  Future<List<_DbImage>> getByProject(String projectArg);

  // @Query("SELECT * FROM image WHERE record = :recordArg")
  Future<List<_DbImage>> getByRecord(String recordArg);

  // @Query("SELECT * FROM image WHERE project = :projectArg and sync <> 1")
  Future<List<_DbImage>> getByProjectUnsynced(String projectArg);

  // @Query("SELECT * FROM image WHERE record = :recordArg AND imagePath = :pathArg")
  Future<List<_DbImage>> getByRecordAndPath(String recordArg, String pathArg);
}
