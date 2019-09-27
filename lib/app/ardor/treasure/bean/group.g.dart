// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) {
  return Group(json['name'] as String)
    ..groupId = json['groupId'] as int
    ..isPrivate = json['isPrivate'] as bool
    ..remarks = json['remarks'] as String
    ..createTime = json['createTime'] as int
    ..updateTime = json['updateTime'] as int
    ..order = json['order'] as int;
}

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'groupId': instance.groupId,
      'isPrivate': instance.isPrivate,
      'name': instance.name,
      'remarks': instance.remarks,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'order': instance.order
    };
