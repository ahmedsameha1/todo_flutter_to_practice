import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/widgets/todo_form.dart';

import 'skeleton_for_widget_testing.dart';

main() {
  final widgetInSkeleton = createWidgetInASkeleton(const TodoForm());
  testWidgets("Test the presense of the main widgets", (tester) async => {});
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
