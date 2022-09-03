import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain_model/todo.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier([state = const <Todo>[]]) : super(state);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeTodo(String id) {
    state = [
      for (final todo in state)
        if (todo.id.value != id) todo,
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id.value == id) todo.copyWith(done: !todo.done) else todo,
    ];
  }

  void updateTodo(Todo toUpdateFromTodo) {
    state = [
      for (final todo in state)
        if (todo.id.value == toUpdateFromTodo.id.value)
          todo.copyWith(title: toUpdateFromTodo.title)
            .copyWith(done: toUpdateFromTodo.done)
            .copyWith(description: toUpdateFromTodo.description)
        else
          todo,
    ];
  }
}
