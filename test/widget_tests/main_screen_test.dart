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
import 'package:todo_flutter_to_practice/widgets/locked.dart';
import 'package:todo_flutter_to_practice/widgets/password.dart';
import 'package:todo_flutter_to_practice/widgets/register.dart';
import 'package:todo_flutter_to_practice/widgets/main_screen.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/widgets/todo_list.dart';

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
    authStateNotifier = AuthStateNotifier(
        firebaseAuth,
        const AuthState(
            applicationLoginState: ApplicationLoginState.loggedOut));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: const MaterialApp(home: MainScreen())));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, TextButton);
    expect(find.descendant(of: scaffoldFinder, matching: textButtonFinder),
        findsOneWidget);
    TextButton textButton = tester.widget(textButtonFinder);
    expect((textButton.child as Text).data, MainScreen.signInUpString);
    expect(textButton.onPressed, authStateNotifier.startLoginFlow);
  });

  testWidgets("emailAddress state case", (WidgetTester tester) async {
    authStateNotifier = AuthStateNotifier(
        firebaseAuth,
        const AuthState(
            applicationLoginState: ApplicationLoginState.emailAddress));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: const MaterialApp(home: MainScreen())));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, Email);
    final emailFinder = find.byType(Email);
    expect(find.descendant(of: scaffoldFinder, matching: emailFinder),
        findsOneWidget);
    Email emailWidget = tester.widget(emailFinder);
    expect(emailWidget.nextAction, authStateNotifier.verifyEmail);
    expect(emailWidget.cancelAction, authStateNotifier.toLoggedOut);
  });

  testWidgets("password state case", (WidgetTester tester) async {
    authStateNotifier = AuthStateNotifier(
        firebaseAuth,
        const AuthState(
            applicationLoginState: ApplicationLoginState.password,
            email: "test@test.com"));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: const MaterialApp(home: MainScreen())));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, Password);
    final passwordFinder = find.byType(Password);
    expect(find.descendant(of: scaffoldFinder, matching: passwordFinder),
        findsOneWidget);
    Password passwordWidget = tester.widget(passwordFinder);
    expect(passwordWidget.nextAction,
        authStateNotifier.signInWithEmailAndPassword);
    expect(passwordWidget.cancelAction, authStateNotifier.toLoggedOut);
  });

  testWidgets("register state case", (WidgetTester tester) async {
    authStateNotifier = AuthStateNotifier(
        firebaseAuth,
        const AuthState(
            applicationLoginState: ApplicationLoginState.register,
            email: "test@test.com"));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: const MaterialApp(home: MainScreen())));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, Register);
    final registerFinder = find.byType(Register);
    expect(find.descendant(of: scaffoldFinder, matching: registerFinder),
        findsOneWidget);
    Register registerWidget = tester.widget(registerFinder);
    expect(registerWidget.nextAction, authStateNotifier.registerAccount);
    expect(registerWidget.cancelAction, authStateNotifier.toLoggedOut);
  });

  testWidgets("locked state case", (WidgetTester tester) async {
    authStateNotifier = AuthStateNotifier(
        firebaseAuth,
        const AuthState(
            applicationLoginState: ApplicationLoginState.locked,
            email: "test@test.com"));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: const MaterialApp(home: MainScreen())));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, Locked);
    final lockedFinder = find.byType(Locked);
    expect(find.descendant(of: scaffoldFinder, matching: lockedFinder),
        findsOneWidget);
    Locked lockedWidget = tester.widget(lockedFinder);
    expect(lockedWidget.refreshAction, authStateNotifier.updateUser);
    expect(lockedWidget.sendVerificationEmailAction,
        authStateNotifier.sendEmailToVerifyEmailAddress);
    expect(lockedWidget.logoutAction, authStateNotifier.signOut);
  });

  testWidgets("loggedIn state case", (WidgetTester tester) async {
    authStateNotifier = AuthStateNotifier(
        firebaseAuth,
        const AuthState(
            applicationLoginState: ApplicationLoginState.loggedIn,
            email: "test@test.com"));
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: const MaterialApp(home: MainScreen())));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, TodoList);
    final todoListFinder = find.byType(TodoList);
    expect(find.descendant(of: scaffoldFinder, matching: todoListFinder),
        findsOneWidget);
  });
}
