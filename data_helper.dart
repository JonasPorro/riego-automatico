import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift_sqflite/drift_sqflite.dart';

part 'app_database.g.dart';
part 'data_helper.g.dart';

@DriftDatabase(tables: [Mediciones])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  static AppDatabase? _instance;

  static Future<AppDatabase> getInstance() async {
    if (_instance != null) return _instance!;

    final dbFolder = await getApplicationDocumentsDirectory();
    final filePath = p.join(dbFolder.path, 'riego_automatico.db');
    final driftDatabase = LazyDatabase(() async {
      return SqfliteQueryExecutor(path: filePath);
    });

    _instance = AppDatabase(driftDatabase);
    return _instance!;
  }

  @override
  int get schemaVersion => 1;
}

class Mediciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get fecha_medicion => dateTime()();
  TextColumn get dispositivo => text()();
  RealColumn get valor => real()();
}
