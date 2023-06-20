import 'package:objectid/objectid.dart';

class BaseBirdList {
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

  BaseBirdList({
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

  factory BaseBirdList.fromJson(Map<String, dynamic> json) => BaseBirdList(
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
