import 'package:floor_annotation/floor_annotation.dart';
import 'package:objectid/objectid.dart';

@entity
class BirdList {
  @primaryKey
  ObjectId id;
  ObjectId author;
  String name;
  String notes;
  DateTime createTime;
  int time; // in minutes
  int birders; // birder amount
  double distance;
  String type = ''; // list type
  bool complete;
  bool sync;

  double lon;
  double lat;
  double ele;

  String country;
  String province;
  String city;
  String county;
  String poi;
  ObjectId track;

  String comment = '';

  BirdList({
    required this.id,
    required this.author,
    required this.name,
    required this.notes,
    required this.createTime,
    required this.sync,
    required this.lon,
    required this.lat,
    required this.ele,
    required this.country,
    required this.province,
    required this.city,
    required this.county,
    required this.poi,
    required this.track,
    required this.comment,
    required this.type,
    required this.time,
    required this.birders,
    required this.distance,
    required this.complete,
  });

  factory BirdList.fromJson(Map<String, dynamic> json) => BirdList(
        id: ObjectId.fromHexString(json['_id']),
        author: ObjectId.fromHexString(json['author']),
        name: json['name'],
        notes: json['notes'],
        createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
        sync: true,
        lon: double.parse(json['lon']),
        lat: double.parse(json['lat']),
        ele: double.parse(json['ele']),
        country: json['country'],
        province: json['province'],
        city: json['city'],
        county: json['county'],
        poi: json['poi'],
        track: json['track'],
        comment: json['comment'],
        type: json['type'],
        time: json['time'],
        birders: json['birders'],
        distance: json['distance'],
        complete: json['complete'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id.hexString,
        'author': author.hexString,
        'name': name,
        'notes': notes,
        'createTime': createTime.millisecondsSinceEpoch,
        'lon': lon,
        'lat': lat,
        'ele': ele,
        'country': country,
        'province': province,
        'city': city,
        'county': county,
        'poi': poi,
        'track': track,
        'comment': comment,
        'type': type,
        'time': time,
        'birders': birders,
        'distance': distance,
        'complete': complete,
      };
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
