import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

class TodoList extends ConsumerWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todosProvider);
    return ListView(
      children: [
        for (final todo in todos) 
        CheckboxListTile(
          title: Text(todo.title),
          subtitle: Text(todo.description),
          value: todo.done,
          onChanged: (bool? value) {},
        )
      ],
    );
  }
}
