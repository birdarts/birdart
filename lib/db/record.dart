import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:naturalist/entity/user_profile.dart';
import 'package:objectid/objectid.dart';


List<DbRecord> userModelFromJson(String str) =>
    List<DbRecord>.from(json.decode(str).map((x) => DbRecord.fromJson(x)));

String userModelToJson(List<DbRecord> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@Entity(tableName: 'RECORD')
class DbRecord {
  @primaryKey
  ObjectId id;
  ObjectId project;
  ObjectId author;

  double lon;
  double lat;
  double ele;

  String species;
  String speciesRef;

  String country;
  String province;
  String city;
  String county;
  String poi;

  String notes;
  bool sync; // if changes already uploaded.

  DateTime observeTime;

  DbRecord({
    required this.id,
    required this.project,
    required this.author,
    required this.lon,
    required this.lat,
    required this.ele,
    required this.species,
    required this.speciesRef,
    required this.country,
    required this.province,
    required this.city,
    required this.county,
    required this.poi,
    required this.notes,
    required this.sync,
    required this.observeTime,
  });

  DbRecord.add({
    required this.project,
    required this.lon,
    required this.lat,
    required this.ele,
    required this.species,
    required this.speciesRef,
    required this.country,
    required this.province,
    required this.city,
    required this.county,
    required this.poi,
    required this.notes,
  })
  : id = ObjectId(),
    author = ObjectId.fromHexString(UserProfile.id),
    sync = false,
    observeTime = DateTime.now();

  factory DbRecord.fromJson(Map<String, dynamic> json) => DbRecord(
    id: ObjectId.fromHexString(json['id']),
    project: ObjectId.fromHexString(json['project']),
    author: ObjectId.fromHexString(json['author']),
    lon: double.parse(json['lon']),
    lat: double.parse(json['lat']),
    ele: double.parse(json['ele']),
    species: json['species'],
    speciesRef: json['speciesRef'],
    country: json['country'],
    province: json['province'],
    city: json['city'],
    county: json['county'],
    poi: json['poi'],
    notes: json['notes'],
    sync: true,
    observeTime: DateTime.fromMillisecondsSinceEpoch(json['observeTime']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'project': project.hexString,
    'author': author.hexString,
    'lon': lon,
    'lat': lat,
    'ele': ele,
    'species': species,
    'speciesRef': speciesRef,
    'country': country,
    'province': province,
    'city': city,
    'county': county,
    'poi': poi,
    'notes': notes,
    'observeTime': observeTime.millisecondsSinceEpoch,
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
