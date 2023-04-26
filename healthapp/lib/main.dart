import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthapp/bloc/caffeine_bloc.dart';
import 'package:healthapp/bloc/location_bloc.dart';
import 'package:healthapp/caffeine_repository.dart';
import 'package:healthapp/dashboard/dashboard_view.dart';
import 'package:healthapp/services/auth/auth/bloc/auth_bloc.dart';
import 'package:healthapp/services/auth/auth/bloc/auth_event.dart';
import 'package:healthapp/services/auth/auth/bloc/auth_state.dart';
import 'package:healthapp/services/auth/auth/firebase_auth_provider.dart';

import 'login/forgot_password_view.dart';
import 'login/login_view.dart';
import 'login/register_view.dart';
import 'login/verify_email_view.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider())
            ..add(const AuthEventInitialize()),
        ),
        BlocProvider<CaffeineBloc>(
          create: (context) => CaffeineBloc(
            CaffeineRepository(),
          )..add(FetchCaffeine()),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc()..add(FetchLocation()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: "title"),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return Material(
            child: SafeArea(child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state.status == LocationStatus.success) {
                  return DashboardView();
                } else {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            )),
          );
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
