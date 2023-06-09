import 'package:floor_annotation/floor_annotation.dart';
import 'package:objectid/objectid.dart';

class BaseRecord {
  @ignore
  ObjectId id;
  @ignore
  ObjectId project;
  @ignore
  ObjectId author;

  @ignore
  String species;
  @ignore
  String speciesRef;

  @ignore
  List<String> tags;
  @ignore
  String notes;
  @ignore
  bool sync; // if changes already uploaded.

  @ignore
  DateTime observeTime;

  BaseRecord({
    required this.id,
    required this.project,
    required this.author,
    required this.species,
    required this.speciesRef,
    required this.notes,
    required this.sync,
    required this.observeTime,
    required this.tags,
  });

  factory BaseRecord.fromJson(Map<String, dynamic> json) => BaseRecord(
    id: ObjectId.fromHexString(json['id']),
    project: ObjectId.fromHexString(json['project']),
    author: ObjectId.fromHexString(json['author']),
    species: json['species'],
    speciesRef: json['speciesRef'],
    notes: json['notes'],
    sync: true,
    observeTime: DateTime.fromMillisecondsSinceEpoch(json['observeTime']),
    tags: json['tags'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'project': project.hexString,
    'author': author.hexString,
    'species': species,
    'speciesRef': speciesRef,
    'notes': notes,
    'observeTime': observeTime.millisecondsSinceEpoch,
    'tags': tags
  };
}
