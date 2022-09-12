import 'package:flutter/material.dart';

class Register extends StatelessWidget {
  static const nameString = "Name";
  static const passwordString = "Password";
  static const confirmPasswordString = "Confirm Password";
  static const nextString = "Next";
  static const cancelString = "Cancel";
  final String _email;
  const Register(this._email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Text(_email),
          TextFormField(
            decoration: const InputDecoration(label: Text(nameString)),
            keyboardType: TextInputType.text,
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text(passwordString)),
            keyboardType: TextInputType.text,
            obscureText: true,
            autocorrect: false,
            readOnly: true,
            enableSuggestions: false,
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
              TextButton(onPressed: null, child: const Text(nextString)),
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
