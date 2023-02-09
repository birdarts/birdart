import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/src/painting/image_provider.dart';
import 'package:flutter_map/flutter_map.dart';

class EmptyTileProvider extends TileProvider {
  @override
  ImageProvider<Object> getImage(Coords<num> coords, TileLayer options) {
    Uint8List blankBytes = const Base64Codec()
        .decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
    return MemoryImage(blankBytes);
  }
}
