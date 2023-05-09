import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/backend/air/airQuality.dart';
import 'package:healthapp/backend/breathing/breathing_repository.dart';
import 'package:healthapp/caffeine_repository.dart';

class BreathingBloc extends Bloc<BreathingEvent, BreathingState> {
  BreathingRepository repository =
      BreathingRepository(FirebaseStorageDataSource());
  BreathingBloc() : super(const BreathingState()) {
    // fetch data

    on<FetchBreathingExercise>(
      (event, emit) async {
        emit(state.copyWith(status: BreathingStatus.loading));
        try {
          final String audioUrl =
              await repository.getBreathingAudio(event.category.toLowerCase());
          final Uri audioUri = Uri.parse(audioUrl);

          log(audioUri.toString());

          emit(state.copyWith(
            status: BreathingStatus.success,
            audioUri: audioUri,
          ));
        } catch (_) {
          log("något gick snett");
          emit(state.copyWith(status: BreathingStatus.error));
        }
      },
    );
  }
}

@immutable
abstract class BreathingEvent {
  const BreathingEvent();
}

class FetchBreathingExercise extends BreathingEvent {
  String category;
  FetchBreathingExercise({required this.category});
}

enum BreathingStatus { loading, success, error }

class BreathingState {
  const BreathingState({this.status = BreathingStatus.loading, this.audioUri});

  final BreathingStatus status;
  final Uri? audioUri;

  BreathingState copyWith({BreathingStatus? status, Uri? audioUri}) {
    return BreathingState(
        status: status ?? this.status, audioUri: audioUri ?? this.audioUri);
  }
}
