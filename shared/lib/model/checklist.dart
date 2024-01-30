import 'package:drift/drift.dart';

import 'uuid_gen.dart';

@UseRowClass(_Checklist)
class Checklist extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get author => text()();
  TextColumn get notes => text()();
  TextColumn get type => text()(); // list type
  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get updateTime => dateTime()();
  IntColumn get time => integer()(); // in minutes
  IntColumn get birders => integer()(); // birder amount
  RealColumn get distance => real()(); // in kilometers
  BoolColumn get complete => boolean()(); // is complete record or not
  BoolColumn get sync => boolean()(); // if already uploaded.
  TextColumn get track => text()();
  TextColumn get comment => text()();

}

// @entity
class _Checklist {
  // @primaryKey
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

  _Checklist({
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

  factory _Checklist.fromJson(Map<String, dynamic> json) => _Checklist(
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

  _Checklist.empty(this.author, this.track)
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

// @dao
abstract class BirdListDao {
  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(_Checklist project);

  // @Insert(onConflict: OnConflictStrategy.abort)
  Future<List<int>> insertList(List<_Checklist> project);

  // @delete
  Future<int> deleteOne(_Checklist project);

  // @delete
  Future<int> deleteList(List<_Checklist> projects);

  // @update
  Future<int> updateOne(_Checklist project);

  // @update
  Future<int> updateList(List<_Checklist> projects);

  // @Query("SELECT * FROM Checklist")
  Future<List<_Checklist>> getAll();

  // @Query("SELECT * FROM Checklist WHERE id = :projectId")
  Future<List<_Checklist>> getById(String projectId);
}
