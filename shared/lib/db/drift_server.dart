import 'package:shared/model/bird_species.dart';
import 'package:shared/model/checklist.dart';
import 'package:shared/model/hotspot.dart';
import 'package:shared/model/image.dart';
import 'package:shared/model/record.dart';
import 'package:shared/model/track.dart';
import 'package:drift/drift.dart';
import 'package:shared/model/user.dart';

import 'drift_server.drift.dart';


// dart run build_runner build --delete-conflicting-outputs

@DriftDatabase(tables: [BirdT, HotspotT, DbImageT, DbRecordT, ChecklistT, TrackT, UserT])
class ServerDB extends $ServerDB {
  ServerDB(super.e);

  @override
  int get schemaVersion => 1;

  Future<List<Checklist>> get checklistGetAll => select(checklistT).get();
}
