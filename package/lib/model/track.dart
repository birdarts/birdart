import 'dart:convert';

import 'package:objectid/objectid.dart';

class BaseTrack {
  ObjectId id;
  ObjectId author;

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

  String file = '';

  bool isSelected = false;

  BaseTrack({
    required this.id,
    required this.author,
    required this.startTime,
    required this.endTime,
    required this.sync,
    required this.file,

    this.startLon = 0.0,
    this.startLat = 0.0,
    this.startEle = 0.0,
    this.endLon = 0.0,
    this.endLat = 0.0,
    this.endEle = 0.0,
    this.pointCount = 0,
    this.distance = 0.0,
  });

  factory BaseTrack.fromJson(Map<String, dynamic> json) => BaseTrack(
    id: ObjectId.fromHexString(json['_id']),
    author: ObjectId.fromHexString(json['author']),
    startLon: double.parse(json['startLon']),
    startLat: double.parse(json['startLat']),
    startEle: double.parse(json['startEle']),
    endLon: double.parse(json['endLon']),
    endLat: double.parse(json['endLat']),
    endEle: double.parse(json['endEle']),
    startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime']),
    endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
    pointCount: int.parse(json['pointCount']),
    distance: double.parse(json['distance']),
    sync: true,
    file: json['file'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'author': author.hexString,
    'startLon': startLon,
    'startLat': startLat,
    'startEle': startEle,
    'endLon': endLon,
    'endLat': endLat,
    'endEle': endEle,
    'startTime': startTime.millisecondsSinceEpoch,
    'endTime': endTime.millisecondsSinceEpoch,
    'pointCount': pointCount,
    'distance': distance,
  };
}
