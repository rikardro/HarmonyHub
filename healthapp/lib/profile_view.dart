import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/services/auth/auth/bloc/auth_bloc.dart';
import 'package:healthapp/services/auth/auth/bloc/auth_event.dart';

import 'bloc/user_bloc.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunningBloc, RunningState>(
      builder: (context, state) {
        final firstName = state.firstName;
        final lastName = state.lastName;
        final email = state.email;
        final initials = state.initals;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your profile'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  child: Text(
                    initials!.toUpperCase(),
                    style: const TextStyle(fontSize: 30),
                  ),
                  backgroundColor: Colors.blue,
                  radius: 50,
                ),
                const SizedBox(height: 20),
                Text(
                  firstName! + ' ' + lastName!,
                  style: const TextStyle(fontSize: 24),
                ),
                SizedBox(height: 15),
                Text(email!),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                    Navigator.pop(context);
                  },
                  child: const Text('Log Out'),
                ),
                const SizedBox(height: 20),
                // Add any other widgets you'd like here
              ],
            ),
          ),
        );
      },
    );
  }
}
