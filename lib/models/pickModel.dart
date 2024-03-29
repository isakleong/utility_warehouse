import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'pickModel.g.dart';

@JsonSerializable()
class Pick {
  String pickNo;
  String wsNo;
  String source;
  String weight;
  String userId;
  String date;
  String sales;
  String gudang;
  String custName;
  String custId;
  String contactName;
  String city;
  String postcode;
  String county;
  String province;

  Pick({
    this.pickNo,
    this.wsNo,
    this.source,
    this.weight,
    this.userId,
    this.date,
    this.sales,
    this.gudang,
    this.custName,
    this.custId,
    this.contactName,
    this.city,
    this.postcode,
    this.county,
    this.province
  });

  factory Pick.fromJson(Map<String, dynamic> parsedJson) =>
      _$PickFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$PickToJson(this);
}
