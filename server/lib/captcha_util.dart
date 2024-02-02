import 'dart:math';
import 'package:image/image.dart';

class Captcha {
  static final List<String> _randomChoice = [
    'acdefhijkmnpqrstuvwxyz',
    'ABCDEFGHJKLMNPQRSTUVWXYZ',
    '234578',
  ];

  static final List<int> _choiceIndex = [0, 1, 2];

  static (Image, String) generate({
    int width = 250,
    int height = 75,
  }) {
    final image = Image(width: width, height: height);

    // background color
    fill(image, color: _bgColor());

    // add random character
    for (var x = 0; x < 40; x++) {
      final letterPool = _randomChoice[_choiceIndex[x % 3]];
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

    // generate random captcha
    var index = _choiceIndex[random.nextInt(_choiceIndex.length)];
    final sb = StringBuffer();
    for (var item = 0; item < 5; item++) {
      final codePool = _randomChoice[_choiceIndex[index % 3]];
      final code = codePool[random.nextInt(codePool.length)];
      sb.write(code);

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

    // add some random lines
    for (var i = 0; i < 7; i++) {
      drawLine(
        image,
        x1: random.nextInt(width),
        y1: random.nextInt(height),
        x2: random.nextInt(width),
        y2: random.nextInt(height),
        color: _lightColor(175),
        thickness: 4,
      );
    }

    // add filter
    chromaticAberration(image, shift: 2);

    return (image, sb.toString().toLowerCase());
  }

  static final Random random = Random();

  static Color _darkColor([int a = 255]) {
    const minBrightness = 60;
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

  static Color _bgColor() {
    final shuffled = [245, 245, 230]..shuffle();
    return ColorRgb8(
      shuffled[0] + random.nextInt(10),
      shuffled[1] + random.nextInt(10),
      shuffled[2] + random.nextInt(10),
    );
  }
}

// test code:
// main() async {
//   final (image, code) = Captcha.generate();
//   await encodePngFile('assets/test.png', image);
//   print(code);
// }
