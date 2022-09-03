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
import 'package:todo_flutter_to_practice/widgets/todo_form.dart';
import 'package:uuid/uuid.dart';

import 'my_matchers.dart';
import 'skeleton_for_widget_testing.dart';
import 'todo_form_test.mocks.dart';

void main() {
  final widgetInSkeletonInProviderScope = ProviderScope(
      overrides: [todosProvider.overrideWithValue(TodosNotifier(<Todo>[]))],
      child: createWidgetInASkeleton(
          CreateTodo(MockGoRouterContextPopFunction())));
  testWidgets("Test the presence of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeletonInProviderScope);
    expect(find.byType(CreateTodo), findsOneWidget);
    expect(find.byType(TodoForm), findsOneWidget);
  });
}
