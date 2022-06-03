import 'package:json_annotation/json_annotation.dart';

part 'stockOpnameHeaderModel.g.dart';

@JsonSerializable()
class StockOpnameHeader {
  @JsonKey(name: 'Id')
  int id;

  @JsonKey(name: 'TanggalTarikData')
  DateTime pullDate;

  @JsonKey(name: 'Cabang')
  String branchId;

  @JsonKey(name: 'SuratJalanTerakhir')
  String lastSJ;

  @JsonKey(name: 'KodeCustomer')
  String customerId;

  @JsonKey(name: 'NamaCustomer')
  String customerName;

  @JsonKey(name: 'JumlahBinTerdaftar')
  int registeredBinCount;

  @JsonKey(name: 'BinTepat')
  int exactBin;

  @JsonKey(name: 'KetepatanJumlahBin')
  int exactBin;

  @JsonKey(name: 'KetepatanJumlahPadaBin')
  int quantityAccuracyOnBin;

  @JsonKey(name: 'JumlahPadaBin')
  int amountOnBin;

  @JsonKey(name: 'ZoneShipment')
  int zoneShipment;

  @JsonKey(name: 'ZoneReceipt')
  int zoneReceipt;

  @JsonKey(name: 'ZoneAdjustment')
  int zoneAdjustment;

  @JsonKey(name: 'TotalQty')
  int totalQty;

  @JsonKey(name: 'NamaKepalaCabang')
  String branchManagerName;

  @JsonKey(name: 'NamaKepalaAdministrasi')
  String branchAdminName;

  @JsonKey(name: 'SelisihItemBinContent')
  int binContentItemDifference;

  @JsonKey(name: 'SaldoItemDesimal')
  int decimalItemSaldo;

  @JsonKey(name: 'JumlahHelper')
  int helperCount;

  @JsonKey(name: 'Dividen Data')
  int dividenData;

  @JsonKey(name: 'CreateUserId')
  String createUserId;

  @JsonKey(name: 'CreateTime')
  DateTime createTime;

  @JsonKey(name: 'UpdateUserId')
  String updateUserId;

  @JsonKey(name: 'UpdateTime')
  DateTime updateTime;

  StockOpnameHeader({this.id, this.pullDate, this.branchId, this.lastSJ, this.customerId, this.customerName, this.registeredBinCount, this.exactBin, this.quantityAccuracyOnBin, this.amountOnBin, this.zoneShipment, this.zoneReceipt, this.zoneAdjustment, this.totalQty, this.branchManagerName, this.branchAdminName, this.binContentItemDifference, this.decimalItemSaldo, this.helperCount, this.dividenData, this.createUserId, this.createTime, this.updateUserId, this.updateTime});

  factory StockOpnameHeader.fromJson(Map<String, dynamic> parsedJson) => _$StockOpnameHeaderFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$StockOpnameHeaderToJson(this);

}