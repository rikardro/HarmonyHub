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
  static late bool logging_in;
  static late bool reseting_password;
  static bool firstTimeShowing = true;
  final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  final snackBar = SnackBar(
      content: Text(
        '${GreetingPhrase.get()} 👋',
        style: const TextStyle(fontSize: 18),
      ),
      duration: const Duration(seconds: 3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.fromLTRB(175, 0, 175, 450));

  @override
  void initState() {
    logging_in = false;
    reseting_password = false;
    if (firstTimeShowing) {
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
    var screenWidth = MediaQuery.of(context).size.width;
    if (reseting_password) {
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
                image: AssetImage('assets/images/nature.gif'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 175,
                  width: screenWidth,
                ),
                Stack(children: [
                  Text(
                    'HarmonyHub',
                    style: GoogleFonts.pinyonScript(
                        fontSize: 60,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.black),
                  ),
                  Text(
                    'HarmonyHub',
                    style: GoogleFonts.pinyonScript(
                        fontSize: 60, color: Colors.white),
                  ),
                ]),
                const SizedBox(height: 90),
                const Text(
                  'If you forgot your password, simply enter your email and we will send you a password reset link',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  autofocus: true,
                  controller: _email,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 38, 0, 126),
                    hintText: 'Your email adress ...',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 209, 209, 209)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final email = _email.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventForgotPassword(email: email));
                  },
                  child: const Text('Send me a password reset link',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.underline)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      reseting_password = false;
                    });
                  },
                  child: const Text('Back to login page',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.underline)),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (!logging_in) {
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
                image: AssetImage('assets/images/nature.gif'),
                fit: BoxFit.fitHeight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 175, width: screenWidth),
                Stack(children: [
                  Text(
                    'HarmonyHub',
                    style: GoogleFonts.pinyonScript(
                        fontSize: 60,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.black),
                  ),
                  Text(
                    'HarmonyHub',
                    style: GoogleFonts.pinyonScript(
                        fontSize: 60, color: Colors.white),
                  ),
                ]),
                const SizedBox(height: 90),
                ElevatedButton(
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: const Text(
                        "Login",
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 38, 0, 126),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      textStyle: TextStyle(color: Colors.white, fontSize: 20)),
                  onPressed: () {
                    setState(() {
                      logging_in = true;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 38, 0, 126),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Align(
                      alignment: Alignment.center,
                      child: const Text(
                        "Register",
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
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
                image: AssetImage('assets/images/nature.gif'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 175),
                Stack(children: [
                  Text(
                    'HarmonyHub',
                    style: GoogleFonts.pinyonScript(
                        fontSize: 60,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 6
                          ..color = Colors.black),
                  ),
                  Text(
                    'HarmonyHub',
                    style: GoogleFonts.pinyonScript(
                        fontSize: 60, color: Colors.white),
                  ),
                ]),
                const SizedBox(height: 90),
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromARGB(255, 38, 0, 126),
                      hintText: "Enter your email here",
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 209, 209, 209))),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromARGB(255, 38, 0, 126),
                    hintText: "Enter your password here",
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 209, 209, 209)),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: TextButton(
                        child: Text(
                          'Log In',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                        onPressed: () async {
                          context.read<AuthBloc>().add(
                                AuthEventLogIn(
                                  _email.text,
                                  _password.text,
                                ),
                              );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          logging_in = false;
                        });
                      },
                      child: const Text(
                        "Back",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          reseting_password = true;
                        });
                      },
                      child: const Text(
                        "Forgot your password?",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
