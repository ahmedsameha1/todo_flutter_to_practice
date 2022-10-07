import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:uuid/uuid.dart';

import '../database/this_app_drift_database.dart';

class TodoForm extends ConsumerStatefulWidget {
  final Function() goRouterContextPopFunction;
  static void update(
      GlobalKey<FormState> formKey, WidgetRef widgetRef, TodoForm todoForm) {
    formKey.currentState!.save();
    final todo = Todo(
        id: todoForm.id!,
        title: todoForm.title!,
        description: todoForm.description!,
        done: todoForm.done!);
    widgetRef.read(todosProvider.notifier).updateTodo(todo);
    todoForm.goRouterContextPopFunction();
  }

  static void create(
      GlobalKey<FormState> formKey, WidgetRef widgetRef, TodoForm todoForm) {
    formKey.currentState!.save();
    final todo = Todo(
        id: todoForm.id!,
        title: todoForm.title!,
        description: todoForm.description!,
        done: todoForm.done!);
    widgetRef.read(todosProvider.notifier).addTodo(todo);
    todoForm.goRouterContextPopFunction();
  }

  static const String labelString = "Label";
  static const String descriptionString = "Description";
  static const String titleValidationErrorMessage = "Title cannot be empty!";
  static const String descriptionValidationErrorMessage =
      "Description cannot by empty!";
  late final String? textOfButton;
  late final Function(GlobalKey<FormState> key, WidgetRef reF, TodoForm to)
      action;
  late String? title, description;
  late bool? done;
  late String? id;

  TodoForm(this.goRouterContextPopFunction,
      {Key? key,
      String? id,
      String? title,
      String? description,
      bool? done})
      : id = id == null && done == null ? const Uuid().v4() : id,
        title =
            id == null && title == null && description == null && done == null
                ? ""
                : title,
        description =
            id == null && title == null && description == null && done == null
                ? ""
                : description,
        done =
            id == null && title == null && description == null && done == null
                ? false
                : done,
        textOfButton =
            id == null && title == null && description == null && done == null
                ? "Create"
                : "Update",
        action =
            id == null && title == null && description == null && done == null
                ? create
                : update,
        super(key: key);

  @override
  ConsumerState<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends ConsumerState<TodoForm> {
  final GlobalKey<FormState> _formGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        children: [
          Checkbox(
              value: widget.done,
              onChanged: (value) {
                setState(() {
                  widget.done = !widget.done!;
                });
              }),
          TextFormField(
            decoration:
                const InputDecoration(label: Text(TodoForm.labelString)),
            initialValue: widget.title,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return TodoForm.titleValidationErrorMessage;
              }
              return null;
            },
            onSaved: (newValue) {
              if (newValue != null) {
                setState(() {
                  widget.title = newValue;
                });
              }
            },
          ),
          TextFormField(
            decoration:
                const InputDecoration(label: Text(TodoForm.descriptionString)),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            initialValue: widget.description,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return TodoForm.descriptionValidationErrorMessage;
              }
              return null;
            },
            onSaved: (newValue) {
              if (newValue != null) {
                setState(() {
                  widget.description = newValue;
                });
              }
            },
          ),
          TextButton(
              onPressed: () {
                if (_formGlobalKey.currentState!.validate()) {
                  widget.action(_formGlobalKey, ref, widget);
                }
              },
              child: Text(widget.textOfButton!))
        ],
      ),
    );
  }
}
