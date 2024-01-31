import 'package:drift/drift.dart';

import '../model/bird_species.dart';
import '../model/checklist.dart';
import '../model/hotspot.dart';
import '../model/image.dart';
import '../model/record.dart';
import '../model/track.dart';

import '../model/user.dart';
import 'drift_db.drift.dart';

// dart run build_runner build --delete-conflicting-outputs

@DriftDatabase(
  tables: [Bird, Hotspot, DbImage, DbRecord, Checklist, Track, User],
  daos: [BirdDao, HotspotDao, DbImageDao, DbRecordDao, ChecklistDao, TrackDao, UserDao],
)
class BirdartDB extends $BirdartDB {
  BirdartDB(super.e);

  @override
  int get schemaVersion => 1;
}
