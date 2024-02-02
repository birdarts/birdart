import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'user_profile.dart';

class Server {
  static const String url =
      kDebugMode ? 'http://192.168.2.21:8080/' : 'https://sun-jiao.github.io/';
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      setupDio();
    }

    return _dio!;
  }

  static setupDio() {
    if (kDebugMode) {
      print(url);
    }
    BaseOptions options = BaseOptions(
      baseUrl: url,
      headers: {
        "Accept": "application/json",
        "Cookie": "session=${UserProfile.session}"
      },
    );
    _dio = Dio(options);
  }
}
