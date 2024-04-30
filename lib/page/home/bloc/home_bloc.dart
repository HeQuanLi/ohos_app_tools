import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bean/audio_info_bean.dart';
import '../../../utils/constant_utils.dart';
import '../../../utils/ffmpeg_utils.dart';
import '../../../utils/file_utils.dart';
import '../../../utils/shared_preferences_utils.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeState([], DetectionStatus.init)) {
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
    on<ExportAllEvent>(_exportErrorFile);
    on<DragDoneEvent>(_importOriginalFile);
    on<DetectionStartEvent>(_startDetection);
  }

  void _clean(CleanEvent event, Emitter<HomeState> emit) {
    state.showAudioList = [];
    state.isEnter = false;
    state.type = null;
    state.detectionStatus = DetectionStatus.stop;
    state.detectionResult = null;
    emit(state.copyWith());
  }

  ///导出错误文件
  void _exportErrorFile(ExportAllEvent event, Emitter<HomeState> emit) {
    try {
      //开始
      emit(ExportStartState());
      var destinationFolderPath = event.exportPath; //导出目录
      Directory(destinationFolderPath).createSync(recursive: true); //创建目标文件夹
      List<String> exportList = [];
      for (var audioInfo in event.exportFileList) {
        debugPrint("audioResultState=${audioInfo.audioResultState}");
        if (audioInfo.audioResultState == 1) {
          var file = File(audioInfo.audioPath);
          String fileName = file.uri.pathSegments.last;
          String destinationFilePath = '$destinationFolderPath/$fileName';
          file.renameSync(destinationFilePath); // 移动文件
          exportList.add(destinationFilePath);
        }
      }
      //完成
      emit(ExportCompleteState(exportList));
    } catch (e) {
      //错误
      emit(ExportErrorState(e));
    }
  }

  /// 导入原始的音频文件
  void _importOriginalFile(DragDoneEvent event, Emitter<HomeState> emit) async {
    state.detectionStatus = DetectionStatus.init;
    emit(state.copyWith());

    List<String> list = [];
    for (final file in event.details.files) {
      await FileUtils.readFile(
        file.path,
        list,
        ConstantUtils.fileFormat,
      );
    }
    List<AudioInfoBean> listAudioInfo = [];
    for (var element in list) {
      var file = File(element);
      String fileName = file.uri.pathSegments.last;
      listAudioInfo.add(AudioInfoBean(fileName, element));
    }
    state.showAudioList = listAudioInfo;
    emit(state.copyWith());
  }

  /// 开始检测
  void _startDetection(
      DetectionStartEvent event, Emitter<HomeState> emit) async {
    debugPrint("开始检测");
    state.detectionStatus = DetectionStatus.running;
    emit(state.copyWith());
    await getAudioLUFSList(emit, event.detectionList);
  }

  Future<List<AudioInfoBean>> getAudioLUFSList(
      Emitter<HomeState> emit, List<AudioInfoBean> audioList) async {
    var threshold = await SharedPreferencesUtil.getString(ConstantUtils.lufsKey,
        defaultValue: ConstantUtils.defaultValue); //阈值
    debugPrint("threshold=$threshold");

    int detectionNum = 0; //检测总数
    int riskNum = 0; //风险总数
    int qualifiedNum = 0; //合格总数
    int failedNum = 0; //失败总数

    for (final audioInfo in audioList) {
      audioInfo.state = AudioStatus.running;
      emit(state.copyWith()); //单个开始检测

      try {
        final lufs = await getAudioLUFS(audioInfo.audioPath);
        debugPrint("lufsValue=$lufs");

        if (threshold == null) {
          qualifiedNum++; //合格
          audioInfo.audioResultState = 0;
          debugPrint("合格");
        } else {
          var diff = num.parse(threshold) - lufs;
          if (diff.abs() <= 2) {
            qualifiedNum++; //合格
            audioInfo.audioResultState = 0;
            debugPrint("合格");
          } else {
            riskNum++; //风险
            audioInfo.audioResultState = 1;
            debugPrint("风险");
          }
        }

        audioInfo.lufsValue = lufs;
        audioInfo.state = AudioStatus.success; //单个检测成功
        emit(state.copyWith());
      } catch (e) {
        failedNum++; //失败
        debugPrint("失败;$e");
        audioInfo.audioResultState = 2;
        audioInfo.state = AudioStatus.failed; //单个检测失败
        emit(state.copyWith());
      }
    }
    detectionNum = audioList.length;
    state.detectionResult =
        DetectionResult(detectionNum, riskNum, qualifiedNum, failedNum);
    state.detectionStatus = DetectionStatus.complete;
    emit(state.copyWith());
    return audioList;
  }
}
