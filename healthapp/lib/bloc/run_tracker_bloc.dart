import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/backend/running/run_session.dart';
import 'package:healthapp/backend/user/user_repository.dart';

import '../backend/location/location.dart';

class RunningBloc extends Bloc<RunningEvent, RunningState> {
  RunningBloc(UserRepository repository) : super(RunningState()) {
    // fetch data
    add(WatchRunSession());

    final locationTracker = LocationTracker();

    on<WatchRunSession>(
      (event, emit) async {
        final stream = locationTracker.getStream();
        await emit.forEach(stream, onData: (RunSession runSession) {
          return state.copyWith(
            status: RunningStatus.running,
            runSession: runSession,
          );
        }, onError: (error, stackTrace) {
          log('Error in stream: $error');
          return state.copyWith(status: RunningStatus.error);
        });
      },
    );

    on<StartTracking>(
      (event, emit) async {
        try {
          await LocationTracker().startTracking();
        } catch (_) {
          emit(state.copyWith(status: RunningStatus.error));
        }
      },
    );

    on<StopTracking>((event, emit) async {
      try {
        locationTracker.stopTracking();
        emit(state.copyWith(status: RunningStatus.stopped));

        final runSession = LocationTracker().getRunSession();
        //await repository.addRunSession(runSession);
      } catch (_) {
        emit(state.copyWith(status: RunningStatus.error));
      }
    });
  }
}

@immutable
abstract class RunningEvent {
  const RunningEvent();
}

class StartTracking extends RunningEvent {}

class StopTracking extends RunningEvent {}

class WatchRunSession extends RunningEvent {}

enum RunningStatus { running, stopped, error }

class RunningState {
  const RunningState({this.status = RunningStatus.stopped, this.runSession});

  final RunningStatus status;
  final RunSession? runSession;

  RunningState copyWith({RunningStatus? status, RunSession? runSession}) {
    return RunningState(
      status: status ?? this.status,
      runSession: runSession ?? this.runSession,
    );
  }
}
