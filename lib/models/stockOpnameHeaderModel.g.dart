// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stockOpnameHeaderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockOpnameHeader _$StockOpnameHeaderFromJson(Map<String, dynamic> json) {
  return StockOpnameHeader(
    id: json['Id'] as int,
    pullDate: json['TanggalTarikData'] == null
        ? null
        : DateTime.parse(json['TanggalTarikData']['date'] as String),
    branchId: json['Cabang'] as String,
    lastSJ: json['SuratJalanTerakhir'] as String,
    customerId: json['KodeCustomer'] as String,
    customerName: json['NamaCustomer'] as String,
    registeredBinCount: json['JumlahBinTerdaftar'] as int,
    exactBin: json['KetepatanJumlahBin'] as int,
    quantityAccuracyOnBin: json['KetepatanJumlahPadaBin'] as int,
    amountOnBin: json['JumlahPadaBin'] as int,
    zoneShipment: json['ZoneShipment'] as int,
    zoneReceipt: json['ZoneReceipt'] as int,
    zoneAdjustment: json['ZoneAdjustment'] as int,
    totalQty: json['TotalQty'] as int,
    branchManagerName: json['NamaKepalaCabang'] as String,
    branchAdminName: json['NamaKepalaAdministrasi'] as String,
    binContentItemDifference: json['SelisihItemBinContent'] as int,
    decimalItemSaldo: json['SaldoItemDesimal'] as int,
    helperCount: json['JumlahHelper'] as int,
    dividenData: json['Dividen Data'] as int,
    createUserId: json['CreateUserId'] as String,
    createTime: json['CreateTime'] == null
        ? null
        : DateTime.parse(json['CreateTime']['date'] as String),
    updateUserId: json['UpdateUserId'] as String,
    updateTime: json['UpdateTime'] == null
        ? null
        : DateTime.parse(json['UpdateTime']['date'] as String),
  );
}

Map<String, dynamic> _$StockOpnameHeaderToJson(StockOpnameHeader instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'TanggalTarikData': instance.pullDate?.toIso8601String(),
      'Cabang': instance.branchId,
      'SuratJalanTerakhir': instance.lastSJ,
      'KodeCustomer': instance.customerId,
      'NamaCustomer': instance.customerName,
      'JumlahBinTerdaftar': instance.registeredBinCount,
      'KetepatanJumlahBin': instance.exactBin,
      'KetepatanJumlahPadaBin': instance.quantityAccuracyOnBin,
      'JumlahPadaBin': instance.amountOnBin,
      'ZoneShipment': instance.zoneShipment,
      'ZoneReceipt': instance.zoneReceipt,
      'ZoneAdjustment': instance.zoneAdjustment,
      'TotalQty': instance.totalQty,
      'NamaKepalaCabang': instance.branchManagerName,
      'NamaKepalaAdministrasi': instance.branchAdminName,
      'SelisihItemBinContent': instance.binContentItemDifference,
      'SaldoItemDesimal': instance.decimalItemSaldo,
      'JumlahHelper': instance.helperCount,
      'Dividen Data': instance.dividenData,
      'CreateUserId': instance.createUserId,
      'CreateTime': instance.createTime?.toIso8601String(),
      'UpdateUserId': instance.updateUserId,
      'UpdateTime': instance.updateTime?.toIso8601String(),
    };
