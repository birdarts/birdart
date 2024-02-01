import 'dart:math';
import 'package:image/image.dart';

class VerCode {
  static final List<String> randomChoice = [
    'acdefhijkmnpqrstuvwxyz',
    'ABCDEFGHJKLMNPQRSTUVWXYZ',
    '234578',
  ];

  static final List<int> randomIndex = [0, 1, 2];
  static const int width = 250;
  static const int height = 75;

  static (Image, String) generateVerCode() {
    final image = Image(width: width, height: height);

    // 设置背景颜色
    _fill(image, ColorRgb8(255, 255, 255));

    // 生成随机数字字母干扰
    for (var x = 0; x < 40; x++) {
      final letterPool = randomChoice[randomIndex[x % 3]];
      final letter = letterPool[random.nextInt(letterPool.length)];
      drawChar(
        image,
        letter,
        x: x % 10 * 25 + random.nextInt(21) - 5,
        y: (x ~/ 10) * 15 + random.nextInt(16) - 5,
        color: _lightColor(),
        font: arial14,
      );
    }

    // 生成随机验证码
    var index = randomIndex[random.nextInt(randomIndex.length)];
    final verCode = StringBuffer();
    for (var item = 0; item < 5; item++) {
      final codePool = randomChoice[randomIndex[index % 3]];
      final code = codePool[random.nextInt(codePool.length)];
      verCode.write(code);

      drawChar(
        image,
        code,
        x: 30 + random.nextInt(16) - 5 + 40 * item,
        y: 10 + random.nextInt(16) - 5,
        color: _darkColor(),
        font: arial48,
      );
      index = index + 1;
    }

    // 随机线
    for (var i = 0; i < 3; i++) {
      drawLine(
        image,
        x1: random.nextInt(width),
        y1: random.nextInt(height),
        x2: random.nextInt(width),
        y2: random.nextInt(height),
        color: _lightColor(188),
        thickness: 5,
      );
    }

    // 加上一层滤波器滤镜
    // image.filter(ImageFilter.edgeEnhanceMore());

    return (image, verCode.toString());
  }

  static void _fill(Image image, Color color) {
    final (x, y) = (0, 0);

    for (var i = x; i < x + width; i++) {
      for (var j = y; j < y + height; j++) {
        image.setPixel(i, j, color);
      }
    }
  }

  static final Random random = Random();

  static Color _darkColor([int a = 255]) {
    const minBrightness = 90;
    const randomNum = 40;
    final red = random.nextInt(randomNum) + minBrightness;
    final green = random.nextInt(randomNum) + minBrightness;
    final blue = random.nextInt(randomNum) + minBrightness;

    return ColorRgba8(red, green, blue, a);
  }

  static Color _lightColor([int a = 255]) {
    const maxBrightness = 160;
    const randomNum = 25;
    final red = random.nextInt(randomNum) + maxBrightness;
    final green = random.nextInt(randomNum) + maxBrightness;
    final blue = random.nextInt(randomNum) + maxBrightness;

    return ColorRgba8(red, green, blue, a);
  }
}

// test code:
// main() async {
//   final (image, code) = VerCode.generateVerCode();
//   await encodePngFile('assets/test.png', image);
//   print(code);
// }
