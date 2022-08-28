import 'package:flutter/material.dart';

class TodoForm extends StatelessWidget {
  static const String labelString = "Label";
  static const String descriptionString = "Description";
  final String title;
  final String description;
  final bool done;
  final String textOfButton;
  const TodoForm(this.title, this.description, this.done, this.textOfButton,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          Checkbox(value: done, onChanged: null),
          TextFormField(
            decoration: const InputDecoration(label: Text(labelString)),
            initialValue: title,
          ),
          TextFormField(
            decoration: const InputDecoration(label: Text(descriptionString)),
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            initialValue: description,
          ),
          TextButton(onPressed: null, child: Text(textOfButton))
        ],
      ),
    );
  }
}
