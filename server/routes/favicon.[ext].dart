import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context, String ext) {
  return Response.movedPermanently(location: '/web/favicon.png');
}
