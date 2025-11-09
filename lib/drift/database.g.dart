// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $FarmsTableTable extends FarmsTable
    with TableInfo<$FarmsTableTable, FarmsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FarmsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _locationMeta =
      const VerificationMeta('location');
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
      'location', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ownerIdMeta =
      const VerificationMeta('ownerId');
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
      'owner_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cheptelNumberMeta =
      const VerificationMeta('cheptelNumber');
  @override
  late final GeneratedColumn<String> cheptelNumber = GeneratedColumn<String>(
      'cheptel_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupNameMeta =
      const VerificationMeta('groupName');
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
      'group_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        location,
        ownerId,
        cheptelNumber,
        groupId,
        groupName,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'farms';
  @override
  VerificationContext validateIntegrity(Insertable<FarmsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    } else if (isInserting) {
      context.missing(_locationMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(_ownerIdMeta,
          ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta));
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('cheptel_number')) {
      context.handle(
          _cheptelNumberMeta,
          cheptelNumber.isAcceptableOrUnknown(
              data['cheptel_number']!, _cheptelNumberMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('group_name')) {
      context.handle(_groupNameMeta,
          groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FarmsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FarmsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      location: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}location'])!,
      ownerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}owner_id'])!,
      cheptelNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cheptel_number']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      groupName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $FarmsTableTable createAlias(String alias) {
    return $FarmsTableTable(attachedDatabase, alias);
  }
}

class FarmsTableData extends DataClass implements Insertable<FarmsTableData> {
  final String id;
  final String name;
  final String location;
  final String ownerId;
  final String? cheptelNumber;
  final String? groupId;
  final String? groupName;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FarmsTableData(
      {required this.id,
      required this.name,
      required this.location,
      required this.ownerId,
      this.cheptelNumber,
      this.groupId,
      this.groupName,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['location'] = Variable<String>(location);
    map['owner_id'] = Variable<String>(ownerId);
    if (!nullToAbsent || cheptelNumber != null) {
      map['cheptel_number'] = Variable<String>(cheptelNumber);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    if (!nullToAbsent || groupName != null) {
      map['group_name'] = Variable<String>(groupName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FarmsTableCompanion toCompanion(bool nullToAbsent) {
    return FarmsTableCompanion(
      id: Value(id),
      name: Value(name),
      location: Value(location),
      ownerId: Value(ownerId),
      cheptelNumber: cheptelNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(cheptelNumber),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      groupName: groupName == null && nullToAbsent
          ? const Value.absent()
          : Value(groupName),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FarmsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FarmsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String>(json['location']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      cheptelNumber: serializer.fromJson<String?>(json['cheptelNumber']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      groupName: serializer.fromJson<String?>(json['groupName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String>(location),
      'ownerId': serializer.toJson<String>(ownerId),
      'cheptelNumber': serializer.toJson<String?>(cheptelNumber),
      'groupId': serializer.toJson<String?>(groupId),
      'groupName': serializer.toJson<String?>(groupName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FarmsTableData copyWith(
          {String? id,
          String? name,
          String? location,
          String? ownerId,
          Value<String?> cheptelNumber = const Value.absent(),
          Value<String?> groupId = const Value.absent(),
          Value<String?> groupName = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      FarmsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        ownerId: ownerId ?? this.ownerId,
        cheptelNumber:
            cheptelNumber.present ? cheptelNumber.value : this.cheptelNumber,
        groupId: groupId.present ? groupId.value : this.groupId,
        groupName: groupName.present ? groupName.value : this.groupName,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  FarmsTableData copyWithCompanion(FarmsTableCompanion data) {
    return FarmsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      cheptelNumber: data.cheptelNumber.present
          ? data.cheptelNumber.value
          : this.cheptelNumber,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FarmsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('ownerId: $ownerId, ')
          ..write('cheptelNumber: $cheptelNumber, ')
          ..write('groupId: $groupId, ')
          ..write('groupName: $groupName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, location, ownerId, cheptelNumber,
      groupId, groupName, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FarmsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.location == this.location &&
          other.ownerId == this.ownerId &&
          other.cheptelNumber == this.cheptelNumber &&
          other.groupId == this.groupId &&
          other.groupName == this.groupName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FarmsTableCompanion extends UpdateCompanion<FarmsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> location;
  final Value<String> ownerId;
  final Value<String?> cheptelNumber;
  final Value<String?> groupId;
  final Value<String?> groupName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FarmsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.cheptelNumber = const Value.absent(),
    this.groupId = const Value.absent(),
    this.groupName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FarmsTableCompanion.insert({
    required String id,
    required String name,
    required String location,
    required String ownerId,
    this.cheptelNumber = const Value.absent(),
    this.groupId = const Value.absent(),
    this.groupName = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        location = Value(location),
        ownerId = Value(ownerId),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<FarmsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<String>? ownerId,
    Expression<String>? cheptelNumber,
    Expression<String>? groupId,
    Expression<String>? groupName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (ownerId != null) 'owner_id': ownerId,
      if (cheptelNumber != null) 'cheptel_number': cheptelNumber,
      if (groupId != null) 'group_id': groupId,
      if (groupName != null) 'group_name': groupName,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FarmsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? location,
      Value<String>? ownerId,
      Value<String?>? cheptelNumber,
      Value<String?>? groupId,
      Value<String?>? groupName,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return FarmsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      ownerId: ownerId ?? this.ownerId,
      cheptelNumber: cheptelNumber ?? this.cheptelNumber,
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (cheptelNumber.present) {
      map['cheptel_number'] = Variable<String>(cheptelNumber.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FarmsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('ownerId: $ownerId, ')
          ..write('cheptelNumber: $cheptelNumber, ')
          ..write('groupId: $groupId, ')
          ..write('groupName: $groupName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AnimalsTableTable extends AnimalsTable
    with TableInfo<$AnimalsTableTable, AnimalsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _currentEidMeta =
      const VerificationMeta('currentEid');
  @override
  late final GeneratedColumn<String> currentEid = GeneratedColumn<String>(
      'current_eid', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _officialNumberMeta =
      const VerificationMeta('officialNumber');
  @override
  late final GeneratedColumn<String> officialNumber = GeneratedColumn<String>(
      'official_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _visualIdMeta =
      const VerificationMeta('visualId');
  @override
  late final GeneratedColumn<String> visualId = GeneratedColumn<String>(
      'visual_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _eidHistoryMeta =
      const VerificationMeta('eidHistory');
  @override
  late final GeneratedColumn<String> eidHistory = GeneratedColumn<String>(
      'eid_history', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _birthDateMeta =
      const VerificationMeta('birthDate');
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
      'birth_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
      'sex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speciesIdMeta =
      const VerificationMeta('speciesId');
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
      'species_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _breedIdMeta =
      const VerificationMeta('breedId');
  @override
  late final GeneratedColumn<String> breedId = GeneratedColumn<String>(
      'breed_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _photoUrlMeta =
      const VerificationMeta('photoUrl');
  @override
  late final GeneratedColumn<String> photoUrl = GeneratedColumn<String>(
      'photo_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _daysMeta = const VerificationMeta('days');
  @override
  late final GeneratedColumn<int> days = GeneratedColumn<int>(
      'days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverVersionMeta =
      const VerificationMeta('serverVersion');
  @override
  late final GeneratedColumn<String> serverVersion = GeneratedColumn<String>(
      'server_version', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        currentEid,
        officialNumber,
        visualId,
        eidHistory,
        birthDate,
        sex,
        motherId,
        status,
        speciesId,
        breedId,
        photoUrl,
        days,
        synced,
        lastSyncedAt,
        serverVersion,
        deletedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'animals';
  @override
  VerificationContext validateIntegrity(Insertable<AnimalsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('current_eid')) {
      context.handle(
          _currentEidMeta,
          currentEid.isAcceptableOrUnknown(
              data['current_eid']!, _currentEidMeta));
    }
    if (data.containsKey('official_number')) {
      context.handle(
          _officialNumberMeta,
          officialNumber.isAcceptableOrUnknown(
              data['official_number']!, _officialNumberMeta));
    }
    if (data.containsKey('visual_id')) {
      context.handle(_visualIdMeta,
          visualId.isAcceptableOrUnknown(data['visual_id']!, _visualIdMeta));
    }
    if (data.containsKey('eid_history')) {
      context.handle(
          _eidHistoryMeta,
          eidHistory.isAcceptableOrUnknown(
              data['eid_history']!, _eidHistoryMeta));
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
    if (data.containsKey('species_id')) {
      context.handle(_speciesIdMeta,
          speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta));
    }
    if (data.containsKey('breed_id')) {
      context.handle(_breedIdMeta,
          breedId.isAcceptableOrUnknown(data['breed_id']!, _breedIdMeta));
    }
    if (data.containsKey('photo_url')) {
      context.handle(_photoUrlMeta,
          photoUrl.isAcceptableOrUnknown(data['photo_url']!, _photoUrlMeta));
    }
    if (data.containsKey('days')) {
      context.handle(
          _daysMeta, days.isAcceptableOrUnknown(data['days']!, _daysMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('server_version')) {
      context.handle(
          _serverVersionMeta,
          serverVersion.isAcceptableOrUnknown(
              data['server_version']!, _serverVersionMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnimalsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnimalsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      currentEid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}current_eid']),
      officialNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}official_number']),
      visualId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}visual_id']),
      eidHistory: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}eid_history']),
      birthDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}birth_date'])!,
      sex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sex'])!,
      motherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mother_id']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      speciesId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}species_id']),
      breedId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}breed_id']),
      photoUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}photo_url']),
      days: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}days']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_version']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $AnimalsTableTable createAlias(String alias) {
    return $AnimalsTableTable(attachedDatabase, alias);
  }
}

class AnimalsTableData extends DataClass
    implements Insertable<AnimalsTableData> {
  final String id;
  final String farmId;
  final String? currentEid;
  final String? officialNumber;
  final String? visualId;
  final String? eidHistory;
  final DateTime birthDate;
  final String sex;
  final String? motherId;
  final String status;
  final String? speciesId;
  final String? breedId;
  final String? photoUrl;
  final int? days;
  final bool synced;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AnimalsTableData(
      {required this.id,
      required this.farmId,
      this.currentEid,
      this.officialNumber,
      this.visualId,
      this.eidHistory,
      required this.birthDate,
      required this.sex,
      this.motherId,
      required this.status,
      this.speciesId,
      this.breedId,
      this.photoUrl,
      this.days,
      required this.synced,
      this.lastSyncedAt,
      this.serverVersion,
      this.deletedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    if (!nullToAbsent || currentEid != null) {
      map['current_eid'] = Variable<String>(currentEid);
    }
    if (!nullToAbsent || officialNumber != null) {
      map['official_number'] = Variable<String>(officialNumber);
    }
    if (!nullToAbsent || visualId != null) {
      map['visual_id'] = Variable<String>(visualId);
    }
    if (!nullToAbsent || eidHistory != null) {
      map['eid_history'] = Variable<String>(eidHistory);
    }
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['sex'] = Variable<String>(sex);
    if (!nullToAbsent || motherId != null) {
      map['mother_id'] = Variable<String>(motherId);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || speciesId != null) {
      map['species_id'] = Variable<String>(speciesId);
    }
    if (!nullToAbsent || breedId != null) {
      map['breed_id'] = Variable<String>(breedId);
    }
    if (!nullToAbsent || photoUrl != null) {
      map['photo_url'] = Variable<String>(photoUrl);
    }
    if (!nullToAbsent || days != null) {
      map['days'] = Variable<int>(days);
    }
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<String>(serverVersion);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AnimalsTableCompanion toCompanion(bool nullToAbsent) {
    return AnimalsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      currentEid: currentEid == null && nullToAbsent
          ? const Value.absent()
          : Value(currentEid),
      officialNumber: officialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(officialNumber),
      visualId: visualId == null && nullToAbsent
          ? const Value.absent()
          : Value(visualId),
      eidHistory: eidHistory == null && nullToAbsent
          ? const Value.absent()
          : Value(eidHistory),
      birthDate: Value(birthDate),
      sex: Value(sex),
      motherId: motherId == null && nullToAbsent
          ? const Value.absent()
          : Value(motherId),
      status: Value(status),
      speciesId: speciesId == null && nullToAbsent
          ? const Value.absent()
          : Value(speciesId),
      breedId: breedId == null && nullToAbsent
          ? const Value.absent()
          : Value(breedId),
      photoUrl: photoUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(photoUrl),
      days: days == null && nullToAbsent ? const Value.absent() : Value(days),
      synced: Value(synced),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AnimalsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnimalsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      currentEid: serializer.fromJson<String?>(json['currentEid']),
      officialNumber: serializer.fromJson<String?>(json['officialNumber']),
      visualId: serializer.fromJson<String?>(json['visualId']),
      eidHistory: serializer.fromJson<String?>(json['eidHistory']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      sex: serializer.fromJson<String>(json['sex']),
      motherId: serializer.fromJson<String?>(json['motherId']),
      status: serializer.fromJson<String>(json['status']),
      speciesId: serializer.fromJson<String?>(json['speciesId']),
      breedId: serializer.fromJson<String?>(json['breedId']),
      photoUrl: serializer.fromJson<String?>(json['photoUrl']),
      days: serializer.fromJson<int?>(json['days']),
      synced: serializer.fromJson<bool>(json['synced']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      serverVersion: serializer.fromJson<String?>(json['serverVersion']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'currentEid': serializer.toJson<String?>(currentEid),
      'officialNumber': serializer.toJson<String?>(officialNumber),
      'visualId': serializer.toJson<String?>(visualId),
      'eidHistory': serializer.toJson<String?>(eidHistory),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'sex': serializer.toJson<String>(sex),
      'motherId': serializer.toJson<String?>(motherId),
      'status': serializer.toJson<String>(status),
      'speciesId': serializer.toJson<String?>(speciesId),
      'breedId': serializer.toJson<String?>(breedId),
      'photoUrl': serializer.toJson<String?>(photoUrl),
      'days': serializer.toJson<int?>(days),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<String?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AnimalsTableData copyWith(
          {String? id,
          String? farmId,
          Value<String?> currentEid = const Value.absent(),
          Value<String?> officialNumber = const Value.absent(),
          Value<String?> visualId = const Value.absent(),
          Value<String?> eidHistory = const Value.absent(),
          DateTime? birthDate,
          String? sex,
          Value<String?> motherId = const Value.absent(),
          String? status,
          Value<String?> speciesId = const Value.absent(),
          Value<String?> breedId = const Value.absent(),
          Value<String?> photoUrl = const Value.absent(),
          Value<int?> days = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AnimalsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        currentEid: currentEid.present ? currentEid.value : this.currentEid,
        officialNumber:
            officialNumber.present ? officialNumber.value : this.officialNumber,
        visualId: visualId.present ? visualId.value : this.visualId,
        eidHistory: eidHistory.present ? eidHistory.value : this.eidHistory,
        birthDate: birthDate ?? this.birthDate,
        sex: sex ?? this.sex,
        motherId: motherId.present ? motherId.value : this.motherId,
        status: status ?? this.status,
        speciesId: speciesId.present ? speciesId.value : this.speciesId,
        breedId: breedId.present ? breedId.value : this.breedId,
        photoUrl: photoUrl.present ? photoUrl.value : this.photoUrl,
        days: days.present ? days.value : this.days,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AnimalsTableData copyWithCompanion(AnimalsTableCompanion data) {
    return AnimalsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      currentEid:
          data.currentEid.present ? data.currentEid.value : this.currentEid,
      officialNumber: data.officialNumber.present
          ? data.officialNumber.value
          : this.officialNumber,
      visualId: data.visualId.present ? data.visualId.value : this.visualId,
      eidHistory:
          data.eidHistory.present ? data.eidHistory.value : this.eidHistory,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      sex: data.sex.present ? data.sex.value : this.sex,
      motherId: data.motherId.present ? data.motherId.value : this.motherId,
      status: data.status.present ? data.status.value : this.status,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      breedId: data.breedId.present ? data.breedId.value : this.breedId,
      photoUrl: data.photoUrl.present ? data.photoUrl.value : this.photoUrl,
      days: data.days.present ? data.days.value : this.days,
      synced: data.synced.present ? data.synced.value : this.synced,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnimalsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('currentEid: $currentEid, ')
          ..write('officialNumber: $officialNumber, ')
          ..write('visualId: $visualId, ')
          ..write('eidHistory: $eidHistory, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('motherId: $motherId, ')
          ..write('status: $status, ')
          ..write('speciesId: $speciesId, ')
          ..write('breedId: $breedId, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('days: $days, ')
          ..write('synced: $synced, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      farmId,
      currentEid,
      officialNumber,
      visualId,
      eidHistory,
      birthDate,
      sex,
      motherId,
      status,
      speciesId,
      breedId,
      photoUrl,
      days,
      synced,
      lastSyncedAt,
      serverVersion,
      deletedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnimalsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.currentEid == this.currentEid &&
          other.officialNumber == this.officialNumber &&
          other.visualId == this.visualId &&
          other.eidHistory == this.eidHistory &&
          other.birthDate == this.birthDate &&
          other.sex == this.sex &&
          other.motherId == this.motherId &&
          other.status == this.status &&
          other.speciesId == this.speciesId &&
          other.breedId == this.breedId &&
          other.photoUrl == this.photoUrl &&
          other.days == this.days &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AnimalsTableCompanion extends UpdateCompanion<AnimalsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String?> currentEid;
  final Value<String?> officialNumber;
  final Value<String?> visualId;
  final Value<String?> eidHistory;
  final Value<DateTime> birthDate;
  final Value<String> sex;
  final Value<String?> motherId;
  final Value<String> status;
  final Value<String?> speciesId;
  final Value<String?> breedId;
  final Value<String?> photoUrl;
  final Value<int?> days;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AnimalsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.currentEid = const Value.absent(),
    this.officialNumber = const Value.absent(),
    this.visualId = const Value.absent(),
    this.eidHistory = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.sex = const Value.absent(),
    this.motherId = const Value.absent(),
    this.status = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.breedId = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.days = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnimalsTableCompanion.insert({
    required String id,
    required String farmId,
    this.currentEid = const Value.absent(),
    this.officialNumber = const Value.absent(),
    this.visualId = const Value.absent(),
    this.eidHistory = const Value.absent(),
    required DateTime birthDate,
    required String sex,
    this.motherId = const Value.absent(),
    required String status,
    this.speciesId = const Value.absent(),
    this.breedId = const Value.absent(),
    this.photoUrl = const Value.absent(),
    this.days = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        birthDate = Value(birthDate),
        sex = Value(sex),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AnimalsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? currentEid,
    Expression<String>? officialNumber,
    Expression<String>? visualId,
    Expression<String>? eidHistory,
    Expression<DateTime>? birthDate,
    Expression<String>? sex,
    Expression<String>? motherId,
    Expression<String>? status,
    Expression<String>? speciesId,
    Expression<String>? breedId,
    Expression<String>? photoUrl,
    Expression<int>? days,
    Expression<bool>? synced,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? serverVersion,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (currentEid != null) 'current_eid': currentEid,
      if (officialNumber != null) 'official_number': officialNumber,
      if (visualId != null) 'visual_id': visualId,
      if (eidHistory != null) 'eid_history': eidHistory,
      if (birthDate != null) 'birth_date': birthDate,
      if (sex != null) 'sex': sex,
      if (motherId != null) 'mother_id': motherId,
      if (status != null) 'status': status,
      if (speciesId != null) 'species_id': speciesId,
      if (breedId != null) 'breed_id': breedId,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (days != null) 'days': days,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnimalsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String?>? currentEid,
      Value<String?>? officialNumber,
      Value<String?>? visualId,
      Value<String?>? eidHistory,
      Value<DateTime>? birthDate,
      Value<String>? sex,
      Value<String?>? motherId,
      Value<String>? status,
      Value<String?>? speciesId,
      Value<String?>? breedId,
      Value<String?>? photoUrl,
      Value<int?>? days,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<String?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AnimalsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      currentEid: currentEid ?? this.currentEid,
      officialNumber: officialNumber ?? this.officialNumber,
      visualId: visualId ?? this.visualId,
      eidHistory: eidHistory ?? this.eidHistory,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      motherId: motherId ?? this.motherId,
      status: status ?? this.status,
      speciesId: speciesId ?? this.speciesId,
      breedId: breedId ?? this.breedId,
      photoUrl: photoUrl ?? this.photoUrl,
      days: days ?? this.days,
      synced: synced ?? this.synced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (currentEid.present) {
      map['current_eid'] = Variable<String>(currentEid.value);
    }
    if (officialNumber.present) {
      map['official_number'] = Variable<String>(officialNumber.value);
    }
    if (visualId.present) {
      map['visual_id'] = Variable<String>(visualId.value);
    }
    if (eidHistory.present) {
      map['eid_history'] = Variable<String>(eidHistory.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
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
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (breedId.present) {
      map['breed_id'] = Variable<String>(breedId.value);
    }
    if (photoUrl.present) {
      map['photo_url'] = Variable<String>(photoUrl.value);
    }
    if (days.present) {
      map['days'] = Variable<int>(days.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<String>(serverVersion.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimalsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('currentEid: $currentEid, ')
          ..write('officialNumber: $officialNumber, ')
          ..write('visualId: $visualId, ')
          ..write('eidHistory: $eidHistory, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('motherId: $motherId, ')
          ..write('status: $status, ')
          ..write('speciesId: $speciesId, ')
          ..write('breedId: $breedId, ')
          ..write('photoUrl: $photoUrl, ')
          ..write('days: $days, ')
          ..write('synced: $synced, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SpeciesTableTable extends SpeciesTable
    with TableInfo<$SpeciesTableTable, SpeciesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SpeciesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  @override
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
      'name_fr', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nameFr, nameEn, nameAr, icon, displayOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'species';
  @override
  VerificationContext validateIntegrity(Insertable<SpeciesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(_nameFrMeta,
          nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta));
    } else if (isInserting) {
      context.missing(_nameFrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SpeciesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SpeciesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nameFr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_fr'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
    );
  }

  @override
  $SpeciesTableTable createAlias(String alias) {
    return $SpeciesTableTable(attachedDatabase, alias);
  }
}

class SpeciesTableData extends DataClass
    implements Insertable<SpeciesTableData> {
  final String id;
  final String nameFr;
  final String nameEn;
  final String nameAr;
  final String icon;
  final int displayOrder;
  const SpeciesTableData(
      {required this.id,
      required this.nameFr,
      required this.nameEn,
      required this.nameAr,
      required this.icon,
      required this.displayOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_fr'] = Variable<String>(nameFr);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ar'] = Variable<String>(nameAr);
    map['icon'] = Variable<String>(icon);
    map['display_order'] = Variable<int>(displayOrder);
    return map;
  }

  SpeciesTableCompanion toCompanion(bool nullToAbsent) {
    return SpeciesTableCompanion(
      id: Value(id),
      nameFr: Value(nameFr),
      nameEn: Value(nameEn),
      nameAr: Value(nameAr),
      icon: Value(icon),
      displayOrder: Value(displayOrder),
    );
  }

  factory SpeciesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SpeciesTableData(
      id: serializer.fromJson<String>(json['id']),
      nameFr: serializer.fromJson<String>(json['nameFr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      icon: serializer.fromJson<String>(json['icon']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameFr': serializer.toJson<String>(nameFr),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String>(nameAr),
      'icon': serializer.toJson<String>(icon),
      'displayOrder': serializer.toJson<int>(displayOrder),
    };
  }

  SpeciesTableData copyWith(
          {String? id,
          String? nameFr,
          String? nameEn,
          String? nameAr,
          String? icon,
          int? displayOrder}) =>
      SpeciesTableData(
        id: id ?? this.id,
        nameFr: nameFr ?? this.nameFr,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr ?? this.nameAr,
        icon: icon ?? this.icon,
        displayOrder: displayOrder ?? this.displayOrder,
      );
  SpeciesTableData copyWithCompanion(SpeciesTableCompanion data) {
    return SpeciesTableData(
      id: data.id.present ? data.id.value : this.id,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      icon: data.icon.present ? data.icon.value : this.icon,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesTableData(')
          ..write('id: $id, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('icon: $icon, ')
          ..write('displayOrder: $displayOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nameFr, nameEn, nameAr, icon, displayOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SpeciesTableData &&
          other.id == this.id &&
          other.nameFr == this.nameFr &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.icon == this.icon &&
          other.displayOrder == this.displayOrder);
}

class SpeciesTableCompanion extends UpdateCompanion<SpeciesTableData> {
  final Value<String> id;
  final Value<String> nameFr;
  final Value<String> nameEn;
  final Value<String> nameAr;
  final Value<String> icon;
  final Value<int> displayOrder;
  final Value<int> rowid;
  const SpeciesTableCompanion({
    this.id = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.icon = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SpeciesTableCompanion.insert({
    required String id,
    required String nameFr,
    required String nameEn,
    required String nameAr,
    required String icon,
    this.displayOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        nameFr = Value(nameFr),
        nameEn = Value(nameEn),
        nameAr = Value(nameAr),
        icon = Value(icon);
  static Insertable<SpeciesTableData> custom({
    Expression<String>? id,
    Expression<String>? nameFr,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<String>? icon,
    Expression<int>? displayOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (icon != null) 'icon': icon,
      if (displayOrder != null) 'display_order': displayOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SpeciesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? nameFr,
      Value<String>? nameEn,
      Value<String>? nameAr,
      Value<String>? icon,
      Value<int>? displayOrder,
      Value<int>? rowid}) {
    return SpeciesTableCompanion(
      id: id ?? this.id,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      icon: icon ?? this.icon,
      displayOrder: displayOrder ?? this.displayOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SpeciesTableCompanion(')
          ..write('id: $id, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('icon: $icon, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BreedsTableTable extends BreedsTable
    with TableInfo<$BreedsTableTable, BreedsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BreedsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _speciesIdMeta =
      const VerificationMeta('speciesId');
  @override
  late final GeneratedColumn<String> speciesId = GeneratedColumn<String>(
      'species_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameFrMeta = const VerificationMeta('nameFr');
  @override
  late final GeneratedColumn<String> nameFr = GeneratedColumn<String>(
      'name_fr', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameArMeta = const VerificationMeta('nameAr');
  @override
  late final GeneratedColumn<String> nameAr = GeneratedColumn<String>(
      'name_ar', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _displayOrderMeta =
      const VerificationMeta('displayOrder');
  @override
  late final GeneratedColumn<int> displayOrder = GeneratedColumn<int>(
      'display_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        speciesId,
        nameFr,
        nameEn,
        nameAr,
        description,
        displayOrder,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'breeds';
  @override
  VerificationContext validateIntegrity(Insertable<BreedsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('species_id')) {
      context.handle(_speciesIdMeta,
          speciesId.isAcceptableOrUnknown(data['species_id']!, _speciesIdMeta));
    } else if (isInserting) {
      context.missing(_speciesIdMeta);
    }
    if (data.containsKey('name_fr')) {
      context.handle(_nameFrMeta,
          nameFr.isAcceptableOrUnknown(data['name_fr']!, _nameFrMeta));
    } else if (isInserting) {
      context.missing(_nameFrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('name_ar')) {
      context.handle(_nameArMeta,
          nameAr.isAcceptableOrUnknown(data['name_ar']!, _nameArMeta));
    } else if (isInserting) {
      context.missing(_nameArMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('display_order')) {
      context.handle(
          _displayOrderMeta,
          displayOrder.isAcceptableOrUnknown(
              data['display_order']!, _displayOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BreedsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BreedsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      speciesId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}species_id'])!,
      nameFr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_fr'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      nameAr: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_ar'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      displayOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}display_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $BreedsTableTable createAlias(String alias) {
    return $BreedsTableTable(attachedDatabase, alias);
  }
}

class BreedsTableData extends DataClass implements Insertable<BreedsTableData> {
  final String id;
  final String speciesId;
  final String nameFr;
  final String nameEn;
  final String nameAr;
  final String? description;
  final int displayOrder;
  final bool isActive;
  const BreedsTableData(
      {required this.id,
      required this.speciesId,
      required this.nameFr,
      required this.nameEn,
      required this.nameAr,
      this.description,
      required this.displayOrder,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['species_id'] = Variable<String>(speciesId);
    map['name_fr'] = Variable<String>(nameFr);
    map['name_en'] = Variable<String>(nameEn);
    map['name_ar'] = Variable<String>(nameAr);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['display_order'] = Variable<int>(displayOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  BreedsTableCompanion toCompanion(bool nullToAbsent) {
    return BreedsTableCompanion(
      id: Value(id),
      speciesId: Value(speciesId),
      nameFr: Value(nameFr),
      nameEn: Value(nameEn),
      nameAr: Value(nameAr),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      displayOrder: Value(displayOrder),
      isActive: Value(isActive),
    );
  }

  factory BreedsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BreedsTableData(
      id: serializer.fromJson<String>(json['id']),
      speciesId: serializer.fromJson<String>(json['speciesId']),
      nameFr: serializer.fromJson<String>(json['nameFr']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      nameAr: serializer.fromJson<String>(json['nameAr']),
      description: serializer.fromJson<String?>(json['description']),
      displayOrder: serializer.fromJson<int>(json['displayOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'speciesId': serializer.toJson<String>(speciesId),
      'nameFr': serializer.toJson<String>(nameFr),
      'nameEn': serializer.toJson<String>(nameEn),
      'nameAr': serializer.toJson<String>(nameAr),
      'description': serializer.toJson<String?>(description),
      'displayOrder': serializer.toJson<int>(displayOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  BreedsTableData copyWith(
          {String? id,
          String? speciesId,
          String? nameFr,
          String? nameEn,
          String? nameAr,
          Value<String?> description = const Value.absent(),
          int? displayOrder,
          bool? isActive}) =>
      BreedsTableData(
        id: id ?? this.id,
        speciesId: speciesId ?? this.speciesId,
        nameFr: nameFr ?? this.nameFr,
        nameEn: nameEn ?? this.nameEn,
        nameAr: nameAr ?? this.nameAr,
        description: description.present ? description.value : this.description,
        displayOrder: displayOrder ?? this.displayOrder,
        isActive: isActive ?? this.isActive,
      );
  BreedsTableData copyWithCompanion(BreedsTableCompanion data) {
    return BreedsTableData(
      id: data.id.present ? data.id.value : this.id,
      speciesId: data.speciesId.present ? data.speciesId.value : this.speciesId,
      nameFr: data.nameFr.present ? data.nameFr.value : this.nameFr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      nameAr: data.nameAr.present ? data.nameAr.value : this.nameAr,
      description:
          data.description.present ? data.description.value : this.description,
      displayOrder: data.displayOrder.present
          ? data.displayOrder.value
          : this.displayOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BreedsTableData(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('description: $description, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, speciesId, nameFr, nameEn, nameAr,
      description, displayOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BreedsTableData &&
          other.id == this.id &&
          other.speciesId == this.speciesId &&
          other.nameFr == this.nameFr &&
          other.nameEn == this.nameEn &&
          other.nameAr == this.nameAr &&
          other.description == this.description &&
          other.displayOrder == this.displayOrder &&
          other.isActive == this.isActive);
}

class BreedsTableCompanion extends UpdateCompanion<BreedsTableData> {
  final Value<String> id;
  final Value<String> speciesId;
  final Value<String> nameFr;
  final Value<String> nameEn;
  final Value<String> nameAr;
  final Value<String?> description;
  final Value<int> displayOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const BreedsTableCompanion({
    this.id = const Value.absent(),
    this.speciesId = const Value.absent(),
    this.nameFr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.nameAr = const Value.absent(),
    this.description = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BreedsTableCompanion.insert({
    required String id,
    required String speciesId,
    required String nameFr,
    required String nameEn,
    required String nameAr,
    this.description = const Value.absent(),
    this.displayOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        speciesId = Value(speciesId),
        nameFr = Value(nameFr),
        nameEn = Value(nameEn),
        nameAr = Value(nameAr);
  static Insertable<BreedsTableData> custom({
    Expression<String>? id,
    Expression<String>? speciesId,
    Expression<String>? nameFr,
    Expression<String>? nameEn,
    Expression<String>? nameAr,
    Expression<String>? description,
    Expression<int>? displayOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (speciesId != null) 'species_id': speciesId,
      if (nameFr != null) 'name_fr': nameFr,
      if (nameEn != null) 'name_en': nameEn,
      if (nameAr != null) 'name_ar': nameAr,
      if (description != null) 'description': description,
      if (displayOrder != null) 'display_order': displayOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BreedsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? speciesId,
      Value<String>? nameFr,
      Value<String>? nameEn,
      Value<String>? nameAr,
      Value<String?>? description,
      Value<int>? displayOrder,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return BreedsTableCompanion(
      id: id ?? this.id,
      speciesId: speciesId ?? this.speciesId,
      nameFr: nameFr ?? this.nameFr,
      nameEn: nameEn ?? this.nameEn,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (speciesId.present) {
      map['species_id'] = Variable<String>(speciesId.value);
    }
    if (nameFr.present) {
      map['name_fr'] = Variable<String>(nameFr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (nameAr.present) {
      map['name_ar'] = Variable<String>(nameAr.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (displayOrder.present) {
      map['display_order'] = Variable<int>(displayOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BreedsTableCompanion(')
          ..write('id: $id, ')
          ..write('speciesId: $speciesId, ')
          ..write('nameFr: $nameFr, ')
          ..write('nameEn: $nameEn, ')
          ..write('nameAr: $nameAr, ')
          ..write('description: $description, ')
          ..write('displayOrder: $displayOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MedicalProductsTableTable extends MedicalProductsTable
    with TableInfo<$MedicalProductsTableTable, MedicalProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicalProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _commercialNameMeta =
      const VerificationMeta('commercialName');
  @override
  late final GeneratedColumn<String> commercialName = GeneratedColumn<String>(
      'commercial_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _activeIngredientMeta =
      const VerificationMeta('activeIngredient');
  @override
  late final GeneratedColumn<String> activeIngredient = GeneratedColumn<String>(
      'active_ingredient', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _manufacturerMeta =
      const VerificationMeta('manufacturer');
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
      'manufacturer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
      'form', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<double> dosage = GeneratedColumn<double>(
      'dosage', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _dosageUnitMeta =
      const VerificationMeta('dosageUnit');
  @override
  late final GeneratedColumn<String> dosageUnit = GeneratedColumn<String>(
      'dosage_unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _withdrawalPeriodMeatMeta =
      const VerificationMeta('withdrawalPeriodMeat');
  @override
  late final GeneratedColumn<int> withdrawalPeriodMeat = GeneratedColumn<int>(
      'withdrawal_period_meat', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _withdrawalPeriodMilkMeta =
      const VerificationMeta('withdrawalPeriodMilk');
  @override
  late final GeneratedColumn<int> withdrawalPeriodMilk = GeneratedColumn<int>(
      'withdrawal_period_milk', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _currentStockMeta =
      const VerificationMeta('currentStock');
  @override
  late final GeneratedColumn<double> currentStock = GeneratedColumn<double>(
      'current_stock', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _minStockMeta =
      const VerificationMeta('minStock');
  @override
  late final GeneratedColumn<double> minStock = GeneratedColumn<double>(
      'min_stock', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stockUnitMeta =
      const VerificationMeta('stockUnit');
  @override
  late final GeneratedColumn<String> stockUnit = GeneratedColumn<String>(
      'stock_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _batchNumberMeta =
      const VerificationMeta('batchNumber');
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
      'batch_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _storageConditionsMeta =
      const VerificationMeta('storageConditions');
  @override
  late final GeneratedColumn<String> storageConditions =
      GeneratedColumn<String>('storage_conditions', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _prescriptionMeta =
      const VerificationMeta('prescription');
  @override
  late final GeneratedColumn<String> prescription = GeneratedColumn<String>(
      'prescription', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('treatment'));
  static const VerificationMeta _targetSpeciesMeta =
      const VerificationMeta('targetSpecies');
  @override
  late final GeneratedColumn<String> targetSpecies = GeneratedColumn<String>(
      'target_species', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _standardCureDaysMeta =
      const VerificationMeta('standardCureDays');
  @override
  late final GeneratedColumn<int> standardCureDays = GeneratedColumn<int>(
      'standard_cure_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _administrationFrequencyMeta =
      const VerificationMeta('administrationFrequency');
  @override
  late final GeneratedColumn<String> administrationFrequency =
      GeneratedColumn<String>('administration_frequency', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _dosageFormulaMeta =
      const VerificationMeta('dosageFormula');
  @override
  late final GeneratedColumn<String> dosageFormula = GeneratedColumn<String>(
      'dosage_formula', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vaccinationProtocolMeta =
      const VerificationMeta('vaccinationProtocol');
  @override
  late final GeneratedColumn<String> vaccinationProtocol =
      GeneratedColumn<String>('vaccination_protocol', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _reminderDaysMeta =
      const VerificationMeta('reminderDays');
  @override
  late final GeneratedColumn<String> reminderDays = GeneratedColumn<String>(
      'reminder_days', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultAdministrationRouteMeta =
      const VerificationMeta('defaultAdministrationRoute');
  @override
  late final GeneratedColumn<String> defaultAdministrationRoute =
      GeneratedColumn<String>('default_administration_route', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _defaultInjectionSiteMeta =
      const VerificationMeta('defaultInjectionSite');
  @override
  late final GeneratedColumn<String> defaultInjectionSite =
      GeneratedColumn<String>('default_injection_site', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverVersionMeta =
      const VerificationMeta('serverVersion');
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
      'server_version', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        commercialName,
        category,
        activeIngredient,
        manufacturer,
        form,
        dosage,
        dosageUnit,
        withdrawalPeriodMeat,
        withdrawalPeriodMilk,
        currentStock,
        minStock,
        stockUnit,
        unitPrice,
        currency,
        batchNumber,
        expiryDate,
        storageConditions,
        prescription,
        notes,
        isActive,
        type,
        targetSpecies,
        standardCureDays,
        administrationFrequency,
        dosageFormula,
        vaccinationProtocol,
        reminderDays,
        defaultAdministrationRoute,
        defaultInjectionSite,
        synced,
        lastSyncedAt,
        serverVersion,
        deletedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medical_products';
  @override
  VerificationContext validateIntegrity(
      Insertable<MedicalProductsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('commercial_name')) {
      context.handle(
          _commercialNameMeta,
          commercialName.isAcceptableOrUnknown(
              data['commercial_name']!, _commercialNameMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('active_ingredient')) {
      context.handle(
          _activeIngredientMeta,
          activeIngredient.isAcceptableOrUnknown(
              data['active_ingredient']!, _activeIngredientMeta));
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
          _manufacturerMeta,
          manufacturer.isAcceptableOrUnknown(
              data['manufacturer']!, _manufacturerMeta));
    }
    if (data.containsKey('form')) {
      context.handle(
          _formMeta, form.isAcceptableOrUnknown(data['form']!, _formMeta));
    }
    if (data.containsKey('dosage')) {
      context.handle(_dosageMeta,
          dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta));
    }
    if (data.containsKey('dosage_unit')) {
      context.handle(
          _dosageUnitMeta,
          dosageUnit.isAcceptableOrUnknown(
              data['dosage_unit']!, _dosageUnitMeta));
    }
    if (data.containsKey('withdrawal_period_meat')) {
      context.handle(
          _withdrawalPeriodMeatMeta,
          withdrawalPeriodMeat.isAcceptableOrUnknown(
              data['withdrawal_period_meat']!, _withdrawalPeriodMeatMeta));
    } else if (isInserting) {
      context.missing(_withdrawalPeriodMeatMeta);
    }
    if (data.containsKey('withdrawal_period_milk')) {
      context.handle(
          _withdrawalPeriodMilkMeta,
          withdrawalPeriodMilk.isAcceptableOrUnknown(
              data['withdrawal_period_milk']!, _withdrawalPeriodMilkMeta));
    } else if (isInserting) {
      context.missing(_withdrawalPeriodMilkMeta);
    }
    if (data.containsKey('current_stock')) {
      context.handle(
          _currentStockMeta,
          currentStock.isAcceptableOrUnknown(
              data['current_stock']!, _currentStockMeta));
    } else if (isInserting) {
      context.missing(_currentStockMeta);
    }
    if (data.containsKey('min_stock')) {
      context.handle(_minStockMeta,
          minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta));
    } else if (isInserting) {
      context.missing(_minStockMeta);
    }
    if (data.containsKey('stock_unit')) {
      context.handle(_stockUnitMeta,
          stockUnit.isAcceptableOrUnknown(data['stock_unit']!, _stockUnitMeta));
    } else if (isInserting) {
      context.missing(_stockUnitMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('batch_number')) {
      context.handle(
          _batchNumberMeta,
          batchNumber.isAcceptableOrUnknown(
              data['batch_number']!, _batchNumberMeta));
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('storage_conditions')) {
      context.handle(
          _storageConditionsMeta,
          storageConditions.isAcceptableOrUnknown(
              data['storage_conditions']!, _storageConditionsMeta));
    }
    if (data.containsKey('prescription')) {
      context.handle(
          _prescriptionMeta,
          prescription.isAcceptableOrUnknown(
              data['prescription']!, _prescriptionMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('target_species')) {
      context.handle(
          _targetSpeciesMeta,
          targetSpecies.isAcceptableOrUnknown(
              data['target_species']!, _targetSpeciesMeta));
    }
    if (data.containsKey('standard_cure_days')) {
      context.handle(
          _standardCureDaysMeta,
          standardCureDays.isAcceptableOrUnknown(
              data['standard_cure_days']!, _standardCureDaysMeta));
    }
    if (data.containsKey('administration_frequency')) {
      context.handle(
          _administrationFrequencyMeta,
          administrationFrequency.isAcceptableOrUnknown(
              data['administration_frequency']!, _administrationFrequencyMeta));
    }
    if (data.containsKey('dosage_formula')) {
      context.handle(
          _dosageFormulaMeta,
          dosageFormula.isAcceptableOrUnknown(
              data['dosage_formula']!, _dosageFormulaMeta));
    }
    if (data.containsKey('vaccination_protocol')) {
      context.handle(
          _vaccinationProtocolMeta,
          vaccinationProtocol.isAcceptableOrUnknown(
              data['vaccination_protocol']!, _vaccinationProtocolMeta));
    }
    if (data.containsKey('reminder_days')) {
      context.handle(
          _reminderDaysMeta,
          reminderDays.isAcceptableOrUnknown(
              data['reminder_days']!, _reminderDaysMeta));
    }
    if (data.containsKey('default_administration_route')) {
      context.handle(
          _defaultAdministrationRouteMeta,
          defaultAdministrationRoute.isAcceptableOrUnknown(
              data['default_administration_route']!,
              _defaultAdministrationRouteMeta));
    }
    if (data.containsKey('default_injection_site')) {
      context.handle(
          _defaultInjectionSiteMeta,
          defaultInjectionSite.isAcceptableOrUnknown(
              data['default_injection_site']!, _defaultInjectionSiteMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('server_version')) {
      context.handle(
          _serverVersionMeta,
          serverVersion.isAcceptableOrUnknown(
              data['server_version']!, _serverVersionMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MedicalProductsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MedicalProductsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      commercialName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}commercial_name']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      activeIngredient: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}active_ingredient']),
      manufacturer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manufacturer']),
      form: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}form']),
      dosage: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}dosage']),
      dosageUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage_unit']),
      withdrawalPeriodMeat: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}withdrawal_period_meat'])!,
      withdrawalPeriodMilk: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}withdrawal_period_milk'])!,
      currentStock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}current_stock'])!,
      minStock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_stock'])!,
      stockUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stock_unit'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency']),
      batchNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_number']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      storageConditions: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}storage_conditions']),
      prescription: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prescription']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      targetSpecies: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_species'])!,
      standardCureDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}standard_cure_days']),
      administrationFrequency: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}administration_frequency']),
      dosageFormula: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dosage_formula']),
      vaccinationProtocol: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}vaccination_protocol']),
      reminderDays: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reminder_days']),
      defaultAdministrationRoute: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_administration_route']),
      defaultInjectionSite: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}default_injection_site']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_version']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $MedicalProductsTableTable createAlias(String alias) {
    return $MedicalProductsTableTable(attachedDatabase, alias);
  }
}

class MedicalProductsTableData extends DataClass
    implements Insertable<MedicalProductsTableData> {
  final String id;
  final String farmId;
  final String name;
  final String? commercialName;
  final String category;
  final String? activeIngredient;
  final String? manufacturer;
  final String? form;
  final double? dosage;
  final String? dosageUnit;
  final int withdrawalPeriodMeat;
  final int withdrawalPeriodMilk;
  final double currentStock;
  final double minStock;
  final String stockUnit;
  final double? unitPrice;
  final String? currency;
  final String? batchNumber;
  final DateTime? expiryDate;
  final String? storageConditions;
  final String? prescription;
  final String? notes;
  final bool isActive;
  final String type;
  final String targetSpecies;
  final int? standardCureDays;
  final String? administrationFrequency;
  final String? dosageFormula;
  final String? vaccinationProtocol;
  final String? reminderDays;
  final String? defaultAdministrationRoute;
  final String? defaultInjectionSite;
  final bool synced;
  final DateTime? lastSyncedAt;
  final int? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MedicalProductsTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      this.commercialName,
      required this.category,
      this.activeIngredient,
      this.manufacturer,
      this.form,
      this.dosage,
      this.dosageUnit,
      required this.withdrawalPeriodMeat,
      required this.withdrawalPeriodMilk,
      required this.currentStock,
      required this.minStock,
      required this.stockUnit,
      this.unitPrice,
      this.currency,
      this.batchNumber,
      this.expiryDate,
      this.storageConditions,
      this.prescription,
      this.notes,
      required this.isActive,
      required this.type,
      required this.targetSpecies,
      this.standardCureDays,
      this.administrationFrequency,
      this.dosageFormula,
      this.vaccinationProtocol,
      this.reminderDays,
      this.defaultAdministrationRoute,
      this.defaultInjectionSite,
      required this.synced,
      this.lastSyncedAt,
      this.serverVersion,
      this.deletedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || commercialName != null) {
      map['commercial_name'] = Variable<String>(commercialName);
    }
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || activeIngredient != null) {
      map['active_ingredient'] = Variable<String>(activeIngredient);
    }
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || form != null) {
      map['form'] = Variable<String>(form);
    }
    if (!nullToAbsent || dosage != null) {
      map['dosage'] = Variable<double>(dosage);
    }
    if (!nullToAbsent || dosageUnit != null) {
      map['dosage_unit'] = Variable<String>(dosageUnit);
    }
    map['withdrawal_period_meat'] = Variable<int>(withdrawalPeriodMeat);
    map['withdrawal_period_milk'] = Variable<int>(withdrawalPeriodMilk);
    map['current_stock'] = Variable<double>(currentStock);
    map['min_stock'] = Variable<double>(minStock);
    map['stock_unit'] = Variable<String>(stockUnit);
    if (!nullToAbsent || unitPrice != null) {
      map['unit_price'] = Variable<double>(unitPrice);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || batchNumber != null) {
      map['batch_number'] = Variable<String>(batchNumber);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || storageConditions != null) {
      map['storage_conditions'] = Variable<String>(storageConditions);
    }
    if (!nullToAbsent || prescription != null) {
      map['prescription'] = Variable<String>(prescription);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['type'] = Variable<String>(type);
    map['target_species'] = Variable<String>(targetSpecies);
    if (!nullToAbsent || standardCureDays != null) {
      map['standard_cure_days'] = Variable<int>(standardCureDays);
    }
    if (!nullToAbsent || administrationFrequency != null) {
      map['administration_frequency'] =
          Variable<String>(administrationFrequency);
    }
    if (!nullToAbsent || dosageFormula != null) {
      map['dosage_formula'] = Variable<String>(dosageFormula);
    }
    if (!nullToAbsent || vaccinationProtocol != null) {
      map['vaccination_protocol'] = Variable<String>(vaccinationProtocol);
    }
    if (!nullToAbsent || reminderDays != null) {
      map['reminder_days'] = Variable<String>(reminderDays);
    }
    if (!nullToAbsent || defaultAdministrationRoute != null) {
      map['default_administration_route'] =
          Variable<String>(defaultAdministrationRoute);
    }
    if (!nullToAbsent || defaultInjectionSite != null) {
      map['default_injection_site'] = Variable<String>(defaultInjectionSite);
    }
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<int>(serverVersion);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MedicalProductsTableCompanion toCompanion(bool nullToAbsent) {
    return MedicalProductsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      commercialName: commercialName == null && nullToAbsent
          ? const Value.absent()
          : Value(commercialName),
      category: Value(category),
      activeIngredient: activeIngredient == null && nullToAbsent
          ? const Value.absent()
          : Value(activeIngredient),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      form: form == null && nullToAbsent ? const Value.absent() : Value(form),
      dosage:
          dosage == null && nullToAbsent ? const Value.absent() : Value(dosage),
      dosageUnit: dosageUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(dosageUnit),
      withdrawalPeriodMeat: Value(withdrawalPeriodMeat),
      withdrawalPeriodMilk: Value(withdrawalPeriodMilk),
      currentStock: Value(currentStock),
      minStock: Value(minStock),
      stockUnit: Value(stockUnit),
      unitPrice: unitPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(unitPrice),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      batchNumber: batchNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNumber),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      storageConditions: storageConditions == null && nullToAbsent
          ? const Value.absent()
          : Value(storageConditions),
      prescription: prescription == null && nullToAbsent
          ? const Value.absent()
          : Value(prescription),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
      type: Value(type),
      targetSpecies: Value(targetSpecies),
      standardCureDays: standardCureDays == null && nullToAbsent
          ? const Value.absent()
          : Value(standardCureDays),
      administrationFrequency: administrationFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(administrationFrequency),
      dosageFormula: dosageFormula == null && nullToAbsent
          ? const Value.absent()
          : Value(dosageFormula),
      vaccinationProtocol: vaccinationProtocol == null && nullToAbsent
          ? const Value.absent()
          : Value(vaccinationProtocol),
      reminderDays: reminderDays == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderDays),
      defaultAdministrationRoute:
          defaultAdministrationRoute == null && nullToAbsent
              ? const Value.absent()
              : Value(defaultAdministrationRoute),
      defaultInjectionSite: defaultInjectionSite == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultInjectionSite),
      synced: Value(synced),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory MedicalProductsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MedicalProductsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      commercialName: serializer.fromJson<String?>(json['commercialName']),
      category: serializer.fromJson<String>(json['category']),
      activeIngredient: serializer.fromJson<String?>(json['activeIngredient']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      form: serializer.fromJson<String?>(json['form']),
      dosage: serializer.fromJson<double?>(json['dosage']),
      dosageUnit: serializer.fromJson<String?>(json['dosageUnit']),
      withdrawalPeriodMeat:
          serializer.fromJson<int>(json['withdrawalPeriodMeat']),
      withdrawalPeriodMilk:
          serializer.fromJson<int>(json['withdrawalPeriodMilk']),
      currentStock: serializer.fromJson<double>(json['currentStock']),
      minStock: serializer.fromJson<double>(json['minStock']),
      stockUnit: serializer.fromJson<String>(json['stockUnit']),
      unitPrice: serializer.fromJson<double?>(json['unitPrice']),
      currency: serializer.fromJson<String?>(json['currency']),
      batchNumber: serializer.fromJson<String?>(json['batchNumber']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      storageConditions:
          serializer.fromJson<String?>(json['storageConditions']),
      prescription: serializer.fromJson<String?>(json['prescription']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      type: serializer.fromJson<String>(json['type']),
      targetSpecies: serializer.fromJson<String>(json['targetSpecies']),
      standardCureDays: serializer.fromJson<int?>(json['standardCureDays']),
      administrationFrequency:
          serializer.fromJson<String?>(json['administrationFrequency']),
      dosageFormula: serializer.fromJson<String?>(json['dosageFormula']),
      vaccinationProtocol:
          serializer.fromJson<String?>(json['vaccinationProtocol']),
      reminderDays: serializer.fromJson<String?>(json['reminderDays']),
      defaultAdministrationRoute:
          serializer.fromJson<String?>(json['defaultAdministrationRoute']),
      defaultInjectionSite:
          serializer.fromJson<String?>(json['defaultInjectionSite']),
      synced: serializer.fromJson<bool>(json['synced']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      serverVersion: serializer.fromJson<int?>(json['serverVersion']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'commercialName': serializer.toJson<String?>(commercialName),
      'category': serializer.toJson<String>(category),
      'activeIngredient': serializer.toJson<String?>(activeIngredient),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'form': serializer.toJson<String?>(form),
      'dosage': serializer.toJson<double?>(dosage),
      'dosageUnit': serializer.toJson<String?>(dosageUnit),
      'withdrawalPeriodMeat': serializer.toJson<int>(withdrawalPeriodMeat),
      'withdrawalPeriodMilk': serializer.toJson<int>(withdrawalPeriodMilk),
      'currentStock': serializer.toJson<double>(currentStock),
      'minStock': serializer.toJson<double>(minStock),
      'stockUnit': serializer.toJson<String>(stockUnit),
      'unitPrice': serializer.toJson<double?>(unitPrice),
      'currency': serializer.toJson<String?>(currency),
      'batchNumber': serializer.toJson<String?>(batchNumber),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'storageConditions': serializer.toJson<String?>(storageConditions),
      'prescription': serializer.toJson<String?>(prescription),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'type': serializer.toJson<String>(type),
      'targetSpecies': serializer.toJson<String>(targetSpecies),
      'standardCureDays': serializer.toJson<int?>(standardCureDays),
      'administrationFrequency':
          serializer.toJson<String?>(administrationFrequency),
      'dosageFormula': serializer.toJson<String?>(dosageFormula),
      'vaccinationProtocol': serializer.toJson<String?>(vaccinationProtocol),
      'reminderDays': serializer.toJson<String?>(reminderDays),
      'defaultAdministrationRoute':
          serializer.toJson<String?>(defaultAdministrationRoute),
      'defaultInjectionSite': serializer.toJson<String?>(defaultInjectionSite),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MedicalProductsTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          Value<String?> commercialName = const Value.absent(),
          String? category,
          Value<String?> activeIngredient = const Value.absent(),
          Value<String?> manufacturer = const Value.absent(),
          Value<String?> form = const Value.absent(),
          Value<double?> dosage = const Value.absent(),
          Value<String?> dosageUnit = const Value.absent(),
          int? withdrawalPeriodMeat,
          int? withdrawalPeriodMilk,
          double? currentStock,
          double? minStock,
          String? stockUnit,
          Value<double?> unitPrice = const Value.absent(),
          Value<String?> currency = const Value.absent(),
          Value<String?> batchNumber = const Value.absent(),
          Value<DateTime?> expiryDate = const Value.absent(),
          Value<String?> storageConditions = const Value.absent(),
          Value<String?> prescription = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isActive,
          String? type,
          String? targetSpecies,
          Value<int?> standardCureDays = const Value.absent(),
          Value<String?> administrationFrequency = const Value.absent(),
          Value<String?> dosageFormula = const Value.absent(),
          Value<String?> vaccinationProtocol = const Value.absent(),
          Value<String?> reminderDays = const Value.absent(),
          Value<String?> defaultAdministrationRoute = const Value.absent(),
          Value<String?> defaultInjectionSite = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<int?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MedicalProductsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        commercialName:
            commercialName.present ? commercialName.value : this.commercialName,
        category: category ?? this.category,
        activeIngredient: activeIngredient.present
            ? activeIngredient.value
            : this.activeIngredient,
        manufacturer:
            manufacturer.present ? manufacturer.value : this.manufacturer,
        form: form.present ? form.value : this.form,
        dosage: dosage.present ? dosage.value : this.dosage,
        dosageUnit: dosageUnit.present ? dosageUnit.value : this.dosageUnit,
        withdrawalPeriodMeat: withdrawalPeriodMeat ?? this.withdrawalPeriodMeat,
        withdrawalPeriodMilk: withdrawalPeriodMilk ?? this.withdrawalPeriodMilk,
        currentStock: currentStock ?? this.currentStock,
        minStock: minStock ?? this.minStock,
        stockUnit: stockUnit ?? this.stockUnit,
        unitPrice: unitPrice.present ? unitPrice.value : this.unitPrice,
        currency: currency.present ? currency.value : this.currency,
        batchNumber: batchNumber.present ? batchNumber.value : this.batchNumber,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        storageConditions: storageConditions.present
            ? storageConditions.value
            : this.storageConditions,
        prescription:
            prescription.present ? prescription.value : this.prescription,
        notes: notes.present ? notes.value : this.notes,
        isActive: isActive ?? this.isActive,
        type: type ?? this.type,
        targetSpecies: targetSpecies ?? this.targetSpecies,
        standardCureDays: standardCureDays.present
            ? standardCureDays.value
            : this.standardCureDays,
        administrationFrequency: administrationFrequency.present
            ? administrationFrequency.value
            : this.administrationFrequency,
        dosageFormula:
            dosageFormula.present ? dosageFormula.value : this.dosageFormula,
        vaccinationProtocol: vaccinationProtocol.present
            ? vaccinationProtocol.value
            : this.vaccinationProtocol,
        reminderDays:
            reminderDays.present ? reminderDays.value : this.reminderDays,
        defaultAdministrationRoute: defaultAdministrationRoute.present
            ? defaultAdministrationRoute.value
            : this.defaultAdministrationRoute,
        defaultInjectionSite: defaultInjectionSite.present
            ? defaultInjectionSite.value
            : this.defaultInjectionSite,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MedicalProductsTableData copyWithCompanion(
      MedicalProductsTableCompanion data) {
    return MedicalProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      commercialName: data.commercialName.present
          ? data.commercialName.value
          : this.commercialName,
      category: data.category.present ? data.category.value : this.category,
      activeIngredient: data.activeIngredient.present
          ? data.activeIngredient.value
          : this.activeIngredient,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      form: data.form.present ? data.form.value : this.form,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
      dosageUnit:
          data.dosageUnit.present ? data.dosageUnit.value : this.dosageUnit,
      withdrawalPeriodMeat: data.withdrawalPeriodMeat.present
          ? data.withdrawalPeriodMeat.value
          : this.withdrawalPeriodMeat,
      withdrawalPeriodMilk: data.withdrawalPeriodMilk.present
          ? data.withdrawalPeriodMilk.value
          : this.withdrawalPeriodMilk,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      stockUnit: data.stockUnit.present ? data.stockUnit.value : this.stockUnit,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      currency: data.currency.present ? data.currency.value : this.currency,
      batchNumber:
          data.batchNumber.present ? data.batchNumber.value : this.batchNumber,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      storageConditions: data.storageConditions.present
          ? data.storageConditions.value
          : this.storageConditions,
      prescription: data.prescription.present
          ? data.prescription.value
          : this.prescription,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      type: data.type.present ? data.type.value : this.type,
      targetSpecies: data.targetSpecies.present
          ? data.targetSpecies.value
          : this.targetSpecies,
      standardCureDays: data.standardCureDays.present
          ? data.standardCureDays.value
          : this.standardCureDays,
      administrationFrequency: data.administrationFrequency.present
          ? data.administrationFrequency.value
          : this.administrationFrequency,
      dosageFormula: data.dosageFormula.present
          ? data.dosageFormula.value
          : this.dosageFormula,
      vaccinationProtocol: data.vaccinationProtocol.present
          ? data.vaccinationProtocol.value
          : this.vaccinationProtocol,
      reminderDays: data.reminderDays.present
          ? data.reminderDays.value
          : this.reminderDays,
      defaultAdministrationRoute: data.defaultAdministrationRoute.present
          ? data.defaultAdministrationRoute.value
          : this.defaultAdministrationRoute,
      defaultInjectionSite: data.defaultInjectionSite.present
          ? data.defaultInjectionSite.value
          : this.defaultInjectionSite,
      synced: data.synced.present ? data.synced.value : this.synced,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MedicalProductsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('commercialName: $commercialName, ')
          ..write('category: $category, ')
          ..write('activeIngredient: $activeIngredient, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('form: $form, ')
          ..write('dosage: $dosage, ')
          ..write('dosageUnit: $dosageUnit, ')
          ..write('withdrawalPeriodMeat: $withdrawalPeriodMeat, ')
          ..write('withdrawalPeriodMilk: $withdrawalPeriodMilk, ')
          ..write('currentStock: $currentStock, ')
          ..write('minStock: $minStock, ')
          ..write('stockUnit: $stockUnit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('currency: $currency, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('storageConditions: $storageConditions, ')
          ..write('prescription: $prescription, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('type: $type, ')
          ..write('targetSpecies: $targetSpecies, ')
          ..write('standardCureDays: $standardCureDays, ')
          ..write('administrationFrequency: $administrationFrequency, ')
          ..write('dosageFormula: $dosageFormula, ')
          ..write('vaccinationProtocol: $vaccinationProtocol, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('defaultAdministrationRoute: $defaultAdministrationRoute, ')
          ..write('defaultInjectionSite: $defaultInjectionSite, ')
          ..write('synced: $synced, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        farmId,
        name,
        commercialName,
        category,
        activeIngredient,
        manufacturer,
        form,
        dosage,
        dosageUnit,
        withdrawalPeriodMeat,
        withdrawalPeriodMilk,
        currentStock,
        minStock,
        stockUnit,
        unitPrice,
        currency,
        batchNumber,
        expiryDate,
        storageConditions,
        prescription,
        notes,
        isActive,
        type,
        targetSpecies,
        standardCureDays,
        administrationFrequency,
        dosageFormula,
        vaccinationProtocol,
        reminderDays,
        defaultAdministrationRoute,
        defaultInjectionSite,
        synced,
        lastSyncedAt,
        serverVersion,
        deletedAt,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MedicalProductsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.commercialName == this.commercialName &&
          other.category == this.category &&
          other.activeIngredient == this.activeIngredient &&
          other.manufacturer == this.manufacturer &&
          other.form == this.form &&
          other.dosage == this.dosage &&
          other.dosageUnit == this.dosageUnit &&
          other.withdrawalPeriodMeat == this.withdrawalPeriodMeat &&
          other.withdrawalPeriodMilk == this.withdrawalPeriodMilk &&
          other.currentStock == this.currentStock &&
          other.minStock == this.minStock &&
          other.stockUnit == this.stockUnit &&
          other.unitPrice == this.unitPrice &&
          other.currency == this.currency &&
          other.batchNumber == this.batchNumber &&
          other.expiryDate == this.expiryDate &&
          other.storageConditions == this.storageConditions &&
          other.prescription == this.prescription &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.type == this.type &&
          other.targetSpecies == this.targetSpecies &&
          other.standardCureDays == this.standardCureDays &&
          other.administrationFrequency == this.administrationFrequency &&
          other.dosageFormula == this.dosageFormula &&
          other.vaccinationProtocol == this.vaccinationProtocol &&
          other.reminderDays == this.reminderDays &&
          other.defaultAdministrationRoute == this.defaultAdministrationRoute &&
          other.defaultInjectionSite == this.defaultInjectionSite &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MedicalProductsTableCompanion
    extends UpdateCompanion<MedicalProductsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String?> commercialName;
  final Value<String> category;
  final Value<String?> activeIngredient;
  final Value<String?> manufacturer;
  final Value<String?> form;
  final Value<double?> dosage;
  final Value<String?> dosageUnit;
  final Value<int> withdrawalPeriodMeat;
  final Value<int> withdrawalPeriodMilk;
  final Value<double> currentStock;
  final Value<double> minStock;
  final Value<String> stockUnit;
  final Value<double?> unitPrice;
  final Value<String?> currency;
  final Value<String?> batchNumber;
  final Value<DateTime?> expiryDate;
  final Value<String?> storageConditions;
  final Value<String?> prescription;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<String> type;
  final Value<String> targetSpecies;
  final Value<int?> standardCureDays;
  final Value<String?> administrationFrequency;
  final Value<String?> dosageFormula;
  final Value<String?> vaccinationProtocol;
  final Value<String?> reminderDays;
  final Value<String?> defaultAdministrationRoute;
  final Value<String?> defaultInjectionSite;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<int?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MedicalProductsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.commercialName = const Value.absent(),
    this.category = const Value.absent(),
    this.activeIngredient = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.form = const Value.absent(),
    this.dosage = const Value.absent(),
    this.dosageUnit = const Value.absent(),
    this.withdrawalPeriodMeat = const Value.absent(),
    this.withdrawalPeriodMilk = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.minStock = const Value.absent(),
    this.stockUnit = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.currency = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.storageConditions = const Value.absent(),
    this.prescription = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.type = const Value.absent(),
    this.targetSpecies = const Value.absent(),
    this.standardCureDays = const Value.absent(),
    this.administrationFrequency = const Value.absent(),
    this.dosageFormula = const Value.absent(),
    this.vaccinationProtocol = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.defaultAdministrationRoute = const Value.absent(),
    this.defaultInjectionSite = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MedicalProductsTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    this.commercialName = const Value.absent(),
    required String category,
    this.activeIngredient = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.form = const Value.absent(),
    this.dosage = const Value.absent(),
    this.dosageUnit = const Value.absent(),
    required int withdrawalPeriodMeat,
    required int withdrawalPeriodMilk,
    required double currentStock,
    required double minStock,
    required String stockUnit,
    this.unitPrice = const Value.absent(),
    this.currency = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.storageConditions = const Value.absent(),
    this.prescription = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.type = const Value.absent(),
    this.targetSpecies = const Value.absent(),
    this.standardCureDays = const Value.absent(),
    this.administrationFrequency = const Value.absent(),
    this.dosageFormula = const Value.absent(),
    this.vaccinationProtocol = const Value.absent(),
    this.reminderDays = const Value.absent(),
    this.defaultAdministrationRoute = const Value.absent(),
    this.defaultInjectionSite = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        category = Value(category),
        withdrawalPeriodMeat = Value(withdrawalPeriodMeat),
        withdrawalPeriodMilk = Value(withdrawalPeriodMilk),
        currentStock = Value(currentStock),
        minStock = Value(minStock),
        stockUnit = Value(stockUnit),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MedicalProductsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? commercialName,
    Expression<String>? category,
    Expression<String>? activeIngredient,
    Expression<String>? manufacturer,
    Expression<String>? form,
    Expression<double>? dosage,
    Expression<String>? dosageUnit,
    Expression<int>? withdrawalPeriodMeat,
    Expression<int>? withdrawalPeriodMilk,
    Expression<double>? currentStock,
    Expression<double>? minStock,
    Expression<String>? stockUnit,
    Expression<double>? unitPrice,
    Expression<String>? currency,
    Expression<String>? batchNumber,
    Expression<DateTime>? expiryDate,
    Expression<String>? storageConditions,
    Expression<String>? prescription,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<String>? type,
    Expression<String>? targetSpecies,
    Expression<int>? standardCureDays,
    Expression<String>? administrationFrequency,
    Expression<String>? dosageFormula,
    Expression<String>? vaccinationProtocol,
    Expression<String>? reminderDays,
    Expression<String>? defaultAdministrationRoute,
    Expression<String>? defaultInjectionSite,
    Expression<bool>? synced,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? serverVersion,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (commercialName != null) 'commercial_name': commercialName,
      if (category != null) 'category': category,
      if (activeIngredient != null) 'active_ingredient': activeIngredient,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (form != null) 'form': form,
      if (dosage != null) 'dosage': dosage,
      if (dosageUnit != null) 'dosage_unit': dosageUnit,
      if (withdrawalPeriodMeat != null)
        'withdrawal_period_meat': withdrawalPeriodMeat,
      if (withdrawalPeriodMilk != null)
        'withdrawal_period_milk': withdrawalPeriodMilk,
      if (currentStock != null) 'current_stock': currentStock,
      if (minStock != null) 'min_stock': minStock,
      if (stockUnit != null) 'stock_unit': stockUnit,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (currency != null) 'currency': currency,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (storageConditions != null) 'storage_conditions': storageConditions,
      if (prescription != null) 'prescription': prescription,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (type != null) 'type': type,
      if (targetSpecies != null) 'target_species': targetSpecies,
      if (standardCureDays != null) 'standard_cure_days': standardCureDays,
      if (administrationFrequency != null)
        'administration_frequency': administrationFrequency,
      if (dosageFormula != null) 'dosage_formula': dosageFormula,
      if (vaccinationProtocol != null)
        'vaccination_protocol': vaccinationProtocol,
      if (reminderDays != null) 'reminder_days': reminderDays,
      if (defaultAdministrationRoute != null)
        'default_administration_route': defaultAdministrationRoute,
      if (defaultInjectionSite != null)
        'default_injection_site': defaultInjectionSite,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MedicalProductsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String?>? commercialName,
      Value<String>? category,
      Value<String?>? activeIngredient,
      Value<String?>? manufacturer,
      Value<String?>? form,
      Value<double?>? dosage,
      Value<String?>? dosageUnit,
      Value<int>? withdrawalPeriodMeat,
      Value<int>? withdrawalPeriodMilk,
      Value<double>? currentStock,
      Value<double>? minStock,
      Value<String>? stockUnit,
      Value<double?>? unitPrice,
      Value<String?>? currency,
      Value<String?>? batchNumber,
      Value<DateTime?>? expiryDate,
      Value<String?>? storageConditions,
      Value<String?>? prescription,
      Value<String?>? notes,
      Value<bool>? isActive,
      Value<String>? type,
      Value<String>? targetSpecies,
      Value<int?>? standardCureDays,
      Value<String?>? administrationFrequency,
      Value<String?>? dosageFormula,
      Value<String?>? vaccinationProtocol,
      Value<String?>? reminderDays,
      Value<String?>? defaultAdministrationRoute,
      Value<String?>? defaultInjectionSite,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<int?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MedicalProductsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      commercialName: commercialName ?? this.commercialName,
      category: category ?? this.category,
      activeIngredient: activeIngredient ?? this.activeIngredient,
      manufacturer: manufacturer ?? this.manufacturer,
      form: form ?? this.form,
      dosage: dosage ?? this.dosage,
      dosageUnit: dosageUnit ?? this.dosageUnit,
      withdrawalPeriodMeat: withdrawalPeriodMeat ?? this.withdrawalPeriodMeat,
      withdrawalPeriodMilk: withdrawalPeriodMilk ?? this.withdrawalPeriodMilk,
      currentStock: currentStock ?? this.currentStock,
      minStock: minStock ?? this.minStock,
      stockUnit: stockUnit ?? this.stockUnit,
      unitPrice: unitPrice ?? this.unitPrice,
      currency: currency ?? this.currency,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      storageConditions: storageConditions ?? this.storageConditions,
      prescription: prescription ?? this.prescription,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      targetSpecies: targetSpecies ?? this.targetSpecies,
      standardCureDays: standardCureDays ?? this.standardCureDays,
      administrationFrequency:
          administrationFrequency ?? this.administrationFrequency,
      dosageFormula: dosageFormula ?? this.dosageFormula,
      vaccinationProtocol: vaccinationProtocol ?? this.vaccinationProtocol,
      reminderDays: reminderDays ?? this.reminderDays,
      defaultAdministrationRoute:
          defaultAdministrationRoute ?? this.defaultAdministrationRoute,
      defaultInjectionSite: defaultInjectionSite ?? this.defaultInjectionSite,
      synced: synced ?? this.synced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (commercialName.present) {
      map['commercial_name'] = Variable<String>(commercialName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (activeIngredient.present) {
      map['active_ingredient'] = Variable<String>(activeIngredient.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<double>(dosage.value);
    }
    if (dosageUnit.present) {
      map['dosage_unit'] = Variable<String>(dosageUnit.value);
    }
    if (withdrawalPeriodMeat.present) {
      map['withdrawal_period_meat'] = Variable<int>(withdrawalPeriodMeat.value);
    }
    if (withdrawalPeriodMilk.present) {
      map['withdrawal_period_milk'] = Variable<int>(withdrawalPeriodMilk.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<double>(currentStock.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<double>(minStock.value);
    }
    if (stockUnit.present) {
      map['stock_unit'] = Variable<String>(stockUnit.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (storageConditions.present) {
      map['storage_conditions'] = Variable<String>(storageConditions.value);
    }
    if (prescription.present) {
      map['prescription'] = Variable<String>(prescription.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (targetSpecies.present) {
      map['target_species'] = Variable<String>(targetSpecies.value);
    }
    if (standardCureDays.present) {
      map['standard_cure_days'] = Variable<int>(standardCureDays.value);
    }
    if (administrationFrequency.present) {
      map['administration_frequency'] =
          Variable<String>(administrationFrequency.value);
    }
    if (dosageFormula.present) {
      map['dosage_formula'] = Variable<String>(dosageFormula.value);
    }
    if (vaccinationProtocol.present) {
      map['vaccination_protocol'] = Variable<String>(vaccinationProtocol.value);
    }
    if (reminderDays.present) {
      map['reminder_days'] = Variable<String>(reminderDays.value);
    }
    if (defaultAdministrationRoute.present) {
      map['default_administration_route'] =
          Variable<String>(defaultAdministrationRoute.value);
    }
    if (defaultInjectionSite.present) {
      map['default_injection_site'] =
          Variable<String>(defaultInjectionSite.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicalProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('commercialName: $commercialName, ')
          ..write('category: $category, ')
          ..write('activeIngredient: $activeIngredient, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('form: $form, ')
          ..write('dosage: $dosage, ')
          ..write('dosageUnit: $dosageUnit, ')
          ..write('withdrawalPeriodMeat: $withdrawalPeriodMeat, ')
          ..write('withdrawalPeriodMilk: $withdrawalPeriodMilk, ')
          ..write('currentStock: $currentStock, ')
          ..write('minStock: $minStock, ')
          ..write('stockUnit: $stockUnit, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('currency: $currency, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('storageConditions: $storageConditions, ')
          ..write('prescription: $prescription, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('type: $type, ')
          ..write('targetSpecies: $targetSpecies, ')
          ..write('standardCureDays: $standardCureDays, ')
          ..write('administrationFrequency: $administrationFrequency, ')
          ..write('dosageFormula: $dosageFormula, ')
          ..write('vaccinationProtocol: $vaccinationProtocol, ')
          ..write('reminderDays: $reminderDays, ')
          ..write('defaultAdministrationRoute: $defaultAdministrationRoute, ')
          ..write('defaultInjectionSite: $defaultInjectionSite, ')
          ..write('synced: $synced, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VaccinesTableTable extends VaccinesTable
    with TableInfo<$VaccinesTableTable, VaccinesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccinesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _manufacturerMeta =
      const VerificationMeta('manufacturer');
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
      'manufacturer', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _targetSpeciesMeta =
      const VerificationMeta('targetSpecies');
  @override
  late final GeneratedColumn<String> targetSpecies = GeneratedColumn<String>(
      'target_species', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetDiseasesMeta =
      const VerificationMeta('targetDiseases');
  @override
  late final GeneratedColumn<String> targetDiseases = GeneratedColumn<String>(
      'target_diseases', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _standardDoseMeta =
      const VerificationMeta('standardDose');
  @override
  late final GeneratedColumn<String> standardDose = GeneratedColumn<String>(
      'standard_dose', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _injectionsRequiredMeta =
      const VerificationMeta('injectionsRequired');
  @override
  late final GeneratedColumn<int> injectionsRequired = GeneratedColumn<int>(
      'injections_required', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _injectionIntervalDaysMeta =
      const VerificationMeta('injectionIntervalDays');
  @override
  late final GeneratedColumn<int> injectionIntervalDays = GeneratedColumn<int>(
      'injection_interval_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _meatWithdrawalDaysMeta =
      const VerificationMeta('meatWithdrawalDays');
  @override
  late final GeneratedColumn<int> meatWithdrawalDays = GeneratedColumn<int>(
      'meat_withdrawal_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _milkWithdrawalDaysMeta =
      const VerificationMeta('milkWithdrawalDays');
  @override
  late final GeneratedColumn<int> milkWithdrawalDays = GeneratedColumn<int>(
      'milk_withdrawal_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _administrationRouteMeta =
      const VerificationMeta('administrationRoute');
  @override
  late final GeneratedColumn<String> administrationRoute =
      GeneratedColumn<String>('administration_route', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverVersionMeta =
      const VerificationMeta('serverVersion');
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
      'server_version', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        description,
        manufacturer,
        targetSpecies,
        targetDiseases,
        standardDose,
        injectionsRequired,
        injectionIntervalDays,
        meatWithdrawalDays,
        milkWithdrawalDays,
        administrationRoute,
        notes,
        isActive,
        synced,
        lastSyncedAt,
        serverVersion,
        deletedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vaccines';
  @override
  VerificationContext validateIntegrity(Insertable<VaccinesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
          _manufacturerMeta,
          manufacturer.isAcceptableOrUnknown(
              data['manufacturer']!, _manufacturerMeta));
    }
    if (data.containsKey('target_species')) {
      context.handle(
          _targetSpeciesMeta,
          targetSpecies.isAcceptableOrUnknown(
              data['target_species']!, _targetSpeciesMeta));
    } else if (isInserting) {
      context.missing(_targetSpeciesMeta);
    }
    if (data.containsKey('target_diseases')) {
      context.handle(
          _targetDiseasesMeta,
          targetDiseases.isAcceptableOrUnknown(
              data['target_diseases']!, _targetDiseasesMeta));
    } else if (isInserting) {
      context.missing(_targetDiseasesMeta);
    }
    if (data.containsKey('standard_dose')) {
      context.handle(
          _standardDoseMeta,
          standardDose.isAcceptableOrUnknown(
              data['standard_dose']!, _standardDoseMeta));
    }
    if (data.containsKey('injections_required')) {
      context.handle(
          _injectionsRequiredMeta,
          injectionsRequired.isAcceptableOrUnknown(
              data['injections_required']!, _injectionsRequiredMeta));
    }
    if (data.containsKey('injection_interval_days')) {
      context.handle(
          _injectionIntervalDaysMeta,
          injectionIntervalDays.isAcceptableOrUnknown(
              data['injection_interval_days']!, _injectionIntervalDaysMeta));
    }
    if (data.containsKey('meat_withdrawal_days')) {
      context.handle(
          _meatWithdrawalDaysMeta,
          meatWithdrawalDays.isAcceptableOrUnknown(
              data['meat_withdrawal_days']!, _meatWithdrawalDaysMeta));
    } else if (isInserting) {
      context.missing(_meatWithdrawalDaysMeta);
    }
    if (data.containsKey('milk_withdrawal_days')) {
      context.handle(
          _milkWithdrawalDaysMeta,
          milkWithdrawalDays.isAcceptableOrUnknown(
              data['milk_withdrawal_days']!, _milkWithdrawalDaysMeta));
    } else if (isInserting) {
      context.missing(_milkWithdrawalDaysMeta);
    }
    if (data.containsKey('administration_route')) {
      context.handle(
          _administrationRouteMeta,
          administrationRoute.isAcceptableOrUnknown(
              data['administration_route']!, _administrationRouteMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('server_version')) {
      context.handle(
          _serverVersionMeta,
          serverVersion.isAcceptableOrUnknown(
              data['server_version']!, _serverVersionMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VaccinesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaccinesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      manufacturer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}manufacturer']),
      targetSpecies: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_species'])!,
      targetDiseases: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_diseases'])!,
      standardDose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}standard_dose']),
      injectionsRequired: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}injections_required']),
      injectionIntervalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}injection_interval_days']),
      meatWithdrawalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}meat_withdrawal_days'])!,
      milkWithdrawalDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}milk_withdrawal_days'])!,
      administrationRoute: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}administration_route']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_version']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $VaccinesTableTable createAlias(String alias) {
    return $VaccinesTableTable(attachedDatabase, alias);
  }
}

class VaccinesTableData extends DataClass
    implements Insertable<VaccinesTableData> {
  final String id;
  final String farmId;
  final String name;
  final String? description;
  final String? manufacturer;

  /// Liste des espèces cibles: ["ovine", "bovine", "caprine"]
  final String targetSpecies;

  /// Liste des maladies ciblées: ["Clostridium", "Pasteurella"]
  final String targetDiseases;
  final String? standardDose;
  final int? injectionsRequired;
  final int? injectionIntervalDays;
  final int meatWithdrawalDays;
  final int milkWithdrawalDays;
  final String? administrationRoute;
  final String? notes;
  final bool isActive;
  final bool synced;
  final DateTime? lastSyncedAt;
  final int? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VaccinesTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      this.description,
      this.manufacturer,
      required this.targetSpecies,
      required this.targetDiseases,
      this.standardDose,
      this.injectionsRequired,
      this.injectionIntervalDays,
      required this.meatWithdrawalDays,
      required this.milkWithdrawalDays,
      this.administrationRoute,
      this.notes,
      required this.isActive,
      required this.synced,
      this.lastSyncedAt,
      this.serverVersion,
      this.deletedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    map['target_species'] = Variable<String>(targetSpecies);
    map['target_diseases'] = Variable<String>(targetDiseases);
    if (!nullToAbsent || standardDose != null) {
      map['standard_dose'] = Variable<String>(standardDose);
    }
    if (!nullToAbsent || injectionsRequired != null) {
      map['injections_required'] = Variable<int>(injectionsRequired);
    }
    if (!nullToAbsent || injectionIntervalDays != null) {
      map['injection_interval_days'] = Variable<int>(injectionIntervalDays);
    }
    map['meat_withdrawal_days'] = Variable<int>(meatWithdrawalDays);
    map['milk_withdrawal_days'] = Variable<int>(milkWithdrawalDays);
    if (!nullToAbsent || administrationRoute != null) {
      map['administration_route'] = Variable<String>(administrationRoute);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<int>(serverVersion);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VaccinesTableCompanion toCompanion(bool nullToAbsent) {
    return VaccinesTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      targetSpecies: Value(targetSpecies),
      targetDiseases: Value(targetDiseases),
      standardDose: standardDose == null && nullToAbsent
          ? const Value.absent()
          : Value(standardDose),
      injectionsRequired: injectionsRequired == null && nullToAbsent
          ? const Value.absent()
          : Value(injectionsRequired),
      injectionIntervalDays: injectionIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(injectionIntervalDays),
      meatWithdrawalDays: Value(meatWithdrawalDays),
      milkWithdrawalDays: Value(milkWithdrawalDays),
      administrationRoute: administrationRoute == null && nullToAbsent
          ? const Value.absent()
          : Value(administrationRoute),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
      synced: Value(synced),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VaccinesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaccinesTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      targetSpecies: serializer.fromJson<String>(json['targetSpecies']),
      targetDiseases: serializer.fromJson<String>(json['targetDiseases']),
      standardDose: serializer.fromJson<String?>(json['standardDose']),
      injectionsRequired: serializer.fromJson<int?>(json['injectionsRequired']),
      injectionIntervalDays:
          serializer.fromJson<int?>(json['injectionIntervalDays']),
      meatWithdrawalDays: serializer.fromJson<int>(json['meatWithdrawalDays']),
      milkWithdrawalDays: serializer.fromJson<int>(json['milkWithdrawalDays']),
      administrationRoute:
          serializer.fromJson<String?>(json['administrationRoute']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      synced: serializer.fromJson<bool>(json['synced']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      serverVersion: serializer.fromJson<int?>(json['serverVersion']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'targetSpecies': serializer.toJson<String>(targetSpecies),
      'targetDiseases': serializer.toJson<String>(targetDiseases),
      'standardDose': serializer.toJson<String?>(standardDose),
      'injectionsRequired': serializer.toJson<int?>(injectionsRequired),
      'injectionIntervalDays': serializer.toJson<int?>(injectionIntervalDays),
      'meatWithdrawalDays': serializer.toJson<int>(meatWithdrawalDays),
      'milkWithdrawalDays': serializer.toJson<int>(milkWithdrawalDays),
      'administrationRoute': serializer.toJson<String?>(administrationRoute),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VaccinesTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> manufacturer = const Value.absent(),
          String? targetSpecies,
          String? targetDiseases,
          Value<String?> standardDose = const Value.absent(),
          Value<int?> injectionsRequired = const Value.absent(),
          Value<int?> injectionIntervalDays = const Value.absent(),
          int? meatWithdrawalDays,
          int? milkWithdrawalDays,
          Value<String?> administrationRoute = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isActive,
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<int?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      VaccinesTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        manufacturer:
            manufacturer.present ? manufacturer.value : this.manufacturer,
        targetSpecies: targetSpecies ?? this.targetSpecies,
        targetDiseases: targetDiseases ?? this.targetDiseases,
        standardDose:
            standardDose.present ? standardDose.value : this.standardDose,
        injectionsRequired: injectionsRequired.present
            ? injectionsRequired.value
            : this.injectionsRequired,
        injectionIntervalDays: injectionIntervalDays.present
            ? injectionIntervalDays.value
            : this.injectionIntervalDays,
        meatWithdrawalDays: meatWithdrawalDays ?? this.meatWithdrawalDays,
        milkWithdrawalDays: milkWithdrawalDays ?? this.milkWithdrawalDays,
        administrationRoute: administrationRoute.present
            ? administrationRoute.value
            : this.administrationRoute,
        notes: notes.present ? notes.value : this.notes,
        isActive: isActive ?? this.isActive,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  VaccinesTableData copyWithCompanion(VaccinesTableCompanion data) {
    return VaccinesTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      targetSpecies: data.targetSpecies.present
          ? data.targetSpecies.value
          : this.targetSpecies,
      targetDiseases: data.targetDiseases.present
          ? data.targetDiseases.value
          : this.targetDiseases,
      standardDose: data.standardDose.present
          ? data.standardDose.value
          : this.standardDose,
      injectionsRequired: data.injectionsRequired.present
          ? data.injectionsRequired.value
          : this.injectionsRequired,
      injectionIntervalDays: data.injectionIntervalDays.present
          ? data.injectionIntervalDays.value
          : this.injectionIntervalDays,
      meatWithdrawalDays: data.meatWithdrawalDays.present
          ? data.meatWithdrawalDays.value
          : this.meatWithdrawalDays,
      milkWithdrawalDays: data.milkWithdrawalDays.present
          ? data.milkWithdrawalDays.value
          : this.milkWithdrawalDays,
      administrationRoute: data.administrationRoute.present
          ? data.administrationRoute.value
          : this.administrationRoute,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      synced: data.synced.present ? data.synced.value : this.synced,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VaccinesTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('targetSpecies: $targetSpecies, ')
          ..write('targetDiseases: $targetDiseases, ')
          ..write('standardDose: $standardDose, ')
          ..write('injectionsRequired: $injectionsRequired, ')
          ..write('injectionIntervalDays: $injectionIntervalDays, ')
          ..write('meatWithdrawalDays: $meatWithdrawalDays, ')
          ..write('milkWithdrawalDays: $milkWithdrawalDays, ')
          ..write('administrationRoute: $administrationRoute, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('synced: $synced, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        farmId,
        name,
        description,
        manufacturer,
        targetSpecies,
        targetDiseases,
        standardDose,
        injectionsRequired,
        injectionIntervalDays,
        meatWithdrawalDays,
        milkWithdrawalDays,
        administrationRoute,
        notes,
        isActive,
        synced,
        lastSyncedAt,
        serverVersion,
        deletedAt,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VaccinesTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.description == this.description &&
          other.manufacturer == this.manufacturer &&
          other.targetSpecies == this.targetSpecies &&
          other.targetDiseases == this.targetDiseases &&
          other.standardDose == this.standardDose &&
          other.injectionsRequired == this.injectionsRequired &&
          other.injectionIntervalDays == this.injectionIntervalDays &&
          other.meatWithdrawalDays == this.meatWithdrawalDays &&
          other.milkWithdrawalDays == this.milkWithdrawalDays &&
          other.administrationRoute == this.administrationRoute &&
          other.notes == this.notes &&
          other.isActive == this.isActive &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VaccinesTableCompanion extends UpdateCompanion<VaccinesTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> manufacturer;
  final Value<String> targetSpecies;
  final Value<String> targetDiseases;
  final Value<String?> standardDose;
  final Value<int?> injectionsRequired;
  final Value<int?> injectionIntervalDays;
  final Value<int> meatWithdrawalDays;
  final Value<int> milkWithdrawalDays;
  final Value<String?> administrationRoute;
  final Value<String?> notes;
  final Value<bool> isActive;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<int?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VaccinesTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.targetSpecies = const Value.absent(),
    this.targetDiseases = const Value.absent(),
    this.standardDose = const Value.absent(),
    this.injectionsRequired = const Value.absent(),
    this.injectionIntervalDays = const Value.absent(),
    this.meatWithdrawalDays = const Value.absent(),
    this.milkWithdrawalDays = const Value.absent(),
    this.administrationRoute = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaccinesTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    this.description = const Value.absent(),
    this.manufacturer = const Value.absent(),
    required String targetSpecies,
    required String targetDiseases,
    this.standardDose = const Value.absent(),
    this.injectionsRequired = const Value.absent(),
    this.injectionIntervalDays = const Value.absent(),
    required int meatWithdrawalDays,
    required int milkWithdrawalDays,
    this.administrationRoute = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        targetSpecies = Value(targetSpecies),
        targetDiseases = Value(targetDiseases),
        meatWithdrawalDays = Value(meatWithdrawalDays),
        milkWithdrawalDays = Value(milkWithdrawalDays),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<VaccinesTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? manufacturer,
    Expression<String>? targetSpecies,
    Expression<String>? targetDiseases,
    Expression<String>? standardDose,
    Expression<int>? injectionsRequired,
    Expression<int>? injectionIntervalDays,
    Expression<int>? meatWithdrawalDays,
    Expression<int>? milkWithdrawalDays,
    Expression<String>? administrationRoute,
    Expression<String>? notes,
    Expression<bool>? isActive,
    Expression<bool>? synced,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? serverVersion,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (targetSpecies != null) 'target_species': targetSpecies,
      if (targetDiseases != null) 'target_diseases': targetDiseases,
      if (standardDose != null) 'standard_dose': standardDose,
      if (injectionsRequired != null) 'injections_required': injectionsRequired,
      if (injectionIntervalDays != null)
        'injection_interval_days': injectionIntervalDays,
      if (meatWithdrawalDays != null)
        'meat_withdrawal_days': meatWithdrawalDays,
      if (milkWithdrawalDays != null)
        'milk_withdrawal_days': milkWithdrawalDays,
      if (administrationRoute != null)
        'administration_route': administrationRoute,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaccinesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? manufacturer,
      Value<String>? targetSpecies,
      Value<String>? targetDiseases,
      Value<String?>? standardDose,
      Value<int?>? injectionsRequired,
      Value<int?>? injectionIntervalDays,
      Value<int>? meatWithdrawalDays,
      Value<int>? milkWithdrawalDays,
      Value<String?>? administrationRoute,
      Value<String?>? notes,
      Value<bool>? isActive,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<int?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return VaccinesTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
      targetSpecies: targetSpecies ?? this.targetSpecies,
      targetDiseases: targetDiseases ?? this.targetDiseases,
      standardDose: standardDose ?? this.standardDose,
      injectionsRequired: injectionsRequired ?? this.injectionsRequired,
      injectionIntervalDays:
          injectionIntervalDays ?? this.injectionIntervalDays,
      meatWithdrawalDays: meatWithdrawalDays ?? this.meatWithdrawalDays,
      milkWithdrawalDays: milkWithdrawalDays ?? this.milkWithdrawalDays,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      synced: synced ?? this.synced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (targetSpecies.present) {
      map['target_species'] = Variable<String>(targetSpecies.value);
    }
    if (targetDiseases.present) {
      map['target_diseases'] = Variable<String>(targetDiseases.value);
    }
    if (standardDose.present) {
      map['standard_dose'] = Variable<String>(standardDose.value);
    }
    if (injectionsRequired.present) {
      map['injections_required'] = Variable<int>(injectionsRequired.value);
    }
    if (injectionIntervalDays.present) {
      map['injection_interval_days'] =
          Variable<int>(injectionIntervalDays.value);
    }
    if (meatWithdrawalDays.present) {
      map['meat_withdrawal_days'] = Variable<int>(meatWithdrawalDays.value);
    }
    if (milkWithdrawalDays.present) {
      map['milk_withdrawal_days'] = Variable<int>(milkWithdrawalDays.value);
    }
    if (administrationRoute.present) {
      map['administration_route'] = Variable<String>(administrationRoute.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VaccinesTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('targetSpecies: $targetSpecies, ')
          ..write('targetDiseases: $targetDiseases, ')
          ..write('standardDose: $standardDose, ')
          ..write('injectionsRequired: $injectionsRequired, ')
          ..write('injectionIntervalDays: $injectionIntervalDays, ')
          ..write('meatWithdrawalDays: $meatWithdrawalDays, ')
          ..write('milkWithdrawalDays: $milkWithdrawalDays, ')
          ..write('administrationRoute: $administrationRoute, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive, ')
          ..write('synced: $synced, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VeterinariansTableTable extends VeterinariansTable
    with TableInfo<$VeterinariansTableTable, VeterinariansTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VeterinariansTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _farmIdMeta = const VerificationMeta('farmId');
  @override
  late final GeneratedColumn<String> farmId = GeneratedColumn<String>(
      'farm_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _licenseNumberMeta =
      const VerificationMeta('licenseNumber');
  @override
  late final GeneratedColumn<String> licenseNumber = GeneratedColumn<String>(
      'license_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _specialtiesMeta =
      const VerificationMeta('specialties');
  @override
  late final GeneratedColumn<String> specialties = GeneratedColumn<String>(
      'specialties', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clinicMeta = const VerificationMeta('clinic');
  @override
  late final GeneratedColumn<String> clinic = GeneratedColumn<String>(
      'clinic', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mobileMeta = const VerificationMeta('mobile');
  @override
  late final GeneratedColumn<String> mobile = GeneratedColumn<String>(
      'mobile', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
      'city', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _postalCodeMeta =
      const VerificationMeta('postalCode');
  @override
  late final GeneratedColumn<String> postalCode = GeneratedColumn<String>(
      'postal_code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isAvailableMeta =
      const VerificationMeta('isAvailable');
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
      'is_available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_available" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _emergencyServiceMeta =
      const VerificationMeta('emergencyService');
  @override
  late final GeneratedColumn<bool> emergencyService = GeneratedColumn<bool>(
      'emergency_service', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("emergency_service" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _workingHoursMeta =
      const VerificationMeta('workingHours');
  @override
  late final GeneratedColumn<String> workingHours = GeneratedColumn<String>(
      'working_hours', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _consultationFeeMeta =
      const VerificationMeta('consultationFee');
  @override
  late final GeneratedColumn<double> consultationFee = GeneratedColumn<double>(
      'consultation_fee', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _emergencyFeeMeta =
      const VerificationMeta('emergencyFee');
  @override
  late final GeneratedColumn<double> emergencyFee = GeneratedColumn<double>(
      'emergency_fee', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isPreferredMeta =
      const VerificationMeta('isPreferred');
  @override
  late final GeneratedColumn<bool> isPreferred = GeneratedColumn<bool>(
      'is_preferred', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_preferred" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
      'rating', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _totalInterventionsMeta =
      const VerificationMeta('totalInterventions');
  @override
  late final GeneratedColumn<int> totalInterventions = GeneratedColumn<int>(
      'total_interventions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastInterventionDateMeta =
      const VerificationMeta('lastInterventionDate');
  @override
  late final GeneratedColumn<DateTime> lastInterventionDate =
      GeneratedColumn<DateTime>('last_intervention_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastSyncedAtMeta =
      const VerificationMeta('lastSyncedAt');
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
      'last_synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _serverVersionMeta =
      const VerificationMeta('serverVersion');
  @override
  late final GeneratedColumn<int> serverVersion = GeneratedColumn<int>(
      'server_version', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        firstName,
        lastName,
        title,
        licenseNumber,
        specialties,
        clinic,
        phone,
        mobile,
        email,
        address,
        city,
        postalCode,
        country,
        isAvailable,
        emergencyService,
        workingHours,
        consultationFee,
        emergencyFee,
        currency,
        notes,
        isPreferred,
        isDefault,
        rating,
        totalInterventions,
        lastInterventionDate,
        isActive,
        synced,
        lastSyncedAt,
        serverVersion,
        deletedAt,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'veterinarians';
  @override
  VerificationContext validateIntegrity(
      Insertable<VeterinariansTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('farm_id')) {
      context.handle(_farmIdMeta,
          farmId.isAcceptableOrUnknown(data['farm_id']!, _farmIdMeta));
    } else if (isInserting) {
      context.missing(_farmIdMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('license_number')) {
      context.handle(
          _licenseNumberMeta,
          licenseNumber.isAcceptableOrUnknown(
              data['license_number']!, _licenseNumberMeta));
    } else if (isInserting) {
      context.missing(_licenseNumberMeta);
    }
    if (data.containsKey('specialties')) {
      context.handle(
          _specialtiesMeta,
          specialties.isAcceptableOrUnknown(
              data['specialties']!, _specialtiesMeta));
    } else if (isInserting) {
      context.missing(_specialtiesMeta);
    }
    if (data.containsKey('clinic')) {
      context.handle(_clinicMeta,
          clinic.isAcceptableOrUnknown(data['clinic']!, _clinicMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('mobile')) {
      context.handle(_mobileMeta,
          mobile.isAcceptableOrUnknown(data['mobile']!, _mobileMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('city')) {
      context.handle(
          _cityMeta, city.isAcceptableOrUnknown(data['city']!, _cityMeta));
    }
    if (data.containsKey('postal_code')) {
      context.handle(
          _postalCodeMeta,
          postalCode.isAcceptableOrUnknown(
              data['postal_code']!, _postalCodeMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
    }
    if (data.containsKey('emergency_service')) {
      context.handle(
          _emergencyServiceMeta,
          emergencyService.isAcceptableOrUnknown(
              data['emergency_service']!, _emergencyServiceMeta));
    }
    if (data.containsKey('working_hours')) {
      context.handle(
          _workingHoursMeta,
          workingHours.isAcceptableOrUnknown(
              data['working_hours']!, _workingHoursMeta));
    }
    if (data.containsKey('consultation_fee')) {
      context.handle(
          _consultationFeeMeta,
          consultationFee.isAcceptableOrUnknown(
              data['consultation_fee']!, _consultationFeeMeta));
    }
    if (data.containsKey('emergency_fee')) {
      context.handle(
          _emergencyFeeMeta,
          emergencyFee.isAcceptableOrUnknown(
              data['emergency_fee']!, _emergencyFeeMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('is_preferred')) {
      context.handle(
          _isPreferredMeta,
          isPreferred.isAcceptableOrUnknown(
              data['is_preferred']!, _isPreferredMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('rating')) {
      context.handle(_ratingMeta,
          rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta));
    }
    if (data.containsKey('total_interventions')) {
      context.handle(
          _totalInterventionsMeta,
          totalInterventions.isAcceptableOrUnknown(
              data['total_interventions']!, _totalInterventionsMeta));
    }
    if (data.containsKey('last_intervention_date')) {
      context.handle(
          _lastInterventionDateMeta,
          lastInterventionDate.isAcceptableOrUnknown(
              data['last_intervention_date']!, _lastInterventionDateMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
          _lastSyncedAtMeta,
          lastSyncedAt.isAcceptableOrUnknown(
              data['last_synced_at']!, _lastSyncedAtMeta));
    }
    if (data.containsKey('server_version')) {
      context.handle(
          _serverVersionMeta,
          serverVersion.isAcceptableOrUnknown(
              data['server_version']!, _serverVersionMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VeterinariansTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VeterinariansTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      licenseNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license_number'])!,
      specialties: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}specialties'])!,
      clinic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}clinic']),
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      mobile: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mobile']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      city: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}city']),
      postalCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}postal_code']),
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      emergencyService: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}emergency_service'])!,
      workingHours: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}working_hours']),
      consultationFee: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}consultation_fee']),
      emergencyFee: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}emergency_fee']),
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      isPreferred: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_preferred'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      rating: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rating'])!,
      totalInterventions: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_interventions'])!,
      lastInterventionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_intervention_date']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}server_version']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $VeterinariansTableTable createAlias(String alias) {
    return $VeterinariansTableTable(attachedDatabase, alias);
  }
}

class VeterinariansTableData extends DataClass
    implements Insertable<VeterinariansTableData> {
  final String id;
  final String farmId;
  final String firstName;
  final String lastName;
  final String? title;
  final String licenseNumber;

  /// Liste des spécialités (JSON array): ["Ovins", "Bovins"]
  final String specialties;
  final String? clinic;
  final String phone;
  final String? mobile;
  final String? email;
  final String? address;
  final String? city;
  final String? postalCode;
  final String? country;
  final bool isAvailable;
  final bool emergencyService;
  final String? workingHours;
  final double? consultationFee;
  final double? emergencyFee;
  final String? currency;
  final String? notes;
  final bool isPreferred;
  final bool isDefault;
  final int rating;
  final int totalInterventions;
  final DateTime? lastInterventionDate;
  final bool isActive;
  final bool synced;
  final DateTime? lastSyncedAt;
  final int? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VeterinariansTableData(
      {required this.id,
      required this.farmId,
      required this.firstName,
      required this.lastName,
      this.title,
      required this.licenseNumber,
      required this.specialties,
      this.clinic,
      required this.phone,
      this.mobile,
      this.email,
      this.address,
      this.city,
      this.postalCode,
      this.country,
      required this.isAvailable,
      required this.emergencyService,
      this.workingHours,
      this.consultationFee,
      this.emergencyFee,
      this.currency,
      this.notes,
      required this.isPreferred,
      required this.isDefault,
      required this.rating,
      required this.totalInterventions,
      this.lastInterventionDate,
      required this.isActive,
      required this.synced,
      this.lastSyncedAt,
      this.serverVersion,
      this.deletedAt,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['license_number'] = Variable<String>(licenseNumber);
    map['specialties'] = Variable<String>(specialties);
    if (!nullToAbsent || clinic != null) {
      map['clinic'] = Variable<String>(clinic);
    }
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || mobile != null) {
      map['mobile'] = Variable<String>(mobile);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || postalCode != null) {
      map['postal_code'] = Variable<String>(postalCode);
    }
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    map['is_available'] = Variable<bool>(isAvailable);
    map['emergency_service'] = Variable<bool>(emergencyService);
    if (!nullToAbsent || workingHours != null) {
      map['working_hours'] = Variable<String>(workingHours);
    }
    if (!nullToAbsent || consultationFee != null) {
      map['consultation_fee'] = Variable<double>(consultationFee);
    }
    if (!nullToAbsent || emergencyFee != null) {
      map['emergency_fee'] = Variable<double>(emergencyFee);
    }
    if (!nullToAbsent || currency != null) {
      map['currency'] = Variable<String>(currency);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_preferred'] = Variable<bool>(isPreferred);
    map['is_default'] = Variable<bool>(isDefault);
    map['rating'] = Variable<int>(rating);
    map['total_interventions'] = Variable<int>(totalInterventions);
    if (!nullToAbsent || lastInterventionDate != null) {
      map['last_intervention_date'] = Variable<DateTime>(lastInterventionDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<int>(serverVersion);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  VeterinariansTableCompanion toCompanion(bool nullToAbsent) {
    return VeterinariansTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      firstName: Value(firstName),
      lastName: Value(lastName),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      licenseNumber: Value(licenseNumber),
      specialties: Value(specialties),
      clinic:
          clinic == null && nullToAbsent ? const Value.absent() : Value(clinic),
      phone: Value(phone),
      mobile:
          mobile == null && nullToAbsent ? const Value.absent() : Value(mobile),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      postalCode: postalCode == null && nullToAbsent
          ? const Value.absent()
          : Value(postalCode),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
      isAvailable: Value(isAvailable),
      emergencyService: Value(emergencyService),
      workingHours: workingHours == null && nullToAbsent
          ? const Value.absent()
          : Value(workingHours),
      consultationFee: consultationFee == null && nullToAbsent
          ? const Value.absent()
          : Value(consultationFee),
      emergencyFee: emergencyFee == null && nullToAbsent
          ? const Value.absent()
          : Value(emergencyFee),
      currency: currency == null && nullToAbsent
          ? const Value.absent()
          : Value(currency),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isPreferred: Value(isPreferred),
      isDefault: Value(isDefault),
      rating: Value(rating),
      totalInterventions: Value(totalInterventions),
      lastInterventionDate: lastInterventionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastInterventionDate),
      isActive: Value(isActive),
      synced: Value(synced),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory VeterinariansTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VeterinariansTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      title: serializer.fromJson<String?>(json['title']),
      licenseNumber: serializer.fromJson<String>(json['licenseNumber']),
      specialties: serializer.fromJson<String>(json['specialties']),
      clinic: serializer.fromJson<String?>(json['clinic']),
      phone: serializer.fromJson<String>(json['phone']),
      mobile: serializer.fromJson<String?>(json['mobile']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      city: serializer.fromJson<String?>(json['city']),
      postalCode: serializer.fromJson<String?>(json['postalCode']),
      country: serializer.fromJson<String?>(json['country']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      emergencyService: serializer.fromJson<bool>(json['emergencyService']),
      workingHours: serializer.fromJson<String?>(json['workingHours']),
      consultationFee: serializer.fromJson<double?>(json['consultationFee']),
      emergencyFee: serializer.fromJson<double?>(json['emergencyFee']),
      currency: serializer.fromJson<String?>(json['currency']),
      notes: serializer.fromJson<String?>(json['notes']),
      isPreferred: serializer.fromJson<bool>(json['isPreferred']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      rating: serializer.fromJson<int>(json['rating']),
      totalInterventions: serializer.fromJson<int>(json['totalInterventions']),
      lastInterventionDate:
          serializer.fromJson<DateTime?>(json['lastInterventionDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      synced: serializer.fromJson<bool>(json['synced']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      serverVersion: serializer.fromJson<int?>(json['serverVersion']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'title': serializer.toJson<String?>(title),
      'licenseNumber': serializer.toJson<String>(licenseNumber),
      'specialties': serializer.toJson<String>(specialties),
      'clinic': serializer.toJson<String?>(clinic),
      'phone': serializer.toJson<String>(phone),
      'mobile': serializer.toJson<String?>(mobile),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'city': serializer.toJson<String?>(city),
      'postalCode': serializer.toJson<String?>(postalCode),
      'country': serializer.toJson<String?>(country),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'emergencyService': serializer.toJson<bool>(emergencyService),
      'workingHours': serializer.toJson<String?>(workingHours),
      'consultationFee': serializer.toJson<double?>(consultationFee),
      'emergencyFee': serializer.toJson<double?>(emergencyFee),
      'currency': serializer.toJson<String?>(currency),
      'notes': serializer.toJson<String?>(notes),
      'isPreferred': serializer.toJson<bool>(isPreferred),
      'isDefault': serializer.toJson<bool>(isDefault),
      'rating': serializer.toJson<int>(rating),
      'totalInterventions': serializer.toJson<int>(totalInterventions),
      'lastInterventionDate':
          serializer.toJson<DateTime?>(lastInterventionDate),
      'isActive': serializer.toJson<bool>(isActive),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VeterinariansTableData copyWith(
          {String? id,
          String? farmId,
          String? firstName,
          String? lastName,
          Value<String?> title = const Value.absent(),
          String? licenseNumber,
          String? specialties,
          Value<String?> clinic = const Value.absent(),
          String? phone,
          Value<String?> mobile = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> address = const Value.absent(),
          Value<String?> city = const Value.absent(),
          Value<String?> postalCode = const Value.absent(),
          Value<String?> country = const Value.absent(),
          bool? isAvailable,
          bool? emergencyService,
          Value<String?> workingHours = const Value.absent(),
          Value<double?> consultationFee = const Value.absent(),
          Value<double?> emergencyFee = const Value.absent(),
          Value<String?> currency = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? isPreferred,
          bool? isDefault,
          int? rating,
          int? totalInterventions,
          Value<DateTime?> lastInterventionDate = const Value.absent(),
          bool? isActive,
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<int?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      VeterinariansTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        title: title.present ? title.value : this.title,
        licenseNumber: licenseNumber ?? this.licenseNumber,
        specialties: specialties ?? this.specialties,
        clinic: clinic.present ? clinic.value : this.clinic,
        phone: phone ?? this.phone,
        mobile: mobile.present ? mobile.value : this.mobile,
        email: email.present ? email.value : this.email,
        address: address.present ? address.value : this.address,
        city: city.present ? city.value : this.city,
        postalCode: postalCode.present ? postalCode.value : this.postalCode,
        country: country.present ? country.value : this.country,
        isAvailable: isAvailable ?? this.isAvailable,
        emergencyService: emergencyService ?? this.emergencyService,
        workingHours:
            workingHours.present ? workingHours.value : this.workingHours,
        consultationFee: consultationFee.present
            ? consultationFee.value
            : this.consultationFee,
        emergencyFee:
            emergencyFee.present ? emergencyFee.value : this.emergencyFee,
        currency: currency.present ? currency.value : this.currency,
        notes: notes.present ? notes.value : this.notes,
        isPreferred: isPreferred ?? this.isPreferred,
        isDefault: isDefault ?? this.isDefault,
        rating: rating ?? this.rating,
        totalInterventions: totalInterventions ?? this.totalInterventions,
        lastInterventionDate: lastInterventionDate.present
            ? lastInterventionDate.value
            : this.lastInterventionDate,
        isActive: isActive ?? this.isActive,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  VeterinariansTableData copyWithCompanion(VeterinariansTableCompanion data) {
    return VeterinariansTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      title: data.title.present ? data.title.value : this.title,
      licenseNumber: data.licenseNumber.present
          ? data.licenseNumber.value
          : this.licenseNumber,
      specialties:
          data.specialties.present ? data.specialties.value : this.specialties,
      clinic: data.clinic.present ? data.clinic.value : this.clinic,
      phone: data.phone.present ? data.phone.value : this.phone,
      mobile: data.mobile.present ? data.mobile.value : this.mobile,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      postalCode:
          data.postalCode.present ? data.postalCode.value : this.postalCode,
      country: data.country.present ? data.country.value : this.country,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      emergencyService: data.emergencyService.present
          ? data.emergencyService.value
          : this.emergencyService,
      workingHours: data.workingHours.present
          ? data.workingHours.value
          : this.workingHours,
      consultationFee: data.consultationFee.present
          ? data.consultationFee.value
          : this.consultationFee,
      emergencyFee: data.emergencyFee.present
          ? data.emergencyFee.value
          : this.emergencyFee,
      currency: data.currency.present ? data.currency.value : this.currency,
      notes: data.notes.present ? data.notes.value : this.notes,
      isPreferred:
          data.isPreferred.present ? data.isPreferred.value : this.isPreferred,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      rating: data.rating.present ? data.rating.value : this.rating,
      totalInterventions: data.totalInterventions.present
          ? data.totalInterventions.value
          : this.totalInterventions,
      lastInterventionDate: data.lastInterventionDate.present
          ? data.lastInterventionDate.value
          : this.lastInterventionDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      synced: data.synced.present ? data.synced.value : this.synced,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VeterinariansTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('title: $title, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('specialties: $specialties, ')
          ..write('clinic: $clinic, ')
          ..write('phone: $phone, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('postalCode: $postalCode, ')
          ..write('country: $country, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('emergencyService: $emergencyService, ')
          ..write('workingHours: $workingHours, ')
          ..write('consultationFee: $consultationFee, ')
          ..write('emergencyFee: $emergencyFee, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('isPreferred: $isPreferred, ')
          ..write('isDefault: $isDefault, ')
          ..write('rating: $rating, ')
          ..write('totalInterventions: $totalInterventions, ')
          ..write('lastInterventionDate: $lastInterventionDate, ')
          ..write('isActive: $isActive, ')
          ..write('synced: $synced, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        farmId,
        firstName,
        lastName,
        title,
        licenseNumber,
        specialties,
        clinic,
        phone,
        mobile,
        email,
        address,
        city,
        postalCode,
        country,
        isAvailable,
        emergencyService,
        workingHours,
        consultationFee,
        emergencyFee,
        currency,
        notes,
        isPreferred,
        isDefault,
        rating,
        totalInterventions,
        lastInterventionDate,
        isActive,
        synced,
        lastSyncedAt,
        serverVersion,
        deletedAt,
        createdAt,
        updatedAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VeterinariansTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.title == this.title &&
          other.licenseNumber == this.licenseNumber &&
          other.specialties == this.specialties &&
          other.clinic == this.clinic &&
          other.phone == this.phone &&
          other.mobile == this.mobile &&
          other.email == this.email &&
          other.address == this.address &&
          other.city == this.city &&
          other.postalCode == this.postalCode &&
          other.country == this.country &&
          other.isAvailable == this.isAvailable &&
          other.emergencyService == this.emergencyService &&
          other.workingHours == this.workingHours &&
          other.consultationFee == this.consultationFee &&
          other.emergencyFee == this.emergencyFee &&
          other.currency == this.currency &&
          other.notes == this.notes &&
          other.isPreferred == this.isPreferred &&
          other.isDefault == this.isDefault &&
          other.rating == this.rating &&
          other.totalInterventions == this.totalInterventions &&
          other.lastInterventionDate == this.lastInterventionDate &&
          other.isActive == this.isActive &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VeterinariansTableCompanion
    extends UpdateCompanion<VeterinariansTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> title;
  final Value<String> licenseNumber;
  final Value<String> specialties;
  final Value<String?> clinic;
  final Value<String> phone;
  final Value<String?> mobile;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> city;
  final Value<String?> postalCode;
  final Value<String?> country;
  final Value<bool> isAvailable;
  final Value<bool> emergencyService;
  final Value<String?> workingHours;
  final Value<double?> consultationFee;
  final Value<double?> emergencyFee;
  final Value<String?> currency;
  final Value<String?> notes;
  final Value<bool> isPreferred;
  final Value<bool> isDefault;
  final Value<int> rating;
  final Value<int> totalInterventions;
  final Value<DateTime?> lastInterventionDate;
  final Value<bool> isActive;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<int?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VeterinariansTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.title = const Value.absent(),
    this.licenseNumber = const Value.absent(),
    this.specialties = const Value.absent(),
    this.clinic = const Value.absent(),
    this.phone = const Value.absent(),
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.country = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.emergencyService = const Value.absent(),
    this.workingHours = const Value.absent(),
    this.consultationFee = const Value.absent(),
    this.emergencyFee = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.isPreferred = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rating = const Value.absent(),
    this.totalInterventions = const Value.absent(),
    this.lastInterventionDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VeterinariansTableCompanion.insert({
    required String id,
    required String farmId,
    required String firstName,
    required String lastName,
    this.title = const Value.absent(),
    required String licenseNumber,
    required String specialties,
    this.clinic = const Value.absent(),
    required String phone,
    this.mobile = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.postalCode = const Value.absent(),
    this.country = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.emergencyService = const Value.absent(),
    this.workingHours = const Value.absent(),
    this.consultationFee = const Value.absent(),
    this.emergencyFee = const Value.absent(),
    this.currency = const Value.absent(),
    this.notes = const Value.absent(),
    this.isPreferred = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.rating = const Value.absent(),
    this.totalInterventions = const Value.absent(),
    this.lastInterventionDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        firstName = Value(firstName),
        lastName = Value(lastName),
        licenseNumber = Value(licenseNumber),
        specialties = Value(specialties),
        phone = Value(phone),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<VeterinariansTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? title,
    Expression<String>? licenseNumber,
    Expression<String>? specialties,
    Expression<String>? clinic,
    Expression<String>? phone,
    Expression<String>? mobile,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? postalCode,
    Expression<String>? country,
    Expression<bool>? isAvailable,
    Expression<bool>? emergencyService,
    Expression<String>? workingHours,
    Expression<double>? consultationFee,
    Expression<double>? emergencyFee,
    Expression<String>? currency,
    Expression<String>? notes,
    Expression<bool>? isPreferred,
    Expression<bool>? isDefault,
    Expression<int>? rating,
    Expression<int>? totalInterventions,
    Expression<DateTime>? lastInterventionDate,
    Expression<bool>? isActive,
    Expression<bool>? synced,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? serverVersion,
    Expression<DateTime>? deletedAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (title != null) 'title': title,
      if (licenseNumber != null) 'license_number': licenseNumber,
      if (specialties != null) 'specialties': specialties,
      if (clinic != null) 'clinic': clinic,
      if (phone != null) 'phone': phone,
      if (mobile != null) 'mobile': mobile,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (postalCode != null) 'postal_code': postalCode,
      if (country != null) 'country': country,
      if (isAvailable != null) 'is_available': isAvailable,
      if (emergencyService != null) 'emergency_service': emergencyService,
      if (workingHours != null) 'working_hours': workingHours,
      if (consultationFee != null) 'consultation_fee': consultationFee,
      if (emergencyFee != null) 'emergency_fee': emergencyFee,
      if (currency != null) 'currency': currency,
      if (notes != null) 'notes': notes,
      if (isPreferred != null) 'is_preferred': isPreferred,
      if (isDefault != null) 'is_default': isDefault,
      if (rating != null) 'rating': rating,
      if (totalInterventions != null) 'total_interventions': totalInterventions,
      if (lastInterventionDate != null)
        'last_intervention_date': lastInterventionDate,
      if (isActive != null) 'is_active': isActive,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VeterinariansTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String?>? title,
      Value<String>? licenseNumber,
      Value<String>? specialties,
      Value<String?>? clinic,
      Value<String>? phone,
      Value<String?>? mobile,
      Value<String?>? email,
      Value<String?>? address,
      Value<String?>? city,
      Value<String?>? postalCode,
      Value<String?>? country,
      Value<bool>? isAvailable,
      Value<bool>? emergencyService,
      Value<String?>? workingHours,
      Value<double?>? consultationFee,
      Value<double?>? emergencyFee,
      Value<String?>? currency,
      Value<String?>? notes,
      Value<bool>? isPreferred,
      Value<bool>? isDefault,
      Value<int>? rating,
      Value<int>? totalInterventions,
      Value<DateTime?>? lastInterventionDate,
      Value<bool>? isActive,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<int?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return VeterinariansTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      title: title ?? this.title,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      specialties: specialties ?? this.specialties,
      clinic: clinic ?? this.clinic,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isAvailable: isAvailable ?? this.isAvailable,
      emergencyService: emergencyService ?? this.emergencyService,
      workingHours: workingHours ?? this.workingHours,
      consultationFee: consultationFee ?? this.consultationFee,
      emergencyFee: emergencyFee ?? this.emergencyFee,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      isPreferred: isPreferred ?? this.isPreferred,
      isDefault: isDefault ?? this.isDefault,
      rating: rating ?? this.rating,
      totalInterventions: totalInterventions ?? this.totalInterventions,
      lastInterventionDate: lastInterventionDate ?? this.lastInterventionDate,
      isActive: isActive ?? this.isActive,
      synced: synced ?? this.synced,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (farmId.present) {
      map['farm_id'] = Variable<String>(farmId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (licenseNumber.present) {
      map['license_number'] = Variable<String>(licenseNumber.value);
    }
    if (specialties.present) {
      map['specialties'] = Variable<String>(specialties.value);
    }
    if (clinic.present) {
      map['clinic'] = Variable<String>(clinic.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (mobile.present) {
      map['mobile'] = Variable<String>(mobile.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (postalCode.present) {
      map['postal_code'] = Variable<String>(postalCode.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (emergencyService.present) {
      map['emergency_service'] = Variable<bool>(emergencyService.value);
    }
    if (workingHours.present) {
      map['working_hours'] = Variable<String>(workingHours.value);
    }
    if (consultationFee.present) {
      map['consultation_fee'] = Variable<double>(consultationFee.value);
    }
    if (emergencyFee.present) {
      map['emergency_fee'] = Variable<double>(emergencyFee.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isPreferred.present) {
      map['is_preferred'] = Variable<bool>(isPreferred.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (totalInterventions.present) {
      map['total_interventions'] = Variable<int>(totalInterventions.value);
    }
    if (lastInterventionDate.present) {
      map['last_intervention_date'] =
          Variable<DateTime>(lastInterventionDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<int>(serverVersion.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VeterinariansTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('title: $title, ')
          ..write('licenseNumber: $licenseNumber, ')
          ..write('specialties: $specialties, ')
          ..write('clinic: $clinic, ')
          ..write('phone: $phone, ')
          ..write('mobile: $mobile, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('postalCode: $postalCode, ')
          ..write('country: $country, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('emergencyService: $emergencyService, ')
          ..write('workingHours: $workingHours, ')
          ..write('consultationFee: $consultationFee, ')
          ..write('emergencyFee: $emergencyFee, ')
          ..write('currency: $currency, ')
          ..write('notes: $notes, ')
          ..write('isPreferred: $isPreferred, ')
          ..write('isDefault: $isDefault, ')
          ..write('rating: $rating, ')
          ..write('totalInterventions: $totalInterventions, ')
          ..write('lastInterventionDate: $lastInterventionDate, ')
          ..write('isActive: $isActive, ')
          ..write('synced: $synced, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FarmsTableTable farmsTable = $FarmsTableTable(this);
  late final $AnimalsTableTable animalsTable = $AnimalsTableTable(this);
  late final $SpeciesTableTable speciesTable = $SpeciesTableTable(this);
  late final $BreedsTableTable breedsTable = $BreedsTableTable(this);
  late final $MedicalProductsTableTable medicalProductsTable =
      $MedicalProductsTableTable(this);
  late final $VaccinesTableTable vaccinesTable = $VaccinesTableTable(this);
  late final $VeterinariansTableTable veterinariansTable =
      $VeterinariansTableTable(this);
  late final FarmDao farmDao = FarmDao(this as AppDatabase);
  late final AnimalDao animalDao = AnimalDao(this as AppDatabase);
  late final SpeciesDao speciesDao = SpeciesDao(this as AppDatabase);
  late final BreedDao breedDao = BreedDao(this as AppDatabase);
  late final MedicalProductDao medicalProductDao =
      MedicalProductDao(this as AppDatabase);
  late final VaccineDao vaccineDao = VaccineDao(this as AppDatabase);
  late final VeterinarianDao veterinarianDao =
      VeterinarianDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        farmsTable,
        animalsTable,
        speciesTable,
        breedsTable,
        medicalProductsTable,
        vaccinesTable,
        veterinariansTable
      ];
}

typedef $$FarmsTableTableCreateCompanionBuilder = FarmsTableCompanion Function({
  required String id,
  required String name,
  required String location,
  required String ownerId,
  Value<String?> cheptelNumber,
  Value<String?> groupId,
  Value<String?> groupName,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$FarmsTableTableUpdateCompanionBuilder = FarmsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> location,
  Value<String> ownerId,
  Value<String?> cheptelNumber,
  Value<String?> groupId,
  Value<String?> groupName,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$FarmsTableTableFilterComposer
    extends Composer<_$AppDatabase, $FarmsTableTable> {
  $$FarmsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cheptelNumber => $composableBuilder(
      column: $table.cheptelNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$FarmsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FarmsTableTable> {
  $$FarmsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get location => $composableBuilder(
      column: $table.location, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ownerId => $composableBuilder(
      column: $table.ownerId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cheptelNumber => $composableBuilder(
      column: $table.cheptelNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupName => $composableBuilder(
      column: $table.groupName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$FarmsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FarmsTableTable> {
  $$FarmsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get cheptelNumber => $composableBuilder(
      column: $table.cheptelNumber, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FarmsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FarmsTableTable,
    FarmsTableData,
    $$FarmsTableTableFilterComposer,
    $$FarmsTableTableOrderingComposer,
    $$FarmsTableTableAnnotationComposer,
    $$FarmsTableTableCreateCompanionBuilder,
    $$FarmsTableTableUpdateCompanionBuilder,
    (
      FarmsTableData,
      BaseReferences<_$AppDatabase, $FarmsTableTable, FarmsTableData>
    ),
    FarmsTableData,
    PrefetchHooks Function()> {
  $$FarmsTableTableTableManager(_$AppDatabase db, $FarmsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FarmsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FarmsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FarmsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> location = const Value.absent(),
            Value<String> ownerId = const Value.absent(),
            Value<String?> cheptelNumber = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<String?> groupName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmsTableCompanion(
            id: id,
            name: name,
            location: location,
            ownerId: ownerId,
            cheptelNumber: cheptelNumber,
            groupId: groupId,
            groupName: groupName,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String location,
            required String ownerId,
            Value<String?> cheptelNumber = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<String?> groupName = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              FarmsTableCompanion.insert(
            id: id,
            name: name,
            location: location,
            ownerId: ownerId,
            cheptelNumber: cheptelNumber,
            groupId: groupId,
            groupName: groupName,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FarmsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FarmsTableTable,
    FarmsTableData,
    $$FarmsTableTableFilterComposer,
    $$FarmsTableTableOrderingComposer,
    $$FarmsTableTableAnnotationComposer,
    $$FarmsTableTableCreateCompanionBuilder,
    $$FarmsTableTableUpdateCompanionBuilder,
    (
      FarmsTableData,
      BaseReferences<_$AppDatabase, $FarmsTableTable, FarmsTableData>
    ),
    FarmsTableData,
    PrefetchHooks Function()>;
typedef $$AnimalsTableTableCreateCompanionBuilder = AnimalsTableCompanion
    Function({
  required String id,
  required String farmId,
  Value<String?> currentEid,
  Value<String?> officialNumber,
  Value<String?> visualId,
  Value<String?> eidHistory,
  required DateTime birthDate,
  required String sex,
  Value<String?> motherId,
  required String status,
  Value<String?> speciesId,
  Value<String?> breedId,
  Value<String?> photoUrl,
  Value<int?> days,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AnimalsTableTableUpdateCompanionBuilder = AnimalsTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String?> currentEid,
  Value<String?> officialNumber,
  Value<String?> visualId,
  Value<String?> eidHistory,
  Value<DateTime> birthDate,
  Value<String> sex,
  Value<String?> motherId,
  Value<String> status,
  Value<String?> speciesId,
  Value<String?> breedId,
  Value<String?> photoUrl,
  Value<int?> days,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AnimalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AnimalsTableTable> {
  $$AnimalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currentEid => $composableBuilder(
      column: $table.currentEid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get officialNumber => $composableBuilder(
      column: $table.officialNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get visualId => $composableBuilder(
      column: $table.visualId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get eidHistory => $composableBuilder(
      column: $table.eidHistory, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get motherId => $composableBuilder(
      column: $table.motherId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get speciesId => $composableBuilder(
      column: $table.speciesId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get breedId => $composableBuilder(
      column: $table.breedId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$AnimalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AnimalsTableTable> {
  $$AnimalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currentEid => $composableBuilder(
      column: $table.currentEid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get officialNumber => $composableBuilder(
      column: $table.officialNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get visualId => $composableBuilder(
      column: $table.visualId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get eidHistory => $composableBuilder(
      column: $table.eidHistory, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
      column: $table.birthDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sex => $composableBuilder(
      column: $table.sex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get motherId => $composableBuilder(
      column: $table.motherId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get speciesId => $composableBuilder(
      column: $table.speciesId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get breedId => $composableBuilder(
      column: $table.breedId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get photoUrl => $composableBuilder(
      column: $table.photoUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get days => $composableBuilder(
      column: $table.days, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$AnimalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnimalsTableTable> {
  $$AnimalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get currentEid => $composableBuilder(
      column: $table.currentEid, builder: (column) => column);

  GeneratedColumn<String> get officialNumber => $composableBuilder(
      column: $table.officialNumber, builder: (column) => column);

  GeneratedColumn<String> get visualId =>
      $composableBuilder(column: $table.visualId, builder: (column) => column);

  GeneratedColumn<String> get eidHistory => $composableBuilder(
      column: $table.eidHistory, builder: (column) => column);

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get motherId =>
      $composableBuilder(column: $table.motherId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<String> get breedId =>
      $composableBuilder(column: $table.breedId, builder: (column) => column);

  GeneratedColumn<String> get photoUrl =>
      $composableBuilder(column: $table.photoUrl, builder: (column) => column);

  GeneratedColumn<int> get days =>
      $composableBuilder(column: $table.days, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AnimalsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AnimalsTableTable,
    AnimalsTableData,
    $$AnimalsTableTableFilterComposer,
    $$AnimalsTableTableOrderingComposer,
    $$AnimalsTableTableAnnotationComposer,
    $$AnimalsTableTableCreateCompanionBuilder,
    $$AnimalsTableTableUpdateCompanionBuilder,
    (
      AnimalsTableData,
      BaseReferences<_$AppDatabase, $AnimalsTableTable, AnimalsTableData>
    ),
    AnimalsTableData,
    PrefetchHooks Function()> {
  $$AnimalsTableTableTableManager(_$AppDatabase db, $AnimalsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnimalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnimalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnimalsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String?> currentEid = const Value.absent(),
            Value<String?> officialNumber = const Value.absent(),
            Value<String?> visualId = const Value.absent(),
            Value<String?> eidHistory = const Value.absent(),
            Value<DateTime> birthDate = const Value.absent(),
            Value<String> sex = const Value.absent(),
            Value<String?> motherId = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> speciesId = const Value.absent(),
            Value<String?> breedId = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<int?> days = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AnimalsTableCompanion(
            id: id,
            farmId: farmId,
            currentEid: currentEid,
            officialNumber: officialNumber,
            visualId: visualId,
            eidHistory: eidHistory,
            birthDate: birthDate,
            sex: sex,
            motherId: motherId,
            status: status,
            speciesId: speciesId,
            breedId: breedId,
            photoUrl: photoUrl,
            days: days,
            synced: synced,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            Value<String?> currentEid = const Value.absent(),
            Value<String?> officialNumber = const Value.absent(),
            Value<String?> visualId = const Value.absent(),
            Value<String?> eidHistory = const Value.absent(),
            required DateTime birthDate,
            required String sex,
            Value<String?> motherId = const Value.absent(),
            required String status,
            Value<String?> speciesId = const Value.absent(),
            Value<String?> breedId = const Value.absent(),
            Value<String?> photoUrl = const Value.absent(),
            Value<int?> days = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AnimalsTableCompanion.insert(
            id: id,
            farmId: farmId,
            currentEid: currentEid,
            officialNumber: officialNumber,
            visualId: visualId,
            eidHistory: eidHistory,
            birthDate: birthDate,
            sex: sex,
            motherId: motherId,
            status: status,
            speciesId: speciesId,
            breedId: breedId,
            photoUrl: photoUrl,
            days: days,
            synced: synced,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AnimalsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AnimalsTableTable,
    AnimalsTableData,
    $$AnimalsTableTableFilterComposer,
    $$AnimalsTableTableOrderingComposer,
    $$AnimalsTableTableAnnotationComposer,
    $$AnimalsTableTableCreateCompanionBuilder,
    $$AnimalsTableTableUpdateCompanionBuilder,
    (
      AnimalsTableData,
      BaseReferences<_$AppDatabase, $AnimalsTableTable, AnimalsTableData>
    ),
    AnimalsTableData,
    PrefetchHooks Function()>;
typedef $$SpeciesTableTableCreateCompanionBuilder = SpeciesTableCompanion
    Function({
  required String id,
  required String nameFr,
  required String nameEn,
  required String nameAr,
  required String icon,
  Value<int> displayOrder,
  Value<int> rowid,
});
typedef $$SpeciesTableTableUpdateCompanionBuilder = SpeciesTableCompanion
    Function({
  Value<String> id,
  Value<String> nameFr,
  Value<String> nameEn,
  Value<String> nameAr,
  Value<String> icon,
  Value<int> displayOrder,
  Value<int> rowid,
});

class $$SpeciesTableTableFilterComposer
    extends Composer<_$AppDatabase, $SpeciesTableTable> {
  $$SpeciesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFr => $composableBuilder(
      column: $table.nameFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => ColumnFilters(column));
}

class $$SpeciesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SpeciesTableTable> {
  $$SpeciesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFr => $composableBuilder(
      column: $table.nameFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder,
      builder: (column) => ColumnOrderings(column));
}

class $$SpeciesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SpeciesTableTable> {
  $$SpeciesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => column);
}

class $$SpeciesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SpeciesTableTable,
    SpeciesTableData,
    $$SpeciesTableTableFilterComposer,
    $$SpeciesTableTableOrderingComposer,
    $$SpeciesTableTableAnnotationComposer,
    $$SpeciesTableTableCreateCompanionBuilder,
    $$SpeciesTableTableUpdateCompanionBuilder,
    (
      SpeciesTableData,
      BaseReferences<_$AppDatabase, $SpeciesTableTable, SpeciesTableData>
    ),
    SpeciesTableData,
    PrefetchHooks Function()> {
  $$SpeciesTableTableTableManager(_$AppDatabase db, $SpeciesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SpeciesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SpeciesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SpeciesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nameFr = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String> nameAr = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpeciesTableCompanion(
            id: id,
            nameFr: nameFr,
            nameEn: nameEn,
            nameAr: nameAr,
            icon: icon,
            displayOrder: displayOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String nameFr,
            required String nameEn,
            required String nameAr,
            required String icon,
            Value<int> displayOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SpeciesTableCompanion.insert(
            id: id,
            nameFr: nameFr,
            nameEn: nameEn,
            nameAr: nameAr,
            icon: icon,
            displayOrder: displayOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SpeciesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SpeciesTableTable,
    SpeciesTableData,
    $$SpeciesTableTableFilterComposer,
    $$SpeciesTableTableOrderingComposer,
    $$SpeciesTableTableAnnotationComposer,
    $$SpeciesTableTableCreateCompanionBuilder,
    $$SpeciesTableTableUpdateCompanionBuilder,
    (
      SpeciesTableData,
      BaseReferences<_$AppDatabase, $SpeciesTableTable, SpeciesTableData>
    ),
    SpeciesTableData,
    PrefetchHooks Function()>;
typedef $$BreedsTableTableCreateCompanionBuilder = BreedsTableCompanion
    Function({
  required String id,
  required String speciesId,
  required String nameFr,
  required String nameEn,
  required String nameAr,
  Value<String?> description,
  Value<int> displayOrder,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$BreedsTableTableUpdateCompanionBuilder = BreedsTableCompanion
    Function({
  Value<String> id,
  Value<String> speciesId,
  Value<String> nameFr,
  Value<String> nameEn,
  Value<String> nameAr,
  Value<String?> description,
  Value<int> displayOrder,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$BreedsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BreedsTableTable> {
  $$BreedsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get speciesId => $composableBuilder(
      column: $table.speciesId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameFr => $composableBuilder(
      column: $table.nameFr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$BreedsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BreedsTableTable> {
  $$BreedsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get speciesId => $composableBuilder(
      column: $table.speciesId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameFr => $composableBuilder(
      column: $table.nameFr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameAr => $composableBuilder(
      column: $table.nameAr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$BreedsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BreedsTableTable> {
  $$BreedsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get speciesId =>
      $composableBuilder(column: $table.speciesId, builder: (column) => column);

  GeneratedColumn<String> get nameFr =>
      $composableBuilder(column: $table.nameFr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get nameAr =>
      $composableBuilder(column: $table.nameAr, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get displayOrder => $composableBuilder(
      column: $table.displayOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$BreedsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BreedsTableTable,
    BreedsTableData,
    $$BreedsTableTableFilterComposer,
    $$BreedsTableTableOrderingComposer,
    $$BreedsTableTableAnnotationComposer,
    $$BreedsTableTableCreateCompanionBuilder,
    $$BreedsTableTableUpdateCompanionBuilder,
    (
      BreedsTableData,
      BaseReferences<_$AppDatabase, $BreedsTableTable, BreedsTableData>
    ),
    BreedsTableData,
    PrefetchHooks Function()> {
  $$BreedsTableTableTableManager(_$AppDatabase db, $BreedsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BreedsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BreedsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BreedsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> speciesId = const Value.absent(),
            Value<String> nameFr = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String> nameAr = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreedsTableCompanion(
            id: id,
            speciesId: speciesId,
            nameFr: nameFr,
            nameEn: nameEn,
            nameAr: nameAr,
            description: description,
            displayOrder: displayOrder,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String speciesId,
            required String nameFr,
            required String nameEn,
            required String nameAr,
            Value<String?> description = const Value.absent(),
            Value<int> displayOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreedsTableCompanion.insert(
            id: id,
            speciesId: speciesId,
            nameFr: nameFr,
            nameEn: nameEn,
            nameAr: nameAr,
            description: description,
            displayOrder: displayOrder,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BreedsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BreedsTableTable,
    BreedsTableData,
    $$BreedsTableTableFilterComposer,
    $$BreedsTableTableOrderingComposer,
    $$BreedsTableTableAnnotationComposer,
    $$BreedsTableTableCreateCompanionBuilder,
    $$BreedsTableTableUpdateCompanionBuilder,
    (
      BreedsTableData,
      BaseReferences<_$AppDatabase, $BreedsTableTable, BreedsTableData>
    ),
    BreedsTableData,
    PrefetchHooks Function()>;
typedef $$MedicalProductsTableTableCreateCompanionBuilder
    = MedicalProductsTableCompanion Function({
  required String id,
  required String farmId,
  required String name,
  Value<String?> commercialName,
  required String category,
  Value<String?> activeIngredient,
  Value<String?> manufacturer,
  Value<String?> form,
  Value<double?> dosage,
  Value<String?> dosageUnit,
  required int withdrawalPeriodMeat,
  required int withdrawalPeriodMilk,
  required double currentStock,
  required double minStock,
  required String stockUnit,
  Value<double?> unitPrice,
  Value<String?> currency,
  Value<String?> batchNumber,
  Value<DateTime?> expiryDate,
  Value<String?> storageConditions,
  Value<String?> prescription,
  Value<String?> notes,
  Value<bool> isActive,
  Value<String> type,
  Value<String> targetSpecies,
  Value<int?> standardCureDays,
  Value<String?> administrationFrequency,
  Value<String?> dosageFormula,
  Value<String?> vaccinationProtocol,
  Value<String?> reminderDays,
  Value<String?> defaultAdministrationRoute,
  Value<String?> defaultInjectionSite,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MedicalProductsTableTableUpdateCompanionBuilder
    = MedicalProductsTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String?> commercialName,
  Value<String> category,
  Value<String?> activeIngredient,
  Value<String?> manufacturer,
  Value<String?> form,
  Value<double?> dosage,
  Value<String?> dosageUnit,
  Value<int> withdrawalPeriodMeat,
  Value<int> withdrawalPeriodMilk,
  Value<double> currentStock,
  Value<double> minStock,
  Value<String> stockUnit,
  Value<double?> unitPrice,
  Value<String?> currency,
  Value<String?> batchNumber,
  Value<DateTime?> expiryDate,
  Value<String?> storageConditions,
  Value<String?> prescription,
  Value<String?> notes,
  Value<bool> isActive,
  Value<String> type,
  Value<String> targetSpecies,
  Value<int?> standardCureDays,
  Value<String?> administrationFrequency,
  Value<String?> dosageFormula,
  Value<String?> vaccinationProtocol,
  Value<String?> reminderDays,
  Value<String?> defaultAdministrationRoute,
  Value<String?> defaultInjectionSite,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MedicalProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MedicalProductsTableTable> {
  $$MedicalProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get commercialName => $composableBuilder(
      column: $table.commercialName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get activeIngredient => $composableBuilder(
      column: $table.activeIngredient,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get form => $composableBuilder(
      column: $table.form, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosageUnit => $composableBuilder(
      column: $table.dosageUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get withdrawalPeriodMeat => $composableBuilder(
      column: $table.withdrawalPeriodMeat,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get withdrawalPeriodMilk => $composableBuilder(
      column: $table.withdrawalPeriodMilk,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get minStock => $composableBuilder(
      column: $table.minStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get stockUnit => $composableBuilder(
      column: $table.stockUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get storageConditions => $composableBuilder(
      column: $table.storageConditions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get prescription => $composableBuilder(
      column: $table.prescription, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetSpecies => $composableBuilder(
      column: $table.targetSpecies, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get standardCureDays => $composableBuilder(
      column: $table.standardCureDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get administrationFrequency => $composableBuilder(
      column: $table.administrationFrequency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dosageFormula => $composableBuilder(
      column: $table.dosageFormula, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vaccinationProtocol => $composableBuilder(
      column: $table.vaccinationProtocol,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reminderDays => $composableBuilder(
      column: $table.reminderDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultAdministrationRoute => $composableBuilder(
      column: $table.defaultAdministrationRoute,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultInjectionSite => $composableBuilder(
      column: $table.defaultInjectionSite,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$MedicalProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicalProductsTableTable> {
  $$MedicalProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get commercialName => $composableBuilder(
      column: $table.commercialName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get activeIngredient => $composableBuilder(
      column: $table.activeIngredient,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get form => $composableBuilder(
      column: $table.form, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get dosage => $composableBuilder(
      column: $table.dosage, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosageUnit => $composableBuilder(
      column: $table.dosageUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get withdrawalPeriodMeat => $composableBuilder(
      column: $table.withdrawalPeriodMeat,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get withdrawalPeriodMilk => $composableBuilder(
      column: $table.withdrawalPeriodMilk,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentStock => $composableBuilder(
      column: $table.currentStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get minStock => $composableBuilder(
      column: $table.minStock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get stockUnit => $composableBuilder(
      column: $table.stockUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get storageConditions => $composableBuilder(
      column: $table.storageConditions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get prescription => $composableBuilder(
      column: $table.prescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetSpecies => $composableBuilder(
      column: $table.targetSpecies,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get standardCureDays => $composableBuilder(
      column: $table.standardCureDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get administrationFrequency => $composableBuilder(
      column: $table.administrationFrequency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dosageFormula => $composableBuilder(
      column: $table.dosageFormula,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vaccinationProtocol => $composableBuilder(
      column: $table.vaccinationProtocol,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reminderDays => $composableBuilder(
      column: $table.reminderDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultAdministrationRoute => $composableBuilder(
      column: $table.defaultAdministrationRoute,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultInjectionSite => $composableBuilder(
      column: $table.defaultInjectionSite,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$MedicalProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicalProductsTableTable> {
  $$MedicalProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get commercialName => $composableBuilder(
      column: $table.commercialName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get activeIngredient => $composableBuilder(
      column: $table.activeIngredient, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<double> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  GeneratedColumn<String> get dosageUnit => $composableBuilder(
      column: $table.dosageUnit, builder: (column) => column);

  GeneratedColumn<int> get withdrawalPeriodMeat => $composableBuilder(
      column: $table.withdrawalPeriodMeat, builder: (column) => column);

  GeneratedColumn<int> get withdrawalPeriodMilk => $composableBuilder(
      column: $table.withdrawalPeriodMilk, builder: (column) => column);

  GeneratedColumn<double> get currentStock => $composableBuilder(
      column: $table.currentStock, builder: (column) => column);

  GeneratedColumn<double> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<String> get stockUnit =>
      $composableBuilder(column: $table.stockUnit, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<String> get storageConditions => $composableBuilder(
      column: $table.storageConditions, builder: (column) => column);

  GeneratedColumn<String> get prescription => $composableBuilder(
      column: $table.prescription, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get targetSpecies => $composableBuilder(
      column: $table.targetSpecies, builder: (column) => column);

  GeneratedColumn<int> get standardCureDays => $composableBuilder(
      column: $table.standardCureDays, builder: (column) => column);

  GeneratedColumn<String> get administrationFrequency => $composableBuilder(
      column: $table.administrationFrequency, builder: (column) => column);

  GeneratedColumn<String> get dosageFormula => $composableBuilder(
      column: $table.dosageFormula, builder: (column) => column);

  GeneratedColumn<String> get vaccinationProtocol => $composableBuilder(
      column: $table.vaccinationProtocol, builder: (column) => column);

  GeneratedColumn<String> get reminderDays => $composableBuilder(
      column: $table.reminderDays, builder: (column) => column);

  GeneratedColumn<String> get defaultAdministrationRoute => $composableBuilder(
      column: $table.defaultAdministrationRoute, builder: (column) => column);

  GeneratedColumn<String> get defaultInjectionSite => $composableBuilder(
      column: $table.defaultInjectionSite, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MedicalProductsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MedicalProductsTableTable,
    MedicalProductsTableData,
    $$MedicalProductsTableTableFilterComposer,
    $$MedicalProductsTableTableOrderingComposer,
    $$MedicalProductsTableTableAnnotationComposer,
    $$MedicalProductsTableTableCreateCompanionBuilder,
    $$MedicalProductsTableTableUpdateCompanionBuilder,
    (
      MedicalProductsTableData,
      BaseReferences<_$AppDatabase, $MedicalProductsTableTable,
          MedicalProductsTableData>
    ),
    MedicalProductsTableData,
    PrefetchHooks Function()> {
  $$MedicalProductsTableTableTableManager(
      _$AppDatabase db, $MedicalProductsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicalProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicalProductsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicalProductsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> commercialName = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String?> activeIngredient = const Value.absent(),
            Value<String?> manufacturer = const Value.absent(),
            Value<String?> form = const Value.absent(),
            Value<double?> dosage = const Value.absent(),
            Value<String?> dosageUnit = const Value.absent(),
            Value<int> withdrawalPeriodMeat = const Value.absent(),
            Value<int> withdrawalPeriodMilk = const Value.absent(),
            Value<double> currentStock = const Value.absent(),
            Value<double> minStock = const Value.absent(),
            Value<String> stockUnit = const Value.absent(),
            Value<double?> unitPrice = const Value.absent(),
            Value<String?> currency = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String?> storageConditions = const Value.absent(),
            Value<String?> prescription = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> targetSpecies = const Value.absent(),
            Value<int?> standardCureDays = const Value.absent(),
            Value<String?> administrationFrequency = const Value.absent(),
            Value<String?> dosageFormula = const Value.absent(),
            Value<String?> vaccinationProtocol = const Value.absent(),
            Value<String?> reminderDays = const Value.absent(),
            Value<String?> defaultAdministrationRoute = const Value.absent(),
            Value<String?> defaultInjectionSite = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicalProductsTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            commercialName: commercialName,
            category: category,
            activeIngredient: activeIngredient,
            manufacturer: manufacturer,
            form: form,
            dosage: dosage,
            dosageUnit: dosageUnit,
            withdrawalPeriodMeat: withdrawalPeriodMeat,
            withdrawalPeriodMilk: withdrawalPeriodMilk,
            currentStock: currentStock,
            minStock: minStock,
            stockUnit: stockUnit,
            unitPrice: unitPrice,
            currency: currency,
            batchNumber: batchNumber,
            expiryDate: expiryDate,
            storageConditions: storageConditions,
            prescription: prescription,
            notes: notes,
            isActive: isActive,
            type: type,
            targetSpecies: targetSpecies,
            standardCureDays: standardCureDays,
            administrationFrequency: administrationFrequency,
            dosageFormula: dosageFormula,
            vaccinationProtocol: vaccinationProtocol,
            reminderDays: reminderDays,
            defaultAdministrationRoute: defaultAdministrationRoute,
            defaultInjectionSite: defaultInjectionSite,
            synced: synced,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            Value<String?> commercialName = const Value.absent(),
            required String category,
            Value<String?> activeIngredient = const Value.absent(),
            Value<String?> manufacturer = const Value.absent(),
            Value<String?> form = const Value.absent(),
            Value<double?> dosage = const Value.absent(),
            Value<String?> dosageUnit = const Value.absent(),
            required int withdrawalPeriodMeat,
            required int withdrawalPeriodMilk,
            required double currentStock,
            required double minStock,
            required String stockUnit,
            Value<double?> unitPrice = const Value.absent(),
            Value<String?> currency = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String?> storageConditions = const Value.absent(),
            Value<String?> prescription = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> targetSpecies = const Value.absent(),
            Value<int?> standardCureDays = const Value.absent(),
            Value<String?> administrationFrequency = const Value.absent(),
            Value<String?> dosageFormula = const Value.absent(),
            Value<String?> vaccinationProtocol = const Value.absent(),
            Value<String?> reminderDays = const Value.absent(),
            Value<String?> defaultAdministrationRoute = const Value.absent(),
            Value<String?> defaultInjectionSite = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MedicalProductsTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            commercialName: commercialName,
            category: category,
            activeIngredient: activeIngredient,
            manufacturer: manufacturer,
            form: form,
            dosage: dosage,
            dosageUnit: dosageUnit,
            withdrawalPeriodMeat: withdrawalPeriodMeat,
            withdrawalPeriodMilk: withdrawalPeriodMilk,
            currentStock: currentStock,
            minStock: minStock,
            stockUnit: stockUnit,
            unitPrice: unitPrice,
            currency: currency,
            batchNumber: batchNumber,
            expiryDate: expiryDate,
            storageConditions: storageConditions,
            prescription: prescription,
            notes: notes,
            isActive: isActive,
            type: type,
            targetSpecies: targetSpecies,
            standardCureDays: standardCureDays,
            administrationFrequency: administrationFrequency,
            dosageFormula: dosageFormula,
            vaccinationProtocol: vaccinationProtocol,
            reminderDays: reminderDays,
            defaultAdministrationRoute: defaultAdministrationRoute,
            defaultInjectionSite: defaultInjectionSite,
            synced: synced,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MedicalProductsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $MedicalProductsTableTable,
        MedicalProductsTableData,
        $$MedicalProductsTableTableFilterComposer,
        $$MedicalProductsTableTableOrderingComposer,
        $$MedicalProductsTableTableAnnotationComposer,
        $$MedicalProductsTableTableCreateCompanionBuilder,
        $$MedicalProductsTableTableUpdateCompanionBuilder,
        (
          MedicalProductsTableData,
          BaseReferences<_$AppDatabase, $MedicalProductsTableTable,
              MedicalProductsTableData>
        ),
        MedicalProductsTableData,
        PrefetchHooks Function()>;
typedef $$VaccinesTableTableCreateCompanionBuilder = VaccinesTableCompanion
    Function({
  required String id,
  required String farmId,
  required String name,
  Value<String?> description,
  Value<String?> manufacturer,
  required String targetSpecies,
  required String targetDiseases,
  Value<String?> standardDose,
  Value<int?> injectionsRequired,
  Value<int?> injectionIntervalDays,
  required int meatWithdrawalDays,
  required int milkWithdrawalDays,
  Value<String?> administrationRoute,
  Value<String?> notes,
  Value<bool> isActive,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$VaccinesTableTableUpdateCompanionBuilder = VaccinesTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String?> description,
  Value<String?> manufacturer,
  Value<String> targetSpecies,
  Value<String> targetDiseases,
  Value<String?> standardDose,
  Value<int?> injectionsRequired,
  Value<int?> injectionIntervalDays,
  Value<int> meatWithdrawalDays,
  Value<int> milkWithdrawalDays,
  Value<String?> administrationRoute,
  Value<String?> notes,
  Value<bool> isActive,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$VaccinesTableTableFilterComposer
    extends Composer<_$AppDatabase, $VaccinesTableTable> {
  $$VaccinesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetSpecies => $composableBuilder(
      column: $table.targetSpecies, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetDiseases => $composableBuilder(
      column: $table.targetDiseases,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get standardDose => $composableBuilder(
      column: $table.standardDose, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get injectionsRequired => $composableBuilder(
      column: $table.injectionsRequired,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get injectionIntervalDays => $composableBuilder(
      column: $table.injectionIntervalDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get meatWithdrawalDays => $composableBuilder(
      column: $table.meatWithdrawalDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get milkWithdrawalDays => $composableBuilder(
      column: $table.milkWithdrawalDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get administrationRoute => $composableBuilder(
      column: $table.administrationRoute,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$VaccinesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VaccinesTableTable> {
  $$VaccinesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetSpecies => $composableBuilder(
      column: $table.targetSpecies,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetDiseases => $composableBuilder(
      column: $table.targetDiseases,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get standardDose => $composableBuilder(
      column: $table.standardDose,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get injectionsRequired => $composableBuilder(
      column: $table.injectionsRequired,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get injectionIntervalDays => $composableBuilder(
      column: $table.injectionIntervalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get meatWithdrawalDays => $composableBuilder(
      column: $table.meatWithdrawalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get milkWithdrawalDays => $composableBuilder(
      column: $table.milkWithdrawalDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get administrationRoute => $composableBuilder(
      column: $table.administrationRoute,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$VaccinesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaccinesTableTable> {
  $$VaccinesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get manufacturer => $composableBuilder(
      column: $table.manufacturer, builder: (column) => column);

  GeneratedColumn<String> get targetSpecies => $composableBuilder(
      column: $table.targetSpecies, builder: (column) => column);

  GeneratedColumn<String> get targetDiseases => $composableBuilder(
      column: $table.targetDiseases, builder: (column) => column);

  GeneratedColumn<String> get standardDose => $composableBuilder(
      column: $table.standardDose, builder: (column) => column);

  GeneratedColumn<int> get injectionsRequired => $composableBuilder(
      column: $table.injectionsRequired, builder: (column) => column);

  GeneratedColumn<int> get injectionIntervalDays => $composableBuilder(
      column: $table.injectionIntervalDays, builder: (column) => column);

  GeneratedColumn<int> get meatWithdrawalDays => $composableBuilder(
      column: $table.meatWithdrawalDays, builder: (column) => column);

  GeneratedColumn<int> get milkWithdrawalDays => $composableBuilder(
      column: $table.milkWithdrawalDays, builder: (column) => column);

  GeneratedColumn<String> get administrationRoute => $composableBuilder(
      column: $table.administrationRoute, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VaccinesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VaccinesTableTable,
    VaccinesTableData,
    $$VaccinesTableTableFilterComposer,
    $$VaccinesTableTableOrderingComposer,
    $$VaccinesTableTableAnnotationComposer,
    $$VaccinesTableTableCreateCompanionBuilder,
    $$VaccinesTableTableUpdateCompanionBuilder,
    (
      VaccinesTableData,
      BaseReferences<_$AppDatabase, $VaccinesTableTable, VaccinesTableData>
    ),
    VaccinesTableData,
    PrefetchHooks Function()> {
  $$VaccinesTableTableTableManager(_$AppDatabase db, $VaccinesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccinesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccinesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccinesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> manufacturer = const Value.absent(),
            Value<String> targetSpecies = const Value.absent(),
            Value<String> targetDiseases = const Value.absent(),
            Value<String?> standardDose = const Value.absent(),
            Value<int?> injectionsRequired = const Value.absent(),
            Value<int?> injectionIntervalDays = const Value.absent(),
            Value<int> meatWithdrawalDays = const Value.absent(),
            Value<int> milkWithdrawalDays = const Value.absent(),
            Value<String?> administrationRoute = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaccinesTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            description: description,
            manufacturer: manufacturer,
            targetSpecies: targetSpecies,
            targetDiseases: targetDiseases,
            standardDose: standardDose,
            injectionsRequired: injectionsRequired,
            injectionIntervalDays: injectionIntervalDays,
            meatWithdrawalDays: meatWithdrawalDays,
            milkWithdrawalDays: milkWithdrawalDays,
            administrationRoute: administrationRoute,
            notes: notes,
            isActive: isActive,
            synced: synced,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> manufacturer = const Value.absent(),
            required String targetSpecies,
            required String targetDiseases,
            Value<String?> standardDose = const Value.absent(),
            Value<int?> injectionsRequired = const Value.absent(),
            Value<int?> injectionIntervalDays = const Value.absent(),
            required int meatWithdrawalDays,
            required int milkWithdrawalDays,
            Value<String?> administrationRoute = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              VaccinesTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            description: description,
            manufacturer: manufacturer,
            targetSpecies: targetSpecies,
            targetDiseases: targetDiseases,
            standardDose: standardDose,
            injectionsRequired: injectionsRequired,
            injectionIntervalDays: injectionIntervalDays,
            meatWithdrawalDays: meatWithdrawalDays,
            milkWithdrawalDays: milkWithdrawalDays,
            administrationRoute: administrationRoute,
            notes: notes,
            isActive: isActive,
            synced: synced,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VaccinesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VaccinesTableTable,
    VaccinesTableData,
    $$VaccinesTableTableFilterComposer,
    $$VaccinesTableTableOrderingComposer,
    $$VaccinesTableTableAnnotationComposer,
    $$VaccinesTableTableCreateCompanionBuilder,
    $$VaccinesTableTableUpdateCompanionBuilder,
    (
      VaccinesTableData,
      BaseReferences<_$AppDatabase, $VaccinesTableTable, VaccinesTableData>
    ),
    VaccinesTableData,
    PrefetchHooks Function()>;
typedef $$VeterinariansTableTableCreateCompanionBuilder
    = VeterinariansTableCompanion Function({
  required String id,
  required String farmId,
  required String firstName,
  required String lastName,
  Value<String?> title,
  required String licenseNumber,
  required String specialties,
  Value<String?> clinic,
  required String phone,
  Value<String?> mobile,
  Value<String?> email,
  Value<String?> address,
  Value<String?> city,
  Value<String?> postalCode,
  Value<String?> country,
  Value<bool> isAvailable,
  Value<bool> emergencyService,
  Value<String?> workingHours,
  Value<double?> consultationFee,
  Value<double?> emergencyFee,
  Value<String?> currency,
  Value<String?> notes,
  Value<bool> isPreferred,
  Value<bool> isDefault,
  Value<int> rating,
  Value<int> totalInterventions,
  Value<DateTime?> lastInterventionDate,
  Value<bool> isActive,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$VeterinariansTableTableUpdateCompanionBuilder
    = VeterinariansTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> firstName,
  Value<String> lastName,
  Value<String?> title,
  Value<String> licenseNumber,
  Value<String> specialties,
  Value<String?> clinic,
  Value<String> phone,
  Value<String?> mobile,
  Value<String?> email,
  Value<String?> address,
  Value<String?> city,
  Value<String?> postalCode,
  Value<String?> country,
  Value<bool> isAvailable,
  Value<bool> emergencyService,
  Value<String?> workingHours,
  Value<double?> consultationFee,
  Value<double?> emergencyFee,
  Value<String?> currency,
  Value<String?> notes,
  Value<bool> isPreferred,
  Value<bool> isDefault,
  Value<int> rating,
  Value<int> totalInterventions,
  Value<DateTime?> lastInterventionDate,
  Value<bool> isActive,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$VeterinariansTableTableFilterComposer
    extends Composer<_$AppDatabase, $VeterinariansTableTable> {
  $$VeterinariansTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get licenseNumber => $composableBuilder(
      column: $table.licenseNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get specialties => $composableBuilder(
      column: $table.specialties, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clinic => $composableBuilder(
      column: $table.clinic, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get emergencyService => $composableBuilder(
      column: $table.emergencyService,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workingHours => $composableBuilder(
      column: $table.workingHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get consultationFee => $composableBuilder(
      column: $table.consultationFee,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get emergencyFee => $composableBuilder(
      column: $table.emergencyFee, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPreferred => $composableBuilder(
      column: $table.isPreferred, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalInterventions => $composableBuilder(
      column: $table.totalInterventions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastInterventionDate => $composableBuilder(
      column: $table.lastInterventionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$VeterinariansTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VeterinariansTableTable> {
  $$VeterinariansTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get farmId => $composableBuilder(
      column: $table.farmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get licenseNumber => $composableBuilder(
      column: $table.licenseNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get specialties => $composableBuilder(
      column: $table.specialties, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clinic => $composableBuilder(
      column: $table.clinic, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mobile => $composableBuilder(
      column: $table.mobile, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get city => $composableBuilder(
      column: $table.city, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get emergencyService => $composableBuilder(
      column: $table.emergencyService,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workingHours => $composableBuilder(
      column: $table.workingHours,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get consultationFee => $composableBuilder(
      column: $table.consultationFee,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get emergencyFee => $composableBuilder(
      column: $table.emergencyFee,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get currency => $composableBuilder(
      column: $table.currency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPreferred => $composableBuilder(
      column: $table.isPreferred, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get rating => $composableBuilder(
      column: $table.rating, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalInterventions => $composableBuilder(
      column: $table.totalInterventions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastInterventionDate => $composableBuilder(
      column: $table.lastInterventionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$VeterinariansTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VeterinariansTableTable> {
  $$VeterinariansTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get farmId =>
      $composableBuilder(column: $table.farmId, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get licenseNumber => $composableBuilder(
      column: $table.licenseNumber, builder: (column) => column);

  GeneratedColumn<String> get specialties => $composableBuilder(
      column: $table.specialties, builder: (column) => column);

  GeneratedColumn<String> get clinic =>
      $composableBuilder(column: $table.clinic, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get mobile =>
      $composableBuilder(column: $table.mobile, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get postalCode => $composableBuilder(
      column: $table.postalCode, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<bool> get emergencyService => $composableBuilder(
      column: $table.emergencyService, builder: (column) => column);

  GeneratedColumn<String> get workingHours => $composableBuilder(
      column: $table.workingHours, builder: (column) => column);

  GeneratedColumn<double> get consultationFee => $composableBuilder(
      column: $table.consultationFee, builder: (column) => column);

  GeneratedColumn<double> get emergencyFee => $composableBuilder(
      column: $table.emergencyFee, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isPreferred => $composableBuilder(
      column: $table.isPreferred, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<int> get totalInterventions => $composableBuilder(
      column: $table.totalInterventions, builder: (column) => column);

  GeneratedColumn<DateTime> get lastInterventionDate => $composableBuilder(
      column: $table.lastInterventionDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<int> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$VeterinariansTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VeterinariansTableTable,
    VeterinariansTableData,
    $$VeterinariansTableTableFilterComposer,
    $$VeterinariansTableTableOrderingComposer,
    $$VeterinariansTableTableAnnotationComposer,
    $$VeterinariansTableTableCreateCompanionBuilder,
    $$VeterinariansTableTableUpdateCompanionBuilder,
    (
      VeterinariansTableData,
      BaseReferences<_$AppDatabase, $VeterinariansTableTable,
          VeterinariansTableData>
    ),
    VeterinariansTableData,
    PrefetchHooks Function()> {
  $$VeterinariansTableTableTableManager(
      _$AppDatabase db, $VeterinariansTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VeterinariansTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VeterinariansTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VeterinariansTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String> licenseNumber = const Value.absent(),
            Value<String> specialties = const Value.absent(),
            Value<String?> clinic = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String?> mobile = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> postalCode = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<bool> emergencyService = const Value.absent(),
            Value<String?> workingHours = const Value.absent(),
            Value<double?> consultationFee = const Value.absent(),
            Value<double?> emergencyFee = const Value.absent(),
            Value<String?> currency = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isPreferred = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<int> totalInterventions = const Value.absent(),
            Value<DateTime?> lastInterventionDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VeterinariansTableCompanion(
            id: id,
            farmId: farmId,
            firstName: firstName,
            lastName: lastName,
            title: title,
            licenseNumber: licenseNumber,
            specialties: specialties,
            clinic: clinic,
            phone: phone,
            mobile: mobile,
            email: email,
            address: address,
            city: city,
            postalCode: postalCode,
            country: country,
            isAvailable: isAvailable,
            emergencyService: emergencyService,
            workingHours: workingHours,
            consultationFee: consultationFee,
            emergencyFee: emergencyFee,
            currency: currency,
            notes: notes,
            isPreferred: isPreferred,
            isDefault: isDefault,
            rating: rating,
            totalInterventions: totalInterventions,
            lastInterventionDate: lastInterventionDate,
            isActive: isActive,
            synced: synced,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String firstName,
            required String lastName,
            Value<String?> title = const Value.absent(),
            required String licenseNumber,
            required String specialties,
            Value<String?> clinic = const Value.absent(),
            required String phone,
            Value<String?> mobile = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> city = const Value.absent(),
            Value<String?> postalCode = const Value.absent(),
            Value<String?> country = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<bool> emergencyService = const Value.absent(),
            Value<String?> workingHours = const Value.absent(),
            Value<double?> consultationFee = const Value.absent(),
            Value<double?> emergencyFee = const Value.absent(),
            Value<String?> currency = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> isPreferred = const Value.absent(),
            Value<bool> isDefault = const Value.absent(),
            Value<int> rating = const Value.absent(),
            Value<int> totalInterventions = const Value.absent(),
            Value<DateTime?> lastInterventionDate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              VeterinariansTableCompanion.insert(
            id: id,
            farmId: farmId,
            firstName: firstName,
            lastName: lastName,
            title: title,
            licenseNumber: licenseNumber,
            specialties: specialties,
            clinic: clinic,
            phone: phone,
            mobile: mobile,
            email: email,
            address: address,
            city: city,
            postalCode: postalCode,
            country: country,
            isAvailable: isAvailable,
            emergencyService: emergencyService,
            workingHours: workingHours,
            consultationFee: consultationFee,
            emergencyFee: emergencyFee,
            currency: currency,
            notes: notes,
            isPreferred: isPreferred,
            isDefault: isDefault,
            rating: rating,
            totalInterventions: totalInterventions,
            lastInterventionDate: lastInterventionDate,
            isActive: isActive,
            synced: synced,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$VeterinariansTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VeterinariansTableTable,
    VeterinariansTableData,
    $$VeterinariansTableTableFilterComposer,
    $$VeterinariansTableTableOrderingComposer,
    $$VeterinariansTableTableAnnotationComposer,
    $$VeterinariansTableTableCreateCompanionBuilder,
    $$VeterinariansTableTableUpdateCompanionBuilder,
    (
      VeterinariansTableData,
      BaseReferences<_$AppDatabase, $VeterinariansTableTable,
          VeterinariansTableData>
    ),
    VeterinariansTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FarmsTableTableTableManager get farmsTable =>
      $$FarmsTableTableTableManager(_db, _db.farmsTable);
  $$AnimalsTableTableTableManager get animalsTable =>
      $$AnimalsTableTableTableManager(_db, _db.animalsTable);
  $$SpeciesTableTableTableManager get speciesTable =>
      $$SpeciesTableTableTableManager(_db, _db.speciesTable);
  $$BreedsTableTableTableManager get breedsTable =>
      $$BreedsTableTableTableManager(_db, _db.breedsTable);
  $$MedicalProductsTableTableTableManager get medicalProductsTable =>
      $$MedicalProductsTableTableTableManager(_db, _db.medicalProductsTable);
  $$VaccinesTableTableTableManager get vaccinesTable =>
      $$VaccinesTableTableTableManager(_db, _db.vaccinesTable);
  $$VeterinariansTableTableTableManager get veterinariansTable =>
      $$VeterinariansTableTableTableManager(_db, _db.veterinariansTable);
}
