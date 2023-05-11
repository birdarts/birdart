import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/src/layer/tile_layer/tile_provider/network_no_retry_image_provider.dart'; // this line will be warned as "Don't import Implementation files from other package", just ignore it.
import 'package:naturalist/entity/app_dir.dart';
import 'package:path/path.dart' as path;

class CacheTileProvider extends NetworkNoRetryTileProvider {
  String tileName;

  CacheTileProvider(
    this.tileName, {
    super.headers,
    super.httpClient,
  });

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    File file = File(path.join(
        AppDir.cache.path,
        'flutter_map_tiles',
        tileName,
        coordinates.z.round().toString(),
        coordinates.x.round().toString(),
        '${coordinates.y.round().toString()}.png'));

    if (file.existsSync()) {
      return FileImage(file);
    } else {
      return NetworkImageSaverProvider(
        getTileUrl(coordinates, options),
        file,
        headers: headers,
        httpClient: httpClient,
        fallbackUrl: null,
      );
    }
  }
}

class NetworkImageSaverProvider extends FMNetworkNoRetryImageProvider {
  File file;

  NetworkImageSaverProvider(
    super.url,
    this.file, {
    HttpClient? httpClient,
    super.headers = const {},
    required super.fallbackUrl,
  });

  @override
  ImageStream createStream(ImageConfiguration configuration) {
    ImageStream stream = ImageStream();
    ImageStreamListener listener = ImageStreamListener(imageListener);
    stream.addListener(listener);
    return stream;
  }

  void imageListener(ImageInfo imageInfo, bool synchronousCall) {
    ui.Image uiImage = imageInfo.image;
    _saveImage(uiImage);
  }

  Future<void> _saveImage(ui.Image uiImage) async {
    try {
      Directory parent = file.parent;
      if (!await parent.exists()) {
        await parent.create(recursive: true);
      }
      ByteData? bytes =
          await uiImage.toByteData(format: ui.ImageByteFormat.png);
      if (bytes != null) {
        final buffer = bytes.buffer;
        file.writeAsBytes(
            buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }
}
