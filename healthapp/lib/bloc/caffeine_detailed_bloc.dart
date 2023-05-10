import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/caffeine_repository.dart';

import '../caffeine_detailed_view.dart';

class CaffeineDetailedBloc
    extends Bloc<CaffeineDetailedEvent, CaffeineDetailedState> {
  CaffeineDetailedBloc(
    CaffeineRepository repository,
  ) : super(CaffeineDetailedState()) {
    // fetch data

    on<FetchAllCaffeine>(
      (event, emit) async {
        emit(state.copyWith(status: CaffeineDetailedStatus.loading));
        try {
          final caffeineList = await repository.fetchAllCaffeine();
          emit(state.copyWith(
              status: CaffeineDetailedStatus.success,
              caffeineList: caffeineList));
        } catch (_) {
          emit(state.copyWith(status: CaffeineDetailedStatus.error));
        }
      },
    );

    on<AddCaffeine>(
      (event, emit) async {
        emit(state.copyWith(status: CaffeineDetailedStatus.loading));
        try {
          emit(state.copyWith(
              status: CaffeineDetailedStatus.loading, caffeineList: null));
          await repository.addConsumedCaffeine(
              event.amount, event.drinkType, event.timeSince);
          emit(state.copyWith(
              status: CaffeineDetailedStatus.success, caffeineList: null));
        } catch (_) {
          emit(state.copyWith(status: CaffeineDetailedStatus.error));
        }
      },
    );

    on<DeleteCaffeine>(
      (event, emit) async{
        emit(state.copyWith(status: CaffeineDetailedStatus.loading));
          try {
          emit(state.copyWith(
              status: CaffeineDetailedStatus.loading, caffeineList: null));
          await repository.deleteCaffeine(event.id);
          emit(state.copyWith(
              status: CaffeineDetailedStatus.success, caffeineList: null));
        } catch (_) {
          emit(state.copyWith(status: CaffeineDetailedStatus.error));
        }
      }
    );
  }
}

@immutable
abstract class CaffeineDetailedEvent {
  const CaffeineDetailedEvent();
}

class FetchAllCaffeine extends CaffeineDetailedEvent {
  const FetchAllCaffeine();
}

class AddCaffeine extends CaffeineDetailedEvent {
  final double amount;
  final String drinkType;
  final double timeSince;
  AddCaffeine(
      {required this.timeSince, required this.amount, required this.drinkType});
}

class DeleteCaffeine extends CaffeineDetailedEvent {
  final String id;
  const DeleteCaffeine({required this.id});
}

enum CaffeineDetailedStatus { loading, success, error }

class CaffeineDetailedState {
  const CaffeineDetailedState(
      {this.status = CaffeineDetailedStatus.loading, this.caffeineList});

  final CaffeineDetailedStatus status;
  final List<CaffeineRecord>? caffeineList;

  CaffeineDetailedState copyWith(
      {CaffeineDetailedStatus? status, List<CaffeineRecord>? caffeineList}) {
    return CaffeineDetailedState(
        status: status ?? this.status,
        caffeineList: caffeineList ?? this.caffeineList);
  }
}
