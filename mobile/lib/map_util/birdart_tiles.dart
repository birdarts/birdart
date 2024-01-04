import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'key_store.dart';
import 'cache_tile_provider.dart'; // Suitable for most situations

typedef TilesGetter = List<Widget> Function(BuildContext context);

class BirdartTiles {
  // static const tianditu = 'key'; in key_store.dart
  static const _tdtKey = KeyStore.tianditu;
  static const _packageName = 'net.sunjiao.birdart';

  // street map
  static final TileLayer _vec = TileLayer(
    tileProvider: CacheTileProvider('vec'),
    urlTemplate:
        'https://t{s}.tianditu.gov.cn/vec_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=vec&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=$_tdtKey',
    userAgentPackageName: _packageName,
    subdomains: const ['0', '1', '2', '3', '4', '5', '6', '7'],
  );

  static final TileLayer _cva = TileLayer(
    tileProvider: CacheTileProvider('cva'),
    urlTemplate:
        'https://t{s}.tianditu.gov.cn/cva_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cva&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=$_tdtKey',
    userAgentPackageName: _packageName,
    subdomains: const ['0', '1', '2', '3', '4', '5', '6', '7'],
  );

  static final TileLayer _eva = TileLayer(
    tileProvider: CacheTileProvider('eva'),
    urlTemplate:
        'https://t{s}.tianditu.gov.cn/eva_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=eva&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=$_tdtKey',
    userAgentPackageName: _packageName,
    subdomains: const ['0', '1', '2', '3', '4', '5', '6', '7'],
  );

  // satellite
  static final TileLayer _img = TileLayer(
    tileProvider: CacheTileProvider('img'),
    urlTemplate:
        'https://t{s}.tianditu.gov.cn/img_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=img&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=$_tdtKey',
    userAgentPackageName: _packageName,
    subdomains: const ['0', '1', '2', '3', '4', '5', '6', '7'],
  );

  static final TileLayer _cia = TileLayer(
    tileProvider: CacheTileProvider('cia'),
    urlTemplate:
        'https://t{s}.tianditu.gov.cn/cia_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=cia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=$_tdtKey',
    userAgentPackageName: _packageName,
    subdomains: const ['0', '1', '2', '3', '4', '5', '6', '7'],
  );

  static final TileLayer _eia = TileLayer(
    tileProvider: CacheTileProvider('eia'),
    urlTemplate:
        'https://t{s}.tianditu.gov.cn/eia_w/wmts?SERVICE=WMTS&REQUEST=GetTile&VERSION=1.0.0&LAYER=eia&STYLE=default&TILEMATRIXSET=w&FORMAT=tiles&TILEMATRIX={z}&TILEROW={y}&TILECOL={x}&tk=$_tdtKey',
    userAgentPackageName: _packageName,
    subdomains: const ['0', '1', '2', '3', '4', '5', '6', '7'],
  );

  static final TileLayer _osm = TileLayer(
    tileProvider: CacheTileProvider('osm'),
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: _packageName,
  );

  static final List<TileLayer> _vecZhTile = [_vec, _cva];

  static final List<TileLayer> _imgZhTile = [_img, _cia];

  static final List<TileLayer> _vecEnTile = [_vec, _eva];

  static final List<TileLayer> _imgEnTile = [_img, _eia];

  static TilesGetter vecTile = (BuildContext context) =>
      ['zh', 'ja'].contains(Localizations.localeOf(context).languageCode)
          ? _vecZhTile
          : _vecEnTile;

  static TilesGetter imgTile = (BuildContext context) =>
      ['zh', 'ja'].contains(Localizations.localeOf(context).languageCode)
          ? _imgZhTile
          : _imgEnTile;

  static TilesGetter osmTile = (BuildContext context) => [_osm];
}
