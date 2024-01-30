import 'dart:convert';

import 'package:drift/drift.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> fromSql(String fromDb) {
    try {
      return jsonDecode(fromDb);
    } catch(e) {
      return [];
    }
    // if (fromDb.isEmpty) {
    //   return [];
    // } else {
    //   fromDb = fromDb.toString().replaceAll('[', '').replaceAll(']', '');
    //
    //   if (fromDb.isEmpty) {
    //     return [];
    //   } else {
    //     return fromDb.split(', ');
    //   }
    // }
  }

  @override
  String toSql(List<String> value) => jsonEncode(value); //value.toString();
}

class MapConverter extends TypeConverter<Map<String, dynamic>, String> {
  @override
  Map<String, dynamic> fromSql(String fromDb) {
    try {
      return jsonDecode(fromDb);
    } catch(e) {
      return {};
    }
  }

  @override
  String toSql(Map<String, dynamic> value) => jsonEncode(value);
}