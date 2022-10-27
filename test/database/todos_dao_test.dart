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
      expect(
          todos[0]
              .createdAt
              .isAfter(DateTime.now().subtract(const Duration(seconds: 1))),
          true);
    });
  });
  group("Updating a todo", () {
    final id = const Uuid().v4();
    const title = "title";
    const description = "description";
    const done = false;
    final createdAt = DateTime.now().toUtc();
    setUp(() async {
      final TodosCompanion todosCompanion = TodosCompanion(
          id: Value(id),
          title: const Value(title),
          description: const Value(description),
          done: const Value(done),
          createdAt: Value(createdAt));
      await todosDao.create(todosCompanion);
    });
    test("Invalid Todo: empty title", () async {
      const updatedTitle = "";
      const updatedDescription = "updateddescription";
      const updatedDone = false;
      final Todo todo = Todo(
          id: id,
          title: updatedTitle,
          description: updatedDescription,
          done: updatedDone,
          createdAt: createdAt);
      expect(() async {
        await todosDao.mutate(todo);
      },
          throwsA(predicate((e) =>
              e is InvalidDataException && e.message.contains("title"))));
    });
    test("Invalid Todo: empty description", () async {
      const updatedTitle = "updatedTitle";
      const updatedDescription = "";
      const updatedDone = false;
      final Todo todo = Todo(
          id: id,
          title: updatedTitle,
          description: updatedDescription,
          done: updatedDone,
          createdAt: createdAt);
      expect(() async {
        await todosDao.mutate(todo);
      },
          throwsA(predicate((e) =>
              e is InvalidDataException && e.message.contains("description"))));
    });
    test("Invalid todo: empty title & empty description", () async {
      const updatedTitle = "";
      const updatedDescription = "";
      const updatedDone = false;
      final Todo todo = Todo(
          id: id,
          title: updatedTitle,
          description: updatedDescription,
          done: updatedDone,
          createdAt: createdAt);
      expect(() async {
        await todosDao.mutate(todo);
      },
          throwsA(predicate((e) =>
              e is InvalidDataException &&
              e.message.contains("description") &&
              e.message.contains("title"))));
    });
    test("Good case", () async {
      const updatedTitle = "updatedTitle";
      const updatedDescription = "updatedDescription";
      const updatedDone = true;
      final Todo todo = Todo(
          id: id,
          title: updatedTitle,
          description: updatedDescription,
          done: updatedDone,
          createdAt: createdAt);
      await todosDao.mutate(todo);
      final todos = await todosDao.getAll();
      expect(todos.length, 1);
      expect(todos[0].id, id);
      expect(todos[0].title, updatedTitle);
      expect(todos[0].description, updatedDescription);
      expect(todos[0].done, updatedDone);
      expect(todos[0].createdAt, createdAt);
    });
    test("Good case: no update for createdAt field", () async {
      const updatedTitle = "updatedTitle";
      const updatedDescription = "updatedDescription";
      const updatedDone = true;
      final Todo todo = Todo(
          id: id,
          title: updatedTitle,
          description: updatedDescription,
          done: updatedDone,
          createdAt: DateTime.now().toUtc());
      await todosDao.mutate(todo);
      final todos = await todosDao.getAll();
      expect(todos.length, 1);
      expect(todos[0].id, id);
      expect(todos[0].title, updatedTitle);
      expect(todos[0].description, updatedDescription);
      expect(todos[0].done, updatedDone);
      expect(todos[0].createdAt, createdAt);
    });
    test("Good case: no update because id is different", () async {
      const updatedTitle = "updatedTitle";
      const updatedDescription = "updatedDescription";
      const updatedDone = true;
      final Todo todo = Todo(
          id: const Uuid().v4(),
          title: updatedTitle,
          description: updatedDescription,
          done: updatedDone,
          createdAt: DateTime.now().toUtc());
      await todosDao.mutate(todo);
      final todos = await todosDao.getAll();
      expect(todos.length, 1);
      expect(todos[0].id, id);
      expect(todos[0].title, title);
      expect(todos[0].description, description);
      expect(todos[0].done, done);
      expect(todos[0].createdAt, createdAt);
    });
  });

  group("Delete a todo", () {
    final id1 = const Uuid().v4();
    final id2 = const Uuid().v4();
    const title = "title";
    const description = "description";
    const done = false;
    final createdAt = DateTime.now().toUtc();
    setUp(() async {
      TodosCompanion todosCompanion = TodosCompanion(
          id: Value(id1),
          title: const Value(title),
          description: const Value(description),
          done: const Value(done),
          createdAt: Value(createdAt));
      await todosDao.create(todosCompanion);
      todosCompanion = TodosCompanion(
          id: Value(id2),
          title: const Value("${title}2"),
          description: const Value(description),
          done: const Value(done),
          createdAt: Value(createdAt));
      await todosDao.create(todosCompanion);
    });
    test("Good case", () async {
      await todosDao.remove(id1);
      var todos = await todosDao.getAll();
      expect(todos.length, 1);
      expect(todos[0].id, id2);
      await todosDao.remove(id1);
      todos = await todosDao.getAll();
      expect(todos.length, 1);
      expect(todos[0].id, id2);
    });
  });

  test("Get all todos", () async {
    const title = "title";
    const description = "description";
    const done = false;
    final createdAt1 = DateTime(2020);
    final createdAt2 = DateTime(2019);
    final createdAt3 = DateTime(2018);
    TodosCompanion todosCompanion;
    todosCompanion = TodosCompanion(
        title: Value("${title}2"),
        description: Value("${description}2"),
        done: Value(!done),
        createdAt: Value(createdAt2));
    await todosDao.create(todosCompanion);
    final id3 = Uuid().v4();
    todosCompanion = TodosCompanion(
      id: Value(id3),
      title: Value("${title}3"),
      description: Value("${description}3"),
      done: Value(done),
    );
    await todosDao.create(todosCompanion);
    final id4 = Uuid().v4();
    todosCompanion = TodosCompanion(
        id: Value(id4),
        title: Value("${title}4"),
        description: Value("${description}4"),
        done: Value(!done),
        createdAt: Value(createdAt3));
    await todosDao.create(todosCompanion);
    todosCompanion = TodosCompanion(
        title: Value("${title}1"),
        description: Value("${description}1"),
        done: Value(done),
        createdAt: Value(createdAt1));
    await todosDao.create(todosCompanion);
    await todosDao.remove(id3);
    await todosDao.mutate(Todo(
        id: id4,
        title: "t",
        description: "d",
        done: !done,
        createdAt: DateTime.now()));
    final todos = await todosDao.getAll();
    expect(todos.length, 3);
    expect(Uuid.isValidUUID(fromString: todos[0].id), true);
    expect(todos[0].title, "${title}1");
    expect(todos[0].description, "${description}1");
    expect(todos[0].done, done);
    expect(todos[0].createdAt, createdAt1);
    expect(Uuid.isValidUUID(fromString: todos[0].id), true);
    expect(todos[1].title, "${title}2");
    expect(todos[1].description, "${description}2");
    expect(todos[1].done, !done);
    expect(todos[1].createdAt, createdAt2);
    expect(Uuid.isValidUUID(fromString: todos[0].id), true);
    expect(todos[2].title, "t");
    expect(todos[2].description, "d");
    expect(todos[2].done, !done);
    expect(todos[2].createdAt, createdAt3);
  });

  test("Watch all todos", () async {
    const title = "title";
    const description = "description";
    const done = false;
    final createdAt1 = DateTime(2020);
    final createdAt2 = DateTime(2019);
    final createdAt3 = DateTime(2018);
    TodosCompanion todosCompanion;
    todosCompanion = TodosCompanion(
        title: Value("${title}2"),
        description: Value("${description}2"),
        done: Value(!done),
        createdAt: Value(createdAt2));
    await todosDao.create(todosCompanion);
    final id3 = Uuid().v4();
    todosCompanion = TodosCompanion(
      id: Value(id3),
      title: Value("${title}3"),
      description: Value("${description}3"),
      done: Value(done),
    );
    await todosDao.create(todosCompanion);
    final id4 = Uuid().v4();
    todosCompanion = TodosCompanion(
        id: Value(id4),
        title: Value("${title}4"),
        description: Value("${description}4"),
        done: Value(!done),
        createdAt: Value(createdAt3));
    await todosDao.create(todosCompanion);
    todosCompanion = TodosCompanion(
        title: Value("${title}1"),
        description: Value("${description}1"),
        done: Value(done),
        createdAt: Value(createdAt1));
    await todosDao.create(todosCompanion);
    await todosDao.remove(id3);
    await todosDao.mutate(Todo(
        id: id4,
        title: "t",
        description: "d",
        done: !done,
        createdAt: DateTime.now()));
    final todosStream = todosDao.watchAll();
    final todos = await todosStream.first;
    expect(todos.length, 3);
    expect(Uuid.isValidUUID(fromString: todos[0].id), true);
    expect(todos[0].title, "${title}1");
    expect(todos[0].description, "${description}1");
    expect(todos[0].done, done);
    expect(todos[0].createdAt, createdAt1);
    expect(Uuid.isValidUUID(fromString: todos[0].id), true);
    expect(todos[1].title, "${title}2");
    expect(todos[1].description, "${description}2");
    expect(todos[1].done, !done);
    expect(todos[1].createdAt, createdAt2);
    expect(Uuid.isValidUUID(fromString: todos[0].id), true);
    expect(todos[2].title, "t");
    expect(todos[2].description, "d");
    expect(todos[2].done, !done);
    expect(todos[2].createdAt, createdAt3);
  });
}
