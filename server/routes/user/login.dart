import 'package:dart_frog/dart_frog.dart';

import '../../lib/user_database.dart';

Response onRequest(RequestContext context) {
  final request = context.request;
  final params = request.uri.queryParameters;

  if (params.containsKey('name') &&
      params.containsKey('password') &&
      users.containsKey(params['name']) &&
      users[params['name']] == params['password']) {
    return Response(body: 'Login Successful!');
  } else {
    return Response(body: 'Invalid credentials', statusCode: 404);
  }
}
