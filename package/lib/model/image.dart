import 'dart:convert';

import 'package:floor_annotation/floor_annotation.dart';
import 'package:objectid/objectid.dart';

class BaseImage {
    @ignore
ObjectId id;
    @ignore
ObjectId record;
    @ignore
ObjectId author;

    @ignore
String imagePath;
    @ignore
String imageId;
    @ignore
int imageSize;
    @ignore
String exif;
    @ignore
bool sync;

  BaseImage({
    required this.id,
    required this.record,
    required this.author,
    required this.imagePath,
    required this.imageId,
    required this.imageSize,
    required this.exif,
    required this.sync,
  });


  factory BaseImage.fromJson(Map<String, dynamic> json) => BaseImage(
    id: ObjectId.fromHexString(json['_id']),
    record: ObjectId.fromHexString(json['record']),
    author: ObjectId.fromHexString(json['author']),
    imagePath: json['imagePath'],
    imageId: json['imageId'],
    imageSize: json['imageSize'],
    exif: json['exif'],
    sync: true,
  );

  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'record': record.hexString,
    'author': author.hexString,
    'imagePath': imagePath,
    'imageId': imageId,
    'imageSize': imageSize,
    'exif': exif,
  };
}
