import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/app_runner.dart';

import 'app_runner_test.mocks.dart';
import 'test_constants.dart';

abstract class RunAppFunction {
  void call(Widget widget);
}

abstract class EnsureInitializedFunction {
  WidgetsBinding call();
}

@GenerateMocks([RunAppFunction, EnsureInitializedFunction])
main() {
  test("""
        $given working with AppRunner class
        $wheN Calling run()
        $then EnsureInitialized should be called
        $then runApp should be called
""", () {
    TestWidgetsFlutterBinding.ensureInitialized();
    Widget widget = const Text("text");
    final runAppCall = MockRunAppFunction();
    final ensureInitializedCall = MockEnsureInitializedFunction();
    when(ensureInitializedCall()).thenReturn(WidgetsBinding.instance);
    AppRunner appRunner = AppRunner(widget, runAppCall, ensureInitializedCall);
    appRunner.run();
    verify(ensureInitializedCall()).called(1);
    verify(runAppCall(widget)).called(1);
  });
}
