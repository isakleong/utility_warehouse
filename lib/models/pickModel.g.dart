// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pick _$PickFromJson(Map<String, dynamic> json) {
  return Pick(
    pickNo: json['Pick No'] as String,
    wsNo: json['wsNo'] as String,
    source: json['source'] as String,
    weight: json['weight'] as String,
    userId: json['userId'] as String,
    date: json['date'] as String,
    sales: json['sales'] as String,
    gudang: json['gudang'] as String,
    custName: json['custName'] as String,
    contactName: json['contactName'] as String,
    city: json['city'] as String,
    postcode: json['postcode'] as String,
    county: json['county'] as String,
    province: json['province'] as String,
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
