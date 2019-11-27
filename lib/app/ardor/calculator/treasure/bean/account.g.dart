// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) {
  return Account(json['groupId'] as int)
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..address = json['address'] as String
    ..account = json['account'] as String
    ..password = json['password'] as String
    ..remarks = json['remarks'] as String
    ..order = json['order'] as int
    ..createTime = json['createTime'] as int
    ..updateTime = json['updateTime'] as int;
}

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'name': instance.name,
      'address': instance.address,
      'account': instance.account,
      'password': instance.password,
      'remarks': instance.remarks,
      'order': instance.order,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime
    };
