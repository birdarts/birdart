import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_map/flutter_map.dart';
import 'package:naturalist/entity/app_dir.dart';
import 'package:path/path.dart' as path;

class CacheTileProvider extends TileProvider {
  String tileName;
  final String urlTemplate;
  String userAgentPackageName;
  List<String> subdomains;

  CacheTileProvider({
    required this.tileName,
    required this.urlTemplate,
    required this.userAgentPackageName,
    this.subdomains = const <String>[],
  });

  @override
  ImageProvider getImage(Coords<num> coords, TileLayer options) {
    var z = coords.z.round().toString();
    var x = coords.x.round().toString();
    var y = coords.y.round().toString();
    var tileImage;
    Map<String, String> header = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Connection': 'Keep-Alive',
      'Accept': 'image/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'User-Agent': 'flutter_map / $userAgentPackageName',
    };

    var dir = path.join(AppDir.cache.path, tileName, z, x, y);
    Directory(dir).createSync(recursive: true);
    var file = File(path.join(dir, 'tile.png'));

    if (file.existsSync()) {
      tileImage = FileImage(file);
    } else {
      String url = urlTemplate
          .replaceFirst('{z}', z)
          .replaceFirst('{x}', x)
          .replaceFirst('{y}', y);
      if (subdomains.isEmpty){
        tileImage = NetworkImage(url, headers: header);
        _saveImage(file, tileImage);
      } else {
        for (var element in subdomains) {
          try {
            tileImage = NetworkImage(url.replaceFirst('{s}', element), headers: header);
            _saveImage(file, tileImage);
          } catch (e){
            continue;
          }
        }
      }
    }

    return tileImage;
  }

  Future<void> _saveImage (File file, NetworkImage nImg) async {
    try {
      ui.Image? uiImage = await _getImage(nImg);
      if (uiImage != null){
        ByteData? bytes = await uiImage.toByteData(format: ui.ImageByteFormat.png);
        if (bytes != null) {
          final buffer = bytes.buffer;
          file.writeAsBytes(buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        }
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  // copied from https://stackoverflow.com/a/58264954/13447926
  Future<ui.Image?> _getImage(NetworkImage nImg) async {
    try {
      var completer = Completer<ImageInfo>();
      nImg.resolve(const ImageConfiguration()).addListener(ImageStreamListener((info, _) {
        completer.complete(info);
      }));
      ImageInfo imageInfo = await completer.future;
      return imageInfo.image;
    } catch (e) {
      dev.log(e.toString());
      return null;
    }
  }
}
