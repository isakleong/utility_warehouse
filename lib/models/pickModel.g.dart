// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pick _$PickFromJson(Map<String, dynamic> json) {
  return Pick(
    dtmCreated: json['dtmCreated'] == null
        ? null
        : DateTime.parse(json['dtmCreated'] as String),
  );
}

Map<String, dynamic> _$PickToJson(Pick instance) => <String, dynamic>{
      'pickNo': instance.pickNo,
      'wsNo': instance.wsNo,
      'source': instance.source,
      'weight': instance.weight,
      'userId': instance.userId,
      'date': instance.date,
      'sales': instance.sales,
      'gudang': instance.gudang,
      'custName': instance.custName,
      'contactName': instance.contactName,
      'city': instance.city,
      'postcode': instance.postcode,
      'county': instance.county,
      'province': instance.province,
      'dtmCreated': instance.dtmCreated?.toIso8601String(),
    };
