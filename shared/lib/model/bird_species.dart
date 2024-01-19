import 'package:floor_annotation/floor_annotation.dart';


@entity
class Bird {
  @primaryKey
  String id;
  String scientific;
  String vernacular;
  String ordo; 
  String familia = '';
  String genus;

  Bird({
    required this.id,
    required this.scientific,
    required this.vernacular,
    required this.ordo,
    required this.familia,
    required this.genus,
  });

  factory Bird.fromJson(Map<String, dynamic> json) => Bird(
    id: json['_id'],
    scientific: json['author'],
    vernacular: json['notes'],
    ordo: json['track'],
    familia: json['comment'],
    genus: json['type'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'author': scientific,
    'notes': vernacular,
    'track': ordo,
    'comment': familia,
    'type': genus,
  };
}


@dao
abstract class BirdDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(Bird bird);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<Bird> birds);

  @delete
  Future<int> deleteOne(Bird bird);

  @delete
  Future<int> deleteList(List<Bird> birds);

  @update
  Future<int> updateOne(Bird bird);

  @update
  Future<int> updateList(List<Bird> birds);

  @Query("SELECT * FROM bird ORDER BY datetime(startTime) desc")
  Future<List<Bird>> getAll();
}