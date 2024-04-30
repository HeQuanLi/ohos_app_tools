import 'package:flutter/material.dart';

import '../../../dialog/about_audio_checker_dialog.dart';
import '../../../static/assets_img.dart';
import '../../../static/assets_svg.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/common/img_asset.dart';
import '../../../widgets/common/svg_asset.dart';

class HomeTitleView extends StatelessWidget {
  const HomeTitleView({super.key});

  @override
  Widget build(BuildContext context) {
    return padding(
      left: 8.0,
      top: 32.0,
      child: Row(
        children: [
          imageAsset(AssetsImg.launcherIcon, width: 40, height: 40),
          normalText("鸿蒙App工具助手", fontWeight: FontWeight.w900),
          padding(left: 4.0),
          InkWell(
            child: svgAsset(AssetsSvg.about),
            onTap: () {
              _showAboutAudioCheckerDialog(context);
            },
          )
        ],
      ),
    );
  }

  _showAboutAudioCheckerDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return const AboutAudioCheckerDialog();
      },
    );
  }
}
