import 'package:birdart_server/responses.dart';
import 'package:birdart_server/session_utils.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session/session.dart';
import 'package:shared/shared.dart';

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
    return Responses.badRequest("Please provide all the following fields in your formdata: "
        "'phone', 'name', 'email', 'password', 'sms_code'");
  }

  final session = await getSessionOrNew(request);
  final fields = data.fields;
  // final user = User.fromRegisterData(fields);

  // TODO write user to database.

  return Response(body: 'Registered successfully!');
}
