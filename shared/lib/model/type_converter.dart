import 'dart:convert';

import 'package:floor_annotation/floor_annotation.dart';
import 'user.dart';

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
    try {
      return jsonDecode(databaseValue);
    } catch(e) {
      return [];
    }
    // if (databaseValue.isEmpty) {
    //   return [];
    // } else {
    //   databaseValue =
    //       databaseValue.toString().replaceAll('[', '').replaceAll(']', '');
    //
    //   if (databaseValue.isEmpty) {
    //     return [];
    //   } else {
    //     return databaseValue.split(', ');
    //   }
    // }
  }

  @override
  String encode(List<String> value) => jsonEncode(value); // value.toString();
}

class MapConverter extends TypeConverter<Map<String, dynamic>, String> {
  @override
  Map<String, dynamic> decode(String databaseValue) {
    try {
      return jsonDecode(databaseValue);
    } catch(e) {
      return {};
    }
  }

  @override
  String encode(Map<String, dynamic> value) => jsonEncode(value);
}

class StatusConverter extends TypeConverter<UserStatus, int> {
  @override
  UserStatus decode(int databaseValue) => UserStatus.values[databaseValue];

  @override
  int encode(UserStatus value) => value.value;
}

class RoleConverter extends TypeConverter<UserRole, int> {
  @override
  UserRole decode(int databaseValue) => UserRole.values[databaseValue];

  @override
  int encode(UserRole value) => value.value;
}
