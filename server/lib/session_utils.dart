import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session_shelf.dart';

Future<Session> getSessionOrNew(Request request) async {
  var session = await Session.getSession(request);
  if (session == null || ! await Session.storage.sessionExist(session.id)) {
    session = await Session.createSession(request);
  }

  return session;
}
