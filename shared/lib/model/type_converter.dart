import 'package:floor_annotation/floor_annotation.dart';
import 'package:xid/xid.dart';

class XidConverter extends TypeConverter<Xid, String> {
  @override
  Xid decode(String databaseValue) =>
      Xid.fromString(databaseValue);

  @override
  String encode(Xid value) => value.toString();
}

class DateTimeConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) =>
      DateTime.fromMicrosecondsSinceEpoch(databaseValue);

  @override
  int encode(DateTime value) => value.microsecondsSinceEpoch;
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
