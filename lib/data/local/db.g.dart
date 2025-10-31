// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $AnimalsTable extends Animals with TableInfo<$AnimalsTable, Animal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eidMeta = const VerificationMeta('eid');
  @override
  late final GeneratedColumn<String> eid = GeneratedColumn<String>(
      'eid', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 128),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _officialNumberMeta =
      const VerificationMeta('officialNumber');
  @override
  late final GeneratedColumn<String> officialNumber = GeneratedColumn<String>(
      'official_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthDateMeta =
      const VerificationMeta('birthDate');
  @override
  late final GeneratedColumn<String> birthDate = GeneratedColumn<String>(
      'birth_date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
      'sex', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 16),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _motherIdMeta =
      const VerificationMeta('motherId');
  @override
  late final GeneratedColumn<String> motherId = GeneratedColumn<String>(
      'mother_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<int> days = GeneratedColumn<int>(
      'days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        eid,
        officialNumber,
        birthDate,
        sex,
        motherId,
        status,
        createdAt,
        updatedAt,
        days,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'animals';
  @override
  VerificationContext validateIntegrity(Insertable<Animal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('eid')) {
      context.handle(
          _eidMeta, eid.isAcceptableOrUnknown(data['eid']!, _eidMeta));
    } else if (isInserting) {
      context.missing(_eidMeta);
    }
    if (data.containsKey('official_number')) {
      context.handle(
          _officialNumberMeta,
          officialNumber.isAcceptableOrUnknown(
              data['official_number']!, _officialNumberMeta));
    }
    if (data.containsKey('birth_date')) {
      context.handle(_birthDateMeta,
          birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta));
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
          _sexMeta, sex.isAcceptableOrUnknown(data['sex']!, _sexMeta));
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('mother_id')) {
      context.handle(_motherIdMeta,
          motherId.isAcceptableOrUnknown(data['mother_id']!, _motherIdMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('days')) {
      context.handle(
          _daysMeta, days.isAcceptableOrUnknown(data['days']!, _daysMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Animal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Animal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      eid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}eid'])!,
      officialNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}official_number']),
      birthDate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}birth_date'])!,
      sex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex'])!,
      motherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mother_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}updated_at'])!,
      days: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days']),
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $AnimalsTable createAlias(String alias) {
    return $AnimalsTable(attachedDatabase, alias);
  }
}

class Animal extends DataClass implements Insertable<Animal> {
  final String id;
  final String eid;
  final String? officialNumber;
  final String birthDate;
  final String sex;
  final String? motherId;
  final String status;
  final String createdAt;
  final String updatedAt;
  final int? days;
  final bool isDeleted;
  const Animal(
      {required this.id,
      required this.eid,
      this.officialNumber,
      required this.birthDate,
      required this.sex,
      this.motherId,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      this.days,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['eid'] = Variable<String>(eid);
    if (!nullToAbsent || officialNumber != null) {
      map['official_number'] = Variable<String>(officialNumber);
    }
    map['birth_date'] = Variable<String>(birthDate);
    map['sex'] = Variable<String>(sex);
    if (!nullToAbsent || motherId != null) {
      map['mother_id'] = Variable<String>(motherId);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    if (!nullToAbsent || days != null) {
      map['days'] = Variable<int>(days);
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  AnimalsCompanion toCompanion(bool nullToAbsent) {
    return AnimalsCompanion(
      id: Value(id),
      eid: Value(eid),
      officialNumber: officialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(officialNumber),
      birthDate: Value(birthDate),
      sex: Value(sex),
      motherId: motherId == null && nullToAbsent
          ? const Value.absent()
          : Value(motherId),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      days: days == null && nullToAbsent ? const Value.absent() : Value(days),
      isDeleted: Value(isDeleted),
    );
  }

  factory Animal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Animal(
      id: serializer.fromJson<String>(json['id']),
      eid: serializer.fromJson<String>(json['eid']),
      officialNumber: serializer.fromJson<String?>(json['officialNumber']),
      birthDate: serializer.fromJson<String>(json['birthDate']),
      sex: serializer.fromJson<String>(json['sex']),
      motherId: serializer.fromJson<String?>(json['motherId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
      days: serializer.fromJson<int?>(json['days']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'eid': serializer.toJson<String>(eid),
      'officialNumber': serializer.toJson<String?>(officialNumber),
      'birthDate': serializer.toJson<String>(birthDate),
      'sex': serializer.toJson<String>(sex),
      'motherId': serializer.toJson<String?>(motherId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
      'days': serializer.toJson<int?>(days),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Animal copyWith(
          {String? id,
          String? eid,
          Value<String?> officialNumber = const Value.absent(),
          String? birthDate,
          String? sex,
          Value<String?> motherId = const Value.absent(),
          String? status,
          String? createdAt,
          String? updatedAt,
          Value<int?> days = const Value.absent(),
          bool? isDeleted}) =>
      Animal(
        id: id ?? this.id,
        eid: eid ?? this.eid,
        officialNumber:
            officialNumber.present ? officialNumber.value : this.officialNumber,
        birthDate: birthDate ?? this.birthDate,
        sex: sex ?? this.sex,
        motherId: motherId.present ? motherId.value : this.motherId,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        days: days.present ? days.value : this.days,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Animal copyWithCompanion(AnimalsCompanion data) {
    return Animal(
      id: data.id.present ? data.id.value : this.id,
      eid: data.eid.present ? data.eid.value : this.eid,
      officialNumber: data.officialNumber.present
          ? data.officialNumber.value
          : this.officialNumber,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      sex: data.sex.present ? data.sex.value : this.sex,
      motherId: data.motherId.present ? data.motherId.value : this.motherId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      days: data.days.present ? data.days.value : this.days,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Animal(')
          ..write('id: $id, ')
          ..write('eid: $eid, ')
          ..write('officialNumber: $officialNumber, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('motherId: $motherId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('days: $days, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, eid, officialNumber, birthDate, sex,
      motherId, status, createdAt, updatedAt, days, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Animal &&
          other.id == this.id &&
          other.eid == this.eid &&
          other.officialNumber == this.officialNumber &&
          other.birthDate == this.birthDate &&
          other.sex == this.sex &&
          other.motherId == this.motherId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.days == this.days &&
          other.isDeleted == this.isDeleted);
}

class AnimalsCompanion extends UpdateCompanion<Animal> {
  final Value<String> id;
  final Value<String> eid;
  final Value<String?> officialNumber;
  final Value<String> birthDate;
  final Value<String> sex;
  final Value<String?> motherId;
  final Value<String> status;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  final Value<int?> days;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const AnimalsCompanion({
    this.id = const Value.absent(),
    this.eid = const Value.absent(),
    this.officialNumber = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.sex = const Value.absent(),
    this.motherId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.days = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnimalsCompanion.insert({
    required String id,
    required String eid,
    this.officialNumber = const Value.absent(),
    required String birthDate,
    required String sex,
    this.motherId = const Value.absent(),
    required String status,
    required String createdAt,
    required String updatedAt,
    this.days = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        eid = Value(eid),
        birthDate = Value(birthDate),
        sex = Value(sex),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<Animal> custom({
    Expression<String>? id,
    Expression<String>? eid,
    Expression<String>? officialNumber,
    Expression<String>? birthDate,
    Expression<String>? sex,
    Expression<String>? motherId,
    Expression<String>? status,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
    Expression<int>? days,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eid != null) 'eid': eid,
      if (officialNumber != null) 'official_number': officialNumber,
      if (birthDate != null) 'birth_date': birthDate,
      if (sex != null) 'sex': sex,
      if (motherId != null) 'mother_id': motherId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (days != null) 'days': days,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnimalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? eid,
      Value<String?>? officialNumber,
      Value<String>? birthDate,
      Value<String>? sex,
      Value<String?>? motherId,
      Value<String>? status,
      Value<String>? createdAt,
      Value<String>? updatedAt,
      Value<int?>? days,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return AnimalsCompanion(
      id: id ?? this.id,
      eid: eid ?? this.eid,
      officialNumber: officialNumber ?? this.officialNumber,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      motherId: motherId ?? this.motherId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      days: days ?? this.days,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (eid.present) {
      map['eid'] = Variable<String>(eid.value);
    }
    if (officialNumber.present) {
      map['official_number'] = Variable<String>(officialNumber.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<String>(birthDate.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (motherId.present) {
      map['mother_id'] = Variable<String>(motherId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    if (days.present) {
      map['days'] = Variable<int>(days.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimalsCompanion(')
          ..write('id: $id, ')
          ..write('eid: $eid, ')
          ..write('officialNumber: $officialNumber, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('motherId: $motherId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('days: $days, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AnimalsTable animals = $AnimalsTable(this);
  late final AnimalDao animalDao = AnimalDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [animals];
}

typedef $$AnimalsTableCreateCompanionBuilder = AnimalsCompanion Function({
  required String id,
  required String eid,
  Value<String?> officialNumber,
  required String birthDate,
  required String sex,
  Value<String?> motherId,
  required String status,
  required String createdAt,
  required String updatedAt,
  Value<int?> days,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$AnimalsTableUpdateCompanionBuilder = AnimalsCompanion Function({
  Value<String> id,
  Value<String> eid,
  Value<String?> officialNumber,
  Value<String> birthDate,
  Value<String> sex,
  Value<String?> motherId,
  Value<String> status,
  Value<String> createdAt,
  Value<String> updatedAt,
  Value<int?> days,
  Value<bool> isDeleted,
  Value<int> rowid,
});

class $$AnimalsTableFilterComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eid => $composableBuilder(
      column: $table.eid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get officialNumber => $composableBuilder(
      column: $table.officialNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherId => $composableBuilder(
      column: $table.motherId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$AnimalsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eid => $composableBuilder(
      column: $table.eid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get officialNumber => $composableBuilder(
      column: $table.officialNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherId => $composableBuilder(
      column: $table.motherId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$AnimalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnimalsTable> {
  $$AnimalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eid =>
      $composableBuilder(column: $table.eid, builder: (column) => column);

  GeneratedColumn<String> get officialNumber => $composableBuilder(
      column: $table.officialNumber, builder: (column) => column);

  GeneratedColumn<String> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get motherId =>
      $composableBuilder(column: $table.motherId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$AnimalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnimalsTable,
    Animal,
    $$AnimalsTableFilterComposer,
    $$AnimalsTableOrderingComposer,
    $$AnimalsTableAnnotationComposer,
    $$AnimalsTableCreateCompanionBuilder,
    $$AnimalsTableUpdateCompanionBuilder,
    (Animal, BaseReferences<_$AppDatabase, $AnimalsTable, Animal>),
    Animal,
    PrefetchHooks Function()> {
  $$AnimalsTableTableManager(_$AppDatabase db, $AnimalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnimalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnimalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnimalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> eid = const Value.absent(),
            Value<String?> officialNumber = const Value.absent(),
            Value<String> birthDate = const Value.absent(),
            Value<String> sex = const Value.absent(),
            Value<String?> motherId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<String> updatedAt = const Value.absent(),
            Value<int?> days = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnimalsCompanion(
            id: id,
            eid: eid,
            officialNumber: officialNumber,
            birthDate: birthDate,
            sex: sex,
            motherId: motherId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            days: days,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String eid,
            Value<String?> officialNumber = const Value.absent(),
            required String birthDate,
            required String sex,
            Value<String?> motherId = const Value.absent(),
            required String status,
            required String createdAt,
            required String updatedAt,
            Value<int?> days = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnimalsCompanion.insert(
            id: id,
            eid: eid,
            officialNumber: officialNumber,
            birthDate: birthDate,
            sex: sex,
            motherId: motherId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            days: days,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AnimalsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AnimalsTable,
    Animal,
    $$AnimalsTableFilterComposer,
    $$AnimalsTableOrderingComposer,
    $$AnimalsTableAnnotationComposer,
    $$AnimalsTableCreateCompanionBuilder,
    $$AnimalsTableUpdateCompanionBuilder,
    (Animal, BaseReferences<_$AppDatabase, $AnimalsTable, Animal>),
    Animal,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AnimalsTableTableManager get animals =>
      $$AnimalsTableTableManager(_db, _db.animals);
}
