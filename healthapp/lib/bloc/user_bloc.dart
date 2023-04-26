import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthapp/backend/user/user_repository.dart';

import '../backend/location/location.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc(UserRepository repository) : super(UserState()) {
    // fetch data

    on<UserAdded>((event, emit) async {
      emit(state.copyWith(status: UserStatus.loading));
      try {
        await repository.addUser(
          event.firstName,
          event.lastName,
        );
        emit(
          state.copyWith(
            status: UserStatus.success,
          ),
        );
      } catch (_) {
        emit(state.copyWith(status: UserStatus.error));
      }
    });

    on<FetchUser>(
      (event, emit) async {
        emit(state.copyWith(status: UserStatus.loading));
        try {
          FirebaseUser? user = await repository.getCurrentUser();
          log(user.toString());
          if (user == null) {
            emit(
              state.copyWith(
                status: UserStatus.needsFirstLastName,
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: UserStatus.success,
                firstName: user.firstName,
                lastName: user.lastName,
                initals: user.initals,
                email: user.email,
              ),
            );
          }
        } catch (_) {
          emit(state.copyWith(status: UserStatus.error));
        }
      },
    );
  }
}

@immutable
abstract class UserEvent {
  const UserEvent();
}

class FetchUser extends UserEvent {}

class UserAdded extends UserEvent {
  final String firstName;
  final String lastName;

  const UserAdded(this.firstName, this.lastName);
}

enum UserStatus { loading, success, error, needsFirstLastName }

class UserState {
  const UserState(
      {this.firstName,
      this.lastName,
      this.initals,
      this.email,
      this.status = UserStatus.loading});

  final UserStatus status;
  final String? firstName;
  final String? lastName;
  final String? initals;
  final String? email;

  UserState copyWith(
      {UserStatus? status,
      String? firstName,
      String? lastName,
      String? initals,
      String? email}) {
    return UserState(
      status: status ?? this.status,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      initals: initals ?? this.initals,
      email: email ?? this.email,
    );
  }
}
