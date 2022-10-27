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
    return (select(todos)
          ..orderBy([
            ((tbl) => OrderingTerm(
                expression: tbl.createdAt, mode: OrderingMode.desc))
          ]))
        .get();
  }

  Stream<List<Todo>> watchAll() {
    return (select(todos)
          ..orderBy([
            ((tbl) => OrderingTerm(
                expression: tbl.createdAt, mode: OrderingMode.desc))
          ]))
        .watch();
  }

  Future<Todo> getById(String id) async {
    return (select(todos)..where(((tbl) => tbl.id.equals(id)))).getSingle();
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

  Future<int> remove(String id) {
    return (delete(todos)..where((tbl) => tbl.id.equals(id))).go();
  }
}
