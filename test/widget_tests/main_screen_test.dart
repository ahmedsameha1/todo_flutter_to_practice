import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/domain_model/auth_state.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/application_login_state.dart';
import 'package:todo_flutter_to_practice/state/auth_state_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/email.dart';
import 'package:todo_flutter_to_practice/widgets/main_screen.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

import '../state/auth_state_notifier_test.mocks.dart';
import 'common_finders.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  late AuthStateNotifier authStateNotifier;
  late StreamController<User?> streamController;
  late FirebaseAuth firebaseAuth;
  setUp(() {
    streamController = StreamController();
    firebaseAuth = MockFirebaseAuth();
    when(firebaseAuth.userChanges()).thenAnswer((_) => streamController.stream);
  });
  testWidgets("loggedOut state case", (WidgetTester tester) async {
    authStateNotifier = AuthStateNotifier(firebaseAuth,
        AuthState(applicationLoginState: ApplicationLoginState.loggedOut));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: MaterialApp(home: MainScreen())));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, TextButton);
    expect(find.descendant(of: scaffoldFinder, matching: textButtonFinder),
        findsOneWidget);
    TextButton textButton = tester.widget(textButtonFinder);
    expect((textButton.child as Text).data, MainScreen.signInUpString);
    expect(textButton.onPressed, authStateNotifier.startLoginFlow);
  });

  testWidgets("emailAddress state case", (WidgetTester tester) async {
    authStateNotifier = AuthStateNotifier(firebaseAuth,
        AuthState(applicationLoginState: ApplicationLoginState.emailAddress));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: MaterialApp(home: MainScreen())));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, Email);
    final emailFinder = find.byType(Email);
    expect(find.descendant(of: scaffoldFinder, matching: emailFinder),
        findsOneWidget);
    Email emailWidget = tester.widget(emailFinder);
    expect(emailWidget.nextAction, authStateNotifier.verifyEmail);
    expect(emailWidget.cancelAction, authStateNotifier.toLoggedOut);
  });
}
