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

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your information"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "You need to enter your first and last name to continue!",
              style: TextStyle(fontSize: 30),
            ),
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                hintText: "First Name",
              ),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                hintText: "Last Name",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final firstName = _firstNameController.text;
                final lastName = _lastNameController.text;
                context.read<UserBloc>().add(
                      UserAdded(
                        firstName,
                        lastName,
                      ),
                    );
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
