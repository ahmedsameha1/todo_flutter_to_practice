import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/todo_list.dart';
import 'package:uuid/uuid.dart';

import 'skeleton_for_widget_testing.dart';

main() {
  testWidgets("Testing TodoList widget", (widgetTester) async {
    Todo todo1 = Todo(
        id: TodoIdString(const Uuid().v4()),
        title: "title1",
        description: "description1",
        done: false);
    Todo todo2 = Todo(
        id: TodoIdString(const Uuid().v4()),
        title: "title2",
        description: "description2",
        done: true);
    final todos = [todo1, todo2];
    TodosNotifier todosNotifier = TodosNotifier(todos);
    var skeleton = createWidgetInASkeleton(const TodoList());
    var skeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: skeleton);
    await widgetTester.pumpWidget(skeletonInProviderScope);
    expect(find.byType(TodoList), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNWidgets(2));
    Iterable<Checkbox> checkboxes =
        widgetTester.widgetList<Checkbox>(find.byType(Checkbox));
    expect(checkboxes.length, todos.length);
    for (int i = 0; i < todos.length; i++) {
      expect(find.text(todos[i].title), findsOneWidget);
      expect(find.text(todos[i].description), findsOneWidget);
      expect(checkboxes.elementAt(i).value, todos[i].done);
    }
  });
}
