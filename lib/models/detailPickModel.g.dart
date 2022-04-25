// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detailPickModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailPick _$DetailPickFromJson(Map<String, dynamic> json) {
  return DetailPick(
    description: json['Description'] as String,
    ukuran: json['Ukuran'] as String,
    bincode: json['Bin Code'] as String,
    quantity: json['Quantity'] as String,
    qty_real: json['qty_real'] as String,
    uom: json['Unit of Measure Code'] as String,
    ada: json['ada'] as int,
  );
}

Map<String, dynamic> _$DetailPickToJson(DetailPick instance) =>
    <String, dynamic>{
      'description': instance.description,
      'ukuran': instance.ukuran,
      'bincode': instance.bincode,
      'quantity': instance.quantity,
      'qty_real': instance.qty_real,
      'uom': instance.uom,
      'ada': instance.ada,
    };
