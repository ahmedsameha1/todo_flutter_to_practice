import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'todos_dao.dart';

part "this_app_drift_database.g.dart";

class Todos extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text()
      .withLength(min: 1, max: 500)
      .check(title.trim().length.isBiggerThanValue(0))();
  TextColumn get description => text()
      .withLength(min: 1, max: 10000)
      .check(title.trim().length.isBiggerThanValue(0))();
  BoolColumn get done => boolean()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Todos], daos: [TodosDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbDirectory = await getApplicationDocumentsDirectory();
    final file = File(join(dbDirectory.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
