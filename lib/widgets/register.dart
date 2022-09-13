import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  static const nameString = "Name";
  static const passwordString = "Password";
  static const confirmPasswordString = "Confirm Password";
  static const nextString = "Next";
  static const cancelString = "Cancel";
  static const nameValidationErrorString = "Enter a name";
  static const passwordMinimumLength = 8;
  static const passwordValidationErrorString =
      "Password needs to be at least $passwordMinimumLength characters";
  final String _email;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Register(this._email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            readOnly: true,
            enableSuggestions: false,
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
