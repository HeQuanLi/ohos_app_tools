import 'package:desktop_drop/desktop_drop.dart';

import '../../../bean/audio_info_bean.dart';
import '../../../bean/drop_type.dart';

///home事件类
sealed class HomeEvent {}

///清空事件
class CleanEvent extends HomeEvent {}

///批量导出事件
class ExportAllEvent extends HomeEvent {
  final List<AudioInfoBean> exportFileList; //导出文件
  final String exportPath; //导出路径

  ExportAllEvent(this.exportFileList, this.exportPath);
}

///拖拽完成
class DragDoneEvent extends HomeEvent {
  final DropDoneDetails details;

  DragDoneEvent(this.details) : super();
}

///拖拽进入
class DragEnteredEvent extends HomeEvent {
  bool enter;
  DropType type;

  DragEnteredEvent(this.enter, this.type);
}

///拖拽退出
class DragExitedEvent extends HomeEvent {
  bool enter;
  DropType type;

  DragExitedEvent(this.enter, this.type);
}

///开始检测
class DetectionStartEvent extends HomeEvent {
  List<AudioInfoBean> detectionList;

  DetectionStartEvent(this.detectionList);
}

///停止检测
class DetectionStopEvent extends HomeEvent {
  DetectionStopEvent();
}

///单个检测完成
class DetectionSingleCompleteEvent extends HomeEvent {
  DetectionSingleCompleteEvent();
}

///全部检测完成
class DetectionAllCompleteEvent extends HomeEvent {
  DetectionAllCompleteEvent();
}
