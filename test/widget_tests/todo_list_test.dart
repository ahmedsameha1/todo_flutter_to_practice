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
    for (int i = 0; i < todos.length; i++) {
      final todo = todos[i];
      final finder = find.byType(Dismissible).at(i);
      expect(finder, findsOneWidget);
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
    const lengthOfList = 300;
    const double delta = lengthOfList / 6;
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
    Dismissible? previousDismissible;
    for (int j = 0; j < todos.length; j++) {
      final todo = todos[j];
      final finder = find.byKey(Key(todo.id.value));
      await widgetTester.scrollUntilVisible(finder, delta);
      final dismissible = widgetTester.widget<Dismissible>(finder);
      final checkboxlisttile = dismissible.child as CheckboxListTile;
      expect((checkboxlisttile.title as Text).data, todo.title);
      expect((checkboxlisttile.subtitle as Text).data, todo.description);
      expect(checkboxlisttile.value, todo.done);
      final dismissibleWidgetList = widgetTester
          .widgetList<Dismissible>(find.byType(Dismissible))
          .toList();
      if (j > 0) {
        expect(dismissibleWidgetList.indexOf(dismissible),
          equals(dismissibleWidgetList.indexOf(previousDismissible!) + 1));
      }
      previousDismissible = dismissible;
    }
  });
  testWidgets("Testing TodoList widget deleting a todo by swiping",
      (widgetTester) async {
    final id1 = TodoIdString(const Uuid().v4());
    final id2 = TodoIdString(const Uuid().v4());
    final id3 = TodoIdString(const Uuid().v4());
    Todo todo1 = Todo(
        id: id1, title: "title1", description: "description1", done: false);
    Todo todo2 =
        Todo(id: id2, title: "title2", description: "description2", done: true);
    Todo todo3 =
        Todo(id: id3, title: "title3", description: "description3", done: true);
    final todos = [todo1, todo2, todo3];
    TodosNotifier todosNotifier = TodosNotifier(todos);
    var skeleton = createWidgetInASkeleton(const TodoList());
    var skeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: skeleton);
    await widgetTester.pumpWidget(skeletonInProviderScope);
    final dismissibleFinder = find.byType(Dismissible).at(1);
    await widgetTester.drag(dismissibleFinder, const Offset(500.0, 0.0));
    await widgetTester.pump();
    final containerFinder = find.byType(Container);
    expect(widgetTester.widget<Container>(containerFinder).color, Colors.red);
    await widgetTester.pumpAndSettle();
    expect(containerFinder, findsNothing);
    expect(find.text(todo2.title), findsNothing);
    expect(find.text(todo2.description), findsNothing);
    expect(find.byType(Dismissible), findsNWidgets(2));
    expect(find.byType(CheckboxListTile), findsNWidgets(2));
    var dismissible =
        widgetTester.widget<Dismissible>(find.byType(Dismissible).at(0));
    var checkboxlisttile = dismissible.child as CheckboxListTile;
    expect((checkboxlisttile.title as Text).data, todo1.title);
    expect((checkboxlisttile.subtitle as Text).data, todo1.description);
    expect(checkboxlisttile.value, todo1.done);
    dismissible =
        widgetTester.widget<Dismissible>(find.byType(Dismissible).at(1));
    checkboxlisttile = dismissible.child as CheckboxListTile;
    expect((checkboxlisttile.title as Text).data, todo3.title);
    expect((checkboxlisttile.subtitle as Text).data, todo3.description);
    expect(checkboxlisttile.value, todo3.done);
  });
}
