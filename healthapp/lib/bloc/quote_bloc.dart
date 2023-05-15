import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../backend/quotes/quote_repository.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteRepository repository = QuoteRepository();
  QuoteBloc() : super(QuoteState()) {
    on<FetchQuote>((event, emit) async {
      emit(state.copyWith(status: QuoteStatus.loading));

      try {
        final quote = await repository.getQuote();
        emit(QuoteState(status: QuoteStatus.success, quote: quote));
      } catch (_) {
        log(_.toString());
        emit(state.copyWith(status: QuoteStatus.error));
      }
    });
  }
}

@immutable
abstract class QuoteEvent {
  const QuoteEvent();
}

class FetchQuote extends QuoteEvent {}

enum QuoteStatus { loading, success, error, needsFirstLastName }

class QuoteState {
  String? quote;

  QuoteState({this.status = QuoteStatus.loading, this.quote});

  final QuoteStatus status;

  QuoteState copyWith({
    QuoteStatus? status,
  }) {
    return QuoteState(
      status: status ?? this.status,
    );
  }
}
