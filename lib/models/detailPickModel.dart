import 'package:json_annotation/json_annotation.dart';

part 'detailPickModel.g.dart';

@JsonSerializable()
class DetailPick {
  String description;
  String ukuran;
  String bincode;
  String quantity;
  String qty_real;
  String uom;
  int ada;

  DetailPick({
    this.description,
    this.ukuran,
    this.bincode,
    this.quantity,
    this.qty_real,
    this.uom,
    this.ada
  });

  factory DetailPick.fromJson(Map<String, dynamic> parsedJson) =>
      _$DetailPickFromJson(parsedJson);

  Map<String, dynamic> toJson() => _$DetailPickToJson(this);
}
