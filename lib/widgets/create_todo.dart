import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:todo_flutter_to_practice/state/notifiers.dart';
import 'package:uuid/uuid.dart';

class CreateTodo extends ConsumerWidget {
  final Function() goRounterContextPopFunction;
  final _doneCheckboxProvider = StateProvider<bool>(
    (ref) => false,
  );
  final _toBeCreatedTodoProvider = StateProvider<Todo>(
    (ref) => Todo(
        id: TodoIdString(const Uuid().v4()),
        title: "",
        description: "",
        done: false),
  );
  static const String titleValidationErrorMessage = "Title cannot be empty!";
  static const String descriptionValidationErrorMessage =
      "Description cannot be empty!";
  static const String createString = "Create";
  static const String titleString = "Title";
  static const String descriptionString = "Description";
  final GlobalKey<FormState> _formGlobalKey = GlobalKey();

  CreateTodo(this.goRounterContextPopFunction, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        children: [
          Checkbox(
              value: ref.watch(_doneCheckboxProvider),
              onChanged: (value) {
                if (value != null) {
                  ref.read(_doneCheckboxProvider.notifier).state = value;
                  ref
                      .read(_toBeCreatedTodoProvider.notifier)
                      .update((state) => state.copyWith(done: value));
                }
              }),
          TextFormField(
            decoration:
                const InputDecoration(label: Text(CreateTodo.titleString)),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return CreateTodo.titleValidationErrorMessage;
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                ref
                    .read(_toBeCreatedTodoProvider.notifier)
                    .update((state) => state.copyWith(title: value));
              } else {
                _formGlobalKey.currentState!.validate();
              }
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
                label: Text(CreateTodo.descriptionString)),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return CreateTodo.descriptionValidationErrorMessage;
              }
              return null;
            },
            onSaved: (value) {
              if (value != null) {
                ref
                    .read(_toBeCreatedTodoProvider.notifier)
                    .update((state) => state.copyWith(description: value));
              } else {
                _formGlobalKey.currentState!.validate();
              }
            },
          ),
          TextButton(
              onPressed: () {
                if (_formGlobalKey.currentState!.validate()) {
                  _formGlobalKey.currentState!.save();
                  ref.read(todosProvider.notifier).addTodo(
                      ref.read(_toBeCreatedTodoProvider.notifier).state);
                  goRounterContextPopFunction();
                }
              },
              child: const Text(CreateTodo.createString))
        ],
      ),
    );
  }
}
