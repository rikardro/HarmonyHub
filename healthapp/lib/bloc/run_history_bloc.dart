import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:healthapp/backend/running/run_session_repository.dart';

import '../backend/running/run_session_history.dart';

class RunHistoryBloc extends Bloc<RunHistoryEvent, RunHistoryState> {
  RunHistoryBloc(
    RunSessionRepository runSessionRepository,
  ) : super(const RunHistoryState()) {

    on<FetchRunHistory>(
      (event, emit) async {
        emit(state.copyWith(status: RunHistoryStatus.loading));
        try {
          List<RunSessionHistory> runHistory = await runSessionRepository.fetchAllRunSessions();
          emit(
            state.copyWith(
              status: RunHistoryStatus.success,
              runHistory: runHistory,
            ),
          );
        } catch (_) {
          log(_.toString());
          emit(state.copyWith(status: RunHistoryStatus.error));
        }
      },
    );
  }
}


abstract class RunHistoryEvent {
  const RunHistoryEvent();
}

class FetchRunHistory extends RunHistoryEvent {
  const FetchRunHistory();
}

enum RunHistoryStatus { success, loading, error }

class RunHistoryState {
  final RunHistoryStatus status;
  final List<RunSessionHistory> runHistory;

  const RunHistoryState({
    this.status = RunHistoryStatus.loading,
    this.runHistory = const <RunSessionHistory>[],
  });

  RunHistoryState copyWith({
    RunHistoryStatus? status,
    List<RunSessionHistory>? runHistory,
  }) {
    return RunHistoryState(
      status: status ?? this.status,
      runHistory: runHistory ?? this.runHistory,
    );
  }
}