import 'package:drift/drift.dart';

import '../model/bird_species.dart';
import '../model/checklist.dart';
import '../model/hotspot.dart';
import '../model/image.dart';
import '../model/record.dart';
import '../model/track.dart';
import '../model/user.dart';
import 'drift_server.drift.dart';


// dart run build_runner build --delete-conflicting-outputs

@DriftDatabase(tables: [Bird, Hotspot, DbImage, DbRecord, Checklist, Track, User])
class ServerDB extends $ServerDB {
  ServerDB(super.e);

  @override
  int get schemaVersion => 1;

  // Future<List<Checklist>> get checklistGetAll => select(checklistT).get();
}
