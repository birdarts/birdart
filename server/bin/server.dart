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
  ..get('/', _rootHandler)
  ..get('/test', _testHandler)
  ..get('/echo/<message>', _echoHandler)
  ..get('/<web|.*>/favicon.<ico>', _faviconHandler)
  ..all('/user/login', _loginHandler)
  ..all('/user/register', _registerHandler)
  ..mount('/web', _staticHandler);

Response _testHandler(Request req) {
  return Response.ok('Hello, World!\n');
}

Response _rootHandler(Request req) {
  return Response.movedPermanently('/web/#/');
}

Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}

Future<Response> _faviconHandler(Request request) async {
  // read image file
  var file = File('$currentDir/assets/favicon.ico');
  var bytes = await file.readAsBytes();

  // create a http response to return the image
  return Response.ok(bytes, headers: {
    'Content-Type': 'image/ico',
    'Content-Length': bytes.length.toString(),
  });
}

// serving flutter web application
// execute before run server: flutter build web --release --base-href=/web/
Handler _staticHandler = Cascade()
    .add(createStaticHandler('$parentDir/web/build/web',
        defaultDocument: 'index.html'))
    .handler;

Map users = {};
// Handler for registration
Future<Response> _registerHandler(Request request) async {
  Map data = {};
  final String query = await request.readAsString();
  data.addAll(Uri(query: query).queryParameters);
  data.addAll(request.url.queryParameters);

  if (data.containsKey('name') &&
      data.containsKey('password')) {
    users[data['name']] = data['password'];
    return Response.ok('Registered successfully!');
  } else {
    return Response.unauthorized('Invalid parameters');
  }
}

// Handler for login
Future<Response> _loginHandler(Request request) async {
  Map data = {};
  final String query = await request.readAsString();
  data.addAll(Uri(query: query).queryParameters);
  data.addAll(request.url.queryParameters);

  if (data.containsKey('name') &&
      data.containsKey('password') &&
      users.containsKey(data['name']) &&
      users[data['name']] == data['password']) {
    return Response.ok('Login Successful!');
  } else {
    return Response.unauthorized('Invalid credentials');
  }
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
