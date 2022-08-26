import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

import '../domain_model/todo.dart';

class UpdateTodo extends ConsumerWidget {
  const UpdateTodo(this.todoId, {Key? key}) : super(key: key);
  static const String titleString = "Title";
  static const String descriptionString = "Description";
  static const String updateString = "Update";
  final TodoIdString todoId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Todo todo =
        ref.watch(todosProvider).where((element) => element.id == todoId).first;
    return Form(
      child: Column(
        children: [
          Checkbox(value: todo.done, onChanged: null),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(label: Text(titleString)),
            initialValue: todo.title,
          ),
          TextFormField(
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: const InputDecoration(label: Text(descriptionString)),
            initialValue: todo.description,
          ),
          const TextButton(onPressed: null, child: Text(updateString))
        ],
      ),
    );
  }
}
