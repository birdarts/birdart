import 'package:shelf/shelf.dart';

Map users = {};
// Handler for registration
Future<Response> registerHandler(Request request) async {
  Map data = {};
  final String query = await request.readAsString();
  data.addAll(Uri(query: query).queryParameters);
  data.addAll(request.url.queryParameters);

  if (data.containsKey('name') && data.containsKey('password')) {
    users[data['name']] = data['password'];
    return Response.ok('Registered successfully!');
  } else {
    return Response.unauthorized('Invalid parameters');
  }
}

// Handler for login
Future<Response> loginHandler(Request request) async {
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
