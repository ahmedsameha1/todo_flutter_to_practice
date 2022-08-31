import 'package:flutter/material.dart';

class TodoForm extends StatefulWidget {
  static const String labelString = "Label";
  static const String descriptionString = "Description";
  static const String titleValidationErrorMessage = "Title cannot be empty!";
  static const String descriptionValidationErrorMessage =
      "Description cannot by empty!";
  final String title;
  final String description;
  bool done;
  final String textOfButton;

  TodoForm(this.title, this.description, this.done, this.textOfButton,
      {Key? key})
      : super(key: key);

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
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
                  widget.done = !widget.done;
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
          ),
          TextButton(
              onPressed: () {
                _formGlobalKey.currentState!.validate();
              },
              child: Text(widget.textOfButton))
        ],
      ),
    );
  }
}
