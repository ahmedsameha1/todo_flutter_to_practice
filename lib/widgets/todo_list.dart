import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

class TodoList extends ConsumerWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Todo> todos = ref.watch(todosProvider);
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (listViewContext, index) {
        return Dismissible(
          key: Key(todos[index].id.value),
          onDismissed: (direction) {
            ref.read(todosProvider.notifier).removeTodo(todos[index].id.value);
          },
          background: Container(color: Colors.red),
          child: CheckboxListTile(
            title: Text(todos[index].title),
            subtitle: Text(todos[index].description),
            value: todos[index].done,
            onChanged: (bool? value) {},
          ),
        );
      },
    );
  }
}
