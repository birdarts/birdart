import 'package:floor_annotation/floor_annotation.dart';
import 'package:xid/xid.dart';

@Entity(tableName: 'RECORD')
class DbRecord {
  @primaryKey
  Xid id;
  Xid project;
  Xid author;

  String species;
  String speciesRef;

  List<String> tags;
  String notes;
  bool sync; // if changes already uploaded.

  DateTime observeTime;

  DbRecord({
    required this.id,
    required this.project,
    required this.author,
    required this.species,
    required this.speciesRef,
    required this.notes,
    required this.sync,
    required this.observeTime,
    required this.tags,
  });

  factory DbRecord.fromJson(Map<String, dynamic> json) => DbRecord(
        id: Xid.fromString(json['id']),
        project: Xid.fromString(json['project']),
        author: Xid.fromString(json['author']),
        species: json['species'],
        speciesRef: json['speciesRef'],
        notes: json['notes'],
        sync: true,
        observeTime: DateTime.fromMicrosecondsSinceEpoch(json['observeTime']),
        tags: json['tags'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id.toString(),
        'project': project.toString(),
        'author': author.toString(),
        'species': species,
        'speciesRef': speciesRef,
        'notes': notes,
        'observeTime': observeTime.microsecondsSinceEpoch,
        'tags': tags
      };

  DbRecord.add(
      {required this.project,
      required this.species,
      required this.speciesRef,
      required this.notes,
      required this.author,
      required this.tags})
      : id = Xid(),
        sync = false,
        observeTime = DateTime.now();
}

@dao
abstract class DbRecordDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(DbRecord record);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<DbRecord> records);

  @delete
  Future<int> deleteOne(DbRecord record);

  @delete
  Future<int> deleteList(List<DbRecord> records);

  @update
  Future<int> updateOne(DbRecord record);

  @update
  Future<int> updateList(List<DbRecord> records);

  @Query("DELETE FROM record WHERE id = :recordId")
  Future<int?> deleteById(String recordId);

  @Query("DELETE FROM record WHERE project = :projectId")
  Future<int?> deleteByProject(String projectId);

  @Query("SELECT * FROM record")
  Future<List<DbRecord>> getAll();

  @Query("SELECT * FROM record WHERE id = :idArg")
  Future<List<DbRecord>> getById(String idArg);

  @Query("SELECT * FROM record WHERE project = :projectArg")
  Future<List<DbRecord>> getByProject(String projectArg);

  @Query("SELECT * FROM record WHERE project = :projectArg and sync <> 1")
  Future<List<DbRecord>> getByProjectUnsynced(String projectArg);
}
