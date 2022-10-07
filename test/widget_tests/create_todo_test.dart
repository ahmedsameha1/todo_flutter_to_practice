import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/create_todo.dart';
import 'package:todo_flutter_to_practice/widgets/todo_form.dart';
import 'package:todo_flutter_to_practice/database/this_app_drift_database.dart';

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
