import 'package:objectid/objectid.dart';

class BaseBirdList {
  ObjectId id;
  ObjectId author;
  String name;
  String notes;
  String coverImg;
  DateTime createTime;
  bool sync;

  String type = ''; // for future usage

  BaseBirdList({
    required this.id,
    required this.author,
    required this.name,
    required this.notes,
    required this.coverImg,
    required this.createTime,
    required this.sync,
  });

  factory BaseBirdList.fromJson(Map<String, dynamic> json) => BaseBirdList(
    id: ObjectId.fromHexString(json['_id']),
    author: ObjectId.fromHexString(json['author']),
    name: json['name'],
    notes: json['notes'],
    createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
    sync: true,
    coverImg: '',
  );

  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'author': author.hexString,
    'name': name,
    'notes': notes,
    'coverImg': coverImg,
    'createTime': createTime.millisecondsSinceEpoch,
  };
}
