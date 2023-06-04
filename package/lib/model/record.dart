import 'dart:convert';

import 'package:objectid/objectid.dart';

class BaseRecord {
  ObjectId id;
  ObjectId project;
  ObjectId author;

  double lon;
  double lat;
  double ele;

  String species;
  String speciesRef;

  String country;
  String province;
  String city;
  String county;
  String poi;

  String notes;
  bool sync; // if changes already uploaded.

  DateTime observeTime;

  BaseRecord({
    required this.id,
    required this.project,
    required this.author,
    required this.lon,
    required this.lat,
    required this.ele,
    required this.species,
    required this.speciesRef,
    required this.country,
    required this.province,
    required this.city,
    required this.county,
    required this.poi,
    required this.notes,
    required this.sync,
    required this.observeTime,
  });

  factory BaseRecord.fromJson(Map<String, dynamic> json) => BaseRecord(
    id: ObjectId.fromHexString(json['id']),
    project: ObjectId.fromHexString(json['project']),
    author: ObjectId.fromHexString(json['author']),
    lon: double.parse(json['lon']),
    lat: double.parse(json['lat']),
    ele: double.parse(json['ele']),
    species: json['species'],
    speciesRef: json['speciesRef'],
    country: json['country'],
    province: json['province'],
    city: json['city'],
    county: json['county'],
    poi: json['poi'],
    notes: json['notes'],
    sync: true,
    observeTime: DateTime.fromMillisecondsSinceEpoch(json['observeTime']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'project': project.hexString,
    'author': author.hexString,
    'lon': lon,
    'lat': lat,
    'ele': ele,
    'species': species,
    'speciesRef': speciesRef,
    'country': country,
    'province': province,
    'city': city,
    'county': county,
    'poi': poi,
    'notes': notes,
    'observeTime': observeTime.millisecondsSinceEpoch,
  };
}
