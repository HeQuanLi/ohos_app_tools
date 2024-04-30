import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

import '../../../dialog/setting_dialog.dart';
import '../../../static/assets_svg.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/common/svg_asset.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeOperateView extends StatefulWidget {
  final HomeBloc bloc;
  final HomeState state;

  const HomeOperateView({super.key, required this.bloc, required this.state});

  @override
  State<HomeOperateView> createState() => _HomeOperateViewState();
}

class _HomeOperateViewState extends State<HomeOperateView> {
  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = widget.bloc;
    final HomeState state = widget.state;
    return padding(
      left: 14.0,
      right: 14.0,
      top: 20.0,
      child: Row(
        children: [
          Expanded(
            child: _iconText(
              AssetsSvg.thresholdSetting,
              "设置",
              4,
              click: (data) async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    return SettingDialog(
                      callback: (data) {
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconText(String assetName, String text, double leftPadding,
      {int textColor = 0xFF404040, Function(int)? click}) {
    return InkWell(
      child: Row(
        children: [
          svgAsset(assetName),
          padding(left: leftPadding),
          normalText(text, color: textColor)
        ],
      ),
      onTap: () {
        click!(1);
      },
    );
  }
}
