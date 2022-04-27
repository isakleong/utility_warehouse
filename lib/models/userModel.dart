import 'package:json_annotation/json_annotation.dart';

part 'userModel.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'UserId', defaultValue: "")
  final String userId;
  @JsonKey(name: 'ModuleId', defaultValue: null)
  List<String> moduleId;

  User({this.userId, this.moduleId});

  factory User.fromJson(Map<String, dynamic> parsedJson) => _$UserFromJson(parsedJson);
  Map<String, dynamic> toJson() => _$UserToJson(this);

}