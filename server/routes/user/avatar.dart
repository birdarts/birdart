import 'dart:io';

import 'package:birdart_server/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session/session.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final method = request.method;

  if (method == HttpMethod.post) {
    final data = await request.formData();
    final session = await Session.getSession(request);

    if (session == null || !session.data.containsKey('id')) {
      return Responses.unauthorized('Session not valid.');
    }

    final userId = session.data['id'];
    final userPower = session.data['power'];

    if (!data.containsKey('id') || !data.files.containsKey('avatar')) {
      return Responses.badRequest('Please provide user id and avatar file.');
    }

    final avatarId = data.fields['id'];

    if (userId != avatarId && userPower != 'admin') {
      return Responses.forbidden("You can not change other user's avatar.");
    }

    final avatarFile = data.files['avatar'];
    final bytes = await avatarFile!.readAsBytes();
    await File('/static/user/avatar/$avatarId.png').writeAsBytes(bytes);

    return Responses.created('/static/user/avatar/$avatarId.png');
  }

  final params = request.uri.queryParameters;

  if (params.containsKey('id')) {
    final avatarId = params['id'];

    if (File('public/static/user/avatar/$avatarId.png').existsSync()) {
      return Responses.redirect('/static/user/avatar/$avatarId.png');
    } else {
      return Responses.redirect('/web/favicon.png');
    }
  }

  return Responses.ok('Please provide user id.');
}
