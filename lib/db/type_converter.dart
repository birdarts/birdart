import 'package:floor/floor.dart';
import 'package:objectid/objectid.dart';

class ObjectIdConverter extends TypeConverter<ObjectId, String> {
  @override
  ObjectId decode(String databaseValue) => ObjectId.fromHexString(databaseValue);

  @override
  String encode(ObjectId value) => value.hexString;
}

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) => DateTime.fromMillisecondsSinceEpoch(databaseValue);

  @override
  int encode(DateTime value) => value.millisecondsSinceEpoch;
}
