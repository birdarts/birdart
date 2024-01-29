import 'package:dart_frog/dart_frog.dart';
import 'package:session_shelf/session_shelf.dart';

Handler middleware(Handler handler) {
  return handler.use(requestLogger())
      .use(fromShelfMiddleware(sessionMiddleware()))
      .use(fromShelfMiddleware(cookiesMiddleware()));
}