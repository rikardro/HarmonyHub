import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/backend/running/run_session.dart';

import '../backend/location/location.dart';

class RunTrackerBloc extends Bloc<RunTrackerEvent, RunTrackerState> {
  RunTrackerBloc() : super(RunTrackerState()) {
    // fetch data
    add(WatchRunSession());

    final locationTracker = LocationTracker();

    on<WatchRunSession>(
      (event, emit) async {
        final stream = locationTracker.getStream();
        await emit.forEach(stream, onData: (RunSession runSession) {
          return state.copyWith(
            status: RunTrackerStatus.running,
            runSession: runSession,
          );
        }, onError: (error, stackTrace) {
          log('Error in stream: $error');
          return state.copyWith(status: RunTrackerStatus.error);
        });
      },
    );

    on<StartTracking>(
      (event, emit) async {
        try {
          await LocationTracker().startTracking();
        } catch (_) {
          emit(state.copyWith(status: RunTrackerStatus.error));
        }
      },
    );

    on<StopTracking>((event, emit) async {
      try {
        locationTracker.stopTracking();
        emit(state.copyWith(status: RunTrackerStatus.stopped));

        final runSession = LocationTracker().getRunSession();
        //await repository.addRunSession(runSession);
      } catch (_) {
        emit(state.copyWith(status: RunTrackerStatus.error));
      }
    });
  }
}

@immutable
abstract class RunTrackerEvent {
  const RunTrackerEvent();
}

class StartTracking extends RunTrackerEvent {}

class StopTracking extends RunTrackerEvent {}

class WatchRunSession extends RunTrackerEvent {}

enum RunTrackerStatus { running, stopped, error }

class RunTrackerState {
  const RunTrackerState({this.status = RunTrackerStatus.stopped, this.runSession});

  final RunTrackerStatus status;
  final RunSession? runSession;

  RunTrackerState copyWith({RunTrackerStatus? status, RunSession? runSession}) {
    return RunTrackerState(
      status: status ?? this.status,
      runSession: runSession ?? this.runSession,
    );
  }
}
