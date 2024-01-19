import 'package:floor_annotation/floor_annotation.dart';
import 'uuid_gen.dart';

@Entity(tableName: 'RECORD')
class DbRecord {
  @primaryKey
  String id;
  String project;
  String author;

  String species;
  String speciesRef;

  List<String> tags;
  String notes;
  int amount;
  bool sync; // if changes already uploaded.

  DateTime createTime;
  DateTime updateTime;

  DbRecord({
    required this.id,
    required this.project,
    required this.author,
    required this.species,
    required this.speciesRef,
    required this.notes,
    required this.amount,
    required this.sync,
    required this.createTime,
    required this.updateTime,
    required this.tags,
  });

  factory DbRecord.fromJson(Map<String, dynamic> json) => DbRecord(
        id: (json['id']),
        project: (json['project']),
        author: (json['author']),
        species: json['species'],
        speciesRef: json['speciesRef'],
        notes: json['notes'],
        sync: true,
        amount: int.tryParse(json['amount'].toString()) ?? 1,
    createTime: DateTime.fromMicrosecondsSinceEpoch(json['createTime']),
    updateTime: DateTime.fromMicrosecondsSinceEpoch(json['updateTime']),
        tags: json['tags'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id.toString(),
        'project': project.toString(),
        'author': author.toString(),
        'species': species,
        'speciesRef': speciesRef,
        'notes': notes,
        'amount': amount,
    'createTime': createTime.microsecondsSinceEpoch,
    'updateTime': updateTime.microsecondsSinceEpoch,
        'tags': tags
      };

  DbRecord.add(
      {required this.project,
      required this.species,
      required this.speciesRef,
      required this.notes,
      required this.author,
      required this.tags})
      : id = uuid.v1(),
        sync = false,
        amount = 1,
        createTime = DateTime.now(),
        updateTime = DateTime.now();
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
