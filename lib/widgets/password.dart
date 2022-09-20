import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter_to_practice/widgets/register.dart';

class Password extends StatelessWidget {
  final String _email;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Future<void> Function(String email, String password,
      void Function(FirebaseAuthException exception) errorCallback) nextAction;
  String? _password;
  Password(this._email, this.nextAction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: [
        Text(_email),
        TextFormField(
          decoration:
              const InputDecoration(label: Text(Register.passwordString)),
          keyboardType: TextInputType.text,
          inputFormatters: [Register.noWhiteSpaceInputFormatter],
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          validator: (value) {
            if (value == null ||
                value.trim().length < Register.passwordMinimumLength) {
              return Register.passwordValidationErrorString;
            }
            return null;
          },
          onSaved: (newValue) {
            if (newValue != null) {
              _password = newValue;
            }
          },
        ),
        Row(
          children: [
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await nextAction(_email, _password!, ((exception) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("${Register.failedString}${exception.code}")));
                  }));
                }
              },
              child: Text(Register.nextString),
            ),
            TextButton(
              onPressed: null,
              child: Text(Register.cancelString),
            )
          ],
        ),
      ]),
    );
  }
}
