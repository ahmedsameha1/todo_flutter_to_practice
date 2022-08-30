import 'package:flutter/material.dart';

class TodoForm extends StatelessWidget {
  static const String labelString = "Label";
  static const String descriptionString = "Description";
  static const String titleValidationErrorMessage = "Title cannot be empty!";
  static const String descriptionValidationErrorMessage = "Description cannot by empty!";
  final String title;
  final String description;
  final bool done;
  final String textOfButton;
  final GlobalKey<FormState> _formGlobalKey = GlobalKey();
  TodoForm(this.title, this.description, this.done, this.textOfButton,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formGlobalKey,
      child: Column(
        children: [
          Checkbox(value: done, onChanged: null),
          TextFormField(
            decoration: const InputDecoration(label: Text(labelString)),
            initialValue: title,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return titleValidationErrorMessage;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text(descriptionString)),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            initialValue: description,
            validator: (value) {
              if (value == null || value.isEmpty || value.trim().isEmpty) {
                return descriptionValidationErrorMessage;
              }
              return null;
            },
          ),
          TextButton(
              onPressed: () {
                _formGlobalKey.currentState!.validate();
              },
              child: Text(textOfButton))
        ],
      ),
    );
  }
}
