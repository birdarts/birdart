import 'package:floor/floor.dart';
import 'package:objectid/objectid.dart';
import 'package:package/model/type_converter.dart';

class ObjectIdDbConverter extends TypeConverter<ObjectId, String> implements ObjectIdConverter {
  @override
  ObjectId decode(String databaseValue) => ObjectIdConverter.decode(databaseValue);

  @override
  String encode(ObjectId value) => ObjectIdConverter.encode(value);
}

class DateTimeDbConverter extends TypeConverter<DateTime, int> {
  @override
  DateTime decode(int databaseValue) => DateTimeConverter.decode(databaseValue);

  @override
  int encode(DateTime value) => DateTimeConverter.encode(value);
}

class StringListDbConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) => StringListConverter.decode(databaseValue);

  @override
  String encode(List<String> value) => StringListConverter.encode(value);
}
