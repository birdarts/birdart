import 'package:drift_postgres/drift_postgres.dart';
import 'package:postgres/postgres.dart';
import 'package:shared/db/drift_server.dart';

class DbManager {
  static ServerDB? database;

  static setDb() async {
    database = ServerDB(_pgDatabase);
  }

  static ServerDB get db => database!;
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