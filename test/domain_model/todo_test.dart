import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/domain_model/todo.dart';

main() {
  final regexp = RegExp(
      "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}");
  test("id is a valid UUID", () {
    final todo = getInstanceOfTodo();
    final id = todo.id;
    expect(regexp.hasMatch(id), true);
  });
  group("title field tests", () {
    test("title isn't an emtpy string", () {
      expect(
          () => getInstanceOfTodo(title: ""),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == "An empty String" &&
              e.name == "title")));
    });
    test("title field length isn't smaller than 3 characters", () {
      expect(
          () => getInstanceOfTodo(title: "tf"),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == "length is smaller than 3 characters" &&
              e.name == "title")));
    });
    test("title field get the correct value", () {
      final todo = getInstanceOfTodo(title: "title");
      expect(todo.title, "title");
    });
  });
  group("project field tests", () {
    test("project isn't an empty string", () {
      expect(
          () => getInstanceOfTodo(project: ""),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == "An empty String" &&
              e.name == "project")));
    });
    test("project field length isn't smaller than 3 characters", () {
      expect(
          () => getInstanceOfTodo(project: 'tf'),
          throwsA(predicate((e) =>
              e is ArgumentError &&
              e.message == "length is smaller than 3 characters" &&
              e.name == "project")));
    });
    test("project field get the correct value", () {
      final todo = getInstanceOfTodo(project: "project");
      expect(todo.project, "project");
    });
  });
  // This is for completeness. It's unneeded
  test("done field get the correct value", () {
    final todo = getInstanceOfTodo(done: true);
    expect(todo.done, true);
  });
}

Todo getInstanceOfTodo(
    {String title = "title", String project = "project", bool done = false}) {
  return Todo(title, project, done);
}
