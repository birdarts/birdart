import 'package:birdart_server/responses.dart';
import 'package:birdart_server/session_utils.dart';
import 'package:birdart_server/smscode_util.dart';
import 'package:dart_frog/dart_frog.dart';


Future<Response> onRequest(RequestContext context) async {
  final request = context.request;
  final method = request.method;

  if (method != HttpMethod.post) {
    return Responses.methodNotAllowed([HttpMethod.post]);
  }

  final data = await request.formData();
  if (!data.fields.containsKey('phone')) {
    return Responses.badRequest('Please provide phone number in your formdata.');
  }

  // TODO: do some checks.
  // if (user.phone.length != 11 || user.phone[0] != '1') {
  //   return Responses.badRequest('手机号码格式错误，目前仅支持中国大陆手机号');
  // }

  final code = SmsCode.sendCode();
  final session = await getSessionOrNew(request);
  session.data['sms_code'] = code;

  return Responses.ok('Sms code already sent.');
}
