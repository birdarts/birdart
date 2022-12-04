import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class SQLProvider{

  static Database? database;

  static init() async {
    database = await openDatabase(path.join(await getDatabasesPath(), 'tiles.db'));
  }
}