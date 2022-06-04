import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain_model/todo.dart';

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier([state = const <Todo>[]]) : super(state);

  void addTodo(Todo todo) {
    state = [...state, todo];
  }

  void removeTodo(String id) {
    state = [for (final todo in state)
    if (todo.id != id) todo,];
  }
}
