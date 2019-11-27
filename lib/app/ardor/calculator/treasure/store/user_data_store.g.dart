// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataStore _$UserDataStoreFromJson(Map<String, dynamic> json) {
  return UserDataStore(json['name'] as String)
    ..maxGroupId = json['maxGroupId'] as int
    ..maxAccountId = json['maxAccountId'] as int
    ..groups = (json['groups'] as List)
        ?.map(
            (e) => e == null ? null : Group.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..accounts = (json['accounts'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(
          k,
          (e as List)
              ?.map((e) => e == null
                  ? null
                  : Account.fromJson(e as Map<String, dynamic>))
              ?.toList()),
    );
}

Map<String, dynamic> _$UserDataStoreToJson(UserDataStore instance) =>
    <String, dynamic>{
      'name': instance.name,
      'maxGroupId': instance.maxGroupId,
      'maxAccountId': instance.maxAccountId,
      'groups': instance.groups,
      'accounts': instance.accounts
    };
