import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session_shelf.dart';

Future<Session> getSessionOrNew(Request request) async {
  Session? session = await Session.getSession(request);
  if (session == null || ! await Session.storage.sessionExist(session.id)) {
    session = await Session.createSession(request);
    Session.storage.saveSession(session, session.id);
  }

  return session;
}