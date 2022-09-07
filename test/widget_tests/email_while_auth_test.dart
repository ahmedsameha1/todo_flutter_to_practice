import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/widgets/email_while_auth.dart';

import 'skeleton_for_widget_testing.dart';

void main() {
  final widgetInSkeleton = createWidgetInASkeleton(EmailWhileAuth());
  testWidgets("Test the precense of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeleton);
    expect(find.byType(EmailWhileAuth), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    final TextField emailTextField =
        tester.widget(find.byType(TextField).at(0));
    expect(
        (emailTextField.decoration!.label as Text).data, EmailWhileAuth.EMAIL);
    expect(emailTextField.keyboardType, TextInputType.emailAddress);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(TextButton), findsNWidgets(2));
    final TextButton nextButton = tester.widget(find.byType(TextButton).at(0));
    expect((nextButton.child as Text).data, EmailWhileAuth.NEXT);
    final TextButton cancelButton =
        tester.widget(find.byType(TextButton).at(1));
    expect((cancelButton.child as Text).data, EmailWhileAuth.CANCEL);
  });

  testWidgets("Test the TextFormField validation", (WidgetTester tester) async {
    // email should be valid using regex
    await tester.pumpWidget(widgetInSkeleton);
    final emailTextFormFieldFinder = find.byType(TextFormField);
    await tester.enterText(emailTextFormFieldFinder, "test@test.com");
    await tester.tap(find.byType(TextButton).at(0));
    await tester.pumpAndSettle();
    expect(find.text(EmailWhileAuth.INVALID_EMAIL), findsNothing);
    await tester.enterText(emailTextFormFieldFinder, "");
    await tester.tap(find.byType(TextButton).at(0));
    await tester.pumpAndSettle();
    expect(find.text(EmailWhileAuth.INVALID_EMAIL), findsOneWidget);
    await tester.enterText(emailTextFormFieldFinder, " ");
    await tester.tap(find.byType(TextButton).at(0));
    await tester.pumpAndSettle();
    expect(find.text(EmailWhileAuth.INVALID_EMAIL), findsOneWidget);
    await tester.enterText(emailTextFormFieldFinder, "test");
    await tester.tap(find.byType(TextButton).at(0));
    await tester.pumpAndSettle();
    expect(find.text(EmailWhileAuth.INVALID_EMAIL), findsOneWidget);
  });

  testWidgets("Test that next Button call the next action function",
      (WidgetTester tester) async {});

  testWidgets("Test that cancel Button call the cancel action function",
      (WidgetTester tester) async {});
}
