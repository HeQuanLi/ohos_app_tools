import '../../../bean/drop_type.dart';

class HomeState {
  bool? isEnter; //是否进入
  DropType? type; //拖入类型
  Execute? execute;

  HomeState({this.isEnter, this.type, this.execute});

  copyWith() {
    return HomeState(isEnter: isEnter, type: type, execute: execute);
  }
}

///异常
final class ErrorState extends HomeState {
  Object error;

  ErrorState(this.error);
}

///执行
final class ExecuteState extends HomeState {
  Execute exe;
  DropType tp; //拖入类型
  ExecuteState(this.exe, this.tp) : super(execute: exe, type: tp);
}

enum Execute {
  running, //执行中
  complete, //执行完成
}
