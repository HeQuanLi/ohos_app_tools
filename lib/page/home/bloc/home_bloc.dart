import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
  HomeBloc() : super(HomeState()) {
    on<DragEnteredEvent>(_dragEntered);

    on<DragExitedEvent>(_dragExited);

    on<DragDoneEvent>(_dragDone);
  }

  ///拖入
  void _dragEntered(DragEnteredEvent event, Emitter<HomeState> emit) {
    state.isEnter = event.enter;
    state.type = event.type;
    emit(state.copyWith());
  }

  ///拖出
  void _dragExited(DragExitedEvent event, Emitter<HomeState> emit) {
    state.isEnter = event.enter;
    state.type = event.type;
    emit(state.copyWith());
  }

  ///拖入完成
  Future<void> _dragDone(DragDoneEvent event, Emitter<HomeState> emit) async {
    var appFile = event.details.files.firstOrNull?.path;
    if (appFile == null) {
      debugPrint("文件路径获取失败");
      emit(ErrorState("文件路径获取失败"));
      return;
    }

    var result =
        await SharedPreferencesUtil.getString(ConstantUtils.signPathInfo);
    if (result == null) {
      emit(ErrorState("配置信息错误"));
      debugPrint("配置信息错误");
      return;
    }

    SingPathInfo singPathInfo = SingPathInfo.fromJson(json.decode(result));
    if (event.type == DropType.signed) {
      debugPrint("签名");
      emit(ExecuteState(Execute.running, event.type));
      await _signedApp(appFile, singPathInfo);
      emit(ExecuteState(Execute.complete, event.type));
    } else {
      debugPrint("安装");
      emit(ExecuteState(Execute.running, event.type));
      await _installApp(appFile, singPathInfo);
      emit(ExecuteState(Execute.complete, event.type));
    }
  }

  Future<void> _signedApp(String appFile, SingPathInfo singPathInfo) async {
    var arguments = [
      appFile,
      singPathInfo.signToolPath,
      singPathInfo.cerPath,
      singPathInfo.p7bPath,
      singPathInfo.p12Path,
      singPathInfo.alias,
      singPathInfo.pwd,
      singPathInfo.packageName
    ];
    await _executeCommand(AssetsPy.ohos_app_signed, arguments);
  }

  Future<void> _installApp(String appFile, SingPathInfo singPathInfo) async {
    var arguments = [appFile, singPathInfo.packageName];
    await _executeCommand(AssetsPy.ohos_app_install, arguments);
  }

  Future<void> _executeCommand(String command, List<String> arguments) async {
    var shell = Shell(verbose: false);
    debugPrint("开始执行");
    await shell.run('python3 $command ${arguments.join(" ")}');
    debugPrint("执行完成");
  }
}
