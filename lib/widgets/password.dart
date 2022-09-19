import 'package:flutter/material.dart';
import 'package:todo_flutter_to_practice/widgets/register.dart';

class Password extends StatelessWidget {
  final String _email;
  final GlobalKey<FormState> _formKey = GlobalKey();
  Password(this._email, {Key? key}) : super(key: key);

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
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {
                _formKey.currentState!.validate();
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
