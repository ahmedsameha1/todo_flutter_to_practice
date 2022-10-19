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
}
