import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:todo_flutter_to_practice/database/this_app_drift_database.dart';

part "todos_dao.g.dart";

@DriftAccessor(tables: [Todos])
class TodosDao extends DatabaseAccessor<AppDatabase> with _$TodosDaoMixin {
  TodosDao(AppDatabase db) : super(db);

  Future<int> create(TodosCompanion entry) {
    return into(todos).insert(entry);
  }

  Future<List<Todo>> getAll() {
    return select(todos).get();
  }

  Future<int> mutate(Todo todo) {
    TodosCompanion todosCompanion = TodosCompanion(
        id: Value(todo.id),
        title: Value(todo.title),
        description: Value(todo.description),
        done: Value(todo.done));
    return (update(todos)..where((tbl) => tbl.id.equals(todo.id)))
        .write(todosCompanion);
  }
}
