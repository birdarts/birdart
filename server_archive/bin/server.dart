import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'routers/base.dart' as base;
import 'routers/tests.dart' as tests;
import 'routers/user.dart' as user;

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure routes.
  final router = Router()
    ..get('/', base.rootHandler)
    ..mount('/web', base.staticHandler)
    ..get('/<web/|.*>favicon.<ico>', base.faviconHandler)
    ..get('/test', tests.testHandler)
    ..get('/echo/<message>', tests.echoHandler)
    ..all('/user/login', user.loginHandler)
    ..all('/user/register', user.registerHandler);

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
