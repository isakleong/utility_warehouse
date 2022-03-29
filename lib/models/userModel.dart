import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

@JsonSerializable()
class User {
  final String userID;
  @JsonKey(name: 'NIK', defaultValue: "")
  String nik;
  final String password;
  final String tokenID;
  final List<String> ModuleId;

  User({this.userID, this.nik, this.password, this.tokenID, this.ModuleId});

  factory User.fromJson(Map<String, dynamic> parsedJson) => _$UserFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}