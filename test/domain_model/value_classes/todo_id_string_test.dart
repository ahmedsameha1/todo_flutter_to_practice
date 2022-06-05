import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:uuid/uuid.dart';

main() {
  test("id must be a valid UUID", () {
    expect(
        () => TodoIdString(""),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message == "value is not a valid UUID" &&
            e.name == "value")));
    expect(
        () => TodoIdString("t[ewhwqhgf"),
        throwsA(predicate((e) =>
            e is ArgumentError &&
            e.message == "value is not a valid UUID" &&
            e.name == "value")));
    expect(() => TodoIdString(const Uuid().v4()), isNot(throwsArgumentError));
  });

  test("toString() return the value field", () {
    var uuid = const Uuid().v4();
    var todoidstring = TodoIdString(uuid);
    expect(todoidstring.toString(), uuid);
  });

  test("Two opjects with equal value fileds are equal", () {
    var uuid = const Uuid().v4();
    var obj1 = TodoIdString(uuid);
    var obj2 = TodoIdString(uuid);
    expect(obj1, equals(obj2));
  });
  test("testing hashCode()", () {
    var uuid = const Uuid().v4();
    var todoidstring = TodoIdString(uuid);
    expect(todoidstring.hashCode,
        Object.hash(todoidstring.runtimeType, todoidstring.value));
  });
}
