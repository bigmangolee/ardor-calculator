// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config()
    ..randomSalt = json['randomSalt'] as String
    ..defCalKeyboard = json['defCalKeyboard'] as String;
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'randomSalt': instance.randomSalt,
      'defCalKeyboard': instance.defCalKeyboard
    };
