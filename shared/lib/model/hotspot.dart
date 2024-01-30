import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

// @UseRowClass(_Hotspot)
class Hotspot extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get author => text()();
  TextColumn get name => text()();
  RealColumn get lon => real()();
  RealColumn get lat => real()();
  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get updateTime => dateTime()();

  TextColumn get country => text()();
  TextColumn get province => text()();
  TextColumn get city => text()();
  TextColumn get county => text()();

  TextColumn get countryId => text()();
  TextColumn get provinceId => text()();
  TextColumn get cityId => text()();
  TextColumn get countyId => text()();
}


// @entity
class _Hotspot {
  // @primaryKey
  String id;
  String author;
  String name;
  double lon;
  double lat;
  DateTime createTime;
  DateTime updateTime;

  String country;
  String province;
  String city;
  String county;

  String countryId;
  String provinceId;
  String cityId;
  String countyId;

  _Hotspot({
    required this.id,
    required this.author,
    required this.name,
    required this.lon,
    required this.lat,
    required this.createTime,
    required this.updateTime,
    required this.country,
    required this.province,
    required this.city,
    required this.county,
    required this.countryId,
    required this.provinceId,
    required this.cityId,
    required this.countyId,
  });

  factory _Hotspot.fromJson(Map<String, dynamic> json) => _Hotspot(
        id: json['_id'],
        author: json['author'],
        name: json['name'].toString(),
        lon: double.tryParse(json['lon'] ?? '0.0') ?? json['lon'] ?? 0.0,
        lat: double.tryParse(json['lat'] ?? '0.0') ?? json['lat'] ?? 0.0,
        createTime: DateTime.fromMicrosecondsSinceEpoch(int.tryParse(json['createTime']) ?? 0),
        updateTime: DateTime.fromMicrosecondsSinceEpoch(int.tryParse(json['updateTime']) ?? 0),
        country: json['country'],
        province: json['province'],
        city: json['city'],
        county: json['county'],
        countryId: json['countryId'],
        provinceId: json['provinceId'],
        cityId: json['cityId'],
        countyId: json['countyId'],
      );

  Map<String, dynamic> toJson() => {
        '_id': id.toString(),
        'author': author.toString(),
        'name': name,
        'lon': lon,
        'lat': lat,
        'createTime': createTime.microsecondsSinceEpoch,
        'updateTime': updateTime.microsecondsSinceEpoch,
        'country': country,
        'province': province,
        'city': city,
        'county': county,
        'countryId': countryId,
        'provinceId': provinceId,
        'cityId': cityId,
        'countyId': countyId,
      };

  _Hotspot.empty(this.author)
      : id = Uuid().v1(),
        name = '',
        lon = 0.0,
        lat = 0.0,
        createTime = DateTime.now(),
        updateTime = DateTime.now(),
        country = '',
        province = '',
        city = '',
        county = '',
        countryId = '',
        provinceId = '',
        cityId = '',
        countyId = '';
}

// @dao
abstract class HotspotDao {
  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(_Hotspot hotspot);

  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<_Hotspot> hotspots);

  // @delete
  Future<int> deleteOne(_Hotspot hotspot);

  // @delete
  Future<int> deleteList(List<_Hotspot> hotspots);

  // @update
  Future<int> updateOne(_Hotspot hotspot);

  // @update
  Future<int> updateList(List<_Hotspot> hotspots);

  // @Query("DELETE FROM hotspot WHERE id = :hotspotId")
  Future<int?> deleteById(String hotspotId);

  // @Query("SELECT * FROM hotspot ORDER BY datetime(startTime) desc")
  Future<List<_Hotspot>> getAll();

  // @Query("SELECT * FROM hotspot WHERE id = :hotspotId")
  Future<List<_Hotspot>> getById(String hotspotId);

  // @Query("SELECT * FROM hotspot WHERE sync <> 1")
  Future<List<_Hotspot>> getUnsynced();

  // @Query("SELECT * FROM hotspot WHERE instr(startTime, :date) ORDER BY datetime(startTime) desc")
  Future<List<_Hotspot>> getByDate(String date);
}
