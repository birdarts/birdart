import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shared/shared.dart';

class DoubleTileProvider extends TileProvider {
  TileLayer chinaTile;
  TileLayer foreignTile;

  DoubleTileProvider(
    this.chinaTile,
    this.foreignTile,
  );

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) {
    if (coordinates.z <= 9 || isTileInChina(coordinates.x, coordinates.y, coordinates.z)) {
      return chinaTile.tileProvider.getImage(coordinates, chinaTile);
    } else {
      return foreignTile.tileProvider.getImage(coordinates, foreignTile);
    }
  }
}
