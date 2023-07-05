import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  final dbName = 'admin_areas';
  await saveAdmins('assets/countries.json', dbName, 'countries');
  await saveAdmins('assets/states.json', dbName, 'states');
  await saveAdmins('assets/cities.json', dbName, 'cities');
}

Future<void> saveAdmins(
    String path, String dbName, String collectionName) async {
  final file = File(path);
  final jsonString = await file.readAsString();
  final jsonList = List<Map<String, dynamic>>.from(
          jsonDecode(jsonString).cast<Map<String, dynamic>>())
      .map((map) => renameKeys(map, {'id': '_id'}))
      .toList();
  ;

  final db = await Db.create('mongodb://localhost:27017/$dbName');
  await db.open();

  final collection = db.collection(collectionName);
  await collection.remove({});

  final length = 99999;
  final List<Future> futures = [];

  for (var i = 0; i < jsonList.length; i += length) {
    final end = (i + length < jsonList.length) ? i + length : jsonList.length;
    futures.add(collection.insertAll(jsonList.sublist(i, end)));
  }

  await Future.wait(futures);

  await db.close();
}

Map<String, dynamic> renameKeys(
        Map<String, dynamic> map, Map<String, String> keyMap) =>
    {
      for (var key in map.keys)
        keyMap.containsKey(key) ? keyMap[key]! : key: map[key]
    };
