import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/app_runner.dart';

import 'app_runner_test.mocks.dart';
import 'state/test_constants.dart';

abstract class RunAppFunction {
  void call(Widget widget);
}

@GenerateMocks([RunAppFunction])
main() {
  test("""
        $given working with AppRunner class
        $wheN Calling run()
        $then runApp should be called
""", () {
    Widget widget = const Text("text");
    final runAppCall = MockRunAppFunction();
    AppRunner appRunner = AppRunner(widget, runAppCall);
    appRunner.run();
    verify(runAppCall(widget)).called(1);
  });
}
