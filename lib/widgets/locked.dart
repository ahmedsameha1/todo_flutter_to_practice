import 'package:flutter/material.dart';

class Locked extends StatelessWidget {
  static const refreshString = "Refresh Account";
  static const verifyEmailAddress =
      "Check your email to verify your email address";
  static const sendVerificationEmail = "Resend verification email";
  static const logout = "Log out";
  final void Function() refreshAction;
  const Locked(this.refreshAction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(verifyEmailAddress),
        TextButton(
          child: const Text(refreshString),
          onPressed: () {
            refreshAction();
          },
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
