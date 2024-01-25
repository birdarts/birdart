import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.movedPermanently(location: '/web/index.html');
}
