// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sing_path_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingPathInfo _$SingPathInfoFromJson(Map<String, dynamic> json) => SingPathInfo(
      json['signToolPath'] as String,
      json['cerPath'] as String,
      json['p7bPath'] as String,
      json['p12Path'] as String,
      json['alias'] as String,
      json['pwd'] as String,
      json['packageName'] as String,
    );

Map<String, dynamic> _$SingPathInfoToJson(SingPathInfo instance) =>
    <String, dynamic>{
      'signToolPath': instance.signToolPath,
      'cerPath': instance.cerPath,
      'p7bPath': instance.p7bPath,
      'p12Path': instance.p12Path,
      'alias': instance.alias,
      'pwd': instance.pwd,
      'packageName': instance.packageName,
    };
