import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/caffeine_repository.dart';

import '../backend/location/location.dart';

class LocationSearchBloc extends Bloc<LocationSearchEvent, LocationSearchState> {
  LocationSearchBloc() : super(LocationSearchState()) {
    // fetch data

    on<LocationsSearchFetch>(
      (event, emit) async {
        emit(state.copyWith(status: LocationStatus.loading));
        try {
          //final caffeine = await repository.fetchCurrentCaffeine();
          /* var location = await Location.getInstance();
          if (event.useCurrentLocation) {
            await location.setCurrentPosition();
          } else {
            await location.setCustomPosition(event.latitude!, event.longitude!);
          } */
          emit(
            state.copyWith(
              status: LocationStatus.success,
              locations: locations,
            ),
          );
        } catch (_) {
          emit(state.copyWith(status: LocationStatus.error));
        }
      },
    );

    /* on<FetchLocation>(
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
    ); */
  }
}

@immutable
abstract class LocationSearchEvent {
  const LocationSearchEvent();
}

class LocationsSearchFetch extends LocationSearchEvent {
  final String searchQuery;
  const LocationsSearchFetch(
      {required this.searchQuery});
}

enum LocationStatus { loading, success, error }

class LocationSearchState {
  const LocationSearchState(
      {this.status = LocationStatus.loading, this.locations});

  final LocationStatus status;
  final List<LocationData>? locations;

  LocationSearchState copyWith({LocationStatus? status, List<LocationData>? locations}) {
    return LocationSearchState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
    );
  }
}
