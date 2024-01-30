import 'package:drift/drift.dart';
import 'package:shared/shared.dart';

@UseRowClass(_DbRecord)
class DbRecord extends Table {
  @override
  Set<Column> get primaryKey => {id};

  TextColumn get id => text().withLength(max: 36, min: 36)();
  TextColumn get checklist => text()();
  TextColumn get author => text()();
  TextColumn get species => text()();
  TextColumn get speciesRef => text()();
  
  TextColumn get tags => text().map(StringListConverter())();
  TextColumn get notes => text()();
  IntColumn get amount => integer()();
  TextColumn get appendix => text().map(MapConverter())();
  BoolColumn get sync => boolean()();

  DateTimeColumn get createTime => dateTime()();
  DateTimeColumn get updateTime => dateTime()();
}

// @Entity(tableName: 'RECORD')
class _DbRecord {
  // @primaryKey
  String id;
  String checklist;
  String author;
  String species;
  String speciesRef;

  List<String> tags;
  String notes;
  int amount;
  Map<String, dynamic> appendix;
  bool sync; // if changes already uploaded.

  DateTime createTime;
  DateTime updateTime;

  _DbRecord({
    required this.id,
    required this.checklist,
    required this.author,
    required this.species,
    required this.speciesRef,
    required this.notes,
    required this.amount,
    required this.sync,
    required this.createTime,
    required this.updateTime,
    required this.tags,
    required this.appendix
  });

  factory _DbRecord.fromJson(Map<String, dynamic> json) => _DbRecord(
        id: (json['id']),
        checklist: (json['checklist']),
        author: (json['author']),
        species: json['species'],
        speciesRef: json['speciesRef'],
        notes: json['notes'],
        sync: true,
        amount: int.tryParse(json['amount'].toString()) ?? 1,
        createTime: DateTime.fromMicrosecondsSinceEpoch(json['createTime']),
        updateTime: DateTime.fromMicrosecondsSinceEpoch(json['updateTime']),
        tags: json['tags'],
        appendix: json['appendix']
      );

  Map<String, dynamic> toJson() => {
        '_id': id.toString(),
        'checklist': checklist.toString(),
        'author': author.toString(),
        'species': species,
        'speciesRef': speciesRef,
        'notes': notes,
        'amount': amount,
        'createTime': createTime.microsecondsSinceEpoch,
        'updateTime': updateTime.microsecondsSinceEpoch,
        'tags': tags,
        'appendix': appendix
      };

  _DbRecord.add(
      {required this.checklist,
      required this.species,
      required this.speciesRef,
      required this.author,})
      : id = uuid.v1(),
        sync = false,
        amount = 1,
        appendix = {},
        notes = '',
        tags = [],
        createTime = DateTime.now(),
        updateTime = DateTime.now();

  // @ignore
  String get oil => appendix[RecordKeys.oil] ?? '';

  // @ignore
  set oil(String value) {
    appendix[RecordKeys.oil] = value;
  }

  // @ignore
  Map<String, Map<String, int>> get ageSex {
    appendix[RecordKeys.ageSex] = appendix[RecordKeys.ageSex] ?? {
      RecordKeys.nestling: {RecordKeys.male: 0, RecordKeys.female: 0, RecordKeys.undefined: 0},
      RecordKeys.juvenile: {RecordKeys.male: 0, RecordKeys.female: 0, RecordKeys.undefined: 0},
      RecordKeys.adult: {RecordKeys.male: 0, RecordKeys.female: 0, RecordKeys.undefined: 0},
      RecordKeys.undefined: {RecordKeys.male: 0, RecordKeys.female: 0, RecordKeys.undefined: 0},
    };

    return appendix[RecordKeys.ageSex];
  }

  // @ignore
  set ageSex(Map<String, Map<String, int>> value) {
    appendix[RecordKeys.ageSex] = value;
  }

  // @ignore
  String get behaviour => appendix[RecordKeys.behaviour] ?? '';

  // @ignore
  set behaviour(String value) {
    appendix[RecordKeys.behaviour] = value;
  }
}

// @dao
abstract class DbRecordDao {
  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(_DbRecord record);

  // @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertList(List<_DbRecord> records);

  // @delete
  Future<int> deleteOne(_DbRecord record);

  // @delete
  Future<int> deleteList(List<_DbRecord> records);

  // @update
  Future<int> updateOne(_DbRecord record);

  // @update
  Future<int> updateList(List<_DbRecord> records);

  // @Query("DELETE FROM record WHERE id = :recordId")
  Future<int?> deleteById(String recordId);

  // @Query("DELETE FROM record WHERE project = :projectId")
  Future<int?> deleteByProject(String projectId);

  // @Query("SELECT * FROM record")
  Future<List<_DbRecord>> getAll();

  // @Query("SELECT * FROM record WHERE id = :idArg")
  Future<List<_DbRecord>> getById(String idArg);

  // @Query("SELECT * FROM record WHERE project = :projectArg")
  Future<List<_DbRecord>> getByProject(String projectArg);

  // @Query("SELECT * FROM record WHERE project = :projectArg and sync <> 1")
  Future<List<_DbRecord>> getByProjectUnsynced(String projectArg);
}
