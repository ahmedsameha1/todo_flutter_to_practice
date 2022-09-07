import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class EmailWhileAuth extends StatelessWidget {
  static const String EMAIL = "Email";
  static const String NEXT = "Next";
  static const String CANCEL = "Cancel";
  static const String INVALID_EMAIL = "This an invalid email";
  static final RegExp emailRegex =
      RegExp(r'\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b');
  final GlobalKey<FormState> _formKey = GlobalKey();
  EmailWhileAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text(EMAIL),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty || !value.contains("@")) {
                return INVALID_EMAIL;
              }
              return null;
            },
          ),
          Row(children: [
            TextButton(
              onPressed: () {
                _formKey.currentState!.validate();
              },
              child: Text(NEXT),
            ),
            TextButton(
              onPressed: null,
              child: Text(CANCEL),
            )
          ]),
        ],
      ),
    );
  }
}
