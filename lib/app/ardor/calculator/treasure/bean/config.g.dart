// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) {
  return Config()
    ..randomSalt = json['randomSalt'] as String
    ..localeLanguageCode = json['localeLanguageCode'] as String
    ..localeCountryCode = json['localeCountryCode'] as String
    ..calculatorIndex = json['calculatorIndex'] as int;
}

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'randomSalt': instance.randomSalt,
      'localeLanguageCode': instance.localeLanguageCode,
      'localeCountryCode': instance.localeCountryCode,
      'calculatorIndex': instance.calculatorIndex
    };
