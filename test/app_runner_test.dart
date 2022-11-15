import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

abstract class FirebaseInitializeAppFunction {
  Future<FirebaseApp> call({String? name, FirebaseOptions? options});
}

@GenerateMocks([
  RunAppFunction,
  EnsureInitializedFunction,
  FirebaseInitializeAppFunction,
  FirebaseOptions,
  FirebaseApp
])
main() {
  test("""
        $given working with AppRunner class
        $wheN Calling run()
        $then EnsureInitialized, intializeApp and runApp should be called
""", () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    Widget widget = const ProviderScope(child: Text("text"));
    final runAppCall = MockRunAppFunction();
    final ensureInitializedCall = MockEnsureInitializedFunction();
    final initializeAppCall = MockFirebaseInitializeAppFunction();
    final firebaseOptions = MockFirebaseOptions();
    final FirebaseApp firebaseApp = MockFirebaseApp();
    when(ensureInitializedCall()).thenReturn(WidgetsBinding.instance);
    when(initializeAppCall(options: firebaseOptions))
        .thenAnswer((realInvocation) async => firebaseApp);
    AppRunner appRunner = AppRunner(widget, runAppCall, ensureInitializedCall,
        initializeAppCall, firebaseOptions);
    await appRunner.run();
    verify(ensureInitializedCall());
    verify(initializeAppCall(options: firebaseOptions));
    verify(runAppCall(widget));
  });
  test("widget isn't a ProviderScope", () {
    TestWidgetsFlutterBinding.ensureInitialized();
    Widget widget = const Text("text");
    final runAppCall = MockRunAppFunction();
    final ensureInitializedCall = MockEnsureInitializedFunction();
    final initializeAppCall = MockFirebaseInitializeAppFunction();
    final firebaseOptions = MockFirebaseOptions();
    final FirebaseApp firebaseApp = MockFirebaseApp();
    when(ensureInitializedCall()).thenReturn(WidgetsBinding.instance);
    when(initializeAppCall(options: firebaseOptions))
        .thenAnswer((realInvocation) async => firebaseApp);
    expect(() {
      AppRunner(widget, runAppCall, ensureInitializedCall,
          initializeAppCall, firebaseOptions);
    }, throwsA(predicate((e) => e is ArgumentError)));
  });
}
