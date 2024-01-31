import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/db/drift_db.dart';
import 'package:sqlite3/sqlite3.dart';

class DbManager {
  static BirdartDB? database;

  static Future<void> setDb() async {
    database = BirdartDB(_openConnection());
  }

  static BirdartDB get db => database!;
}

// use sqlite for dev
LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    final file = File('db.sqlite');
    sqlite3.tempDirectory = '/tmp';

    return NativeDatabase.createInBackground(file);
  });
}

final _pgDatabase = PgDatabase(
  endpoint: Endpoint(
    host: 'localhost',
    database: 'postgres',
    username: 'postgres',
    password: 'postgres',
  ),
  settings: const ConnectionSettings(
    // If you expect to talk to a Postgres database over a public connection,
    // please use SslMode.verifyFull instead.
    sslMode: SslMode.disable,
  ),
);