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
    final id1 = TodoIdString(const Uuid().v4());
    final id2 = TodoIdString(const Uuid().v4());
    Todo todo1 = Todo(
        id: id1, title: "title1", description: "description1", done: false);
    Todo todo2 =
        Todo(id: id2, title: "title2", description: "description2", done: true);
    final todos = [todo1, todo2];
    TodosNotifier todosNotifier = TodosNotifier(todos);
    var skeleton = createWidgetInASkeleton(const TodoList());
    var skeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: skeleton);
    await widgetTester.pumpWidget(skeletonInProviderScope);
    expect(find.byType(TodoList), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    for (final todo in todos) {
      final dismissible =
          widgetTester.widget<Dismissible>(find.byKey(Key(todo.id.value)));
      final checkboxlisttile = dismissible.child as CheckboxListTile;
      expect((checkboxlisttile.title as Text).data, todo.title);
      expect((checkboxlisttile.subtitle as Text).data, todo.description);
      expect(checkboxlisttile.value, todo.done);
    }
  });
  testWidgets("Testing TodoList widget when long list of Todos",
      (widgetTester) async {
    const lengthOfList = 100;
    const double delta = lengthOfList / 2;
    const uuid = Uuid();
    var ids = <TodoIdString>[];
    var todos = <Todo>[];
    var done = false;
    for (int i = 0; i < lengthOfList; i++) {
      done = i % 4 == 0 ? true : false;
      ids.add(TodoIdString(uuid.v4()));
      todos.add(Todo(
          id: ids[i],
          title: "title$i",
          description: "description$i",
          done: done));
    }
    TodosNotifier todosNotifier = TodosNotifier(todos);
    var skeleton = createWidgetInASkeleton(const TodoList());
    var skeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: skeleton);
    await widgetTester.pumpWidget(skeletonInProviderScope);
    expect(find.byType(TodoList), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    for (final todo in todos) {
      final finder = find.byKey(Key(todo.id.value));
      await widgetTester.scrollUntilVisible(finder, delta);
      final dismissible = widgetTester.widget<Dismissible>(finder);
      final checkboxlisttile = dismissible.child as CheckboxListTile;
      expect((checkboxlisttile.title as Text).data, todo.title);
      expect((checkboxlisttile.subtitle as Text).data, todo.description);
      expect(checkboxlisttile.value, todo.done);
    }
  });
}
