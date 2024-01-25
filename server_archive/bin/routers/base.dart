import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf_static/shelf_static.dart';

import 'dirs.dart';

Response rootHandler(Request req) {
  return Response.movedPermanently('/web/#/');
}

Future<Response> faviconHandler(Request request) async {
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
Handler staticHandler = Cascade()
    .add(createStaticHandler('$parentDir/web/build/web',
    defaultDocument: 'index.html'))
    .handler;
