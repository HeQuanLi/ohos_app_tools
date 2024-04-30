import 'package:flutter/material.dart';
import '../../../static/assets_img.dart';
import '../../../static/assets_svg.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/common/img_asset.dart';
import '../../../widgets/common/svg_asset.dart';

class ErrorDialog extends StatefulWidget {
  const ErrorDialog({super.key});

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          width: 378,
          height: 183,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _titleRegion(),
              padding(top: 20),
              Row(
                children: [
                  imageAsset(AssetsImg.errorIcon, width: 72, height: 56),
                  padding(left: 10),
                  Expanded(child: normalText("暂不支持导入.mov格式的媒体文件。"))
                ],
              ),
              _buttonRegion(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleRegion() {
    return Row(
      children: [
        Expanded(
          child: normalText(
            "异常弹窗",
            fontSize: 18,
            color: 0xFF404040,
          ),
        ),
        svgAsset(AssetsSvg.close, width: 20, height: 21)
      ],
    );
  }

  Widget _buttonRegion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _button(
          "知道了",
          BoxDecoration(
            color: const Color(0xFFA9B52D), // border
            borderRadius: BorderRadius.circular((10)), // 圆角
          ),
        ),
      ],
    );
  }

  Widget _button(String text, Decoration decoration) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
      decoration: decoration,
      child: normalText(
        text,
        fontSize: 16,
        color: 0xFFFFFFFF,
      ),
    );
  }
}
