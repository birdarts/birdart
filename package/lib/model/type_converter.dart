import 'package:objectid/objectid.dart';

class ObjectIdConverter {
  static ObjectId decode(String databaseValue) => ObjectId.fromHexString(databaseValue);

  static String encode(ObjectId value) => value.hexString;
}

class DateTimeConverter {
  static DateTime decode(int databaseValue) => DateTime.fromMillisecondsSinceEpoch(databaseValue);

  static int encode(DateTime value) => value.millisecondsSinceEpoch;
}

class StringListConverter {
  static List<String> decode(String databaseValue) {
    if (databaseValue.isEmpty) {
      return [];
    } else {
      databaseValue = databaseValue
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '');

      if (databaseValue.isEmpty) {
        return [];
      } else {
        return databaseValue.split(', ');
      }
    }
  }

  static String encode(List<String> value) => value.toString();
}