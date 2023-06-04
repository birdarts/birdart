import 'package:floor/floor.dart';
import 'package:objectid/objectid.dart';
import 'package:package/package.dart';

import '../entity/user_profile.dart';

@entity
class BirdList implements BaseBirdList {
  @override
  @primaryKey
  ObjectId id;
  @override
  ObjectId author;
  @override
  String name;
  @override
  String notes;
  @override
  String coverImg;
  @override
  DateTime createTime;
  @override
  bool sync;

  @override
  String type = ''; // for future usage

  BirdList({
    required this.id,
    required this.author,
    required this.name,
    required this.notes,
    required this.coverImg,
    required this.createTime,
    required this.sync,
  });

  BirdList.add({
    required this.name,
    required this.notes,
    required this.coverImg,
  })
  : id = ObjectId(),
    author = ObjectId.fromHexString(UserProfile.id),
    createTime = DateTime.now(),
    sync = false;

  factory BirdList.fromJson(Map<String, dynamic> json) => BirdList(
    id: ObjectId.fromHexString(json['_id']),
    author: ObjectId.fromHexString(json['author']),
    name: json['name'],
    notes: json['notes'],
    createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
    sync: true,
    coverImg: '',
  );

  @override
  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'author': author.hexString,
    'name': name,
    'notes': notes,
    'coverImg': coverImg,
    'createTime': createTime.millisecondsSinceEpoch,
  };
}

@dao
abstract class ProjectDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(BirdList project);

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<List<int>> insertList(List<BirdList> project);

  @delete
  Future<int> deleteOne(BirdList project);

  @delete
  Future<int> deleteList(List<BirdList> projects);

  @update
  Future<int> updateOne(BirdList project);

  @update
  Future<int> updateList(List<BirdList> projects);

  @Query("SELECT * FROM project")
  Future<List<BirdList>> getAll();

  @Query("SELECT * FROM project WHERE id = :projectId")
  Future<List<BirdList>> getById(String projectId);
}
