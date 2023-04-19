import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/caffeine_repository.dart';

class CaffeineBloc extends Bloc<CaffeineEvent, CaffeineState> {
  CaffeineBloc(
    CaffeineRepository repository,
  ) : super(CaffeineState()) {
    // fetch data

    on<FetchCaffeine>(
      (event, emit) async {
        emit(state.copyWith(status: CaffeineStatus.loading));
        try {
          final caffeine = await repository.fetchCurrentCaffeine();
          emit(state.copyWith(
              status: CaffeineStatus.success,
              caffeine: caffeine.amount,
              caffeineStatus: caffeine.status));
        } catch (_) {
          emit(state.copyWith(status: CaffeineStatus.error));
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

class AddCaffeine extends CaffeineEvent {
  final double amount;
  final String drinkType;
  const AddCaffeine({required this.amount, required this.drinkType});
}

enum CaffeineStatus { loading, success, error }

class CaffeineState {
  const CaffeineState(
      {this.status = CaffeineStatus.loading,
      this.caffeine,
      this.caffeineStatus});

  final CaffeineStatus status;
  final double? caffeine;
  final String? caffeineStatus;

  CaffeineState copyWith(
      {CaffeineStatus? status, double? caffeine, String? caffeineStatus}) {
    return CaffeineState(
        status: status ?? this.status,
        caffeine: caffeine ?? this.caffeine,
        caffeineStatus: caffeineStatus ?? this.caffeineStatus);
  }
}

/* class PostStateLoaded extends CaffeineState {
  final List<Post> posts;
  final Uint8List? image;
  const PostStateLoaded({required this.posts, required this.image});
} */

