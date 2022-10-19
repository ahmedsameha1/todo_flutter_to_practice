import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/database/this_app_drift_database.dart';
import 'package:todo_flutter_to_practice/database/todos_dao.dart';
import 'package:uuid/uuid.dart';

main() {
  late AppDatabase appDatabase;
  late TodosDao todosDao;
  setUp(() {
    appDatabase = AppDatabase(NativeDatabase.memory());
    todosDao = TodosDao(appDatabase);
  });

  tearDown(() async {
    await appDatabase.close();
  });

  group("Creating a Todo", () {
    test("Invalid Todo: empty title", () async {
      final id = const Uuid().v4();
      const title = "";
      const description = "description";
      const done = false;
      final createdAt = DateTime.now().toUtc();
      final TodosCompanion todosCompanion = TodosCompanion(
          id: Value(id),
          title: const Value(title),
          description: const Value(description),
          done: const Value(done),
          createdAt: Value(createdAt));
      expect(() async {
        await todosDao.create(todosCompanion);
      },
          throwsA(predicate((e) =>
              e is InvalidDataException && e.message.contains("title"))));
    });
    test("Invalid Todo: no title", () async {
      final id = const Uuid().v4();
      const description = "description";
      const done = false;
      final createdAt = DateTime.now().toUtc();
      final TodosCompanion todosCompanion = TodosCompanion(
          id: Value(id),
          description: const Value(description),
          done: const Value(done),
          createdAt: Value(createdAt));
      expect(() async {
        await todosDao.create(todosCompanion);
      },
          throwsA(predicate((e) =>
              e is InvalidDataException && e.message.contains("title"))));
    });
    test("Invalid Todo: empty description", () async {
      final id = const Uuid().v4();
      const title = "title";
      const description = "";
      const done = false;
      final createdAt = DateTime.now().toUtc();
      final TodosCompanion todosCompanion = TodosCompanion(
          id: Value(id),
          title: const Value(title),
          description: const Value(description),
          done: const Value(done),
          createdAt: Value(createdAt));
      expect(() async {
        await todosDao.create(todosCompanion);
      },
          throwsA(predicate((e) =>
              e is InvalidDataException && e.message.contains("description"))));
    });
    test("Invalid Todo: no description", () async {
      final id = const Uuid().v4();
      const title = "title";
      const done = false;
      final createdAt = DateTime.now().toUtc();
      final TodosCompanion todosCompanion = TodosCompanion(
          id: Value(id),
          title: const Value(title),
          done: const Value(done),
          createdAt: Value(createdAt));
      expect(() async {
        await todosDao.create(todosCompanion);
      },
          throwsA(predicate((e) =>
              e is InvalidDataException && e.message.contains("description"))));
    });
    test("Invalid Todo: no done", () async {
      final id = const Uuid().v4();
      const title = "title";
      const description = "description";
      final createdAt = DateTime.now().toUtc();
      final TodosCompanion todosCompanion = TodosCompanion(
          id: Value(id),
          title: const Value(title),
          description: const Value(description),
          createdAt: Value(createdAt));
      expect(() async {
        await todosDao.create(todosCompanion);
      },
          throwsA(predicate(
              (e) => e is InvalidDataException && e.message.contains("done"))));
    });
    test("Invalid Todo: no title, no description & no done", () async {
      const TodosCompanion todosCompanion = TodosCompanion();
      expect(() async {
        await todosDao.create(todosCompanion);
      },
          throwsA(predicate((e) =>
              e is InvalidDataException &&
              e.message.contains("title") &&
              e.message.contains("description") &&
              e.message.contains("done"))));
    });
    test("Valid Todo", () async {
      final id = const Uuid().v4();
      const title = "title";
      const description = "description";
      const done = false;
      final createdAt = DateTime.now().toUtc();
      final TodosCompanion todosCompanion = TodosCompanion(
          id: Value(id),
          title: const Value(title),
          description: const Value(description),
          done: const Value(done),
          createdAt: Value(createdAt));
      await todosDao.create(todosCompanion);
      final todos = await todosDao.getAll();
      expect(todos.length, 1);
      expect(
          todos[0],
          Todo(
              id: id,
              title: title,
              description: description,
              done: done,
              createdAt: createdAt));
    });
    test("Valid Todo, default id & createdAt", () async {
      const title = "title";
      const description = "description";
      const done = false;
      const TodosCompanion todosCompanion = TodosCompanion(
        title: Value(title),
        description: Value(description),
        done: Value(done),
      );
      await todosDao.create(todosCompanion);
      final todos = await todosDao.getAll();
      expect(todos.length, 1);
      expect(Uuid.isValidUUID(fromString: todos[0].id), true);
      expect(todos[0].title, title);
      expect(todos[0].description, description);
      expect(todos[0].done, done);
      expect(todos[0].createdAt.isBefore(DateTime.now()), true);
      expect(todos[0].createdAt.isAfter(DateTime.now().subtract(const Duration(seconds: 1))), true);
    });
  });
}
