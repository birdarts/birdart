import 'dart:io';

import 'package:dev/dev.dart' as dev;
import 'package:pinyin/pinyin.dart';

void main(List<String> arguments) {
  final fileContent = File('bin/Multiling IOC 14.1_b.csv').readAsLinesSync();
  final Set<String> nonBmp = {};

  for (final line in fileContent) {
    nonBmp.addAll(dev.getNonBmpChars(line));
    nonBmp.addAll(dev.getNonBmpChars(ChineseHelper.convertToSimplifiedChinese(line)));
    nonBmp.addAll(dev.getNonBmpChars(ChineseHelper.convertToTraditionalChinese(line)));
  }

  final result = nonBmp.reduce((value, element) => value + element);
  print(result);
  print(ChineseHelper.convertToSimplifiedChinese(result));
  print(ChineseHelper.convertToTraditionalChinese(result));
}
