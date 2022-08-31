import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/widgets/todo_form.dart';

import 'my_matchers.dart';
import 'skeleton_for_widget_testing.dart';

main() {
  String title = "title";
  String description = "description";
  bool done = true;
  String buttonText = "Do";
  final widgetInSkeleton =
      createWidgetInASkeleton(TodoForm(title, description, done, buttonText));
  testWidgets("Test the presense of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeleton);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    final TextFormField titleTextFormField =
        tester.widget(find.byType(TextFormField).at(0));
    final TextField titleTextField =
        tester.widget(find.byType(TextField).at(0));
    expect(
        (titleTextField.decoration!.label as Text).data, TodoForm.labelString);
    expect(titleTextField.keyboardType, TextInputType.text);
    expect(titleTextFormField.initialValue, title);
    final TextFormField descriptionTextFormField =
        tester.widget(find.byType(TextFormField).at(1));
    final TextField descriptionTextField =
        tester.widget(find.byType(TextField).at(1));
    expect((descriptionTextField.decoration!.label as Text).data,
        TodoForm.descriptionString);
    expect(descriptionTextField.keyboardType, TextInputType.multiline);
    expect(descriptionTextField.maxLines, 5);
    expect(descriptionTextFormField.initialValue, description);
    final Checkbox doneCheckbox = tester.widget(find.byType(Checkbox));
    expect(doneCheckbox.value, done);
    final TextButton submissionButton = tester.widget(find.byType(TextButton));
    expect((submissionButton.child as Text).data, buttonText);
    expect(tester.widgetList(find.bySubtype()).toList(),
        FirstPrecedesSecond(doneCheckbox, titleTextFormField));
    expect(tester.widgetList(find.bySubtype()).toList(),
        FirstPrecedesSecond(titleTextFormField, descriptionTextFormField));
    expect(tester.widgetList(find.bySubtype()).toList(),
        FirstPrecedesSecond(descriptionTextFormField, submissionButton));
  });
  group("Test form validation", () {
    testWidgets("Testing the validation of the title text field",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeleton);
      final submissionTextButtonFinder = find.byType(TextButton);
      final titleTextFormFieldFinder = find.byType(TextFormField).at(0);
      await tester.enterText(titleTextFormFieldFinder, " ");
      await tester.tap(submissionTextButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text(TodoForm.titleValidationErrorMessage), findsOneWidget);
      expect(
          tester.widgetList(find.bySubtype()).toList(),
          FirstPrecedesSecond(tester.widget(titleTextFormFieldFinder),
              tester.widget(find.text(TodoForm.titleValidationErrorMessage))));
      await tester.enterText(titleTextFormFieldFinder, " f");
      await tester.tap(submissionTextButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text(TodoForm.titleValidationErrorMessage), findsNothing);
    });
    testWidgets("Testing the validation of the description text field",
        (tester) async {
      await tester.pumpWidget(widgetInSkeleton);
      final submissionTextButtonFinder = find.byType(TextButton);
      final descriptionTextFormFieldFinder = find.byType(TextFormField).at(1);
      await tester.enterText(descriptionTextFormFieldFinder, " ");
      await tester.tap(submissionTextButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text(TodoForm.descriptionValidationErrorMessage),
          findsOneWidget);
      expect(
          tester.widgetList(find.bySubtype()).toList(),
          FirstPrecedesSecond(
              tester.widget(descriptionTextFormFieldFinder),
              tester.widget(
                  find.text(TodoForm.descriptionValidationErrorMessage))));
      await tester.enterText(descriptionTextFormFieldFinder, "h ");
      await tester.tap(submissionTextButtonFinder);
      await tester.pumpAndSettle();
      expect(
          find.text(TodoForm.descriptionValidationErrorMessage), findsNothing);
    });
    testWidgets("Testing the validation when no text in the two text fields",
        (tester) async {
      await tester.pumpWidget(widgetInSkeleton);
      final submissionTextButtonFinder = find.byType(TextButton);
      final titleTextFormFieldFinder = find.byType(TextFormField).at(0);
      final descriptionTextFormFieldFinder = find.byType(TextFormField).at(1);
      await tester.enterText(titleTextFormFieldFinder, " ");
      await tester.enterText(descriptionTextFormFieldFinder, " ");
      await tester.tap(submissionTextButtonFinder);
      await tester.pumpAndSettle();
      expect(
          tester.widgetList(find.bySubtype()).toList(),
          FirstPrecedesSecond(
              tester.widget(find.text(TodoForm.titleValidationErrorMessage)),
              tester.widget(descriptionTextFormFieldFinder)));
      expect(
          tester.widgetList(find.bySubtype()).toList(),
          FirstPrecedesSecond(
              tester.widget(descriptionTextFormFieldFinder),
              tester.widget(
                  find.text(TodoForm.descriptionValidationErrorMessage))));
    });
    testWidgets(
        "The checkbox changes its value when clicked", (tester) async => {});
    testWidgets(
        "The submission function get called when the text button is being clicked",
        (tester) async => {});
  });
}