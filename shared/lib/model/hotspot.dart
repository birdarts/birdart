import 'package:floor_annotation/floor_annotation.dart';
import 'package:objectid/objectid.dart';

@entity
class Hotspot {
  @primaryKey
  ObjectId id;
  ObjectId author;
  String name;
  double lon;
  double lat;
  double ele;

  String country;
  String province;
  String city;
  String county;

  Hotspot({
    required this.id,
    required this.author,
    required this.name,
    required this.lon,
    required this.lat,
    required this.ele,
    required this.country,
    required this.province,
    required this.city,
    required this.county,
  });

  factory Hotspot.fromJson(Map<String, dynamic> json) => Hotspot(
    id: ObjectId.fromHexString(json['_id']),
    author: ObjectId.fromHexString(json['author']),
    name: json['name'].toString(),
    lon: double.tryParse(json['lon'] ?? '0.0') ?? json['lon'] ?? 0.0,
    lat: double.tryParse(json['lat'] ?? '0.0') ?? json['lat'] ?? 0.0,
    ele: double.tryParse(json['ele'] ?? '0.0') ?? json['ele'] ?? 0.0,
    country: json['country'],
    province: json['province'],
    city: json['city'],
    county: json['county'],
  );

  Map<String, dynamic> toJson() => {
    '_id': id.hexString,
    'author': author.hexString,
    'name': name,
    'lon': lon,
    'lat': lat,
    'ele': ele,
    'country': country,
    'province': province,
    'city': city,
    'county': county,
  };

  Hotspot.empty(this.author)
      : id = ObjectId(),
        name = '',
        lon = 0.0,
        lat = 0.0,
        ele = 0.0,
        country = '',
        province = '',
        city = '',
        county = '';
}

@dao
abstract class HotspotDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(Hotspot hotspot);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<Hotspot> hotspots);

  @delete
  Future<int> deleteOne(Hotspot hotspot);

  @delete
  Future<int> deleteList(List<Hotspot> hotspots);

  @update
  Future<int> updateOne(Hotspot hotspot);

  @update
  Future<int> updateList(List<Hotspot> hotspots);

  @Query("DELETE FROM hotspot WHERE id = :hotspotId")
  Future<int?> deleteById(String hotspotId);

  @Query("SELECT * FROM hotspot ORDER BY datetime(startTime) desc")
  Future<List<Hotspot>> getAll();

  @Query("SELECT * FROM hotspot WHERE id = :hotspotId")
  Future<List<Hotspot>> getById(String hotspotId);

  @Query("SELECT * FROM hotspot WHERE sync <> 1")
  Future<List<Hotspot>> getUnsynced();

  @Query(
      "SELECT * FROM hotspot WHERE instr(startTime, :date) ORDER BY datetime(startTime) desc")
  Future<List<Hotspot>> getByDate(String date);
}