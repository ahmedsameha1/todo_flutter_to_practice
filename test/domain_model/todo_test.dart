import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:uuid/uuid.dart';

main() {
  test("id isn't an invalid UUID", () {
    expect(() => Todo(id: TodoIdString(""), title: "title", description: "description", done: false), throwsArgumentError);
    expect(() => Todo(id: TodoIdString("ehwthwhgwe"), title: "title", description: "description", done: false), throwsArgumentError);
    expect(() => Todo(id: TodoIdString(const Uuid().v4()), title: "title", description: "description", done: false), isNot(throwsArgumentError));
  });
}