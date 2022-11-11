import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/application_login_state.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

import 'email.dart';
import 'password.dart';
import 'register.dart';

class MainScreen extends ConsumerWidget {
  static const String signInUpString = "Sign in/up";
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateNotifier = ref.read(authStateNotifierProvider);
    final authState = ref.watch(authStateProvider);
    final body;
    switch (authState.applicationLoginState) {
      case ApplicationLoginState.loggedOut:
        body = TextButton(
            onPressed: authStateNotifier.startLoginFlow,
            child: const Text(signInUpString));
        break;
      case ApplicationLoginState.emailAddress:
        body =
            Email(authStateNotifier.verifyEmail, authStateNotifier.toLoggedOut);
        break;
      case ApplicationLoginState.password:
        body = Password(
            authState.email!,
            authStateNotifier.signInWithEmailAndPassword,
            authStateNotifier.toLoggedOut);
        break;
      case ApplicationLoginState.register:
        body = Register(authState.email!, authStateNotifier.registerAccount,
            authStateNotifier.toLoggedOut);
        break;
      default:
        body = Text("");
    }
    return Scaffold(
      body: body,
    );
  }
}
