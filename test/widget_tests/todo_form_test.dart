import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter_to_practice/database/this_app_drift_database.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/todo_form.dart';
import 'package:uuid/uuid.dart';

import 'common_finders.dart';
import 'my_matchers.dart';
import 'skeleton_for_widget_testing.dart';
import 'todo_form_test.mocks.dart';

abstract class GoRouterContextPopFunction {
  void call();
}

@GenerateMocks([GoRouterContextPopFunction])
main() {
  final goRouterContextPopFunctionCall = MockGoRouterContextPopFunction();
  final id1 = const Uuid().v4();
  final id2 = const Uuid().v4();
  final id3 = const Uuid().v4();
  final DateTime todo2CreatedAt =
      DateTime.now().subtract(const Duration(days: 3)).toUtc();
  Todo todo1 = Todo(
      id: id1,
      title: "title1",
      description: "description1",
      done: false,
      createdAt: DateTime.now().toUtc());
  Todo todo2 = Todo(
      id: id2,
      title: "title2",
      description: "description2",
      done: true,
      createdAt: todo2CreatedAt);
  Todo todo3 = Todo(
      id: id3,
      title: "title3",
      description: "description3",
      done: false,
      createdAt: DateTime.now().toUtc());
  final todos = [todo1, todo2, todo3];
  late TodosNotifier todosNotifier;
  late ProviderScope widgetInSkeletonInProviderScope;
  late Widget widgetInSkeleton;
  group("Updating", () {
    setUp(() {
      todosNotifier = TodosNotifier(todos);
      widgetInSkeleton = createWidgetInASkeleton(TodoForm(
          goRouterContextPopFunctionCall,
          id: todo2.id,
          title: todo2.title,
          description: todo2.description,
          done: todo2.done,
          createdAt: todo2.createdAt));
      widgetInSkeletonInProviderScope = ProviderScope(
          overrides: [todosProvider.overrideWithValue(todosNotifier)],
          child: widgetInSkeleton);
      reset(goRouterContextPopFunctionCall);
    });
    testWidgets("Test the presense of the main widgets",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeletonInProviderScope);
      expect(formFinder, findsOneWidget);
      expect(columnFinder, findsOneWidget);
      final TextFormField titleTextFormField =
          tester.widget(textFormFieldFinder.at(0));
      final TextField titleTextField = tester.widget(textFieldFinder.at(0));
      expect((titleTextField.decoration!.label as Text).data,
          TodoForm.labelString);
      expect(titleTextField.keyboardType, TextInputType.text);
      expect(titleTextFormField.initialValue, todos[1].title);
      final TextFormField descriptionTextFormField =
          tester.widget(textFormFieldFinder.at(1));
      final TextField descriptionTextField =
          tester.widget(textFieldFinder.at(1));
      expect((descriptionTextField.decoration!.label as Text).data,
          TodoForm.descriptionString);
      expect(descriptionTextField.keyboardType, TextInputType.multiline);
      expect(descriptionTextField.maxLines, 5);
      expect(descriptionTextFormField.initialValue, todos[1].description);
      final Checkbox doneCheckbox = tester.widget(checkboxFinder);
      expect(doneCheckbox.value, todos[1].done);
      final TextButton submissionButton = tester.widget(textButtonFinder);
      expect((submissionButton.child as Text).data, "Update");
      final listOfWidgets = tester.widgetList(find.bySubtype()).toList();
      expect(
          listOfWidgets, FirstPrecedesSecond(doneCheckbox, titleTextFormField));
      expect(listOfWidgets,
          FirstPrecedesSecond(titleTextFormField, descriptionTextFormField));
      expect(listOfWidgets,
          FirstPrecedesSecond(descriptionTextFormField, submissionButton));
    });
    group("Test form validation", () {
      testWidgets("Testing the validation of the title text field",
          (WidgetTester tester) async {
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        final submissionTextButtonFinder = textButtonFinder;
        final titleTextFormFieldFinder = textFormFieldFinder.at(0);
        await tester.enterText(titleTextFormFieldFinder, " ");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text(TodoForm.titleValidationErrorMessage), findsOneWidget);
        expect(
            tester.widgetList(bySubtypeFinder).toList(),
            FirstPrecedesSecond(
                tester.widget(titleTextFormFieldFinder),
                tester
                    .widget(find.text(TodoForm.titleValidationErrorMessage))));
        await tester.enterText(titleTextFormFieldFinder, " f");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text(TodoForm.titleValidationErrorMessage), findsNothing);
      });
      testWidgets("Testing the validation of the description text field",
          (tester) async {
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        final submissionTextButtonFinder = textButtonFinder;
        final descriptionTextFormFieldFinder = textFormFieldFinder.at(1);
        await tester.enterText(descriptionTextFormFieldFinder, " ");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text(TodoForm.descriptionValidationErrorMessage),
            findsOneWidget);
        expect(
            tester.widgetList(bySubtypeFinder).toList(),
            FirstPrecedesSecond(
                tester.widget(descriptionTextFormFieldFinder),
                tester.widget(
                    find.text(TodoForm.descriptionValidationErrorMessage))));
        await tester.enterText(descriptionTextFormFieldFinder, "h ");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text(TodoForm.descriptionValidationErrorMessage),
            findsNothing);
      });
      testWidgets("Testing the validation when no text in the two text fields",
          (tester) async {
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        final submissionTextButtonFinder = textButtonFinder;
        final titleTextFormFieldFinder = textFormFieldFinder.at(0);
        final descriptionTextFormFieldFinder = textFormFieldFinder.at(1);
        await tester.enterText(titleTextFormFieldFinder, " ");
        await tester.enterText(descriptionTextFormFieldFinder, " ");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        final listOfWidgets = tester.widgetList(find.bySubtype()).toList();
        expect(
            listOfWidgets,
            FirstPrecedesSecond(
                tester.widget(find.text(TodoForm.titleValidationErrorMessage)),
                tester.widget(descriptionTextFormFieldFinder)));
        expect(
            listOfWidgets,
            FirstPrecedesSecond(
                tester.widget(descriptionTextFormFieldFinder),
                tester.widget(
                    find.text(TodoForm.descriptionValidationErrorMessage))));
      });
      testWidgets("The checkbox changes its value when clicked",
          (tester) async {
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        final doneCheckboxFinder = checkboxFinder;
        await tester.tap(doneCheckboxFinder);
        await tester.pumpAndSettle();
        expect((doneCheckboxFinder.evaluate().first.widget as Checkbox).value,
            !todos[1].done);
        await tester.tap(doneCheckboxFinder);
        await tester.pumpAndSettle();
        expect((doneCheckboxFinder.evaluate().first.widget as Checkbox).value,
            todos[1].done);
      });
    });
    testWidgets(
        "The submission function get called when the text button is being clicked",
        (tester) async {
      const title = "my title";
      const description = "my description";
      await tester.pumpWidget(widgetInSkeletonInProviderScope);
      await tester.enterText(textFormFieldFinder.at(0), title);
      await tester.enterText(textFormFieldFinder.at(1), description);
      await tester.tap(checkboxFinder);
      await tester.tap(textButtonFinder);
      await tester.pumpAndSettle();
      expect(todosNotifier.state[1].title, title);
      expect(todosNotifier.state[1].description, description);
      expect(todosNotifier.state[1].done, !todo2.done);
      expect(todosNotifier.state[1].id, todo2.id);
      expect(todosNotifier.state[1].createdAt, todo2CreatedAt);
      verify(goRouterContextPopFunctionCall()).called(1);
    });
  });
  group("Creating", () {
    setUp(() {
      todosNotifier = TodosNotifier(todos);
      widgetInSkeleton =
          createWidgetInASkeleton(TodoForm(goRouterContextPopFunctionCall));
      widgetInSkeletonInProviderScope = ProviderScope(
          overrides: [todosProvider.overrideWithValue(todosNotifier)],
          child: widgetInSkeleton);
      reset(goRouterContextPopFunctionCall);
    });
    testWidgets("Test the presense of the main widgets",
        (WidgetTester tester) async {
      await tester.pumpWidget(widgetInSkeletonInProviderScope);
      expect(formFinder, findsOneWidget);
      expect(columnFinder, findsOneWidget);
      final TextFormField titleTextFormField =
          tester.widget(textFormFieldFinder.at(0));
      final TextField titleTextField = tester.widget(textFieldFinder.at(0));
      expect((titleTextField.decoration!.label as Text).data,
          TodoForm.labelString);
      expect(titleTextField.keyboardType, TextInputType.text);
      expect(titleTextFormField.initialValue, "");
      final TextFormField descriptionTextFormField =
          tester.widget(textFormFieldFinder.at(1));
      final TextField descriptionTextField =
          tester.widget(textFieldFinder.at(1));
      expect((descriptionTextField.decoration!.label as Text).data,
          TodoForm.descriptionString);
      expect(descriptionTextField.keyboardType, TextInputType.multiline);
      expect(descriptionTextField.maxLines, 5);
      expect(descriptionTextFormField.initialValue, "");
      final Checkbox doneCheckbox = tester.widget(checkboxFinder);
      expect(doneCheckbox.value, false);
      final TextButton submissionButton = tester.widget(textButtonFinder);
      expect((submissionButton.child as Text).data, "Create");
      final listOfWidgets = tester.widgetList(find.bySubtype()).toList();
      expect(
          listOfWidgets, FirstPrecedesSecond(doneCheckbox, titleTextFormField));
      expect(listOfWidgets,
          FirstPrecedesSecond(titleTextFormField, descriptionTextFormField));
      expect(listOfWidgets,
          FirstPrecedesSecond(descriptionTextFormField, submissionButton));
    });
    group("Test form validation", () {
      testWidgets("Testing the validation of the title text field",
          (WidgetTester tester) async {
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        final submissionTextButtonFinder = textButtonFinder;
        final titleTextFormFieldFinder = textFormFieldFinder.at(0);
        await tester.enterText(titleTextFormFieldFinder, " ");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text(TodoForm.titleValidationErrorMessage), findsOneWidget);
        expect(
            tester.widgetList(bySubtypeFinder).toList(),
            FirstPrecedesSecond(
                tester.widget(titleTextFormFieldFinder),
                tester
                    .widget(find.text(TodoForm.titleValidationErrorMessage))));
        await tester.enterText(titleTextFormFieldFinder, " f");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text(TodoForm.titleValidationErrorMessage), findsNothing);
      });
      testWidgets("Testing the validation of the description text field",
          (tester) async {
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        final submissionTextButtonFinder = textButtonFinder;
        final descriptionTextFormFieldFinder = textFormFieldFinder.at(1);
        await tester.enterText(descriptionTextFormFieldFinder, " ");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text(TodoForm.descriptionValidationErrorMessage),
            findsOneWidget);
        expect(
            tester.widgetList(bySubtypeFinder).toList(),
            FirstPrecedesSecond(
                tester.widget(descriptionTextFormFieldFinder),
                tester.widget(
                    find.text(TodoForm.descriptionValidationErrorMessage))));
        await tester.enterText(descriptionTextFormFieldFinder, "h ");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text(TodoForm.descriptionValidationErrorMessage),
            findsNothing);
      });
      testWidgets("Testing the validation when no text in the two text fields",
          (tester) async {
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        final submissionTextButtonFinder = textButtonFinder;
        final titleTextFormFieldFinder = textFormFieldFinder.at(0);
        final descriptionTextFormFieldFinder = textFormFieldFinder.at(1);
        await tester.enterText(titleTextFormFieldFinder, " ");
        await tester.enterText(descriptionTextFormFieldFinder, " ");
        await tester.tap(submissionTextButtonFinder);
        await tester.pumpAndSettle();
        final listOfWidgets = tester.widgetList(find.bySubtype()).toList();
        expect(
            listOfWidgets,
            FirstPrecedesSecond(
                tester.widget(find.text(TodoForm.titleValidationErrorMessage)),
                tester.widget(descriptionTextFormFieldFinder)));
        expect(
            listOfWidgets,
            FirstPrecedesSecond(
                tester.widget(descriptionTextFormFieldFinder),
                tester.widget(
                    find.text(TodoForm.descriptionValidationErrorMessage))));
      });
      testWidgets("The checkbox changes its value when clicked",
          (tester) async {
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        final doneCheckboxFinder = checkboxFinder;
        await tester.tap(doneCheckboxFinder);
        await tester.pumpAndSettle();
        expect((doneCheckboxFinder.evaluate().first.widget as Checkbox).value,
            true);
        await tester.tap(doneCheckboxFinder);
        await tester.pumpAndSettle();
        expect((doneCheckboxFinder.evaluate().first.widget as Checkbox).value,
            false);
      });
    });
    testWidgets(
        "The submission function get called when the text button is being clicked",
        (tester) async {
      final DateTime createdAt = DateTime(2020).toUtc();
      withClock(Clock.fixed(createdAt), () async {
        const title = "my title";
        const description = "my description";
        await tester.pumpWidget(widgetInSkeletonInProviderScope);
        await tester.enterText(textFormFieldFinder.at(0), title);
        await tester.enterText(textFormFieldFinder.at(1), description);
        await tester.tap(checkboxFinder);
        await tester.tap(textButtonFinder);
        await tester.pumpAndSettle();
        expect(todosNotifier.state[3].title, title);
        expect(todosNotifier.state[3].description, description);
        expect(todosNotifier.state[3].done, true);
        expect(todosNotifier.state[3].createdAt, createdAt);
        verify(goRouterContextPopFunctionCall()).called(1);
      });
    });
  });
}
