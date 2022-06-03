import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';

import '../test_constants.dart';

main() {
  test("""
        $given working with TodosNotifier
        $wheN Creating TodosNotifier
        $then TodosNotifier is a StateNotifier<List<Todo>>
""", () {
    TodosNotifier todosNotifier = TodosNotifier(List<Todo>.empty());
    expect(todosNotifier, isA<StateNotifier<List<Todo>>>());
  });
}
