import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/caffeine_repository.dart';

import '../backend/location/location.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc(
  ) : super(LocationState()) {
    // fetch data

    on<LocationChanged>(
      (event, emit) async {
        emit(state.copyWith(status: LocationStatus.loading));
        try {
          //final caffeine = await repository.fetchCurrentCaffeine();
          var location = await Location.getInstance();
          if (event.useCurrentLocation) {
            await location.setCurrentPosition();
          } else {
            await location.setCustomPosition(event.latitude!, event.longitude!);
          }
          emit(
            state.copyWith(
              status: LocationStatus.success,
              locationName: location.locationName,
            ),
          );
        } catch (_) {
          emit(state.copyWith(status: LocationStatus.error));
        }
      },
    );

    on<FetchLocation>(
      (event, emit) async {
        emit(state.copyWith(status: LocationStatus.loading));
        try {
          var location = await Location.getInstance();
          emit(
            state.copyWith(
              status: LocationStatus.success,
              locationName: location.locationName,
            ),
          );
        } catch (_) {
          emit(state.copyWith(status: LocationStatus.error));
        }
      },
    );
  }
}

@immutable
abstract class LocationEvent {
  const LocationEvent();
}

class FetchLocation extends LocationEvent {}

class LocationChanged extends LocationEvent {
  final bool useCurrentLocation;
  final double? latitude;
  final double? longitude;
  const LocationChanged(
      {required this.useCurrentLocation, this.latitude, this.longitude});
}

enum LocationStatus { loading, success, error }

class LocationState {
  const LocationState({this.status = LocationStatus.loading, this.locationName});

  final LocationStatus status;
  final String? locationName;

  LocationState copyWith(
      {LocationStatus? status, String? locationName}) {
    return LocationState(
      status: status ?? this.status,
      locationName: locationName ?? this.locationName,
    );
  }
}
