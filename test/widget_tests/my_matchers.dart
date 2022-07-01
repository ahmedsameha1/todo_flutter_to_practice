import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FirstPrecedesSecond extends Matcher {
  final Widget first, second;

  const FirstPrecedesSecond(this.first, this.second);

  @override
  Description describe(Description description) {
    return description;
  }

  @override
  bool matches(
      covariant List<Widget> allWidgetsList, Map<dynamic, dynamic> matchState) {
    if (allWidgetsList.indexOf(first) < allWidgetsList.indexOf(second)) {
      return true;
    }
    return false;
  }
}
