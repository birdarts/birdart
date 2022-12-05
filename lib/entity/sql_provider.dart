import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class SQLProvider {
  static Database? database;

  static init() async {
    database =
        await openDatabase(path.join(await getDatabasesPath(), 'tiles.db'));
  }
}
