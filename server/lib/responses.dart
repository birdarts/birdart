import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

extension Responses on Response {
  static Response ok(
    String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) =>
      Response(
        body: body,
        headers: headers,
        encoding: encoding,
      );

  static Response created(String location) => Response(
        statusCode: 201,
        headers: {
          'Location': location,
        },
      );

  static Response redirect(String location) => Response(
        statusCode: 302,
        headers: {
          'Location': location,
        },
      );

  static Response badRequest(
    String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) =>
      Response(
        statusCode: 400,
        body: body,
        headers: headers,
        encoding: encoding,
      );

  static Response unauthorized(
    String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) =>
      Response(
        statusCode: 401,
        body: body,
        headers: (headers?..addAll({
          'WWW-Authenticate': '/user/login',
        })) ?? {
          'WWW-Authenticate': '/user/login',
        },
        encoding: encoding,
      );

  static Response forbidden(
    String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) =>
      Response(
        statusCode: 403,
        body: body,
        headers: headers,
        encoding: encoding,
      );

  static Response methodNotAllowed(List<HttpMethod> allows) => Response(
        statusCode: 403,
        headers: {
          'Allow': allows.map((e) => e.value).reduce((m1, m2) => '$m1, $m2'),
        },
      );

  static Response internalServerError(
    String? body, {
    Map<String, Object>? headers,
    Encoding? encoding,
  }) =>
      Response(
        statusCode: 500,
        body: body,
        headers: headers,
        encoding: encoding,
      );
}
