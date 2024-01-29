import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

extension Responses on Response {
  static Response ok(String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) => Response(
    statusCode: 200,
    body: body,
    headers: headers,
    encoding: encoding,
  );

  static Response created(String location) => Response(statusCode: 201, headers: {
    'Location': location,
  });

  static Response redirect(String location) => Response(statusCode: 302, headers: {
    'Location': location,
  });

  static Response badRequest(String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) => Response(
    statusCode: 400,
    body: body,
    headers: headers,
    encoding: encoding,
  );

  static Response unauthorized(String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) => Response(
    statusCode: 401,
    body: body,
    headers: headers,
    encoding: encoding,
  );

  static Response forbidden(String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) => Response(
    statusCode: 403,
    body: body,
    headers: headers,
    encoding: encoding,
  );
}