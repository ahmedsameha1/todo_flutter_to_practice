import 'package:flutter/material.dart';

class AppRunner {
  AppRunner(this.widget, this.runAppFunction);
  final Widget widget;
  final Function(Widget) runAppFunction;

  void run() {
    runAppFunction(widget);
  }
}
