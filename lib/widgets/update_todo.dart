import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

import '../domain_model/todo.dart';
import 'todo_form.dart';

class UpdateTodo extends ConsumerWidget {
  final Function() goRouterContextPopFunction;
  final TodoIdString todoId;

  const UpdateTodo(this.todoId, this.goRouterContextPopFunction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Todo todo =
        ref.watch(todosProvider).where((element) => element.id == todoId).first;
    return TodoForm(
      goRouterContextPopFunction,
      id: todo.id,
      title: todo.title,
      description: todo.description,
      done: todo.done,
    );
  }
}
