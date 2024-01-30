import 'package:drift/drift.dart';

@UseRowClass(_Bird)
class Bird extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get scientific => text()();
  TextColumn get vernacular => text()();
  TextColumn get ordo => text()();
  TextColumn get familia => text()();
  TextColumn get genus => text()();
}

// @entity
class _Bird {
  // @primaryKey
  String id;
  String scientific;
  String vernacular;
  String ordo; 
  String familia = '';
  String genus;

  _Bird({
    required this.id,
    required this.scientific,
    required this.vernacular,
    required this.ordo,
    required this.familia,
    required this.genus,
  });

  factory _Bird.fromJson(Map<String, dynamic> json) => _Bird(
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


abstract class BirdDao {
  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(_Bird bird);

  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<_Bird> birds);

  // @delete
  Future<int> deleteOne(_Bird bird);

  // @delete
  Future<int> deleteList(List<_Bird> birds);

  // @update
  Future<int> updateOne(_Bird bird);

  // @update
  Future<int> updateList(List<_Bird> birds);

  // @Query("SELECT * FROM bird ORDER BY datetime(startTime) desc")
  Future<List<_Bird>> getAll();
}