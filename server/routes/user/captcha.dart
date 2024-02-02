import 'package:birdart_server/captcha_util.dart';
import 'package:birdart_server/session_utils.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:image/image.dart';

Future<Response> onRequest(RequestContext context) async {
  final session = await getSessionOrNew(context.request);
  final (image, code) = Captcha.generate();
  final raw = encodePng(image);
  session.data['captcha_code'] = code;

  return Response.bytes(
    body: raw,
    headers: {
      'Content-Type': 'image/png',
      'Content-Length': raw.lengthInBytes.toString(),
    },
  );
}
