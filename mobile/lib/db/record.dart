import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:package/model/record.dart';
import '../entity/user_profile.dart';
import 'package:objectid/objectid.dart';


List<DbRecord> userModelFromJson(String str) =>
    List<DbRecord>.from(json.decode(str).map((x) => DbRecord.fromJson(x)));

String userModelToJson(List<DbRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity(tableName: 'RECORD')
class DbRecord implements BaseRecord{
    @primaryKey
    @override
    ObjectId id;
    @override
    ObjectId project;
    @override
    ObjectId author;

    @override
    String species;
    @override
    String speciesRef;

    @override
    String notes;
    @override
    bool sync; // if changes already uploaded.

    @override
    List<String> tags;

    @override
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

  DbRecord.add({
    required this.project,
    required this.species,
    required this.speciesRef,
    required this.notes,
    required this.tags,
  })
  : id = ObjectId(),
    author = ObjectId.fromHexString(UserProfile.id),
    sync = false,
    observeTime = DateTime.now();

  factory DbRecord.fromJson(Map<String, dynamic> json) => DbRecord(
    id: ObjectId.fromHexString(json['id']),
    project: ObjectId.fromHexString(json['project']),
    author: ObjectId.fromHexString(json['author']),
    species: json['species'],
    speciesRef: json['speciesRef'],
    notes: json['notes'],
    sync: true,
    observeTime: DateTime.fromMillisecondsSinceEpoch(json['observeTime']),
    tags: json['tags']
  );

  @override
  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'project': project.hexString,
    'author': author.hexString,
    'species': species,
    'speciesRef': speciesRef,
    'notes': notes,
    'observeTime': observeTime.millisecondsSinceEpoch,
    'tags': tags,
  };
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
