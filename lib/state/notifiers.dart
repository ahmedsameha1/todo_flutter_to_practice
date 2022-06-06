import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/state/todos_notifier.dart';

import '../domain_model/todo.dart';

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
