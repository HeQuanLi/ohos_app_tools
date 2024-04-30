import 'package:desktop_drop/desktop_drop.dart';

import '../../../bean/drop_type.dart';

///home事件类
sealed class HomeEvent {}

///清空事件
class CleanEvent extends HomeEvent {}

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
