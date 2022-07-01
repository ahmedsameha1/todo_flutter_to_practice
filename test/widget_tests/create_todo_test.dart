import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/create_todo.dart';
import 'package:uuid/uuid.dart';

import 'create_todo_test.mocks.dart';
import 'my_matchers.dart';
import 'skeleton_for_widget_testing.dart';

abstract class GoRouterContextPopFunction {
  void call();
}

@GenerateMocks([GoRouterContextPopFunction])
void main() {
  final goRouterContextPopFunctionCall = MockGoRouterContextPopFunction();
  final id1 = TodoIdString(const Uuid().v4());
  final id2 = TodoIdString(const Uuid().v4());
  Todo todo1 =
      Todo(id: id1, title: "title1", description: "description1", done: false);
  Todo todo2 =
      Todo(id: id2, title: "title2", description: "description2", done: true);
  final todos = [todo1, todo2];
  TodosNotifier todosNotifier = TodosNotifier(todos);
  ProviderScope widgetInSkeletonInProviderScope;
  final widgetInSkeleton =
      createWidgetInASkeleton(CreateTodo(goRouterContextPopFunctionCall));
  widgetInSkeletonInProviderScope = ProviderScope(
      overrides: [todosProvider.overrideWithValue(todosNotifier)],
      child: widgetInSkeleton);
  setUp(() {
    todosNotifier = TodosNotifier(todos);
    widgetInSkeletonInProviderScope = ProviderScope(
        overrides: [todosProvider.overrideWithValue(todosNotifier)],
        child: widgetInSkeleton);
  });
  testWidgets("Test the presence of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeletonInProviderScope);
    expect(find.byType(CreateTodo), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(TextFormField).at(0), findsOneWidget);
    final TextField titleTextField =
        tester.widget(find.byType(TextField).at(0));
    expect((titleTextField.decoration!.label as Text).data,
        CreateTodo.titleString);
    expect(titleTextField.keyboardType, TextInputType.text);
    expect(find.byType(TextFormField).at(1), findsOneWidget);
    final TextField descriptionTextField =
        tester.widget(find.byType(TextField).at(1));
    expect((descriptionTextField.decoration!.label as Text).data,
        CreateTodo.descriptionString);
    expect(descriptionTextField.keyboardType, TextInputType.multiline);
    expect(descriptionTextField.maxLines, 5);
    expect(find.byType(Checkbox), findsOneWidget);
    final TextButton createTodoButton = tester.widget(find.byType(TextButton));
    expect((createTodoButton.child as Text).data, CreateTodo.createString);
  });
  group("Test from validation", () {
    testWidgets("Testing the validation of the title text field",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeletonInProviderScope);
      await tester.enterText(find.byType(TextFormField).at(0), " f");
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.text(CreateTodo.titleValidationErrorMessage), findsNothing);
      await tester.enterText(find.byType(TextFormField).at(0), " ");
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.text(CreateTodo.titleValidationErrorMessage), findsOneWidget);
      expect(
          tester.widgetList(find.bySubtype()).toList(),
          FirstPrecedesSecond(
              tester.widget(find.byType(TextFormField).at(0)),
              tester
                  .widget(find.text(CreateTodo.titleValidationErrorMessage))));
    });
    testWidgets("Testing the validation of the description text field",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeletonInProviderScope);
      await tester.enterText(find.byType(TextFormField).at(1), " ");
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.text(CreateTodo.descriptionValidationErrorMessage),
          findsOneWidget);
      expect(
          tester.widgetList(find.bySubtype()).toList(),
          FirstPrecedesSecond(
              tester.widget(find.byType(TextFormField).at(1)),
              tester.widget(
                  find.text(CreateTodo.descriptionValidationErrorMessage))));
      await tester.enterText(find.byType(TextFormField).at(1), "h ");
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.text(CreateTodo.descriptionValidationErrorMessage),
          findsNothing);
    });
    testWidgets("No text in the two text fields", (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeletonInProviderScope);
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(
          tester.widgetList(find.bySubtype()).toList(),
          FirstPrecedesSecond(
              tester.widget(find.text(CreateTodo.titleValidationErrorMessage)),
              tester.widget(find.byType(TextFormField).at(1))));
      expect(
          tester.widgetList(find.bySubtype()).toList(),
          FirstPrecedesSecond(
              tester.widget(find.byType(TextFormField).at(1)),
              tester.widget(
                  find.text(CreateTodo.descriptionValidationErrorMessage))));
    });
  });
  testWidgets("The checkbox change its value when cliced",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeletonInProviderScope);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect((find.byType(Checkbox).evaluate().first.widget as Checkbox).value,
        true);
    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();
    expect((find.byType(Checkbox).evaluate().first.widget as Checkbox).value,
        false);
  });
  testWidgets("Test saving the created Todo", (WidgetTester tester) async {
    const title = "my title";
    const description = "my description";
    await tester.pumpWidget(widgetInSkeletonInProviderScope);
    await tester.enterText(find.byType(TextFormField).at(0), title);
    await tester.enterText(find.byType(TextFormField).at(1), description);
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(todosNotifier.state.length, 3);
    expect(todosNotifier.state[2].title, title);
    expect(todosNotifier.state[2].description, description);
    expect(todosNotifier.state[2].done, false);
    verify(goRouterContextPopFunctionCall()).called(1);
  });
  testWidgets("Test saving the created Todo 2", (WidgetTester tester) async {
    const title = "my title";
    const description = "my description";
    await tester.pumpWidget(widgetInSkeletonInProviderScope);
    await tester.enterText(find.byType(TextFormField).at(0), title);
    await tester.enterText(find.byType(TextFormField).at(1), description);
    await tester.tap(find.byType(Checkbox));
    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();
    expect(todosNotifier.state.length, 3);
    expect(todosNotifier.state[2].title, title);
    expect(todosNotifier.state[2].description, description);
    expect(todosNotifier.state[2].done, true);
    verify(goRouterContextPopFunctionCall()).called(1);
  });
}
