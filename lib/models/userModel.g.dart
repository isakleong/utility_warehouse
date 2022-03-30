// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    userId: json['userId'] as String ?? '',
    nik: json['nik'] as String ?? '',
    tokenId: json['tokenId'] as String ?? '',
    dtmValid: json['dtmValid'] == null
        ? null
        : DateTime.parse(json['dtmValid']['date'] as String),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userId': instance.userId,
      'nik': instance.nik,
      'tokenId': instance.tokenId,
      'dtmValid': instance.dtmValid?.toIso8601String(),
    };
