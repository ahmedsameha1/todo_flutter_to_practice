import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/domain_model/auth_state.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/application_login_state.dart';
import 'package:todo_flutter_to_practice/state/auth_state_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/main_screen.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

import 'common_finders.dart';
import 'main_screen_test.mocks.dart';

@GenerateMocks([AuthStateNotifier])
void main() {
  late AuthStateNotifier authStateNotifier;
  setUp(() {
    authStateNotifier = MockAuthStateNotifier();
  });
  testWidgets("loggedOut state case", (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(overrides: [
      authStateNotifierProvider.overrideWithValue(authStateNotifier)
    ], child: MaterialApp(home: MainScreen())));
    when(authStateNotifier.state).thenReturn(
        AuthState(applicationLoginState: ApplicationLoginState.loggedOut));
    Scaffold scaffold = tester.widget(scaffoldFinder);
    expect(scaffold.body.runtimeType, TextButton);
    expect(find.descendant(of: scaffoldFinder, matching: textButtonFinder),
        findsOneWidget);
    TextButton textButton = tester.widget(textButtonFinder);
    expect((textButton.child as Text).data, MainScreen.signInUpString);
    expect(textButton.onPressed, authStateNotifier.startLoginFlow);
  });
}
