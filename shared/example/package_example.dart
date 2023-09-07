import 'package:shared/shared.dart';
import 'package:shared/src/in_china_tester.dart';
import 'dart:math' as math;

void main() {
  final start = DateTime.now().microsecondsSinceEpoch;
  for (int i = 0 ; i < 100000 ; i++) {
    print(isInChina(math.Random().nextDouble() * 60, 70 + math.Random().nextDouble() * 70));
  }
  final end = DateTime.now().microsecondsSinceEpoch;
  print((end - start).toString());
}
