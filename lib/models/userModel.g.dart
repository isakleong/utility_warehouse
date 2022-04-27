// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userId: json['UserId'] as String ?? '',
    moduleId: (json['ModuleId'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'UserId': instance.userId,
      'ModuleId': instance.moduleId,
    };
