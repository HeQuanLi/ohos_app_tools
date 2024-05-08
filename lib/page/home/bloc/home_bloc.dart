import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:process_run/process_run.dart';

import '../../../bean/drop_type.dart';
import '../../../bean/sing_path_info.dart';
import '../../../static/assets_py.dart';
import '../../../utils/constant_utils.dart';
import '../../../utils/shared_preferences_utils.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState(DetectionStatus.init)) {
    on<DragEnteredEvent>((event, emit) {
      state.isEnter = event.enter;
      state.type = event.type;
      emit(state.copyWith());
    });

    on<DragExitedEvent>((event, emit) {
      state.isEnter = event.enter;
      state.type = event.type;
      emit(state.copyWith());
    });

    on<CleanEvent>(_clean);
    on<DragDoneEvent>(_dragDone);
  }

  void _clean(CleanEvent event, Emitter<HomeState> emit) {
    state.isEnter = false;
    state.type = null;
    state.detectionStatus = DetectionStatus.stop;
    state.detectionResult = null;
    emit(state.copyWith());
  }

  Future<void> _dragDone(DragDoneEvent event, Emitter<HomeState> emit) async {
    var appFile = event.details.files.firstOrNull?.path;
    if (appFile == null) {
      //TODO 提示错误信息,非法检测
      debugPrint("文件路径获取失败");
      return;
    }
    var result =
        await SharedPreferencesUtil.getString(ConstantUtils.signPathInfo);
    if (result == null) {
      //TODO 提示错误信息
      debugPrint("配置信息错误");
      return;
    }
    Map<String, dynamic> map = json.decode(result);
    SingPathInfo singPathInfo = SingPathInfo.fromJson(map);
    if (event.type == DropType.signed) {
      debugPrint("签名");
      _signedApp(appFile, singPathInfo);
    } else {
      debugPrint("安装");
      _installApp(appFile, singPathInfo);
    }
  }

  _signedApp(String appFile, SingPathInfo singPathInfo) async {
    var shell = Shell(verbose: false);
    debugPrint("开始执行");
    await shell.run("python3 ${AssetsPy.ohos_app_signed} $appFile ${singPathInfo.signToolPath} ${singPathInfo.cerPath} ${singPathInfo.p7bPath} ${singPathInfo.p12Path} ${singPathInfo.alias} ${singPathInfo.pwd} ${singPathInfo.packageName}");
    debugPrint("执行完成");
  }

  _installApp(String appFile, SingPathInfo singPathInfo) async {
    var shell = Shell(verbose: false);
    debugPrint("开始执行");
    await shell.run("python3 ${AssetsPy.ohos_app_install} $appFile ${singPathInfo.packageName}");
    debugPrint("执行完成");
  }
}
