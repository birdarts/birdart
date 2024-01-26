import 'package:dart_frog/dart_frog.dart';

// serving flutter web application
Response onRequest(RequestContext context) {
  return Response.movedPermanently(location: '/web/index.html');
}
