import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/domain_model/auth_state.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/application_login_state.dart';
import 'package:todo_flutter_to_practice/state/auth_state_notifier.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/widgets/main_screen.dart';
import 'package:todo_flutter_to_practice/widgets/main_widget.dart';

import 'main_screen_test.mocks.dart';
import 'main_widget_test.mocks.dart';

@GenerateMocks([BuildContext, GoRouterState])
void main() {
  late AuthStateNotifier authStateNotifier;
  late StreamController<User?> streamController;
  late FirebaseAuth firebaseAuth;
  setUp(() {
    streamController = StreamController();
    firebaseAuth = MockFirebaseAuth();
    when(firebaseAuth.userChanges()).thenAnswer((_) => streamController.stream);
  });
  test("rootPathBuilder() returns MainScreen", () {
    expect(
        MainWidget.rootPathBuilder(MockBuildContext(), MockGoRouterState())
            .runtimeType,
        MainScreen);
  });

  testWidgets("Test the precese of the main widgets",
      (WidgetTester tester) async {
    authStateNotifier = AuthStateNotifier(
        firebaseAuth,
        const AuthState(
            applicationLoginState: ApplicationLoginState.loggedOut));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: const MainWidget()));
    final materialAppFinder = find.byType(MaterialApp);
    expect(materialAppFinder, findsOneWidget);
    expect(
        find.descendant(
            of: materialAppFinder, matching: find.byType(MainScreen)),
        findsOneWidget);
    final MaterialApp materialAppWidget = tester.widget(materialAppFinder);
    expect(materialAppWidget.title, "Todos List");
  });
}
