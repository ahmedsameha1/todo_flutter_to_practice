import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/database/this_app_drift_database.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';
import 'package:todo_flutter_to_practice/widgets/todo_form.dart';
import 'package:todo_flutter_to_practice/widgets/update_todo.dart';
import 'package:uuid/uuid.dart';

import 'skeleton_for_widget_testing.dart';
import 'todo_form_test.mocks.dart';

void main() {
  final id1 = const Uuid().v4();
  final widgetInSkeletonInProviderScope = ProviderScope(
      overrides: [
        todosProvider.overrideWithValue(TodosNotifier(<Todo>[
          Todo(
              id: id1,
              title: "title1",
              description: "description1",
              done: false,
              createdAt: DateTime.now().toUtc())
        ]))
      ],
      child: createWidgetInASkeleton(
          UpdateTodo(id1, MockGoRouterContextPopFunction())));
  testWidgets("Test the precsense of the main widgets",
      (WidgetTester tester) async {
    await tester.pumpWidget(widgetInSkeletonInProviderScope);
    expect(find.byType(UpdateTodo), findsOneWidget);
    expect(find.byType(TodoForm), findsOneWidget);
  });
}
