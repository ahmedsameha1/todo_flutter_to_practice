import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AppRunner {
  AppRunner(this.widget, this.runAppFunction, this.ensureInitialized,
      this.initializeApp, this.firebaseOptions);
  final Widget widget;
  final Function(Widget) runAppFunction;
  final WidgetsBinding Function() ensureInitialized;
  final Future<FirebaseApp> Function({String? name, FirebaseOptions options})
      initializeApp;
  final FirebaseOptions firebaseOptions;

  Future<void> run() async {
    ensureInitialized();
    await initializeApp(options: firebaseOptions);
    runAppFunction(widget);
  }
}
