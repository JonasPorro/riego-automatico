// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EcoRiegoHomePage.dart';

// ignore_for_file: type=lint
class $MedicionesTable extends Mediciones
    with TableInfo<$MedicionesTable, Medicion> {
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
  static const VerificationMeta _fecha_meicionMeta =
      const VerificationMeta('fecha_meicion');
  @override
  late final GeneratedColumn<DateTime> fecha_meicion =
      GeneratedColumn<DateTime>('fecha_meicion', aliasedName, false,
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
  List<GeneratedColumn> get $columns => [id, fecha_meicion, dispositivo, valor];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mediciones';
  @override
  VerificationContext validateIntegrity(Insertable<Medicion> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha_meicion')) {
      context.handle(
          _fecha_meicionMeta,
          fecha_meicion.isAcceptableOrUnknown(
              data['fecha_meicion']!, _fecha_meicionMeta));
    } else if (isInserting) {
      context.missing(_fecha_meicionMeta);
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
  Medicion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicion(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fecha_meicion: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}fecha_meicion'])!,
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

class Medicion extends DataClass implements Insertable<Medicion> {
  final int id;
  final DateTime fecha_meicion;
  final String dispositivo;
  final double valor;
  const Medicion(
      {required this.id,
      required this.fecha_meicion,
      required this.dispositivo,
      required this.valor});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha_meicion'] = Variable<DateTime>(fecha_meicion);
    map['dispositivo'] = Variable<String>(dispositivo);
    map['valor'] = Variable<double>(valor);
    return map;
  }

  MedicionesCompanion toCompanion(bool nullToAbsent) {
    return MedicionesCompanion(
      id: Value(id),
      fecha_meicion: Value(fecha_meicion),
      dispositivo: Value(dispositivo),
      valor: Value(valor),
    );
  }

  factory Medicion.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicion(
      id: serializer.fromJson<int>(json['id']),
      fecha_meicion: serializer.fromJson<DateTime>(json['fecha_meicion']),
      dispositivo: serializer.fromJson<String>(json['dispositivo']),
      valor: serializer.fromJson<double>(json['valor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fecha_meicion': serializer.toJson<DateTime>(fecha_meicion),
      'dispositivo': serializer.toJson<String>(dispositivo),
      'valor': serializer.toJson<double>(valor),
    };
  }

  Medicion copyWith(
          {int? id,
          DateTime? fecha_meicion,
          String? dispositivo,
          double? valor}) =>
      Medicion(
        id: id ?? this.id,
        fecha_meicion: fecha_meicion ?? this.fecha_meicion,
        dispositivo: dispositivo ?? this.dispositivo,
        valor: valor ?? this.valor,
      );
  @override
  String toString() {
    return (StringBuffer('Medicion(')
          ..write('id: $id, ')
          ..write('fecha_meicion: $fecha_meicion, ')
          ..write('dispositivo: $dispositivo, ')
          ..write('valor: $valor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fecha_meicion, dispositivo, valor);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicion &&
          other.id == this.id &&
          other.fecha_meicion == this.fecha_meicion &&
          other.dispositivo == this.dispositivo &&
          other.valor == this.valor);
}

class MedicionesCompanion extends UpdateCompanion<Medicion> {
  final Value<int> id;
  final Value<DateTime> fecha_meicion;
  final Value<String> dispositivo;
  final Value<double> valor;
  const MedicionesCompanion({
    this.id = const Value.absent(),
    this.fecha_meicion = const Value.absent(),
    this.dispositivo = const Value.absent(),
    this.valor = const Value.absent(),
  });
  MedicionesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime fecha_meicion,
    required String dispositivo,
    required double valor,
  })  : fecha_meicion = Value(fecha_meicion),
        dispositivo = Value(dispositivo),
        valor = Value(valor);
  static Insertable<Medicion> custom({
    Expression<int>? id,
    Expression<DateTime>? fecha_meicion,
    Expression<String>? dispositivo,
    Expression<double>? valor,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fecha_meicion != null) 'fecha_meicion': fecha_meicion,
      if (dispositivo != null) 'dispositivo': dispositivo,
      if (valor != null) 'valor': valor,
    });
  }

  MedicionesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? fecha_meicion,
      Value<String>? dispositivo,
      Value<double>? valor}) {
    return MedicionesCompanion(
      id: id ?? this.id,
      fecha_meicion: fecha_meicion ?? this.fecha_meicion,
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
    if (fecha_meicion.present) {
      map['fecha_meicion'] = Variable<DateTime>(fecha_meicion.value);
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
          ..write('fecha_meicion: $fecha_meicion, ')
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
  required DateTime fecha_meicion,
  required String dispositivo,
  required double valor,
});
typedef $$MedicionesTableUpdateCompanionBuilder = MedicionesCompanion Function({
  Value<int> id,
  Value<DateTime> fecha_meicion,
  Value<String> dispositivo,
  Value<double> valor,
});

class $$MedicionesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicionesTable,
    Medicion,
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
            Value<DateTime> fecha_meicion = const Value.absent(),
            Value<String> dispositivo = const Value.absent(),
            Value<double> valor = const Value.absent(),
          }) =>
              MedicionesCompanion(
            id: id,
            fecha_meicion: fecha_meicion,
            dispositivo: dispositivo,
            valor: valor,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required DateTime fecha_meicion,
            required String dispositivo,
            required double valor,
          }) =>
              MedicionesCompanion.insert(
            id: id,
            fecha_meicion: fecha_meicion,
            dispositivo: dispositivo,
            valor: valor,
          ),
        ));
}

class $$MedicionesTableProcessedTableManager extends ProcessedTableManager<
    _$AppDatabase,
    $MedicionesTable,
    Medicion,
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

  ColumnFilters<DateTime> get fecha_meicion => $state.composableBuilder(
      column: $state.table.fecha_meicion,
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

  ColumnOrderings<DateTime> get fecha_meicion => $state.composableBuilder(
      column: $state.table.fecha_meicion,
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
