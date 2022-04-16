import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String title;
  final String project;
  final bool done;
  Todo(this.title, this.project, this.done) : id = const Uuid().v4() {
    // title validation
    if (title.isEmpty) {
      throw ArgumentError("An empty String", "title");
    }
    if (title.length < 3) {
      throw ArgumentError("length is smaller than 3 characters", "title");
    }
    // project validation
    if (project.isEmpty) {
      throw ArgumentError("An empty String", "project");
    }
    if (project.length < 3) {
      throw ArgumentError("length is smaller than 3 characters", "project");
    }
  }
}
