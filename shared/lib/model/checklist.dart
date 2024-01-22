import 'package:floor_annotation/floor_annotation.dart';

import 'uuid_gen.dart';

@entity
class Checklist {
  @primaryKey
  String id;
  String author;
  String notes;
  DateTime createTime;
  DateTime updateTime;
  int time; // in minutes
  int birders; // birder amount
  double distance; //
  String type = ''; // list type
  bool complete; // is complete record or not
  bool sync; // if already uploaded.

  String track;

  String comment = '';

  Checklist({
    required this.id,
    required this.author,
    required this.notes,
    required this.createTime,
    required this.updateTime,
    required this.sync,
    required this.track,
    required this.comment,
    required this.type,
    required this.time,
    required this.birders,
    required this.distance,
    required this.complete,
  });

  factory Checklist.fromJson(Map<String, dynamic> json) => Checklist(
        id: json['_id'],
        author: json['author'],
        notes: json['notes'],
        createTime: DateTime.fromMicrosecondsSinceEpoch(json['createTime']),
        updateTime: DateTime.fromMicrosecondsSinceEpoch(json['updateTime']),
        sync: true,
        track: json['track'],
        comment: json['comment'],
        type: json['type'],
        time: json['time'],
        birders: json['birders'],
        distance: json['distance'],
        complete: json['complete'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id.toString(),
        'author': author.toString(),
        'notes': notes,
        'createTime': createTime.microsecondsSinceEpoch,
        'updateTime': createTime.microsecondsSinceEpoch,
        'track': track,
        'comment': comment,
        'type': type,
        'time': time,
        'birders': birders,
        'distance': distance,
        'complete': complete,
      };

  Checklist.empty(this.author, this.track)
      : id = uuid.v1(),
        notes = '',
        createTime = DateTime.now(),
        updateTime = DateTime.now(),
        sync = false,
        comment = '',
        type = '',
        time = 0,
        birders = 1,
        distance = 0,
        complete = true;
}

@dao
abstract class BirdListDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(Checklist project);

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<List<int>> insertList(List<Checklist> project);

  @delete
  Future<int> deleteOne(Checklist project);

  @delete
  Future<int> deleteList(List<Checklist> projects);

  @update
  Future<int> updateOne(Checklist project);

  @update
  Future<int> updateList(List<Checklist> projects);

  @Query("SELECT * FROM Checklist")
  Future<List<Checklist>> getAll();

  @Query("SELECT * FROM Checklist WHERE id = :projectId")
  Future<List<Checklist>> getById(String projectId);
}
