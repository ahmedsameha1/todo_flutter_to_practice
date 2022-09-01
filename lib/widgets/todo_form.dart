import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';

class TodoForm extends ConsumerStatefulWidget {
  static void update(
      GlobalKey<FormState> formKey, WidgetRef widgetRef, TodoForm todoForm) {
    formKey.currentState!.save();
    widgetRef
        .read(todosProvider.notifier)
        .updateTodo(todoForm.todo.id.value, todoForm.todo);
  }

  static const String labelString = "Label";
  static const String descriptionString = "Description";
  static const String titleValidationErrorMessage = "Title cannot be empty!";
  static const String descriptionValidationErrorMessage =
      "Description cannot by empty!";
  Todo todo;
  final String textOfButton;
  final Function(GlobalKey<FormState> key, WidgetRef reF, TodoForm to) action;

  TodoForm(this.todo, this.textOfButton, this.action, {Key? key})
      : super(key: key);

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
              value: widget.todo.done,
              onChanged: (value) {
                setState(() {
                  widget.todo = widget.todo.copyWith(done: !widget.todo.done);
                });
              }),
          TextFormField(
            decoration:
                const InputDecoration(label: Text(TodoForm.labelString)),
            initialValue: widget.todo.title,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return TodoForm.titleValidationErrorMessage;
              }
              return null;
            },
            onSaved: (newValue) {
              if (newValue != null) {
                setState(() {
                  widget.todo = widget.todo.copyWith(title: newValue);
                });
              }
            },
          ),
          TextFormField(
            decoration:
                const InputDecoration(label: Text(TodoForm.descriptionString)),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            initialValue: widget.todo.description,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return TodoForm.descriptionValidationErrorMessage;
              }
              return null;
            },
          ),
          TextButton(
              onPressed: () {
                if (_formGlobalKey.currentState!.validate()) {
                  widget.action(_formGlobalKey, ref, widget);
                }
              },
              child: Text(widget.textOfButton))
        ],
      ),
    );
  }
}
