import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_bloc.dart';

class AddUserInformationView extends StatefulWidget {
  const AddUserInformationView({Key? key}) : super(key: key);

  @override
  State<AddUserInformationView> createState() => _AddUserInformationViewState();
}

class _AddUserInformationViewState extends State<AddUserInformationView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  bool _isButtonEnabled = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _checkButtonEnabled() {
    setState(() {
      _isButtonEnabled = _firstNameController.text.isNotEmpty &&
          _lastNameController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your information"),
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              "assets/images/nature_image.png",
              height: 300,
            ),
            Text(
              "Please enter your first and last name to keep using this application",
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                hintText: "First Name",
              ),
              onChanged: (text) {
                _checkButtonEnabled();
              },
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: "Last Name",
              ),
              onChanged: (text) {
                _checkButtonEnabled();
              },
            ),
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                      final firstName = _firstNameController.text;
                      final lastName = _lastNameController.text;
                      context.read<UserBloc>().add(
                            UserAdded(
                              firstName,
                              lastName,
                            ),
                          );
                    }
                  : null,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
