// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userID: json['userID'] as String,
    nik: json['NIK'] as String ?? '',
    password: json['password'] as String,
    tokenID: json['tokenID'] as String,
    ModuleId: (json['ModuleId'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userID': instance.userID,
      'NIK': instance.nik,
      'password': instance.password,
      'tokenID': instance.tokenID,
      'ModuleId': instance.ModuleId,
    };
