import 'dart:math';

class SmsCode {
  static final Random _random = Random();

  static String sendCode() {
    final code = _random.nextInt(999999);
    print(code); // TODO: use a SMS service SDK.
    return code.toString();
  }
}
