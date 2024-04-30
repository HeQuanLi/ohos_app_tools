import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Widget svgAsset(
  String assetName, {
  Key? key,
  AssetBundle? bundle,
  String? package,
  double? width,
  double? height,
  BoxFit? fit = BoxFit.contain,
  Alignment alignment = Alignment.center,
}) {
  return SvgPicture.asset(
    assetName,
    width: width,
    height: height,
    key: key,
    fit: fit ?? BoxFit.contain,
    alignment: alignment,
  );
}
