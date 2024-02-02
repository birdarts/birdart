import 'package:birdart_server/db/postgres_db.dart';
import 'package:birdart_server/responses.dart';
import 'package:birdart_server/session_utils.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session/session.dart';
import 'package:shared/shared.dart';

final RegExp emailRegex = RegExp(r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$");

Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final method = request.method;

  if (method != HttpMethod.post) {
    return Responses.methodNotAllowed([HttpMethod.post]);
  }

  final data = await request.formData();
  final dataCheck = ['phone', 'name', 'email', 'password', 'sms_code']
      .map((e) => data.fields.containsKey(e))
      .reduce((e1, e2) => e1 && e2);
  if (!dataCheck) {
    return Responses.badRequest('Please provide all the following fields in '
        "your formdata: 'phone', 'name', 'email', 'password', 'sms_code'");
  }

  final fields = data.fields;
  final session = await getSessionOrNew(request);
  final user = await User.fromRegisterData(fields);

  if (!emailRegex.hasMatch(user.email)) {
    Responses.badRequest('Email address invalid.');
  }

  if (fields['sms_code'] != session.data['sms_code']) {
    Responses.badRequest('Verification code mismatch.');
  }

  final currentUsers = await DbManager.db.userDao.getAll();

  if (currentUsers.isEmpty) {
    user.role = UserRole.sysAdmin; // Set first user as sys admin.
  }

  final emailCheck = await DbManager.db.userDao.getByEmail(user.email);
  final phoneCheck = await DbManager.db.userDao.getByPhone(user.phone);

  if (emailCheck != null) {
    Responses.badRequest('Email address already taken.');
  }

  if (phoneCheck != null) {
    Responses.badRequest('Phone number already taken.');
  }

  final result = await DbManager.db.userDao.insertOne(user);

  if (result != 1) {
    Responses.internalServerError('Database error.');
  }

  session.data.addAll(user.toJson());
  Session.storage.saveSession(session, session.id); // This is required if you use a file storage.

  return Responses.ok('Registered successfully!');
}
