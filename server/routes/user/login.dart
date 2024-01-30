import 'package:birdart_server/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  final request = context.request;
  final params = request.uri.queryParameters;

  if (params.containsKey('name') &&
      params.containsKey('password')) {

    // TODO check username existence and password
    return Response(body: 'Login Successful!');
  } else {
    return Responses.badRequest('Invalid parameters.');
  }
}
