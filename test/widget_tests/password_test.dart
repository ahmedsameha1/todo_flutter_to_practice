import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/widgets/password.dart';
import 'package:todo_flutter_to_practice/widgets/register.dart';

import 'common_finders.dart';
import 'skeleton_for_widget_testing.dart';

void main() {
  const email = "test@test.com";
  late Widget widgetInSkeleton;
  setUp(() {
    widgetInSkeleton = createWidgetInASkeleton(Password(email));
  });
  testWidgets("Test the precense of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeleton);
    final passwordFinder = find.byType(Password);
    expect(passwordFinder, findsOneWidget);
    expect(find.descendant(of: passwordFinder, matching: formFinder),
        findsOneWidget);
    expect(find.descendant(of: formFinder, matching: columnFinder),
        findsOneWidget);
    expect(find.descendant(of: columnFinder, matching: find.text(email)),
        findsOneWidget);
    expect(find.descendant(of: columnFinder, matching: textFormFieldFinder),
        findsOneWidget);
    final TextField passwordTextField = tester.widget(
        find.descendant(of: textFormFieldFinder, matching: textFieldFinder));
    expect((passwordTextField.decoration!.label as Text).data,
        Register.passwordString);
    expect(passwordTextField.keyboardType, TextInputType.text);
    expect(passwordTextField.inputFormatters!.elementAt(0),
        Register.noWhiteSpaceInputFormatter);
    expect(passwordTextField.obscureText, true);
    expect(passwordTextField.autocorrect, false);
    expect(passwordTextField.enableSuggestions, false);
    expect(
        find.descendant(of: columnFinder, matching: rowFinder), findsOneWidget);
    final nextTextButtonFinder =
        find.descendant(of: rowFinder, matching: textButtonFinder.at(0));
    expect(nextTextButtonFinder, findsOneWidget);
    expect(
        ((tester.widget(nextTextButtonFinder) as TextButton).child as Text)
            .data,
        Register.nextString);
    final cancelTextButtonFinder =
        find.descendant(of: rowFinder, matching: textButtonFinder.at(1));
    expect(cancelTextButtonFinder, findsOneWidget);
    expect(
        ((tester.widget(cancelTextButtonFinder) as TextButton).child as Text)
            .data,
        Register.cancelString);
  });
  testWidgets("Test password textfield validation",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeleton);
    final passwordTextFieldFinder = textFieldFinder.at(0);
    await tester.enterText(passwordTextFieldFinder, "8*prt&3k");
    final nextTextButtonFinder = textButtonFinder.at(0);
    await tester.tap(nextTextButtonFinder);
    await tester.pumpAndSettle();
    final passwordValidationErrorTextFinder = find.descendant(
        of: textFormFieldFinder.at(0),
        matching: find.text(Register.passwordValidationErrorString));
    expect(passwordValidationErrorTextFinder, findsNothing);
    await tester.enterText(passwordTextFieldFinder, "");
    await tester.tap(nextTextButtonFinder);
    await tester.pumpAndSettle();
    expect(passwordValidationErrorTextFinder, findsOneWidget);
    await tester.enterText(passwordTextFieldFinder, " ");
    await tester.tap(nextTextButtonFinder);
    await tester.pumpAndSettle();
    final TextField passwordTextField = tester.widget(passwordTextFieldFinder);
    expect(passwordTextField.controller!.text, "");
    expect(passwordValidationErrorTextFinder, findsOneWidget);
    await tester.enterText(passwordTextFieldFinder, " gfh");
    await tester.tap(nextTextButtonFinder);
    await tester.pumpAndSettle();
    expect(passwordTextField.controller!.text, "gfh");
    expect(passwordValidationErrorTextFinder, findsOneWidget);
  });
}
