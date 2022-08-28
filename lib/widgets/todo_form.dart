import 'package:flutter/material.dart';

class TodoForm extends StatelessWidget {
  static const String labelString = "Label";
  final String title;
  const TodoForm(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(label: Text(labelString)),
            initialValue: title,
          ),
        ],
      ),
    );
  }
}
