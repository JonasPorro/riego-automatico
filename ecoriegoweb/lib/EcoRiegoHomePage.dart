  import 'dart:io';
  import 'package:drift/drift.dart';
  import 'package:path_provider/path_provider.dart';
  import 'package:drift/native.dart';
  import 'package:path/path.dart' as p;

  part 'EcoRiegoHomePage.g.dart';


  @DriftDatabase(tables: [Mediciones])
  class AppDatabase extends _$AppDatabase {
    AppDatabase(QueryExecutor e) : super(e);

    @override
    int get schemaVersion => 1;

    static AppDatabase? _instance;

    static Future<AppDatabase> getInstance() async {
      if (_instance != null) return _instance!;
      _instance = AppDatabase(await initDatabase());
      return _instance!;
    }

    static Future<QueryExecutor> initDatabase() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'riego_database.db'));
      return NativeDatabase(file);
    }
  }

  @DataClassName('Medicion')
  class Mediciones extends Table {
    IntColumn get id => integer().autoIncrement()();
    DateTimeColumn get fecha_meicion => dateTime()();
    TextColumn get dispositivo => text()();
    RealColumn get valor => real()();
  }
