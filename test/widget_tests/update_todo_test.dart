import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/update_todo.dart';
import 'package:uuid/uuid.dart';

import 'my_matchers.dart';
import 'skeleton_for_widget_testing.dart';

void main() {
  final id1 = TodoIdString(const Uuid().v4());
  final id2 = TodoIdString(const Uuid().v4());
  final id3 = TodoIdString(const Uuid().v4());
  final todo1 =
      Todo(id: id1, title: "title1", description: "description1", done: false);
  final todo2 =
      Todo(id: id2, title: "title2", description: "description2", done: false);
  final todo3 =
      Todo(id: id3, title: "title3", description: "description3", done: false);
  final todos = [todo1, todo2, todo3];
  TodosNotifier todosNotifier = TodosNotifier(todos);
  ProviderScope widgetInSkeletonInProviderScope;
  final widgetInSkeleton = createWidgetInASkeleton(UpdateTodo(id2));
  widgetInSkeletonInProviderScope = ProviderScope(
      overrides: [todosProvider.overrideWithValue(todosNotifier)],
      child: widgetInSkeleton);
  setUp(() {
    todosNotifier = TodosNotifier(todos);
    widgetInSkeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: widgetInSkeleton);
  });
  testWidgets("Test the precsense of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeletonInProviderScope);
    expect(find.byType(UpdateTodo), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    Finder titleTextFormFieldFinder = find.byType(TextFormField).at(0);
    expect(titleTextFormFieldFinder, findsOneWidget);
    final TextField titleTextField =
        tester.widget(find.byType(TextField).at(0));
    expect((titleTextField.decoration!.label as Text).data,
        UpdateTodo.titleString);
    expect(
        (tester.widget(titleTextFormFieldFinder) as TextFormField).initialValue,
        todo2.title);
    expect(titleTextField.keyboardType, TextInputType.text);
    Finder descriptionTextFormFieldFinder = find.byType(TextFormField).at(1);
    expect(descriptionTextFormFieldFinder, findsOneWidget);
    final TextField descriptionTextField =
        tester.widget(find.byType(TextField).at(1));
    expect((descriptionTextField.decoration!.label as Text).data,
        UpdateTodo.descriptionString);
    expect(
        (tester.widget(descriptionTextFormFieldFinder) as TextFormField)
            .initialValue,
        todo2.description);
    expect(descriptionTextField.keyboardType, TextInputType.multiline);
    expect(descriptionTextField.maxLines, 5);
    Checkbox doneCheckbox = tester.widget(find.byType(Checkbox));
    expect(
        tester.widgetList(find.bySubtype()).toList(),
        FirstPrecedesSecond(
            doneCheckbox, tester.widget(titleTextFormFieldFinder)));
    expect(doneCheckbox.value, todo2.done);
    TextButton updateTextButton = tester.widget(find.byType(TextButton));
    expect(
        tester.widgetList(find.bySubtype()).toList(),
        FirstPrecedesSecond(
            tester.widget(descriptionTextFormFieldFinder), updateTextButton));
    expect((updateTextButton.child as Text).data, UpdateTodo.updateString);
  });
}
