import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Register extends HookWidget {
  static const nameString = "Name";
  static const passwordString = "Password";
  static const confirmPasswordString = "Confirm Password";
  static const nextString = "Next";
  static const cancelString = "Cancel";
  static const nameValidationErrorString = "Enter a name";
  static const passwordMinimumLength = 8;
  static const passwordValidationErrorString =
      "Password needs to be at least $passwordMinimumLength characters";
  static const confirmPasswordValidationErrorString =
      "This doesn't match the above password";
  final String _email;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Register(this._email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordTextEditingController =
        useTextEditingController();
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(_email),
          TextFormField(
            decoration: const InputDecoration(label: Text(nameString)),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return nameValidationErrorString;
              }
              return null;
            },
          ),
          TextFormField(
            controller: passwordTextEditingController,
            decoration: const InputDecoration(label: Text(passwordString)),
            keyboardType: TextInputType.text,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            validator: (value) {
              if (value == null ||
                  value.trim().length < passwordMinimumLength) {
                return passwordValidationErrorString;
              }
              return null;
            },
          ),
          TextFormField(
            decoration:
                const InputDecoration(label: Text(confirmPasswordString)),
            keyboardType: TextInputType.text,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            validator: (value) {
              if (value == null ||
                  value != passwordTextEditingController.text) {
                return confirmPasswordValidationErrorString;
              }
              return null;
            },
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    _formKey.currentState!.validate();
                  },
                  child: const Text(nextString)),
              TextButton(
                onPressed: null,
                child: const Text(cancelString),
              )
            ],
          ),
        ],
      ),
    );
  }
}
