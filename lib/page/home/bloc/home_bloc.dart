import 'package:flutter_bloc/flutter_bloc.dart';

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
  }

  void _clean(CleanEvent event, Emitter<HomeState> emit) {
    state.isEnter = false;
    state.type = null;
    state.detectionStatus = DetectionStatus.stop;
    state.detectionResult = null;
    emit(state.copyWith());
  }
}
