import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

class MainScreen extends ConsumerWidget {
  static const String signInUpString = "Sign in/up";
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateNotifier = ref.read(authStateNotifierProvider);
    return Scaffold(
        body: TextButton(
      onPressed: authStateNotifier.startLoginFlow,
      child: const Text(signInUpString),
    ));
  }
}
