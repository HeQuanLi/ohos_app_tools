import '../../../bean/audio_info_bean.dart';
import '../../../bean/drop_type.dart';

class HomeState {
  List<AudioInfoBean> showAudioList; //未检测的原始音频数据
  bool? isEnter; //是否进入
  DropType? type; //拖入类型
  DetectionStatus detectionStatus; //检查状态
  DetectionResult? detectionResult; //检测结果

  HomeState(this.showAudioList, this.detectionStatus,
      {this.isEnter, this.type, this.detectionResult});

  copyWith() {
    return HomeState(showAudioList, detectionStatus,
        isEnter: isEnter, type: type, detectionResult: detectionResult);
  }
}

final class ExportStartState extends HomeState {
  ExportStartState() : super([], DetectionStatus.complete);
}

final class ExportCompleteState extends HomeState {
  List<String> exportList; //导出文件路径
  ExportCompleteState(this.exportList) : super([], DetectionStatus.complete);
}

final class ExportErrorState extends HomeState {
  Object error;

  ExportErrorState(this.error) : super([], DetectionStatus.complete);
}

enum DetectionStatus {
  init, //初始化中
  running, //检测中
  complete, //检测完成
  stop, //停止检测
}

final class DetectionResult {
  int detectionNum; //检测总数
  int riskNum; //风险总数
  int qualifiedNum; //合格总数
  int failedNum; //失败总数

  DetectionResult(
      this.detectionNum, this.riskNum, this.qualifiedNum, this.failedNum);
}
