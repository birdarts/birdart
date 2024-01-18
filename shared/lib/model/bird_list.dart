import 'package:floor_annotation/floor_annotation.dart';

import 'uuid_gen.dart';

@entity
class BirdList {
  @primaryKey
  String id;
  String author;
  String notes;
  DateTime createTime;
  int time; // in minutes
  int birders; // birder amount
  double distance; //
  String type = ''; // list type
  bool complete; // is complete record or not
  bool sync; // if already uploaded.

  String track;

  String comment = '';

  BirdList({
    required this.id,
    required this.author,
    required this.notes,
    required this.createTime,
    required this.sync,
    required this.track,
    required this.comment,
    required this.type,
    required this.time,
    required this.birders,
    required this.distance,
    required this.complete,
  });

  factory BirdList.fromJson(Map<String, dynamic> json) => BirdList(
        id: json['_id'],
        author: json['author'],
        notes: json['notes'],
        createTime: DateTime.fromMicrosecondsSinceEpoch(json['createTime']),
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
        'track': track,
        'comment': comment,
        'type': type,
        'time': time,
        'birders': birders,
        'distance': distance,
        'complete': complete,
      };

  BirdList.empty(this.author, this.track)
      : id = uuid.v1(),
        notes = '',
        createTime = DateTime.now(),
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

  @Query("SELECT * FROM BirdList")
  Future<List<BirdList>> getAll();

  @Query("SELECT * FROM BirdList WHERE id = :projectId")
  Future<List<BirdList>> getById(String projectId);
}
