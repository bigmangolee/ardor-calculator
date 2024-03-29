// Copyright 2019-present the Ardor.App authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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

  //语言代码
  String localeLanguageCode;

  //语言代码国家
  String localeCountryCode;

  //默认计算输入键盘索引。
  int calculatorIndex = 0;

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