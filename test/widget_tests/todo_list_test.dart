import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/database/this_app_drift_database.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/todo_list.dart';
import 'package:uuid/uuid.dart';

import 'common_finders.dart';
import 'skeleton_for_widget_testing.dart';

main() {
  final createdAt = DateTime.now().toUtc();
  testWidgets("Testing TodoList widget", (widgetTester) async {
    final id1 = const Uuid().v4();
    final id2 = const Uuid().v4();
    Todo todo1 = Todo(
        id: id1, title: "title1", description: "description1", done: false, createdAt: createdAt);
    Todo todo2 =
        Todo(id: id2, title: "title2", description: "description2", done: true, createdAt: createdAt);
    final todos = [todo1, todo2];
    TodosNotifier todosNotifier = TodosNotifier(todos);
    var skeleton = createWidgetInASkeleton(const TodoList());
    var skeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: skeleton);
    await widgetTester.pumpWidget(skeletonInProviderScope);
    expect(find.byType(TodoList), findsOneWidget);
    expect(listViewFinder, findsOneWidget);
    for (int i = 0; i < todos.length; i++) {
      final todo = todos[i];
      final finder = dismissibleFinder.at(i);
      expect(finder, findsOneWidget);
      final dismissible =
          widgetTester.widget<Dismissible>(find.byKey(Key(todo.id)));
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
    var ids = <String>[];
    var todos = <Todo>[];
    var done = false;
    for (int i = 0; i < lengthOfList; i++) {
      done = i % 4 == 0 ? true : false;
      ids.add(uuid.v4());
      todos.add(Todo(
          id: ids[i],
          title: "title$i",
          description: "description$i",
          done: done,
          createdAt: createdAt));
    }
    TodosNotifier todosNotifier = TodosNotifier(todos);
    var skeleton = createWidgetInASkeleton(const TodoList());
    var skeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: skeleton);
    await widgetTester.pumpWidget(skeletonInProviderScope);
    expect(find.byType(TodoList), findsOneWidget);
    expect(listViewFinder, findsOneWidget);
    Dismissible? previousDismissible;
    for (int j = 0; j < todos.length; j++) {
      final todo = todos[j];
      final finder = find.byKey(Key(todo.id));
      await widgetTester.scrollUntilVisible(finder, delta);
      final dismissible = widgetTester.widget<Dismissible>(finder);
      final checkboxlisttile = dismissible.child as CheckboxListTile;
      expect((checkboxlisttile.title as Text).data, todo.title);
      expect((checkboxlisttile.subtitle as Text).data, todo.description);
      expect(checkboxlisttile.value, todo.done);
      final dismissibleWidgetList =
          widgetTester.widgetList<Dismissible>(dismissibleFinder).toList();
      if (j > 0) {
        expect(dismissibleWidgetList.indexOf(dismissible),
            equals(dismissibleWidgetList.indexOf(previousDismissible!) + 1));
      }
      previousDismissible = dismissible;
    }
  });
  testWidgets("Testing TodoList widget deleting a todo by swiping",
      (widgetTester) async {
    final id1 = const Uuid().v4();
    final id2 = const Uuid().v4();
    final id3 = const Uuid().v4();
    Todo todo1 = Todo(
        id: id1, title: "title1", description: "description1", done: false, createdAt: createdAt);
    Todo todo2 =
        Todo(id: id2, title: "title2", description: "description2", done: true, createdAt: createdAt);
    Todo todo3 =
        Todo(id: id3, title: "title3", description: "description3", done: true, createdAt: createdAt);
    final todos = [todo1, todo2, todo3];
    TodosNotifier todosNotifier = TodosNotifier(todos);
    var skeleton = createWidgetInASkeleton(const TodoList());
    var skeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: skeleton);
    await widgetTester.pumpWidget(skeletonInProviderScope);
    await widgetTester.drag(dismissibleFinder.at(1), const Offset(500.0, 0.0));
    await widgetTester.pump();
    final containerFinder = find.byType(Container);
    expect(widgetTester.widget<Container>(containerFinder).color, Colors.red);
    await widgetTester.pumpAndSettle();
    expect(containerFinder, findsNothing);
    expect(find.text(todo2.title), findsNothing);
    expect(find.text(todo2.description), findsNothing);
    expect(dismissibleFinder, findsNWidgets(2));
    expect(checkboxListTileFinder, findsNWidgets(2));
    var dismissible = widgetTester.widget<Dismissible>(dismissibleFinder.at(0));
    var checkboxlisttile = dismissible.child as CheckboxListTile;
    expect((checkboxlisttile.title as Text).data, todo1.title);
    expect((checkboxlisttile.subtitle as Text).data, todo1.description);
    expect(checkboxlisttile.value, todo1.done);
    dismissible = widgetTester.widget<Dismissible>(dismissibleFinder.at(1));
    checkboxlisttile = dismissible.child as CheckboxListTile;
    expect((checkboxlisttile.title as Text).data, todo3.title);
    expect((checkboxlisttile.subtitle as Text).data, todo3.description);
    expect(checkboxlisttile.value, todo3.done);
  });
  testWidgets("Testing the done checkbox", (WidgetTester tester) async {
    final id1 = const Uuid().v4();
    final id2 = const Uuid().v4();
    final id3 = const Uuid().v4();
    Todo todo1 = Todo(
        id: id1, title: "title1", description: "description1", done: false, createdAt: createdAt);
    Todo todo2 =
        Todo(id: id2, title: "title2", description: "description2", done: true, createdAt: createdAt);
    Todo todo3 =
        Todo(id: id3, title: "title3", description: "description3", done: true, createdAt: createdAt);
    final todos = [todo1, todo2, todo3];
    TodosNotifier todosNotifier = TodosNotifier(todos);
    var skeleton = createWidgetInASkeleton(const TodoList());
    var skeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: skeleton);
    await tester.pumpWidget(skeletonInProviderScope);
    await tester.tap(checkboxListTileFinder.at(0));
    await tester.pumpAndSettle();
    expect(todosNotifier.state[0].done, true);
    expect(tester.widget<CheckboxListTile>(checkboxListTileFinder.at(0)).value,
        true);
  });
}
