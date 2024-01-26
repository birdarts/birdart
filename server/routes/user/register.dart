import 'package:dart_frog/dart_frog.dart';

import '../../lib/user_database.dart';

Response onRequest(RequestContext context) {
  final request = context.request;
  final params = request.uri.queryParameters;

  if (params.containsKey('name') && params.containsKey('password')) {
    users[params['name']!] = params['password']!;
    return Response(body: 'Registered successfully!');
  } else {
    return Response(body: 'Invalid parameters', statusCode: 404);
  }
}
