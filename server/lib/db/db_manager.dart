import 'server_db.dart';

class DbManager {
  static ServerDb? database;

  static setDb() async {
    database = await $FloorServerDb.databaseBuilder('on_database.sqlite').build();
  }

  static ServerDb get db => database!;
}
