import 'package:birdart_server/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Response onRequest(RequestContext context) {
  // if (user.phone.length != 11 || user.phone[0] != '1') {
  //   return Responses.badRequest('手机号码格式错误，目前仅支持中国大陆手机号');
  // }
  return Responses.ok('OK');
}
