// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_helper.dart';

// ignore_for_file: type=lint
class $MedicionesTable extends Mediciones
    with TableInfo<$MedicionesTable, Medicione> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicionesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fecha_medicionMeta =
      const VerificationMeta('fecha_medicion');
  @override
  late final GeneratedColumn<DateTime> fecha_medicion =
      GeneratedColumn<DateTime>('fecha_medicion', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _dispositivoMeta =
      const VerificationMeta('dispositivo');
  @override
  late final GeneratedColumn<String> dispositivo = GeneratedColumn<String>(
      'dispositivo', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valorMeta = const VerificationMeta('valor');
  @override
  late final GeneratedColumn<double> valor = GeneratedColumn<double>(
      'valor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fecha_medicion, dispositivo, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mediciones';
  @override
  VerificationContext validateIntegrity(Insertable<Medicione> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha_medicion')) {
      context.handle(
          _fecha_medicionMeta,
          fecha_medicion.isAcceptableOrUnknown(
              data['fecha_medicion']!, _fecha_medicionMeta));
    } else if (isInserting) {
      context.missing(_fecha_medicionMeta);
    }
    if (data.containsKey('dispositivo')) {
      context.handle(
          _dispositivoMeta,
          dispositivo.isAcceptableOrUnknown(
              data['dispositivo']!, _dispositivoMeta));
    } else if (isInserting) {
      context.missing(_dispositivoMeta);
    }
    if (data.containsKey('valor')) {
      context.handle(
          _valorMeta, valor.isAcceptableOrUnknown(data['valor']!, _valorMeta));
    } else if (isInserting) {
      context.missing(_valorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medicione map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicione(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fecha_medicion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_medicion'])!,
      dispositivo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dispositivo'])!,
      valor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}valor'])!,
    );
  }

  @override
  $MedicionesTable createAlias(String alias) {
    return $MedicionesTable(attachedDatabase, alias);
  }
}

class Medicione extends DataClass implements Insertable<Medicione> {
  final int id;
  final DateTime fecha_medicion;
  final String dispositivo;
  final double valor;
  const Medicione(
      {required this.id,
      required this.fecha_medicion,
      required this.dispositivo,
      required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha_medicion'] = Variable<DateTime>(fecha_medicion);
    map['dispositivo'] = Variable<String>(dispositivo);
    map['valor'] = Variable<double>(valor);
    return map;
  }

  MedicionesCompanion toCompanion(bool nullToAbsent) {
    return MedicionesCompanion(
      id: Value(id),
      fecha_medicion: Value(fecha_medicion),
      dispositivo: Value(dispositivo),
      valor: Value(valor),
    );
  }

  factory Medicione.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicione(
      id: serializer.fromJson<int>(json['id']),
      fecha_medicion: serializer.fromJson<DateTime>(json['fecha_medicion']),
      dispositivo: serializer.fromJson<String>(json['dispositivo']),
      valor: serializer.fromJson<double>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fecha_medicion': serializer.toJson<DateTime>(fecha_medicion),
      'dispositivo': serializer.toJson<String>(dispositivo),
      'valor': serializer.toJson<double>(valor),
    };
  }

  Medicione copyWith(
          {int? id,
          DateTime? fecha_medicion,
          String? dispositivo,
          double? valor}) =>
      Medicione(
        id: id ?? this.id,
        fecha_medicion: fecha_medicion ?? this.fecha_medicion,
        dispositivo: dispositivo ?? this.dispositivo,
        valor: valor ?? this.valor,
      );
  @override
  String toString() {
    return (StringBuffer('Medicione(')
          ..write('id: $id, ')
          ..write('fecha_medicion: $fecha_medicion, ')
          ..write('dispositivo: $dispositivo, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fecha_medicion, dispositivo, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicione &&
          other.id == this.id &&
          other.fecha_medicion == this.fecha_medicion &&
          other.dispositivo == this.dispositivo &&
          other.valor == this.valor);
}

class MedicionesCompanion extends UpdateCompanion<Medicione> {
  final Value<int> id;
  final Value<DateTime> fecha_medicion;
  final Value<String> dispositivo;
  final Value<double> valor;
  const MedicionesCompanion({
    this.id = const Value.absent(),
    this.fecha_medicion = const Value.absent(),
    this.dispositivo = const Value.absent(),
    this.valor = const Value.absent(),
  });
  MedicionesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime fecha_medicion,
    required String dispositivo,
    required double valor,
  })  : fecha_medicion = Value(fecha_medicion),
        dispositivo = Value(dispositivo),
        valor = Value(valor);
  static Insertable<Medicione> custom({
    Expression<int>? id,
    Expression<DateTime>? fecha_medicion,
    Expression<String>? dispositivo,
    Expression<double>? valor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fecha_medicion != null) 'fecha_medicion': fecha_medicion,
      if (dispositivo != null) 'dispositivo': dispositivo,
      if (valor != null) 'valor': valor,
    });
  }

  MedicionesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? fecha_medicion,
      Value<String>? dispositivo,
      Value<double>? valor}) {
    return MedicionesCompanion(
      id: id ?? this.id,
      fecha_medicion: fecha_medicion ?? this.fecha_medicion,
      dispositivo: dispositivo ?? this.dispositivo,
      valor: valor ?? this.valor,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fecha_medicion.present) {
      map['fecha_medicion'] = Variable<DateTime>(fecha_medicion.value);
    }
    if (dispositivo.present) {
      map['dispositivo'] = Variable<String>(dispositivo.value);
    }
    if (valor.present) {
      map['valor'] = Variable<double>(valor.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicionesCompanion(')
          ..write('id: $id, ')
          ..write('fecha_medicion: $fecha_medicion, ')
          ..write('dispositivo: $dispositivo, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  _$AppDatabaseManager get managers => _$AppDatabaseManager(this);
  late final $MedicionesTable mediciones = $MedicionesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [mediciones];
}

typedef $$MedicionesTableInsertCompanionBuilder = MedicionesCompanion Function({
  Value<int> id,
  required DateTime fecha_medicion,
  required String dispositivo,
  required double valor,
});
typedef $$MedicionesTableUpdateCompanionBuilder = MedicionesCompanion Function({
  Value<int> id,
  Value<DateTime> fecha_medicion,
  Value<String> dispositivo,
  Value<double> valor,
});

class $$MedicionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicionesTable,
    Medicione,
    $$MedicionesTableFilterComposer,
    $$MedicionesTableOrderingComposer,
    $$MedicionesTableProcessedTableManager,
    $$MedicionesTableInsertCompanionBuilder,
    $$MedicionesTableUpdateCompanionBuilder> {
  $$MedicionesTableTableManager(_$AppDatabase db, $MedicionesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$MedicionesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$MedicionesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$MedicionesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> fecha_medicion = const Value.absent(),
            Value<String> dispositivo = const Value.absent(),
            Value<double> valor = const Value.absent(),
          }) =>
              MedicionesCompanion(
            id: id,
            fecha_medicion: fecha_medicion,
            dispositivo: dispositivo,
            valor: valor,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required DateTime fecha_medicion,
            required String dispositivo,
            required double valor,
          }) =>
              MedicionesCompanion.insert(
            id: id,
            fecha_medicion: fecha_medicion,
            dispositivo: dispositivo,
            valor: valor,
          ),
        ));
}

class $$MedicionesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $MedicionesTable,
    Medicione,
    $$MedicionesTableFilterComposer,
    $$MedicionesTableOrderingComposer,
    $$MedicionesTableProcessedTableManager,
    $$MedicionesTableInsertCompanionBuilder,
    $$MedicionesTableUpdateCompanionBuilder> {
  $$MedicionesTableProcessedTableManager(super.$state);
}

class $$MedicionesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $MedicionesTable> {
  $$MedicionesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get fecha_medicion => $state.composableBuilder(
      column: $state.table.fecha_medicion,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get dispositivo => $state.composableBuilder(
      column: $state.table.dispositivo,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get valor => $state.composableBuilder(
      column: $state.table.valor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$MedicionesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $MedicionesTable> {
  $$MedicionesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get fecha_medicion => $state.composableBuilder(
      column: $state.table.fecha_medicion,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get dispositivo => $state.composableBuilder(
      column: $state.table.dispositivo,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get valor => $state.composableBuilder(
      column: $state.table.valor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$AppDatabaseManager {
  final _$AppDatabase _db;
  _$AppDatabaseManager(this._db);
  $$MedicionesTableTableManager get mediciones =>
      $$MedicionesTableTableManager(_db, _db.mediciones);
}
