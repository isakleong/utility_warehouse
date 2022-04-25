// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pickModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pick _$PickFromJson(Map<String, dynamic> json) {
  return Pick(
    pickNo: json['Pick No'] as String,
    wsNo: json['WS NO'] as String,
    source: json['Source'] as String,
    weight: json['Weight'] as String,
    userId: json['User ID'] as String,
    date: json['Tanggal'] as String,
    sales: json['Sales'] as String,
    gudang: json['Gudang'] as String,
    custName: json['Sell-to Customer Name'] as String,
    contactName: json['Sell-to Contact'] as String,
    city: json['City'] as String,
    postcode: json['Post Code'] as String,
    county: json['Sell-to County'] as String,
    province: json['Name'] as String
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
      'province': instance.province
    };
