import 'package:flutter/material.dart';
import '../../../static/assets_svg.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/common/img_asset.dart';
import '../../../widgets/common/svg_asset.dart';

import '../static/assets_img.dart';

class AboutOhosAppToolsDialog extends StatefulWidget {
  const AboutOhosAppToolsDialog({super.key});

  @override
  State<AboutOhosAppToolsDialog> createState() =>
      _AboutOhosAppToolsDialogState();
}

class _AboutOhosAppToolsDialogState extends State<AboutOhosAppToolsDialog> {
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
          width: 292,
          height: 386,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _titleRegion(),
              padding(top: 10),
              imageAsset(AssetsImg.aboutIcon, width: 141, height: 113),
              padding(top: 14),
              normalText("鸿蒙App工具助手"),
              padding(top: 4),
              normalText("V 1.0", color: 0xFFA9B52D),
              padding(top: 20),
              _introduceRegion()
            ],
          ),
        ),
      ),
    );
  }

  Widget _introduceRegion() {
    return normalText(
      "有问题请邮箱反馈或提issue",
      fontSize: 16,
      color: 0xFF7F8075,
      fontWeight: FontWeight.w300,
    );
  }

  Widget _titleRegion() {
    return Row(
      children: [
        Expanded(
          child: normalText(
            "关于",
            fontSize: 18,
            color: 0xFF404040,
          ),
        ),
        InkWell(
          child: svgAsset(AssetsSvg.close, width: 20, height: 21),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
