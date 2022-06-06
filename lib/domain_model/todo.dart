import 'package:todo_flutter_to_practice/domain_model/value_classes/todo_id_string.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'todo.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required TodoIdString id,
    required String title,
    required String description,
    required bool done,
  }) = _Todo;
}
