import 'package:floor_annotation/floor_annotation.dart';
import 'package:objectid/objectid.dart';

class ObjectIdConverter extends TypeConverter<ObjectId, String> {
  @override
  ObjectId decode(String databaseValue) =>
      ObjectId.fromHexString(databaseValue);

  @override
  String encode(ObjectId value) => value.hexString;
}

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) =>
      DateTime.fromMillisecondsSinceEpoch(databaseValue);

  @override
  int encode(DateTime value) => value.millisecondsSinceEpoch;
}

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    if (databaseValue.isEmpty) {
      return [];
    } else {
      databaseValue =
          databaseValue.toString().replaceAll('[', '').replaceAll(']', '');

      if (databaseValue.isEmpty) {
        return [];
      } else {
        return databaseValue.split(', ');
      }
    }
  }

  @override
  String encode(List<String> value) => value.toString();
}
