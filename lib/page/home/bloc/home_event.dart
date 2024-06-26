import 'package:desktop_drop/desktop_drop.dart';

import '../../../bean/drop_type.dart';

///home事件类
sealed class HomeEvent {}

///执行事件，(签名 or 安装)
class ExecuteEvent extends HomeEvent {
  final DropType type;

  ExecuteEvent(this.type);
}

///拖拽完成
class DragDoneEvent extends HomeEvent {
  final DropDoneDetails details;
  final DropType type;

  DragDoneEvent(this.details, this.type) : super();
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
