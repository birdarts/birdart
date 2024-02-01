import 'package:birdart_server/session_utils.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  final session = await getSessionOrNew(context.request);
  session.save();

  return Response.json(
    body: {
      'message': 'Session ID updated successfully.',
      'data': session.id,
    },
  );
}
