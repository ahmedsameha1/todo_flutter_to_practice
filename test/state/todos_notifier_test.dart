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
    TodosNotifier todosNotifier = TodosNotifier();
    expect(todosNotifier, isA<StateNotifier<List<Todo>>>());
  });
  test("""
        $given working with TodosNotifier
        $wheN Calling addTodo()
        $then the passed todo will be added to the state list of todos
""", () async {
    TodosNotifier todosNotifier = TodosNotifier();
    Todo todo1 = Todo("title1", "description2", false);
    todosNotifier.addTodo(todo1);
    expect(todosNotifier.state.length, 1);
    expect(todosNotifier.state.first, todo1);
    Todo todo2 = Todo("title2", "description2", false);
    todosNotifier.addTodo(todo2);
    expect(todosNotifier.state.length, 2);
    expect(todosNotifier.state.first, todo1);
    expect(todosNotifier.state[1], todo2);
    Todo todo3 = Todo("title3", "description3", false);
    todosNotifier.addTodo(todo3);
    expect(todosNotifier.state.length, 3);
    expect(todosNotifier.state.first, todo1);
    expect(todosNotifier.state[1], todo2);
    expect(todosNotifier.state[2], todo3);
    todosNotifier = TodosNotifier([todo1, todo2, todo3]);
    Todo todo4 = Todo("title4", "description4", false);
    todosNotifier.addTodo(todo4);
    expect(todosNotifier.state.length, 4);
    expect(todosNotifier.state.first, todo1);
    expect(todosNotifier.state[1], todo2);
    expect(todosNotifier.state[2], todo3);
    expect(todosNotifier.state[3], todo4);
  });
}
