import 'package:birdart_server/db/postgres_db.dart';
import 'package:birdart_server/responses.dart';
import 'package:birdart_server/session_utils.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session/session.dart';
import 'package:shared/model/user.dart';

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final method = request.method;

  if (method != HttpMethod.post) {
    return Responses.methodNotAllowed([HttpMethod.post]);
  }

  final data = await request.formData();
  final fields = data.fields;

  if ((fields['phone'] == null && fields['email'] == null)
      || fields['password'] == null) {
    return Responses.badRequest('Please provide phone or email and password.');
  }

  final session = await getSessionOrNew(request);
  final user = fields['phone'] != null
      ? await DbManager.db.userDao.getByPhone(fields['phone']!)
      : await DbManager.db.userDao.getByEmail(fields['email']!);

  if (user == null) {
    return Responses.badRequest('User not registered.');
  }

  if (!await user.checkPassword(fields['password']!)) {
    return Responses.unauthorized('Wrong password.');
  }

  session.data.addAll(user.toJson());
  Session.storage.saveSession(session, session.id); // This is required if you use a file storage.

  return Response.json(
    body: {
      'message': 'Registered successfully!',
      'data': user.toJson()..remove('password')..remove('salt')..addAll({
        'session': session.id,
      }),
    },
  );
}
