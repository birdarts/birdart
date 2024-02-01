import 'package:birdart_server/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Response.movedPermanently(location: '/user/resetpass');
}
