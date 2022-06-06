import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';
import 'package:uuid/uuid.dart';

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
    Todo todo1 = createTodoInstance("title1", "description1", false);
    todosNotifier.addTodo(todo1);
    expect(todosNotifier.state.length, 1);
    expect(todosNotifier.state.first, todo1);
    Todo todo2 = createTodoInstance("title2", "description2", false);
    todosNotifier.addTodo(todo2);
    expect(todosNotifier.state.length, 2);
    expect(todosNotifier.state.first, todo1);
    expect(todosNotifier.state[1], todo2);
    Todo todo3 = createTodoInstance("title3", "description3", false);
    todosNotifier.addTodo(todo3);
    expect(todosNotifier.state.length, 3);
    expect(todosNotifier.state.first, todo1);
    expect(todosNotifier.state[1], todo2);
    expect(todosNotifier.state[2], todo3);
    todosNotifier = TodosNotifier([todo1, todo2, todo3]);
    Todo todo4 = createTodoInstance("title4", "description4", false);
    todosNotifier.addTodo(todo4);
    expect(todosNotifier.state.length, 4);
    expect(todosNotifier.state.first, todo1);
    expect(todosNotifier.state[1], todo2);
    expect(todosNotifier.state[2], todo3);
    expect(todosNotifier.state[3], todo4);
  });
  test("""
      $given working with TodosNotifier
      $wheN Calling removeTodo()
      $then The todo with the given id is removed from the state list of todos
""", () {
    TodosNotifier todosNotifier = TodosNotifier();
    Todo todo1 = createTodoInstance("title1", "description1", false);
    todosNotifier.addTodo(todo1);
    todosNotifier.removeTodo(todo1.id.value);
    expect(todosNotifier.state.length, 0);
    Todo todo2 = createTodoInstance("title2", "description2", false);
    Todo todo3 = createTodoInstance("title3", "description3", false);
    todosNotifier.addTodo(todo2);
    todosNotifier.addTodo(todo3);
    todosNotifier.addTodo(todo1);
    todosNotifier.removeTodo(todo3.id.value);
    expect(todosNotifier.state.length, 2);
    expect(todosNotifier.state[0], todo2);
    expect(todosNotifier.state[1], todo1);
    Todo todo4 = createTodoInstance("title4", "description4", false);
    todosNotifier = TodosNotifier([todo1, todo2, todo3, todo4]);
    todosNotifier.removeTodo(todo1.id.value);
    todosNotifier.removeTodo(todo4.id.value);
    expect(todosNotifier.state.length, 2);
    expect(todosNotifier.state[0], todo2);
    expect(todosNotifier.state[1], todo3);
  });
  test("""
      $given working with TodosNotifier
      $wheN Calling toggle()
      $then The done field of the todo with the given id is toggled
""", () {
    TodosNotifier todosNotifier = TodosNotifier();
    Todo todo1 = createTodoInstance("title1", "description1", false);
    todosNotifier.addTodo(todo1);
    todosNotifier.toggle(todo1.id.value);
    expect(todosNotifier.state[0].done, true);
    Todo todo2 = createTodoInstance("title2", "description2", false);
    Todo todo3 = createTodoInstance("title3", "description3", false);
    Todo todo4 = createTodoInstance("title4", "description4", false);
    todosNotifier = TodosNotifier([todo1, todo2, todo3, todo4]);
    todosNotifier.toggle(todo1.id.value);
    todosNotifier.toggle(todo3.id.value);
    expect(todosNotifier.state[0].done, true);
    expect(todosNotifier.state[1].done, false);
    expect(todosNotifier.state[2].done, true);
    expect(todosNotifier.state[3].done, false);
    todosNotifier.toggle(todo3.id.value);
    expect(todosNotifier.state[2].done, false);
  });
}

createTodoInstance(String title, String description, bool done) {
  return Todo(
      id: TodoIdString(const Uuid().v4()),
      title: title,
      description: description,
      done: done);
}
