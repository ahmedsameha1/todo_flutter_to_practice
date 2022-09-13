import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/widgets/register.dart';
import 'package:flutter/material.dart';

import 'skeleton_for_widget_testing.dart';

void main() {
  const email = "test@test.com";
  late Widget widgetInSkeleton;
  setUp(() {
    widgetInSkeleton = createWidgetInASkeleton(Register(email));
  });
  testWidgets("Test the precence of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeleton);
    expect(find.byType(Register), findsOneWidget);
    expect(
        find.descendant(of: find.byType(Register), matching: find.byType(Form)),
        findsOneWidget);
    final columnFinder = find.byType(Column);
    expect(find.descendant(of: find.byType(Form), matching: columnFinder),
        findsOneWidget);
    final emailTextFinder = find.byType(Text).at(0);
    expect(find.descendant(of: columnFinder, matching: emailTextFinder),
        findsOneWidget);
    expect((tester.widget(emailTextFinder) as Text).data, email);
    final displayNameTextFormFieldFinder = find.byType(TextFormField).at(0);
    expect(
        find.descendant(
            of: columnFinder, matching: displayNameTextFormFieldFinder),
        findsOneWidget);
    final TextField nameTextField = tester.widget(find.descendant(
        of: displayNameTextFormFieldFinder,
        matching: find.byType(TextField).at(0))) as TextField;
    expect((nameTextField.decoration!.label as Text).data, Register.nameString);
    expect(nameTextField.keyboardType, TextInputType.text);
    final passwordTextFormFieldFinder = find.byType(TextFormField).at(1);
    expect(
        find.descendant(
            of: columnFinder, matching: passwordTextFormFieldFinder),
        findsOneWidget);
    final TextField passwordTextField = tester.widget(find.descendant(
        of: passwordTextFormFieldFinder,
        matching: find.byType(TextField).at(1))) as TextField;
    expect((passwordTextField.decoration!.label as Text).data,
        Register.passwordString);
    expect(passwordTextField.keyboardType, TextInputType.text);
    expect(passwordTextField.obscureText, true);
    expect(passwordTextField.autocorrect, false);
    expect(passwordTextField.enableSuggestions, false);
    final confirmPasswordTextFormFieldFinder = find.byType(TextFormField).at(2);
    expect(
        find.descendant(
            of: columnFinder, matching: confirmPasswordTextFormFieldFinder),
        findsOneWidget);
    final confirmPasswordTextField = tester.widget(find.descendant(
        of: confirmPasswordTextFormFieldFinder,
        matching: find.byType(TextField).at(2))) as TextField;
    expect((confirmPasswordTextField.decoration!.label as Text).data,
        Register.confirmPasswordString);
    expect(confirmPasswordTextField.keyboardType, TextInputType.text);
    expect(confirmPasswordTextField.obscureText, true);
    expect(confirmPasswordTextField.autocorrect, false);
    expect(confirmPasswordTextField.enableSuggestions, false);
    final rowFinder = find.byType(Row);
    expect(
        find.descendant(of: columnFinder, matching: rowFinder), findsOneWidget);
    final nextTextButtonFinder =
        find.descendant(of: rowFinder, matching: find.byType(TextButton).at(0));
    expect(nextTextButtonFinder, findsOneWidget);
    expect(
        ((tester.widget(nextTextButtonFinder) as TextButton).child as Text)
            .data,
        Register.nextString);
    final cancelTextButtonFinder =
        find.descendant(of: rowFinder, matching: find.byType(TextButton).at(1));
    expect(cancelTextButtonFinder, findsOneWidget);
    expect(
        ((tester.widget(cancelTextButtonFinder) as TextButton).child as Text)
            .data,
        Register.cancelString);
  });
  group("Form validation", () {
    testWidgets("name textfield validation", (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeleton);
      final nameTextFieldFinder = find.byType(TextField).at(0);
      await tester.enterText(nameTextFieldFinder, "f");
      final nextTextButtonFinder = find.byType(TextButton).at(0);
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      final nameValidationErrorTextFinder = find.descendant(
          of: find.byType(TextFormField).at(0),
          matching: find.text(Register.nameValidationErrorString));
      expect(nameValidationErrorTextFinder, findsNothing);
      await tester.enterText(nameTextFieldFinder, "");
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      expect(nameValidationErrorTextFinder, findsOneWidget);
      await tester.enterText(nameTextFieldFinder, " ");
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      expect(nameValidationErrorTextFinder, findsOneWidget);
    });

    testWidgets("password textfield validation", (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeleton);
      final passwordTextFieldFinder = find.byType(TextField).at(1);
      await tester.enterText(passwordTextFieldFinder, "8*prt&3k");
      final nextTextButtonFinder = find.byType(TextButton).at(0);
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      final passwordValidationErrorTextFinder = find.descendant(
          of: find.byType(TextFormField).at(1),
          matching: find.text(Register.passwordValidationErrorString));
      expect(passwordValidationErrorTextFinder, findsNothing);
      await tester.enterText(passwordTextFieldFinder, "");
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      expect(passwordValidationErrorTextFinder, findsOneWidget);
      await tester.enterText(passwordTextFieldFinder, " ");
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      expect(passwordValidationErrorTextFinder, findsOneWidget);
      await tester.enterText(passwordTextFieldFinder, " gfh");
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      expect(passwordValidationErrorTextFinder, findsOneWidget);
    });

    testWidgets("confirm password textfield validation",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeleton);
      final passwordTextFieldFinder = find.byType(TextField).at(1);
      final confirmPasswordTextFieldFinder = find.byType(TextField).at(2);
      await tester.enterText(passwordTextFieldFinder, "8*prt&3k");
      await tester.enterText(confirmPasswordTextFieldFinder, "8*prt&3k");
      final nextTextButtonFinder = find.byType(TextButton).at(0);
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      final confirmPasswordValidationErrorTextFinder = find.descendant(
          of: find.byType(TextFormField).at(2),
          matching: find.text(Register.confirmPasswordValidationErrorString));
      expect(confirmPasswordValidationErrorTextFinder, findsNothing);
      await tester.enterText(passwordTextFieldFinder, "");
      await tester.enterText(confirmPasswordTextFieldFinder, "");
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      expect(confirmPasswordValidationErrorTextFinder, findsNothing);
      await tester.enterText(passwordTextFieldFinder, "hbefr");
      await tester.enterText(confirmPasswordTextFieldFinder, "rhg");
      await tester.tap(nextTextButtonFinder);
      await tester.pumpAndSettle();
      expect(confirmPasswordValidationErrorTextFinder, findsOneWidget);
    });
  });
}
