

import 'dart:math';

import 'package:ardor_calculator/library/applog.dart';

class RandomUtils {

  static String _alphabet = '1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';

  /// 生成固定长度的随机字符串
  static String generateString(int length) {
    String left = '';
    for (var i = 0; i < length; i++) {
      left = left + _alphabet[Random().nextInt(_alphabet.length)];
    }
    AppLog.i("RandomUtils","generateString $left");
    return left;
  }
}