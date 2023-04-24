import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/caffeine_repository.dart';

class CaffeineBloc extends Bloc<CaffeineEvent, LocationState> {
  CaffeineBloc(
    CaffeineRepository repository,
  ) : super(LocationState()) {
    // fetch data

    on<FetchCaffeine>(
      (event, emit) async {
        print("EMITTING");
        emit(state.copyWith(status: LocationStatus.loading));
        try {
          final caffeine = await repository.fetchCurrentCaffeine();
          print(caffeine.amount);
          emit(state.copyWith(
              status: LocationStatus.success,
              caffeine: caffeine.amount,
              caffeineStatus: caffeine.status));
        } catch (_) {
          emit(state.copyWith(status: LocationStatus.error));
        }
      },
    );
  }
}

@immutable
abstract class CaffeineEvent {
  const CaffeineEvent();
}

class FetchCaffeine extends CaffeineEvent {
  const FetchCaffeine();
}

enum LocationStatus { loading, success, error }

class LocationState {
  const LocationState(
      {this.status = LocationStatus.loading,
      this.caffeine,
      this.caffeineStatus});

  final LocationStatus status;
  final double? caffeine;
  final String? caffeineStatus;

  LocationState copyWith(
      {LocationStatus? status, double? caffeine, String? caffeineStatus}) {
    return LocationState(
        status: status ?? this.status,
        caffeine: caffeine ?? this.caffeine,
        caffeineStatus: caffeineStatus ?? this.caffeineStatus);
  }
}

