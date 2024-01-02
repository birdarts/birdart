import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppDir {
  static Directory data = Directory('');
  static Directory cache = Directory('');

  static setDir() async {
    data = await getApplicationDocumentsDirectory();
    cache = await getTemporaryDirectory();
  }
}
