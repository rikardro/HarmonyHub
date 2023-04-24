import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/caffeine_repository.dart';

import '../backend/location/location.dart';
import '../backend/location/location_search.dart';

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  LocationSearchBloc() : super(LocationSearchState()) {
    // fetch data

    on<LocationsSearchFetch>(
      (event, emit) async {
        emit(state.copyWith(status: LocationSearchStatus.loading));
        try {
          //final caffeine = await repository.fetchCurrentCaffeine();
          /* var location = await Location.getInstance();
          if (event.useCurrentLocation) {
            await location.setCurrentPosition();
          } else {
            await location.setCustomPosition(event.latitude!, event.longitude!);
          } */
          List<LocationData> locations =
              await LocationSearch().search(event.searchQuery);
          emit(
            state.copyWith(
              status: LocationSearchStatus.success,
              locations: locations,
            ),
          );
        } catch (_) {
          emit(state.copyWith(status: LocationSearchStatus.error));
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
  const LocationsSearchFetch({required this.searchQuery});
}

enum LocationSearchStatus { loading, success, error }

class LocationSearchState {
  const LocationSearchState(
      {this.status = LocationSearchStatus.loading, this.locations});

  final LocationSearchStatus status;
  final List<LocationData>? locations;

  LocationSearchState copyWith(
      {LocationSearchStatus? status, List<LocationData>? locations}) {
    return LocationSearchState(
      status: status ?? this.status,
      locations: locations ?? this.locations,
    );
  }
}
