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
  DateTime createTime;
  @override
  int birders;
  @override
  String comment;
  @override
  bool complete;
  @override
  double distance;
  @override
  int time;

  @override
  ObjectId track;

  @override
  bool sync;

  @override
  double lon;
  @override
  double lat;
  @override
  double ele;

  @override
  String country;
  @override
  String province;
  @override
  String city;
  @override
  String county;
  @override
  String poi;

  @override
  String type = ''; // for future usage

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

  BirdList.add({
    required this.name,
    required this.notes,
    required this.lon,
    required this.lat,
    required this.ele,
    required this.country,
    required this.province,
    required this.city,
    required this.county,
    required this.poi,
    required this.track,
  })
  : id = ObjectId(),
    author = ObjectId.fromHexString(UserProfile.id),
    createTime = DateTime.now(),
    sync = false,
    comment = '',
    type = '偶然记录',
    time = 0,
    birders = 1,
    distance = 0,
    complete = false;

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

  @override
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
