import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../backend/greetingPhrase.dart';
import '../services/auth/auth/auth_exceptions.dart';
import '../services/auth/auth/bloc/auth_bloc.dart';
import '../services/auth/auth/bloc/auth_event.dart';
import '../services/auth/auth/bloc/auth_state.dart';
import '../util/dialogs/error_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}


class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  static bool firstTimeShowing = true;
  
  final snackBar = SnackBar(content: Text('${GreetingPhrase.get()} 👋', style: const TextStyle(fontSize: 18),),
  duration: const Duration(seconds: 3),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  behavior: SnackBarBehavior.floating,
  margin: EdgeInsets.fromLTRB(175, 0, 175, 450));

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    if (firstTimeShowing){
      Future<Null>.delayed(Duration.zero, () {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar,
      );
      });
      firstTimeShowing = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
                context, "Cannot find a user with the entered credentials");
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(context, "Wrong credentials");
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, "Authentication error");
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/boat.gif'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("H", style: TextStyle(fontSize: 50, color: Colors.transparent),
              ),
              const Text("H", style: TextStyle(fontSize: 50, color: Colors.transparent),
              ),
              const Text("H", style: TextStyle(fontSize: 50, color: Colors.transparent),
              ),
              Text(
                'HarmonyHub',
                style: GoogleFonts.pinyonScript(
                color: Colors.white,
                fontSize: 50,
                ),
              ),
              const Text("H", style: TextStyle(fontSize: 60, color: Colors.transparent),
              ),
              const Text(
                'Welcome to Healthapp, please log in to see all kinds of interesting things about your health!',
                style: TextStyle(color: Colors.white),
              ),
              const Text("H", style: TextStyle(fontSize: 20, color: Colors.transparent),
              ),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  hintText: "Enter your email here",
                  hintStyle: TextStyle(color: Color.fromARGB(255, 209, 209, 209))
                ),
              ),
              const Text("H", style: TextStyle(fontSize: 10, color: Colors.transparent),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                style: TextStyle(color: Colors.white),
                decoration:
                    const InputDecoration(
                      filled: true,
                      fillColor: Colors.black,
                      hintText: "Enter your password here",
                      hintStyle: TextStyle(color: Color.fromARGB(255, 209, 209, 209))),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context.read<AuthBloc>().add(
                        AuthEventLogIn(
                          email,
                          password,
                        ),
                      );
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline),
                  
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                },
                child: const Text(
                  "I forgot my password",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventShouldRegister(),
                      );
                },
                child: const Text(
                  "Not registered yet? Register here!",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
