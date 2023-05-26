import 'on_db.dart';

class DbManager {
  static OnDb? database;

  static setDb() async {
    database = await $FloorOnDb
        .databaseBuilder('on_database.db')
        .build();
  }

  static OnDb get db => database!;
}
