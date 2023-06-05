import 'package:objectid/objectid.dart';

class BaseBirdList {
  ObjectId id;
  ObjectId author;
  String name;
  String notes;
  String coverImg;
  DateTime createTime;
  bool sync;

  double lon;
  double lat;
  double ele;

  String country;
  String province;
  String city;
  String county;
  String poi;

  String type = ''; // for future usage

  BaseBirdList({
    required this.id,
    required this.author,
    required this.name,
    required this.notes,
    required this.coverImg,
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
  });

  factory BaseBirdList.fromJson(Map<String, dynamic> json) => BaseBirdList(
    id: ObjectId.fromHexString(json['_id']),
    author: ObjectId.fromHexString(json['author']),
    name: json['name'],
    notes: json['notes'],
    createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
    sync: true,
    coverImg: '',
    lon: double.parse(json['lon']),
    lat: double.parse(json['lat']),
    ele: double.parse(json['ele']),
    country: json['country'],
    province: json['province'],
    city: json['city'],
    county: json['county'],
    poi: json['poi'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'author': author.hexString,
    'name': name,
    'notes': notes,
    'coverImg': coverImg,
    'createTime': createTime.millisecondsSinceEpoch,
    'lon': lon,
    'lat': lat,
    'ele': ele,
    'country': country,
    'province': province,
    'city': city,
    'county': county,
    'poi': poi,
  };
}
