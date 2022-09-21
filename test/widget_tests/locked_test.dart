import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/widgets/locked.dart';

import 'common_finders.dart';
import 'skeleton_for_widget_testing.dart';

void main() {
  testWidgets("Test the precense of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetInASkeleton(Locked()));
    final lockedFinder = find.byType(Locked);
    expect(lockedFinder, findsOneWidget);
    expect(find.descendant(of: lockedFinder, matching: columnFinder),
        findsOneWidget);
    expect(
        find.descendant(
            of: columnFinder, matching: find.text(Locked.verifyEmailAddress)),
        findsOneWidget);
    final refreshAccountTextButtonFinder = textButtonFinder.at(0);
    expect(
        find.descendant(
            of: columnFinder, matching: refreshAccountTextButtonFinder),
        findsOneWidget);
    expect(
        ((tester.widget(refreshAccountTextButtonFinder) as TextButton).child
                as Text)
            .data,
        Locked.refreshString);
    final sendVerificationEmailTextButtonFinder = textButtonFinder.at(1);
    expect(
        find.descendant(
            of: columnFinder, matching: sendVerificationEmailTextButtonFinder),
        findsOneWidget);
    expect(
        ((tester.widget(sendVerificationEmailTextButtonFinder) as TextButton)
                .child as Text)
            .data,
        Locked.sendVerificationEmail);
    final logoutTextButtonFinder = textButtonFinder.at(2);
    expect(find.descendant(of: columnFinder, matching: logoutTextButtonFinder),
        findsOneWidget);
    expect(
        ((tester.widget(logoutTextButtonFinder) as TextButton).child as Text)
            .data,
        Locked.logout);
  });
}
