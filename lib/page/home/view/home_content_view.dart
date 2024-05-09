import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../bean/drop_type.dart';
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
        child: _content(state, bloc),
      ),
    );
  }

  Widget _content(HomeState state, HomeBloc bloc) {
    return Stack(
      children: [
        Row(
          children: [
            _dropTarget(state, bloc, DropType.signed),
            padding(left: 5, right: 5),
            _dropTarget(state, bloc, DropType.install),
          ],
        ),
        Visibility(
          visible: state.execute == Execute.running,
          child: Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.amber[400],
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  //阴影
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(10.0, 10.0),
                    blurRadius: 15.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.white,
                    size: 100,
                  ),
                  padding(top: 10),
                  normalText(
                    state.type == DropType.signed ? "签名中..." : "安装中...",
                    color: 0xFFFFFFFF,
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _dropTarget(HomeState state, HomeBloc bloc, DropType type) {
    return Expanded(
      child: DropTarget(
        //拖拽完成
        onDragDone: (DropDoneDetails detail) {
          bloc.add(DragDoneEvent(detail, type));
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
}
