import 'package:floor/floor.dart';
import 'package:objectid/objectid.dart';

@Entity(tableName: 'IMAGE')
class DbImage {
  @primaryKey
  ObjectId id;
  ObjectId record;
  ObjectId author;

  String imagePath;
  String imageId;
  int imageSize;
  String exif;
  bool sync;

  DbImage({
    required this.id,
    required this.record,
    required this.author,
    required this.imagePath,
    required this.imageId,
    required this.imageSize,
    required this.exif,
    required this.sync,
  });

  factory DbImage.fromJson(Map<String, dynamic> json) => DbImage(
        id: ObjectId.fromHexString(json['_id']),
        record: ObjectId.fromHexString(json['record']),
        author: ObjectId.fromHexString(json['author']),
        imagePath: json['imagePath'],
        imageId: json['imageId'],
        imageSize: json['imageSize'],
        exif: json['exif'],
        sync: true,
      );

  Map<String, dynamic> toJson() => {
        '_id': id.hexString,
        'record': record.hexString,
        'author': author.hexString,
        'imagePath': imagePath,
        'imageId': imageId,
        'imageSize': imageSize,
        'exif': exif,
      };

  DbImage.add({
    required this.record,
    required this.imagePath,
    required this.imageId,
    required this.imageSize,
    required this.exif,
    required String userId
  }) : id = ObjectId(),
        author = ObjectId.fromHexString(userId),
        sync = false;
}


@dao
abstract class DbImageDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(DbImage image);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<DbImage> images);

  @delete
  Future<int> deleteOne(DbImage image);

  @delete
  Future<int> deleteList(List<DbImage> images);

  @Query("DELETE FROM image WHERE id = :imageId")
  Future<int?> deleteById(String imageId);

  @Query("DELETE FROM image WHERE record = :recordId")
  Future<int?> deleteByRecord(String recordId);

  @Query("DELETE FROM image WHERE project = :projectId")
  Future<int?> deleteByProject(String projectId);

  @update
  Future<int> updateOne(DbImage image);

  @update
  Future<int> updateList(List<DbImage> images);

  @Query("SELECT * FROM image")
  Future<List<DbImage>> getAll();

  @Query("SELECT * FROM image WHERE project = :projectArg")
  Future<List<DbImage>> getByProject(String projectArg);

  @Query("SELECT * FROM image WHERE record = :recordArg")
  Future<List<DbImage>> getByRecord(String recordArg);

  @Query("SELECT * FROM image WHERE project = :projectArg and sync <> 1")
  Future<List<DbImage>> getByProjectUnsynced(String projectArg);

  @Query("SELECT * FROM image WHERE record = :recordArg AND imagePath = :pathArg")
  Future<List<DbImage>> getByRecordAndPath(String recordArg, String pathArg);
}
