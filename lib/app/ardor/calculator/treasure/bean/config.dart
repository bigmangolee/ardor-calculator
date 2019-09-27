
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

// config.g.dart 将在我们运行生成命令后自动生成
// flutter packages pub run build_runner build
part 'config.g.dart';

///这个标注是告诉生成器，这个类是需要生成Model类的
@JsonSerializable()


class Config{

  //随机数。
  String randomSalt;

  //默认计算输入键盘。
  String defCalKeyboard;

  Config();

  ///将json字符串解析成对象。
  static Config parseJson(String jsonString) {
    Map userMap = jsonDecode(jsonString);
    return Config.fromJson(userMap as Map<String, dynamic>);
  }

  ///将对象编码成json字符串。
  String encodeJson() {
    Map userMap = toJson();
    return jsonEncode(userMap);
  }

  //不同的类使用不同的mixin即可
  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);
  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}