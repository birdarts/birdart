import 'dart:async';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:floor/floor.dart' as floor;
import 'package:sqflite/sqflite.dart' as sqflite;

final sqfliteDatabaseFactory = DatabaseFactory();

class FloorDatabase {
  @override
  late StreamController<String> changeListener;

  late Database database;

  Future<void> close() async {
    await changeListener.close();

    final database = this.database;
    if (database.isOpen) {
      await database.close();
    }
  }

}

typedef DatabaseExecutor = Database;

class DatabaseFactory implements sqflite.DatabaseFactory{
  @override
  Future<bool> databaseExists(String path) {
    // TODO: implement databaseExists
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDatabase(String path) {
    // TODO: implement deleteDatabase
    throw UnimplementedError();
  }

  @override
  Future<String> getDatabasesPath() {
    // TODO: implement getDatabasesPath
    throw UnimplementedError();
  }

  @override
  Future<Database> openDatabase(String path, {sqflite.OpenDatabaseOptions? options}) {
    // TODO: implement openDatabase
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readDatabaseBytes(String path) {
    // TODO: implement readDatabaseBytes
    throw UnimplementedError();
  }

  @override
  Future<void> setDatabasesPath(String path) {
    // TODO: implement setDatabasesPath
    throw UnimplementedError();
  }

  @override
  Future<void> writeDatabaseBytes(String path, Uint8List bytes) {
    // TODO: implement writeDatabaseBytes
    throw UnimplementedError();
  }

  Future<String> getDatabasePath(final String name) async {
    final databasesPath = await this.getDatabasesPath();
    return path.join(databasesPath, name);
  }
}

class Database implements sqflite.Database {
  @override
  sqflite.Batch batch() {
    // TODO: implement batch
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  // TODO: implement database
  sqflite.Database get database => throw UnimplementedError();

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<T> devInvokeMethod<T>(String method, [Object? arguments]) {
    // TODO: implement devInvokeMethod
    throw UnimplementedError();
  }

  @override
  Future<T> devInvokeSqlMethod<T>(String method, String sql, [List<Object?>? arguments]) {
    // TODO: implement devInvokeSqlMethod
    throw UnimplementedError();
  }

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  @override
  Future<int> insert(String table, Map<String, Object?> values, {String? nullColumnHack, sqflite.ConflictAlgorithm? conflictAlgorithm}) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  // TODO: implement isOpen
  bool get isOpen => throw UnimplementedError();

  @override
  // TODO: implement path
  String get path => throw UnimplementedError();

  @override
  Future<List<Map<String, Object?>>> query(String table, {bool? distinct, List<String>? columns, String? where, List<Object?>? whereArgs, String? groupBy, String? having, String? orderBy, int? limit, int? offset}) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future<sqflite.QueryCursor> queryCursor(String table, {bool? distinct, List<String>? columns, String? where, List<Object?>? whereArgs, String? groupBy, String? having, String? orderBy, int? limit, int? offset, int? bufferSize}) {
    // TODO: implement queryCursor
    throw UnimplementedError();
  }

  @override
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) {
    // TODO: implement rawDelete
    throw UnimplementedError();
  }

  @override
  Future<int> rawInsert(String sql, [List<Object?>? arguments]) {
    // TODO: implement rawInsert
    throw UnimplementedError();
  }

  @override
  Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments]) {
    // TODO: implement rawQuery
    throw UnimplementedError();
  }

  @override
  Future<sqflite.QueryCursor> rawQueryCursor(String sql, List<Object?>? arguments, {int? bufferSize}) {
    // TODO: implement rawQueryCursor
    throw UnimplementedError();
  }

  @override
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) {
    // TODO: implement rawUpdate
    throw UnimplementedError();
  }

  @override
  Future<T> readTransaction<T>(Future<T> Function(sqflite.Transaction txn) action) {
    // TODO: implement readTransaction
    throw UnimplementedError();
  }

  @override
  Future<T> transaction<T>(Future<T> Function(sqflite.Transaction txn) action, {bool? exclusive}) {
    // TODO: implement transaction
    throw UnimplementedError();
  }

  @override
  Future<int> update(String table, Map<String, Object?> values, {String? where, List<Object?>? whereArgs, sqflite.ConflictAlgorithm? conflictAlgorithm}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

class OpenDatabaseOptions implements sqflite.OpenDatabaseOptions {
  OpenDatabaseOptions(
      {int? version,
        sqflite.OnDatabaseConfigureFn? onConfigure,
        sqflite.OnDatabaseCreateFn? onCreate,
        sqflite.OnDatabaseVersionChangeFn? onUpgrade,
        sqflite.OnDatabaseVersionChangeFn? onDowngrade,
        sqflite.OnDatabaseOpenFn? onOpen,
        bool? readOnly = false,
        bool? singleInstance = true});

  @override
  sqflite.OnDatabaseConfigureFn? onConfigure;

  @override
  sqflite.OnDatabaseCreateFn? onCreate;

  @override
  sqflite.OnDatabaseVersionChangeFn? onDowngrade;

  @override
  sqflite.OnDatabaseOpenFn? onOpen;

  @override
  sqflite.OnDatabaseVersionChangeFn? onUpgrade;

  @override
  late bool readOnly;

  @override
  late bool singleInstance;

  @override
  int? version;
}