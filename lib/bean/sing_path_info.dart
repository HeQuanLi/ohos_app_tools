import 'package:json_annotation/json_annotation.dart';

part 'sing_path_info.g.dart';

@JsonSerializable()
class SingPathInfo {
  @JsonKey(name: 'signToolPath')
  String signToolPath;

  @JsonKey(name: 'cerPath')
  String cerPath;

  @JsonKey(name: 'p7bPath')
  String p7bPath;

  @JsonKey(name: 'p12Path')
  String p12Path;

  @JsonKey(name: 'alias')
  String alias;

  @JsonKey(name: 'pwd')
  String pwd;

  @JsonKey(name: 'packageName')
  String packageName;

  SingPathInfo(
    this.signToolPath,
    this.cerPath,
    this.p7bPath,
    this.p12Path,
    this.alias,
    this.pwd,
    this.packageName,
  );

  factory SingPathInfo.fromJson(Map<String, dynamic> srcJson) =>
      _$SingPathInfoFromJson(srcJson);

  Map<String, dynamic> toJson() => _$SingPathInfoToJson(this);
}
