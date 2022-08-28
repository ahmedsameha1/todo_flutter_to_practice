import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/widgets/todo_form.dart';

import 'skeleton_for_widget_testing.dart';

main() {
  String title = "title";
  final widgetInSkeleton = createWidgetInASkeleton(TodoForm(title));
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
    expect(titleTextFormField.initialValue, title);
    expect(titleTextField.keyboardType, TextInputType.text);
    final TextFormField descriptionTextFormField =
        tester.widget(find.byType(TextFormField).at(1));
    final TextField descriptionTextField =
        tester.widget(find.byType(TextField).at(1));
    expect((descriptionTextField.decoration!.label as Text).data,
        TodoForm.descriptionString);
    expect(descriptionTextField.keyboardType, TextInputType.multiline);
    expect(descriptionTextField.maxLines, 5);
  });
  group("Test form validation", () {
    testWidgets(
        "Testing the validation of the title text field", (tester) async => {});
    testWidgets("Testing the validation of the description text field",
        (tester) async => {});
    testWidgets("Testing the validation when no text in the two text fields",
        (tester) async => {});
    testWidgets(
        "The checkbox changes its value when clicked", (tester) async => {});
    testWidgets(
        "The submission function get called when the text button is being clicked",
        (tester) async => {});
  });
}
