import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session_shelf.dart';

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) {
  // 1. Execute any custom code prior to starting the server...

  // 2. Use the provided `handler`, `ip`, and `port` to create a custom `HttpServer`.
  // Or use the Dart Frog serve method to do that for you.
  final secretKey = SecretKey(base64Decode(Platform.environment['birdart_session_key'].toString()));
  final dir = Directory('session');
  if (!dir.existsSync()) {
    dir.createSync();
  }
  Session.lifetime = const Duration(days: 7);
  Session.storage = FileStorage.crypto(dir, AesGcm.with256bits(), secretKey);

  return serve(handler, ip, port);
}
