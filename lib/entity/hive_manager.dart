import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveManager{
  static init() async {
    await Hive.initFlutter();
    await Hive.openBox('project');
    await Hive.openBox('record');
    await Hive.openBox('image');
  }

  static test() async {
    var box = await Hive.openBox('contacts');
    var map = {'name': 'sunjiao', 'species': 'hx'};
    box.put('20221228', map);
    box.toMap().forEach((key, value) {
      print(key);
      print(value);
    });
  }
}