import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/backend/weather/recommended_days_repo.dart';

class RunningBloc extends Bloc<RunningEvent, RunningState> {
  RunningBloc(
    RecommendedDaysRepo repository,
  ) : super(RunningState()) {
    // fetch data

    on<FetchRecommended>(
      (event, emit) async {
        emit(state.copyWith(status: RunningStatus.loading));
        try{
          final recommended = await repository.getRecommended(3);
          emit(state.copyWith(
              status: RunningStatus.success,
              intervals: recommended,));
        } catch(_){
          emit(state.copyWith(status: RunningStatus.error));
        }
      },
    );
  }
}

abstract class RunningEvent {
  const RunningEvent();
}

class FetchRecommended extends RunningEvent {
  const FetchRecommended();
}

enum RunningStatus { loading, success, error }

class RunningState {
  const RunningState(
      {this.status = RunningStatus.loading,
      this.intervals});

  final RunningStatus status;
  final List<RecommendedIntervals>? intervals;

  RunningState copyWith(
      {RunningStatus? status, List<RecommendedIntervals>? intervals}) {
    return RunningState(
        status: status ?? this.status,
        intervals: intervals ?? this.intervals
    );
  }
}