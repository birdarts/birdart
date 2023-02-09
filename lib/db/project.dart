import 'package:floor/floor.dart';
import 'package:objectid/objectid.dart';

import '../entity/user_profile.dart';

@entity
class Project {
  @primaryKey
  ObjectId id;
  ObjectId author;
  String name;
  String notes;
  String coverImg;
  DateTime createTime;
  bool sync;

  String type = ''; // for future usage

  Project({
    required this.id,
    required this.author,
    required this.name,
    required this.notes,
    required this.coverImg,
    required this.createTime,
    required this.sync,
  });

  Project.add({
    required this.name,
    required this.notes,
    required this.coverImg,
  })
  : id = ObjectId(),
    author = ObjectId.fromHexString(UserProfile.id),
    createTime = DateTime.now(),
    sync = false;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
    id: ObjectId.fromHexString(json['_id']),
    author: ObjectId.fromHexString(json['author']),
    name: json['name'],
    notes: json['notes'],
    createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
    sync: true,
    coverImg: '',
  );

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
  Future<int> insertOne(Project project);

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<List<int>> insertList(List<Project> project);

  @delete
  Future<int> deleteOne(Project project);

  @delete
  Future<int> deleteList(List<Project> projects);

  @update
  Future<int> updateOne(Project project);

  @update
  Future<int> updateList(List<Project> projects);

  @Query("SELECT * FROM project")
  Future<List<Project>> getAll();

  @Query("SELECT * FROM project WHERE id = :projectId")
  Future<List<Project>> getById(String projectId);
}
