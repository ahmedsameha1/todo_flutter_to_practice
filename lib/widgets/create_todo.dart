import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo_form.dart';

class CreateTodo extends ConsumerWidget {
  final Function() goRouterContextPopFunction;

  const CreateTodo(this.goRouterContextPopFunction, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TodoForm(goRouterContextPopFunction);
  }
}
