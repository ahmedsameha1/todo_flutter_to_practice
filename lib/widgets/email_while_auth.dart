import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class EmailWhileAuth extends StatelessWidget {
  static const String EMAIL = "Email";
  static const String NEXT = "Next";
  static const String CANCEL = "Cancel";
  const EmailWhileAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              label: Text(EMAIL),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          Row(children: [
            TextButton(
              onPressed: null,
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
