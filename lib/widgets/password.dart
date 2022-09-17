import 'package:flutter/material.dart';
import 'package:todo_flutter_to_practice/widgets/register.dart';

class Password extends StatelessWidget {
  final String _email;
  const Password(this._email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
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
        ),
        Row(
          children: [
            TextButton(
              onPressed: null,
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
