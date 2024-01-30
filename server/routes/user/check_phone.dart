import 'package:birdart_server/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  return Responses.ok('OK');
}
