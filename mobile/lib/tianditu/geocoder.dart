import 'dart:convert';

import 'package:dio/dio.dart';

import 'key_store.dart';

class Geocoder {
  // static const tianditu = 'key'; in key_store.dart
  static const key = KeyStore.tianditu;

  static Future<List<Address>> getFromLocation(
      double latitude, double longitude,
      {int maxResults = 1}) async {
    final dio = Dio();
    final response = await dio.get(
        'http://api.tianditu.gov.cn/geocoder?postStr={\'lon\':$longitude,\'lat\':$latitude,\'ver\':1}&type=geocode&tk=$key');
    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = jsonDecode(response.toString());
      if (responseBody['msg'] == 'ok') {
        var result = responseBody['result'];
        var component = result['addressComponent'];
        var location = result['location'];
        final address = Address(
          formattedAddress: result['formatted_address'],
          address: component['address'],
          addressDistance: component['address_distance'],
          addressPosition: component['address_position'],
          nation: component['nation'],
          city: component['city'],
          province: component['province'],
          county: component['county'],
          poi: component['poi'],
          poiDistince: component['poi_distance'],
          poiPosition: component['poi_position'],
          road: component['road'],
          roadDistince: component['road_distance'],
          latitude: location['lat'],
          longitude: location['lon'],
        );
        return [address];
      }
    }
    return [];
  }

  Future<List<Address>> getFromLocationName(
      String locationName, int maxResults) async {
    return [];
  }
}

class Address {
  String formattedAddress;
  String address;
  int addressDistance;
  String addressPosition;
  String nation;
  String province;
  String city;
  String county;
  String poi;
  int poiDistince;
  String poiPosition;
  String road;
  int roadDistince;
  double latitude;
  double longitude;

  Address({
    required this.formattedAddress,
    required this.address,
    required this.addressDistance,
    required this.addressPosition,
    required this.nation,
    required this.province,
    required this.city,
    required this.county,
    required this.poi,
    required this.poiDistince,
    required this.poiPosition,
    required this.road,
    required this.roadDistince,
    required this.latitude,
    required this.longitude,
  });
}
