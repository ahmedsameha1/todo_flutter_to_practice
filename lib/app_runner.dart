import 'package:flutter/material.dart';

class AppRunner {
  AppRunner(this.widget, this.runAppFunction, this.ensureInitialized);
  final Widget widget;
  final Function(Widget) runAppFunction;
  final WidgetsBinding Function() ensureInitialized;

  void run() {
    ensureInitialized();
    runAppFunction(widget);
  }
}
