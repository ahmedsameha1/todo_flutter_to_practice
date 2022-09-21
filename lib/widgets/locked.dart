import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Locked extends StatelessWidget {
  static const refreshString = "Refresh Account";
  static const verifyEmailAddress =
      "Check your email to verify your email address";
  static const sendVerificationEmail = "Resend verification email";
  static const logout = "Log out";
  const Locked({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(verifyEmailAddress),
        TextButton(
          child: Text(refreshString),
          onPressed: null,
        ),
        TextButton(
          child: const Text(sendVerificationEmail),
          onPressed: null,
        ),
        TextButton(child: const Text(logout), onPressed: null)
      ],
    );
  }
}
