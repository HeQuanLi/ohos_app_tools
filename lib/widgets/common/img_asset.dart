import 'package:flutter/material.dart';

Widget imageAsset(
  String assetName, {
  Key? key,
  AssetBundle? bundle,
  String? package,
  double? width,
  double? height,
  BoxFit? fit = BoxFit.contain,
  Alignment alignment = Alignment.center,
}) {
  return Image.asset(
    assetName,
    width: width,
    height: height,
    key: key,
    fit: fit ?? BoxFit.contain,
    alignment: alignment,
  );
}
