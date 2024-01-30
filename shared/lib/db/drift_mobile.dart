import 'package:drift/drift.dart';

import '../model/bird_species.dart';
import '../model/checklist.dart';
import '../model/hotspot.dart';
import '../model/image.dart';
import '../model/record.dart';
import '../model/track.dart';
import 'drift_mobile.drift.dart';


// dart run build_runner build --delete-conflicting-outputs

@DriftDatabase(tables: [Bird, Hotspot, DbImage, DbRecord, Checklist, Track])
class MobileDB extends $MobileDB {
  MobileDB(super.e);

  @override
  int get schemaVersion => 1;

  // Future<List<Checklist>> get checklistGetAll => select(checklistT).get();
}
