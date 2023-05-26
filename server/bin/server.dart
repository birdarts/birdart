import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

final directoryCurrent = Directory.current;
final currentDir = directoryCurrent.path;
final parentDir = directoryCurrent.parent.path;

// Configure routes.
final _router = Router()
  ..get('/test', _rootHandler)
  ..get('/echo/<message>', _echoHandler)
  ..get('/favicon.<ico>', _faviconHandler)
  ..get('/', _staticHandler)
  ..mount('/web', _staticHandler);

Response _rootHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _faviconHandler(Request request) async {
  // 读取图片文件
  var file = File('$currentDir/assets/favicon.ico');
  var bytes = await file.readAsBytes();

  // 创建一个HTTP响应，将图片数据作为响应体返回
  return Response.ok(bytes, headers: {
    'Content-Type': 'image/ico',
    'Content-Length': bytes.length.toString(),
  });
}

// serving flutter web application
// execute before run server: flutter build web --release --base-href=/web/
get _staticHandler {
  var cascade = Cascade().add(createStaticHandler('$parentDir/web/build/web',
      defaultDocument: 'index.html'));

  return cascade.handler;
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
