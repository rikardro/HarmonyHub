import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/backend/air/airQuality.dart';
import 'package:healthapp/caffeine_repository.dart';

class AirQualityBloc extends Bloc<AirQualityEvent, AirQualityState> {
  AirQualityBloc() : super(AirQualityState()) {
    // fetch data

    on<FetchAirQuality>(
      (event, emit) async {
        emit(state.copyWith(status: AirQualityStatus.loading));
        try {
          final AirQualityData data = await AirQuality.fetchAirQualityData();
          log(data.airQuality.toString());
          log(data.airQualityStatus);
          emit(state.copyWith(
              status: AirQualityStatus.success,
              airQuality: data.aqi.toDouble(),
              airQualityStatus: data.status));
        } catch (_) {
          emit(state.copyWith(status: AirQualityStatus.error));
        }
      },
    );
  }
}

@immutable
abstract class AirQualityEvent {
  const AirQualityEvent();
}

class FetchAirQuality extends AirQualityEvent {
  const FetchAirQuality();
}

enum AirQualityStatus { loading, success, error }

class AirQualityState {
  const AirQualityState(
      {this.status = AirQualityStatus.loading,
      this.airQuality,
      this.airQualityStatus});

  final AirQualityStatus status;
  final double? airQuality;
  final String? airQualityStatus;

  AirQualityState copyWith(
      {AirQualityStatus? status,
      double? airQuality,
      String? airQualityStatus}) {
    return AirQualityState(
        status: status ?? this.status,
        airQuality: airQuality ?? this.airQuality,
        airQualityStatus: airQualityStatus ?? this.airQualityStatus);
  }
}

/* class PostStateLoaded extends CaffeineState {
  final List<Post> posts;
  final Uint8List? image;
  const PostStateLoaded({required this.posts, required this.image});
} */

