import 'drift_birdart.dart';

class DbManager {
  static BirdartDatabase? database;

  static setDb() async {
    database = BirdartDatabase();
  }

  static BirdartDatabase get db => database!;
}
