import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../bean/audio_info_bean.dart';
import '../../../bean/drop_type.dart';
import '../../../bean/item_content_show_info.dart';
import '../../../static/assets_img.dart';
import '../../../static/assets_svg.dart';
import '../../../utils/padding_utils.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/common/img_asset.dart';
import '../../../widgets/common/svg_asset.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeContentView extends StatefulWidget {
  final HomeBloc bloc;
  final HomeState state;

  const HomeContentView({super.key, required this.bloc, required this.state});

  @override
  State<HomeContentView> createState() => _HomeContentViewState();
}

class _HomeContentViewState extends State<HomeContentView> {
  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = widget.bloc;
    final HomeState state = widget.state;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14.0),
        width: double.infinity,
        child: _showContent(state, bloc),
      ),
    );
  }

  //显示内容
  Widget _showContent(HomeState state, HomeBloc bloc) {
    if (state.showAudioList.isEmpty) {
      //为空
      return _emptyContent(state, bloc);
    } else {
      if (state.detectionStatus == DetectionStatus.init) {
        bloc.add(DetectionStartEvent(state.showAudioList));
      }
      return _listContent(state, bloc);
    }
  }

  Widget _emptyContent(HomeState state, HomeBloc bloc) {
    return Row(
      children: [
        _dropTarget(state, bloc, DropType.signed),
        padding(left: 5, right: 5),
        _dropTarget(state, bloc, DropType.install),
      ],
    );
  }

  Widget _dropTarget(HomeState state, HomeBloc bloc, DropType type) {
    return Expanded(
      child: DropTarget(
        //拖拽完成
        onDragDone: (DropDoneDetails detail) {
          bloc.add(DragDoneEvent(detail));
        },
        //拖拽进入
        onDragEntered: (detail) {
          bloc.add(DragEnteredEvent(true, type));
        },
        //拖拽退出
        onDragExited: (detail) {
          bloc.add(DragEnteredEvent(false, type));
        },
        child: _dottedBorder(state, type),
      ),
    );
  }

  Widget _dottedBorder(HomeState state, DropType type) {
    var choose = (state.isEnter == true && state.type == type);
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      color: choose ? const Color(0XFF7F8075) : const Color(0XFFE0E3C8),
      dashPattern: const [6, 6],
      strokeWidth: 2,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          color: choose ? const Color(0XFFE0E3C8) : const Color(0XFFEBEDDF),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  padding(
                    top: 100,
                    child: imageAsset(AssetsImg.audio, width: 60, height: 60),
                  ),
                  padding(top: 10.0),
                  Text(
                    (type == DropType.signed)
                        ? "拖入.app文件\n进行重新签名"
                        : "拖入已签名.app文件\n进行安装",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF7F8075),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: svgAsset(
                        choose ? AssetsSvg.handsChoose : AssetsSvg.hands,
                        width: 120,
                        height: 140,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listContent(HomeState state, HomeBloc bloc) {
    return Column(
      children: [
        _stateDetection(state, bloc),
        _listViewContent(state, bloc),
      ],
    );
  }

  Widget _listViewContent(HomeState state, HomeBloc bloc) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: state.showAudioList.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: (_showItemContent(state, index, bloc)),
        ),
      ),
    );
  }

  Row _showItemContent(HomeState state, int index, HomeBloc bloc) {
    var audioInfoBean = state.showAudioList[index];
    var itemContentShowInfo = _showStateContent(audioInfoBean);
    return Row(
      children: [
        padding(
          left: 4,
          top: 0,
          right: 20,
          child: imageAsset(AssetsImg.audio, width: 30, height: 30),
        ),
        Expanded(
          child: Text(
            state.showAudioList[index].audioName,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
          decoration: BoxDecoration(
            color: Color(itemContentShowInfo.bgColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            itemContentShowInfo.content,
            style: TextStyle(
              color: Color(itemContentShowInfo.textColor),
              fontSize: 10,
            ),
          ),
        ),
        InkWell(
          child: padding(
            right: 14,
            left: 10,
            child: svgAsset(AssetsSvg.openFolder, width: 20, height: 21),
          ),
          onTap: () async {
            if (Platform.isMacOS) {
              Process.runSync('open', ['-R', audioInfoBean.audioPath]);
            } else if (Platform.isWindows) {
              Process.runSync(
                  'explorer', ['/select,', audioInfoBean.audioPath]);
            }
          },
        ),
      ],
    );
  }

  ItemContentShowInfo _showStateContent(AudioInfoBean info) {
    String s = "";
    int bgColor = 0xFFFFFFFF;
    int textColor = 0xFF666666;
    switch (info.state) {
      case AudioStatus.no:
        s = "待检测";
        bgColor = 0xFFFFFFFF;
        textColor = 0xFF666666;
        break;
      case AudioStatus.running:
        s = "处理中";
        bgColor = 0xFFF2F7B2;
        textColor = 0xFF3D4200;
        break;
      case AudioStatus.success:
        s = "${info.lufsValue} LUFS";
        switch (info.audioResultState) {
          case -1:
            bgColor = 0xFFFFFFFF;
            textColor = 0xFF666666;
            break;
          case 0:
            bgColor = 0xFFEBEDDF;
            textColor = 0xFF7F8075;
            break;
          case 1:
            bgColor = 0xFFFFE2DE;
            textColor = 0xFF781A0C;
            break;
          case 2:
            bgColor = 0xFFEBEDDF;
            textColor = 0xFF666666;
            break;
        }
        break;
      case AudioStatus.failed:
        s = "失败";
        bgColor = 0xFFFFFFFF;
        textColor = 0xFF666666;
        break;
    }
    return ItemContentShowInfo(s, bgColor, textColor);
  }

  //状态检测
  Widget _stateDetection(HomeState state, HomeBloc bloc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
      child: _iconText(
          state.detectionStatus == DetectionStatus.complete
              ? AssetsSvg.detectionComplete
              : AssetsSvg.loading,
          _showDetectionState(state),
          10),
    );
  }

  String _showDetectionState(HomeState state) {
    String s = "";
    switch (state.detectionStatus) {
      case DetectionStatus.init:
        s = "初始化...";
      case DetectionStatus.running:
        s = "正在检测...";
      case DetectionStatus.stop:
        s = "停止检测";
      case DetectionStatus.complete:
        var result = state.detectionResult;
        s = "已检测${result?.detectionNum}个文件，有风险${result?.riskNum}个，合格${result?.qualifiedNum}个，失败${result?.failedNum}个";
    }
    return s;
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
