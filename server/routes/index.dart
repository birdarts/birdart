import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session_shelf.dart';

// serving flutter web application
Future<Response> onRequest(RequestContext context) async {
  Cookie('foo', 'Foo').addTo(context.request);
  final session = await Session.getSession(context.request);
  if (session != null && await Session.storage.sessionExist(session.id)) {
    Session.storage.saveSession(session, session.id);
  } else {
    final session = await Session.createSession(context.request);
    Session.storage.saveSession(session, session.id);
  }
  return Response.movedPermanently(location: '/web/index.html');
}
