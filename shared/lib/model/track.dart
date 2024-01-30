import 'package:drift/drift.dart';

import 'uuid_gen.dart';

@UseRowClass(_Track)
class Track extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get author => text()();
  TextColumn get filePath => text()();

  RealColumn get startLon => real()();
  RealColumn get startLat => real()();
  RealColumn get startEle => real()();
  RealColumn get endLon => real()();
  RealColumn get endLat => real()();
  RealColumn get endEle => real()();

  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();

  IntColumn get pointCount => integer()();
  RealColumn get distance => real()();
  BoolColumn get sync => boolean()();
}

// @entity
class _Track {
  // @primaryKey
  String id;
  String author;

  double startLon = 0.0;
  double startLat = 0.0;
  double startEle = 0.0;
  double endLon = 0.0;
  double endLat = 0.0;
  double endEle = 0.0;

  DateTime startTime;
  DateTime endTime;

  int pointCount = 0;
  double distance = 0.0;
  bool sync;

  String filePath = '';

  bool isSelected = false;

  _Track({
    required this.id,
    required this.author,
    required this.startTime,
    required this.endTime,
    required this.sync,
    required this.filePath,
    this.startLon = 0.0,
    this.startLat = 0.0,
    this.startEle = 0.0,
    this.endLon = 0.0,
    this.endLat = 0.0,
    this.endEle = 0.0,
    this.pointCount = 0,
    this.distance = 0.0,
  });

  factory _Track.fromJson(Map<String, dynamic> json) => _Track(
        id: (json['_id']),
        author: (json['author']),
        startLon: double.parse(json['startLon']),
        startLat: double.parse(json['startLat']),
        startEle: double.parse(json['startEle']),
        endLon: double.parse(json['endLon']),
        endLat: double.parse(json['endLat']),
        endEle: double.parse(json['endEle']),
        startTime: DateTime.fromMicrosecondsSinceEpoch(json['startTime']),
        endTime: DateTime.fromMicrosecondsSinceEpoch(json['endTime']),
        pointCount: int.parse(json['pointCount']),
        distance: double.parse(json['distance']),
        sync: true,
        filePath: json['filePath'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id.toString(),
        'author': author.toString(),
        'startLon': startLon,
        'startLat': startLat,
        'startEle': startEle,
        'endLon': endLon,
        'endLat': endLat,
        'endEle': endEle,
        'startTime': startTime.microsecondsSinceEpoch,
        'endTime': endTime.microsecondsSinceEpoch,
        'pointCount': pointCount,
        'distance': distance,
      };

  _Track.empty(this.author)
      : id = uuid.v1(),
        startTime = DateTime.fromMicrosecondsSinceEpoch(0),
        endTime = DateTime.fromMicrosecondsSinceEpoch(0),
        sync = false;
}

// @dao
abstract class TrackDao {
  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(_Track track);

  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<_Track> tracks);

  // @delete
  Future<int> deleteOne(_Track track);

  // @delete
  Future<int> deleteList(List<_Track> tracks);

  // @update
  Future<int> updateOne(_Track track);

  // @update
  Future<int> updateList(List<_Track> tracks);

  // @Query("DELETE FROM track WHERE id = :trackId")
  Future<int?> deleteById(String trackId);

  // @Query("SELECT * FROM track ORDER BY datetime(startTime) desc")
  Future<List<_Track>> getAll();

  // @Query("SELECT * FROM track WHERE id = :trackId")
  Future<List<_Track>> getById(String trackId);

  // @Query("SELECT * FROM track WHERE sync <> 1")
  Future<List<_Track>> getUnsynced();

  // @Query("SELECT * FROM track WHERE instr(startTime, :date) ORDER BY datetime(startTime) desc")
  Future<List<_Track>> getByDate(String date);
}
