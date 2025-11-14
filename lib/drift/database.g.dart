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
        isDefault,
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
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
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
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
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
  final bool isDefault;
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
      required this.isDefault,
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
    map['is_default'] = Variable<bool>(isDefault);
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
      isDefault: Value(isDefault),
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
      isDefault: serializer.fromJson<bool>(json['isDefault']),
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
      'isDefault': serializer.toJson<bool>(isDefault),
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
          bool? isDefault,
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
        isDefault: isDefault ?? this.isDefault,
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
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
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
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, location, ownerId, cheptelNumber,
      groupId, groupName, isDefault, createdAt, updatedAt);
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
          other.isDefault == this.isDefault &&
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
  final Value<bool> isDefault;
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
    this.isDefault = const Value.absent(),
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
    this.isDefault = const Value.absent(),
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
    Expression<bool>? isDefault,
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
      if (isDefault != null) 'is_default': isDefault,
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
      Value<bool>? isDefault,
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
      isDefault: isDefault ?? this.isDefault,
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
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
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
          ..write('isDefault: $isDefault, ')
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
  static const VerificationMeta _validatedAtMeta =
      const VerificationMeta('validatedAt');
  @override
  late final GeneratedColumn<DateTime> validatedAt = GeneratedColumn<DateTime>(
      'validated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
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
        validatedAt,
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
    if (data.containsKey('validated_at')) {
      context.handle(
          _validatedAtMeta,
          validatedAt.isAcceptableOrUnknown(
              data['validated_at']!, _validatedAtMeta));
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
      validatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}validated_at']),
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
  final DateTime? validatedAt;
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
      this.validatedAt,
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
    if (!nullToAbsent || validatedAt != null) {
      map['validated_at'] = Variable<DateTime>(validatedAt);
    }
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
      validatedAt: validatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(validatedAt),
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
      validatedAt: serializer.fromJson<DateTime?>(json['validatedAt']),
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
      'validatedAt': serializer.toJson<DateTime?>(validatedAt),
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
          Value<DateTime?> validatedAt = const Value.absent(),
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
        validatedAt: validatedAt.present ? validatedAt.value : this.validatedAt,
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
      validatedAt:
          data.validatedAt.present ? data.validatedAt.value : this.validatedAt,
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
          ..write('validatedAt: $validatedAt, ')
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
  int get hashCode => Object.hashAll([
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
        validatedAt,
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
      ]);
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
          other.validatedAt == this.validatedAt &&
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
  final Value<DateTime?> validatedAt;
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
    this.validatedAt = const Value.absent(),
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
    this.validatedAt = const Value.absent(),
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
    Expression<DateTime>? validatedAt,
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
      if (validatedAt != null) 'validated_at': validatedAt,
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
      Value<DateTime?>? validatedAt,
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
      validatedAt: validatedAt ?? this.validatedAt,
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
    if (validatedAt.present) {
      map['validated_at'] = Variable<DateTime>(validatedAt.value);
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
          ..write('validatedAt: $validatedAt, ')
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

class $BreedingsTableTable extends BreedingsTable
    with TableInfo<$BreedingsTableTable, BreedingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BreedingsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _motherIdMeta =
      const VerificationMeta('motherId');
  @override
  late final GeneratedColumn<String> motherId = GeneratedColumn<String>(
      'mother_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fatherIdMeta =
      const VerificationMeta('fatherId');
  @override
  late final GeneratedColumn<String> fatherId = GeneratedColumn<String>(
      'father_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _fatherNameMeta =
      const VerificationMeta('fatherName');
  @override
  late final GeneratedColumn<String> fatherName = GeneratedColumn<String>(
      'father_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
      'method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _breedingDateMeta =
      const VerificationMeta('breedingDate');
  @override
  late final GeneratedColumn<DateTime> breedingDate = GeneratedColumn<DateTime>(
      'breeding_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expectedBirthDateMeta =
      const VerificationMeta('expectedBirthDate');
  @override
  late final GeneratedColumn<DateTime> expectedBirthDate =
      GeneratedColumn<DateTime>('expected_birth_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _actualBirthDateMeta =
      const VerificationMeta('actualBirthDate');
  @override
  late final GeneratedColumn<DateTime> actualBirthDate =
      GeneratedColumn<DateTime>('actual_birth_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _expectedOffspringCountMeta =
      const VerificationMeta('expectedOffspringCount');
  @override
  late final GeneratedColumn<int> expectedOffspringCount = GeneratedColumn<int>(
      'expected_offspring_count', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _offspringIdsMeta =
      const VerificationMeta('offspringIds');
  @override
  late final GeneratedColumn<String> offspringIds = GeneratedColumn<String>(
      'offspring_ids', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _veterinarianIdMeta =
      const VerificationMeta('veterinarianId');
  @override
  late final GeneratedColumn<String> veterinarianId = GeneratedColumn<String>(
      'veterinarian_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _veterinarianNameMeta =
      const VerificationMeta('veterinarianName');
  @override
  late final GeneratedColumn<String> veterinarianName = GeneratedColumn<String>(
      'veterinarian_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
        motherId,
        fatherId,
        fatherName,
        method,
        breedingDate,
        expectedBirthDate,
        actualBirthDate,
        expectedOffspringCount,
        offspringIds,
        veterinarianId,
        veterinarianName,
        notes,
        status,
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
  static const String $name = 'breedings';
  @override
  VerificationContext validateIntegrity(Insertable<BreedingsTableData> instance,
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
    if (data.containsKey('mother_id')) {
      context.handle(_motherIdMeta,
          motherId.isAcceptableOrUnknown(data['mother_id']!, _motherIdMeta));
    } else if (isInserting) {
      context.missing(_motherIdMeta);
    }
    if (data.containsKey('father_id')) {
      context.handle(_fatherIdMeta,
          fatherId.isAcceptableOrUnknown(data['father_id']!, _fatherIdMeta));
    }
    if (data.containsKey('father_name')) {
      context.handle(
          _fatherNameMeta,
          fatherName.isAcceptableOrUnknown(
              data['father_name']!, _fatherNameMeta));
    }
    if (data.containsKey('method')) {
      context.handle(_methodMeta,
          method.isAcceptableOrUnknown(data['method']!, _methodMeta));
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('breeding_date')) {
      context.handle(
          _breedingDateMeta,
          breedingDate.isAcceptableOrUnknown(
              data['breeding_date']!, _breedingDateMeta));
    } else if (isInserting) {
      context.missing(_breedingDateMeta);
    }
    if (data.containsKey('expected_birth_date')) {
      context.handle(
          _expectedBirthDateMeta,
          expectedBirthDate.isAcceptableOrUnknown(
              data['expected_birth_date']!, _expectedBirthDateMeta));
    } else if (isInserting) {
      context.missing(_expectedBirthDateMeta);
    }
    if (data.containsKey('actual_birth_date')) {
      context.handle(
          _actualBirthDateMeta,
          actualBirthDate.isAcceptableOrUnknown(
              data['actual_birth_date']!, _actualBirthDateMeta));
    }
    if (data.containsKey('expected_offspring_count')) {
      context.handle(
          _expectedOffspringCountMeta,
          expectedOffspringCount.isAcceptableOrUnknown(
              data['expected_offspring_count']!, _expectedOffspringCountMeta));
    }
    if (data.containsKey('offspring_ids')) {
      context.handle(
          _offspringIdsMeta,
          offspringIds.isAcceptableOrUnknown(
              data['offspring_ids']!, _offspringIdsMeta));
    }
    if (data.containsKey('veterinarian_id')) {
      context.handle(
          _veterinarianIdMeta,
          veterinarianId.isAcceptableOrUnknown(
              data['veterinarian_id']!, _veterinarianIdMeta));
    }
    if (data.containsKey('veterinarian_name')) {
      context.handle(
          _veterinarianNameMeta,
          veterinarianName.isAcceptableOrUnknown(
              data['veterinarian_name']!, _veterinarianNameMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
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
  BreedingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BreedingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      motherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mother_id'])!,
      fatherId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}father_id']),
      fatherName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}father_name']),
      method: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}method'])!,
      breedingDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}breeding_date'])!,
      expectedBirthDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}expected_birth_date'])!,
      actualBirthDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}actual_birth_date']),
      expectedOffspringCount: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}expected_offspring_count']),
      offspringIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}offspring_ids']),
      veterinarianId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}veterinarian_id']),
      veterinarianName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}veterinarian_name']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
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
  $BreedingsTableTable createAlias(String alias) {
    return $BreedingsTableTable(attachedDatabase, alias);
  }
}

class BreedingsTableData extends DataClass
    implements Insertable<BreedingsTableData> {
  final String id;
  final String farmId;
  final String motherId;
  final String? fatherId;
  final String? fatherName;
  final String method;
  final DateTime breedingDate;
  final DateTime expectedBirthDate;
  final DateTime? actualBirthDate;
  final int? expectedOffspringCount;
  final String? offspringIds;
  final String? veterinarianId;
  final String? veterinarianName;
  final String? notes;
  final String status;
  final bool synced;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BreedingsTableData(
      {required this.id,
      required this.farmId,
      required this.motherId,
      this.fatherId,
      this.fatherName,
      required this.method,
      required this.breedingDate,
      required this.expectedBirthDate,
      this.actualBirthDate,
      this.expectedOffspringCount,
      this.offspringIds,
      this.veterinarianId,
      this.veterinarianName,
      this.notes,
      required this.status,
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
    map['mother_id'] = Variable<String>(motherId);
    if (!nullToAbsent || fatherId != null) {
      map['father_id'] = Variable<String>(fatherId);
    }
    if (!nullToAbsent || fatherName != null) {
      map['father_name'] = Variable<String>(fatherName);
    }
    map['method'] = Variable<String>(method);
    map['breeding_date'] = Variable<DateTime>(breedingDate);
    map['expected_birth_date'] = Variable<DateTime>(expectedBirthDate);
    if (!nullToAbsent || actualBirthDate != null) {
      map['actual_birth_date'] = Variable<DateTime>(actualBirthDate);
    }
    if (!nullToAbsent || expectedOffspringCount != null) {
      map['expected_offspring_count'] = Variable<int>(expectedOffspringCount);
    }
    if (!nullToAbsent || offspringIds != null) {
      map['offspring_ids'] = Variable<String>(offspringIds);
    }
    if (!nullToAbsent || veterinarianId != null) {
      map['veterinarian_id'] = Variable<String>(veterinarianId);
    }
    if (!nullToAbsent || veterinarianName != null) {
      map['veterinarian_name'] = Variable<String>(veterinarianName);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['status'] = Variable<String>(status);
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

  BreedingsTableCompanion toCompanion(bool nullToAbsent) {
    return BreedingsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      motherId: Value(motherId),
      fatherId: fatherId == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherId),
      fatherName: fatherName == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherName),
      method: Value(method),
      breedingDate: Value(breedingDate),
      expectedBirthDate: Value(expectedBirthDate),
      actualBirthDate: actualBirthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actualBirthDate),
      expectedOffspringCount: expectedOffspringCount == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedOffspringCount),
      offspringIds: offspringIds == null && nullToAbsent
          ? const Value.absent()
          : Value(offspringIds),
      veterinarianId: veterinarianId == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianId),
      veterinarianName: veterinarianName == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianName),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      status: Value(status),
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

  factory BreedingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BreedingsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      motherId: serializer.fromJson<String>(json['motherId']),
      fatherId: serializer.fromJson<String?>(json['fatherId']),
      fatherName: serializer.fromJson<String?>(json['fatherName']),
      method: serializer.fromJson<String>(json['method']),
      breedingDate: serializer.fromJson<DateTime>(json['breedingDate']),
      expectedBirthDate:
          serializer.fromJson<DateTime>(json['expectedBirthDate']),
      actualBirthDate: serializer.fromJson<DateTime?>(json['actualBirthDate']),
      expectedOffspringCount:
          serializer.fromJson<int?>(json['expectedOffspringCount']),
      offspringIds: serializer.fromJson<String?>(json['offspringIds']),
      veterinarianId: serializer.fromJson<String?>(json['veterinarianId']),
      veterinarianName: serializer.fromJson<String?>(json['veterinarianName']),
      notes: serializer.fromJson<String?>(json['notes']),
      status: serializer.fromJson<String>(json['status']),
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
      'motherId': serializer.toJson<String>(motherId),
      'fatherId': serializer.toJson<String?>(fatherId),
      'fatherName': serializer.toJson<String?>(fatherName),
      'method': serializer.toJson<String>(method),
      'breedingDate': serializer.toJson<DateTime>(breedingDate),
      'expectedBirthDate': serializer.toJson<DateTime>(expectedBirthDate),
      'actualBirthDate': serializer.toJson<DateTime?>(actualBirthDate),
      'expectedOffspringCount': serializer.toJson<int?>(expectedOffspringCount),
      'offspringIds': serializer.toJson<String?>(offspringIds),
      'veterinarianId': serializer.toJson<String?>(veterinarianId),
      'veterinarianName': serializer.toJson<String?>(veterinarianName),
      'notes': serializer.toJson<String?>(notes),
      'status': serializer.toJson<String>(status),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<String?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BreedingsTableData copyWith(
          {String? id,
          String? farmId,
          String? motherId,
          Value<String?> fatherId = const Value.absent(),
          Value<String?> fatherName = const Value.absent(),
          String? method,
          DateTime? breedingDate,
          DateTime? expectedBirthDate,
          Value<DateTime?> actualBirthDate = const Value.absent(),
          Value<int?> expectedOffspringCount = const Value.absent(),
          Value<String?> offspringIds = const Value.absent(),
          Value<String?> veterinarianId = const Value.absent(),
          Value<String?> veterinarianName = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          String? status,
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      BreedingsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        motherId: motherId ?? this.motherId,
        fatherId: fatherId.present ? fatherId.value : this.fatherId,
        fatherName: fatherName.present ? fatherName.value : this.fatherName,
        method: method ?? this.method,
        breedingDate: breedingDate ?? this.breedingDate,
        expectedBirthDate: expectedBirthDate ?? this.expectedBirthDate,
        actualBirthDate: actualBirthDate.present
            ? actualBirthDate.value
            : this.actualBirthDate,
        expectedOffspringCount: expectedOffspringCount.present
            ? expectedOffspringCount.value
            : this.expectedOffspringCount,
        offspringIds:
            offspringIds.present ? offspringIds.value : this.offspringIds,
        veterinarianId:
            veterinarianId.present ? veterinarianId.value : this.veterinarianId,
        veterinarianName: veterinarianName.present
            ? veterinarianName.value
            : this.veterinarianName,
        notes: notes.present ? notes.value : this.notes,
        status: status ?? this.status,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BreedingsTableData copyWithCompanion(BreedingsTableCompanion data) {
    return BreedingsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      motherId: data.motherId.present ? data.motherId.value : this.motherId,
      fatherId: data.fatherId.present ? data.fatherId.value : this.fatherId,
      fatherName:
          data.fatherName.present ? data.fatherName.value : this.fatherName,
      method: data.method.present ? data.method.value : this.method,
      breedingDate: data.breedingDate.present
          ? data.breedingDate.value
          : this.breedingDate,
      expectedBirthDate: data.expectedBirthDate.present
          ? data.expectedBirthDate.value
          : this.expectedBirthDate,
      actualBirthDate: data.actualBirthDate.present
          ? data.actualBirthDate.value
          : this.actualBirthDate,
      expectedOffspringCount: data.expectedOffspringCount.present
          ? data.expectedOffspringCount.value
          : this.expectedOffspringCount,
      offspringIds: data.offspringIds.present
          ? data.offspringIds.value
          : this.offspringIds,
      veterinarianId: data.veterinarianId.present
          ? data.veterinarianId.value
          : this.veterinarianId,
      veterinarianName: data.veterinarianName.present
          ? data.veterinarianName.value
          : this.veterinarianName,
      notes: data.notes.present ? data.notes.value : this.notes,
      status: data.status.present ? data.status.value : this.status,
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
    return (StringBuffer('BreedingsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('motherId: $motherId, ')
          ..write('fatherId: $fatherId, ')
          ..write('fatherName: $fatherName, ')
          ..write('method: $method, ')
          ..write('breedingDate: $breedingDate, ')
          ..write('expectedBirthDate: $expectedBirthDate, ')
          ..write('actualBirthDate: $actualBirthDate, ')
          ..write('expectedOffspringCount: $expectedOffspringCount, ')
          ..write('offspringIds: $offspringIds, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
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
        motherId,
        fatherId,
        fatherName,
        method,
        breedingDate,
        expectedBirthDate,
        actualBirthDate,
        expectedOffspringCount,
        offspringIds,
        veterinarianId,
        veterinarianName,
        notes,
        status,
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
      (other is BreedingsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.motherId == this.motherId &&
          other.fatherId == this.fatherId &&
          other.fatherName == this.fatherName &&
          other.method == this.method &&
          other.breedingDate == this.breedingDate &&
          other.expectedBirthDate == this.expectedBirthDate &&
          other.actualBirthDate == this.actualBirthDate &&
          other.expectedOffspringCount == this.expectedOffspringCount &&
          other.offspringIds == this.offspringIds &&
          other.veterinarianId == this.veterinarianId &&
          other.veterinarianName == this.veterinarianName &&
          other.notes == this.notes &&
          other.status == this.status &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BreedingsTableCompanion extends UpdateCompanion<BreedingsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> motherId;
  final Value<String?> fatherId;
  final Value<String?> fatherName;
  final Value<String> method;
  final Value<DateTime> breedingDate;
  final Value<DateTime> expectedBirthDate;
  final Value<DateTime?> actualBirthDate;
  final Value<int?> expectedOffspringCount;
  final Value<String?> offspringIds;
  final Value<String?> veterinarianId;
  final Value<String?> veterinarianName;
  final Value<String?> notes;
  final Value<String> status;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BreedingsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.motherId = const Value.absent(),
    this.fatherId = const Value.absent(),
    this.fatherName = const Value.absent(),
    this.method = const Value.absent(),
    this.breedingDate = const Value.absent(),
    this.expectedBirthDate = const Value.absent(),
    this.actualBirthDate = const Value.absent(),
    this.expectedOffspringCount = const Value.absent(),
    this.offspringIds = const Value.absent(),
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.notes = const Value.absent(),
    this.status = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BreedingsTableCompanion.insert({
    required String id,
    required String farmId,
    required String motherId,
    this.fatherId = const Value.absent(),
    this.fatherName = const Value.absent(),
    required String method,
    required DateTime breedingDate,
    required DateTime expectedBirthDate,
    this.actualBirthDate = const Value.absent(),
    this.expectedOffspringCount = const Value.absent(),
    this.offspringIds = const Value.absent(),
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.notes = const Value.absent(),
    required String status,
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        motherId = Value(motherId),
        method = Value(method),
        breedingDate = Value(breedingDate),
        expectedBirthDate = Value(expectedBirthDate),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<BreedingsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? motherId,
    Expression<String>? fatherId,
    Expression<String>? fatherName,
    Expression<String>? method,
    Expression<DateTime>? breedingDate,
    Expression<DateTime>? expectedBirthDate,
    Expression<DateTime>? actualBirthDate,
    Expression<int>? expectedOffspringCount,
    Expression<String>? offspringIds,
    Expression<String>? veterinarianId,
    Expression<String>? veterinarianName,
    Expression<String>? notes,
    Expression<String>? status,
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
      if (motherId != null) 'mother_id': motherId,
      if (fatherId != null) 'father_id': fatherId,
      if (fatherName != null) 'father_name': fatherName,
      if (method != null) 'method': method,
      if (breedingDate != null) 'breeding_date': breedingDate,
      if (expectedBirthDate != null) 'expected_birth_date': expectedBirthDate,
      if (actualBirthDate != null) 'actual_birth_date': actualBirthDate,
      if (expectedOffspringCount != null)
        'expected_offspring_count': expectedOffspringCount,
      if (offspringIds != null) 'offspring_ids': offspringIds,
      if (veterinarianId != null) 'veterinarian_id': veterinarianId,
      if (veterinarianName != null) 'veterinarian_name': veterinarianName,
      if (notes != null) 'notes': notes,
      if (status != null) 'status': status,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BreedingsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? motherId,
      Value<String?>? fatherId,
      Value<String?>? fatherName,
      Value<String>? method,
      Value<DateTime>? breedingDate,
      Value<DateTime>? expectedBirthDate,
      Value<DateTime?>? actualBirthDate,
      Value<int?>? expectedOffspringCount,
      Value<String?>? offspringIds,
      Value<String?>? veterinarianId,
      Value<String?>? veterinarianName,
      Value<String?>? notes,
      Value<String>? status,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<String?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return BreedingsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      motherId: motherId ?? this.motherId,
      fatherId: fatherId ?? this.fatherId,
      fatherName: fatherName ?? this.fatherName,
      method: method ?? this.method,
      breedingDate: breedingDate ?? this.breedingDate,
      expectedBirthDate: expectedBirthDate ?? this.expectedBirthDate,
      actualBirthDate: actualBirthDate ?? this.actualBirthDate,
      expectedOffspringCount:
          expectedOffspringCount ?? this.expectedOffspringCount,
      offspringIds: offspringIds ?? this.offspringIds,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      notes: notes ?? this.notes,
      status: status ?? this.status,
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
    if (motherId.present) {
      map['mother_id'] = Variable<String>(motherId.value);
    }
    if (fatherId.present) {
      map['father_id'] = Variable<String>(fatherId.value);
    }
    if (fatherName.present) {
      map['father_name'] = Variable<String>(fatherName.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (breedingDate.present) {
      map['breeding_date'] = Variable<DateTime>(breedingDate.value);
    }
    if (expectedBirthDate.present) {
      map['expected_birth_date'] = Variable<DateTime>(expectedBirthDate.value);
    }
    if (actualBirthDate.present) {
      map['actual_birth_date'] = Variable<DateTime>(actualBirthDate.value);
    }
    if (expectedOffspringCount.present) {
      map['expected_offspring_count'] =
          Variable<int>(expectedOffspringCount.value);
    }
    if (offspringIds.present) {
      map['offspring_ids'] = Variable<String>(offspringIds.value);
    }
    if (veterinarianId.present) {
      map['veterinarian_id'] = Variable<String>(veterinarianId.value);
    }
    if (veterinarianName.present) {
      map['veterinarian_name'] = Variable<String>(veterinarianName.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
    return (StringBuffer('BreedingsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('motherId: $motherId, ')
          ..write('fatherId: $fatherId, ')
          ..write('fatherName: $fatherName, ')
          ..write('method: $method, ')
          ..write('breedingDate: $breedingDate, ')
          ..write('expectedBirthDate: $expectedBirthDate, ')
          ..write('actualBirthDate: $actualBirthDate, ')
          ..write('expectedOffspringCount: $expectedOffspringCount, ')
          ..write('offspringIds: $offspringIds, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('notes: $notes, ')
          ..write('status: $status, ')
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

class $DocumentsTableTable extends DocumentsTable
    with TableInfo<$DocumentsTableTable, DocumentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _animalIdMeta =
      const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
      'animal_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileUrlMeta =
      const VerificationMeta('fileUrl');
  @override
  late final GeneratedColumn<String> fileUrl = GeneratedColumn<String>(
      'file_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileSizeBytesMeta =
      const VerificationMeta('fileSizeBytes');
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
      'file_size_bytes', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _mimeTypeMeta =
      const VerificationMeta('mimeType');
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
      'mime_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uploadDateMeta =
      const VerificationMeta('uploadDate');
  @override
  late final GeneratedColumn<DateTime> uploadDate = GeneratedColumn<DateTime>(
      'upload_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _expiryDateMeta =
      const VerificationMeta('expiryDate');
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
      'expiry_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _uploadedByMeta =
      const VerificationMeta('uploadedBy');
  @override
  late final GeneratedColumn<String> uploadedBy = GeneratedColumn<String>(
      'uploaded_by', aliasedName, true,
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
        animalId,
        type,
        fileName,
        fileUrl,
        fileSizeBytes,
        mimeType,
        uploadDate,
        expiryDate,
        notes,
        uploadedBy,
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
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<DocumentsTableData> instance,
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
    if (data.containsKey('animal_id')) {
      context.handle(_animalIdMeta,
          animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_url')) {
      context.handle(_fileUrlMeta,
          fileUrl.isAcceptableOrUnknown(data['file_url']!, _fileUrlMeta));
    } else if (isInserting) {
      context.missing(_fileUrlMeta);
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
          _fileSizeBytesMeta,
          fileSizeBytes.isAcceptableOrUnknown(
              data['file_size_bytes']!, _fileSizeBytesMeta));
    }
    if (data.containsKey('mime_type')) {
      context.handle(_mimeTypeMeta,
          mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta));
    }
    if (data.containsKey('upload_date')) {
      context.handle(
          _uploadDateMeta,
          uploadDate.isAcceptableOrUnknown(
              data['upload_date']!, _uploadDateMeta));
    } else if (isInserting) {
      context.missing(_uploadDateMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
          _expiryDateMeta,
          expiryDate.isAcceptableOrUnknown(
              data['expiry_date']!, _expiryDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('uploaded_by')) {
      context.handle(
          _uploadedByMeta,
          uploadedBy.isAcceptableOrUnknown(
              data['uploaded_by']!, _uploadedByMeta));
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
  DocumentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      animalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}animal_id']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      fileUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_url'])!,
      fileSizeBytes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size_bytes']),
      mimeType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mime_type']),
      uploadDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}upload_date'])!,
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      uploadedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uploaded_by']),
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
  $DocumentsTableTable createAlias(String alias) {
    return $DocumentsTableTable(attachedDatabase, alias);
  }
}

class DocumentsTableData extends DataClass
    implements Insertable<DocumentsTableData> {
  final String id;
  final String farmId;
  final String? animalId;
  final String type;
  final String fileName;
  final String fileUrl;
  final int? fileSizeBytes;
  final String? mimeType;
  final DateTime uploadDate;
  final DateTime? expiryDate;
  final String? notes;
  final String? uploadedBy;
  final bool synced;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DocumentsTableData(
      {required this.id,
      required this.farmId,
      this.animalId,
      required this.type,
      required this.fileName,
      required this.fileUrl,
      this.fileSizeBytes,
      this.mimeType,
      required this.uploadDate,
      this.expiryDate,
      this.notes,
      this.uploadedBy,
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
    if (!nullToAbsent || animalId != null) {
      map['animal_id'] = Variable<String>(animalId);
    }
    map['type'] = Variable<String>(type);
    map['file_name'] = Variable<String>(fileName);
    map['file_url'] = Variable<String>(fileUrl);
    if (!nullToAbsent || fileSizeBytes != null) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    map['upload_date'] = Variable<DateTime>(uploadDate);
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || uploadedBy != null) {
      map['uploaded_by'] = Variable<String>(uploadedBy);
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

  DocumentsTableCompanion toCompanion(bool nullToAbsent) {
    return DocumentsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      animalId: animalId == null && nullToAbsent
          ? const Value.absent()
          : Value(animalId),
      type: Value(type),
      fileName: Value(fileName),
      fileUrl: Value(fileUrl),
      fileSizeBytes: fileSizeBytes == null && nullToAbsent
          ? const Value.absent()
          : Value(fileSizeBytes),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      uploadDate: Value(uploadDate),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      uploadedBy: uploadedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(uploadedBy),
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

  factory DocumentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      animalId: serializer.fromJson<String?>(json['animalId']),
      type: serializer.fromJson<String>(json['type']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileUrl: serializer.fromJson<String>(json['fileUrl']),
      fileSizeBytes: serializer.fromJson<int?>(json['fileSizeBytes']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      uploadDate: serializer.fromJson<DateTime>(json['uploadDate']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      uploadedBy: serializer.fromJson<String?>(json['uploadedBy']),
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
      'animalId': serializer.toJson<String?>(animalId),
      'type': serializer.toJson<String>(type),
      'fileName': serializer.toJson<String>(fileName),
      'fileUrl': serializer.toJson<String>(fileUrl),
      'fileSizeBytes': serializer.toJson<int?>(fileSizeBytes),
      'mimeType': serializer.toJson<String?>(mimeType),
      'uploadDate': serializer.toJson<DateTime>(uploadDate),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'notes': serializer.toJson<String?>(notes),
      'uploadedBy': serializer.toJson<String?>(uploadedBy),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<String?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DocumentsTableData copyWith(
          {String? id,
          String? farmId,
          Value<String?> animalId = const Value.absent(),
          String? type,
          String? fileName,
          String? fileUrl,
          Value<int?> fileSizeBytes = const Value.absent(),
          Value<String?> mimeType = const Value.absent(),
          DateTime? uploadDate,
          Value<DateTime?> expiryDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> uploadedBy = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      DocumentsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        animalId: animalId.present ? animalId.value : this.animalId,
        type: type ?? this.type,
        fileName: fileName ?? this.fileName,
        fileUrl: fileUrl ?? this.fileUrl,
        fileSizeBytes:
            fileSizeBytes.present ? fileSizeBytes.value : this.fileSizeBytes,
        mimeType: mimeType.present ? mimeType.value : this.mimeType,
        uploadDate: uploadDate ?? this.uploadDate,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        notes: notes.present ? notes.value : this.notes,
        uploadedBy: uploadedBy.present ? uploadedBy.value : this.uploadedBy,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  DocumentsTableData copyWithCompanion(DocumentsTableCompanion data) {
    return DocumentsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      type: data.type.present ? data.type.value : this.type,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileUrl: data.fileUrl.present ? data.fileUrl.value : this.fileUrl,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      uploadDate:
          data.uploadDate.present ? data.uploadDate.value : this.uploadDate,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      uploadedBy:
          data.uploadedBy.present ? data.uploadedBy.value : this.uploadedBy,
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
    return (StringBuffer('DocumentsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('type: $type, ')
          ..write('fileName: $fileName, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('mimeType: $mimeType, ')
          ..write('uploadDate: $uploadDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notes: $notes, ')
          ..write('uploadedBy: $uploadedBy, ')
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
      animalId,
      type,
      fileName,
      fileUrl,
      fileSizeBytes,
      mimeType,
      uploadDate,
      expiryDate,
      notes,
      uploadedBy,
      synced,
      lastSyncedAt,
      serverVersion,
      deletedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.animalId == this.animalId &&
          other.type == this.type &&
          other.fileName == this.fileName &&
          other.fileUrl == this.fileUrl &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.mimeType == this.mimeType &&
          other.uploadDate == this.uploadDate &&
          other.expiryDate == this.expiryDate &&
          other.notes == this.notes &&
          other.uploadedBy == this.uploadedBy &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DocumentsTableCompanion extends UpdateCompanion<DocumentsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String?> animalId;
  final Value<String> type;
  final Value<String> fileName;
  final Value<String> fileUrl;
  final Value<int?> fileSizeBytes;
  final Value<String?> mimeType;
  final Value<DateTime> uploadDate;
  final Value<DateTime?> expiryDate;
  final Value<String?> notes;
  final Value<String?> uploadedBy;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DocumentsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.animalId = const Value.absent(),
    this.type = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileUrl = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.uploadDate = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DocumentsTableCompanion.insert({
    required String id,
    required String farmId,
    this.animalId = const Value.absent(),
    required String type,
    required String fileName,
    required String fileUrl,
    this.fileSizeBytes = const Value.absent(),
    this.mimeType = const Value.absent(),
    required DateTime uploadDate,
    this.expiryDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.uploadedBy = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        type = Value(type),
        fileName = Value(fileName),
        fileUrl = Value(fileUrl),
        uploadDate = Value(uploadDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<DocumentsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? animalId,
    Expression<String>? type,
    Expression<String>? fileName,
    Expression<String>? fileUrl,
    Expression<int>? fileSizeBytes,
    Expression<String>? mimeType,
    Expression<DateTime>? uploadDate,
    Expression<DateTime>? expiryDate,
    Expression<String>? notes,
    Expression<String>? uploadedBy,
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
      if (animalId != null) 'animal_id': animalId,
      if (type != null) 'type': type,
      if (fileName != null) 'file_name': fileName,
      if (fileUrl != null) 'file_url': fileUrl,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (mimeType != null) 'mime_type': mimeType,
      if (uploadDate != null) 'upload_date': uploadDate,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (notes != null) 'notes': notes,
      if (uploadedBy != null) 'uploaded_by': uploadedBy,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DocumentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String?>? animalId,
      Value<String>? type,
      Value<String>? fileName,
      Value<String>? fileUrl,
      Value<int?>? fileSizeBytes,
      Value<String?>? mimeType,
      Value<DateTime>? uploadDate,
      Value<DateTime?>? expiryDate,
      Value<String?>? notes,
      Value<String?>? uploadedBy,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<String?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return DocumentsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      type: type ?? this.type,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      mimeType: mimeType ?? this.mimeType,
      uploadDate: uploadDate ?? this.uploadDate,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
      uploadedBy: uploadedBy ?? this.uploadedBy,
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
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileUrl.present) {
      map['file_url'] = Variable<String>(fileUrl.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (uploadDate.present) {
      map['upload_date'] = Variable<DateTime>(uploadDate.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (uploadedBy.present) {
      map['uploaded_by'] = Variable<String>(uploadedBy.value);
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
    return (StringBuffer('DocumentsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('type: $type, ')
          ..write('fileName: $fileName, ')
          ..write('fileUrl: $fileUrl, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('mimeType: $mimeType, ')
          ..write('uploadDate: $uploadDate, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('notes: $notes, ')
          ..write('uploadedBy: $uploadedBy, ')
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

class $TreatmentsTableTable extends TreatmentsTable
    with TableInfo<$TreatmentsTableTable, TreatmentsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TreatmentsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _animalIdMeta =
      const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
      'animal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<double> dose = GeneratedColumn<double>(
      'dose', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _treatmentDateMeta =
      const VerificationMeta('treatmentDate');
  @override
  late final GeneratedColumn<DateTime> treatmentDate =
      GeneratedColumn<DateTime>('treatment_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _withdrawalEndDateMeta =
      const VerificationMeta('withdrawalEndDate');
  @override
  late final GeneratedColumn<DateTime> withdrawalEndDate =
      GeneratedColumn<DateTime>('withdrawal_end_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _veterinarianIdMeta =
      const VerificationMeta('veterinarianId');
  @override
  late final GeneratedColumn<String> veterinarianId = GeneratedColumn<String>(
      'veterinarian_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _veterinarianNameMeta =
      const VerificationMeta('veterinarianName');
  @override
  late final GeneratedColumn<String> veterinarianName = GeneratedColumn<String>(
      'veterinarian_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _campaignIdMeta =
      const VerificationMeta('campaignId');
  @override
  late final GeneratedColumn<String> campaignId = GeneratedColumn<String>(
      'campaign_id', aliasedName, true,
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
        animalId,
        productId,
        productName,
        dose,
        treatmentDate,
        withdrawalEndDate,
        notes,
        veterinarianId,
        veterinarianName,
        campaignId,
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
  static const String $name = 'treatments';
  @override
  VerificationContext validateIntegrity(
      Insertable<TreatmentsTableData> instance,
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
    if (data.containsKey('animal_id')) {
      context.handle(_animalIdMeta,
          animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta));
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('dose')) {
      context.handle(
          _doseMeta, dose.isAcceptableOrUnknown(data['dose']!, _doseMeta));
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('treatment_date')) {
      context.handle(
          _treatmentDateMeta,
          treatmentDate.isAcceptableOrUnknown(
              data['treatment_date']!, _treatmentDateMeta));
    } else if (isInserting) {
      context.missing(_treatmentDateMeta);
    }
    if (data.containsKey('withdrawal_end_date')) {
      context.handle(
          _withdrawalEndDateMeta,
          withdrawalEndDate.isAcceptableOrUnknown(
              data['withdrawal_end_date']!, _withdrawalEndDateMeta));
    } else if (isInserting) {
      context.missing(_withdrawalEndDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('veterinarian_id')) {
      context.handle(
          _veterinarianIdMeta,
          veterinarianId.isAcceptableOrUnknown(
              data['veterinarian_id']!, _veterinarianIdMeta));
    }
    if (data.containsKey('veterinarian_name')) {
      context.handle(
          _veterinarianNameMeta,
          veterinarianName.isAcceptableOrUnknown(
              data['veterinarian_name']!, _veterinarianNameMeta));
    }
    if (data.containsKey('campaign_id')) {
      context.handle(
          _campaignIdMeta,
          campaignId.isAcceptableOrUnknown(
              data['campaign_id']!, _campaignIdMeta));
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
  TreatmentsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TreatmentsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      animalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}animal_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      dose: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}dose'])!,
      treatmentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}treatment_date'])!,
      withdrawalEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}withdrawal_end_date'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      veterinarianId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}veterinarian_id']),
      veterinarianName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}veterinarian_name']),
      campaignId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}campaign_id']),
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
  $TreatmentsTableTable createAlias(String alias) {
    return $TreatmentsTableTable(attachedDatabase, alias);
  }
}

class TreatmentsTableData extends DataClass
    implements Insertable<TreatmentsTableData> {
  final String id;
  final String farmId;
  final String animalId;
  final String productId;
  final String productName;
  final double dose;
  final DateTime treatmentDate;
  final DateTime withdrawalEndDate;
  final String? notes;
  final String? veterinarianId;
  final String? veterinarianName;
  final String? campaignId;
  final bool synced;
  final DateTime? lastSyncedAt;
  final int? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TreatmentsTableData(
      {required this.id,
      required this.farmId,
      required this.animalId,
      required this.productId,
      required this.productName,
      required this.dose,
      required this.treatmentDate,
      required this.withdrawalEndDate,
      this.notes,
      this.veterinarianId,
      this.veterinarianName,
      this.campaignId,
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
    map['animal_id'] = Variable<String>(animalId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    map['dose'] = Variable<double>(dose);
    map['treatment_date'] = Variable<DateTime>(treatmentDate);
    map['withdrawal_end_date'] = Variable<DateTime>(withdrawalEndDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || veterinarianId != null) {
      map['veterinarian_id'] = Variable<String>(veterinarianId);
    }
    if (!nullToAbsent || veterinarianName != null) {
      map['veterinarian_name'] = Variable<String>(veterinarianName);
    }
    if (!nullToAbsent || campaignId != null) {
      map['campaign_id'] = Variable<String>(campaignId);
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

  TreatmentsTableCompanion toCompanion(bool nullToAbsent) {
    return TreatmentsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      animalId: Value(animalId),
      productId: Value(productId),
      productName: Value(productName),
      dose: Value(dose),
      treatmentDate: Value(treatmentDate),
      withdrawalEndDate: Value(withdrawalEndDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      veterinarianId: veterinarianId == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianId),
      veterinarianName: veterinarianName == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianName),
      campaignId: campaignId == null && nullToAbsent
          ? const Value.absent()
          : Value(campaignId),
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

  factory TreatmentsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TreatmentsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      animalId: serializer.fromJson<String>(json['animalId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      dose: serializer.fromJson<double>(json['dose']),
      treatmentDate: serializer.fromJson<DateTime>(json['treatmentDate']),
      withdrawalEndDate:
          serializer.fromJson<DateTime>(json['withdrawalEndDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      veterinarianId: serializer.fromJson<String?>(json['veterinarianId']),
      veterinarianName: serializer.fromJson<String?>(json['veterinarianName']),
      campaignId: serializer.fromJson<String?>(json['campaignId']),
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
      'animalId': serializer.toJson<String>(animalId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'dose': serializer.toJson<double>(dose),
      'treatmentDate': serializer.toJson<DateTime>(treatmentDate),
      'withdrawalEndDate': serializer.toJson<DateTime>(withdrawalEndDate),
      'notes': serializer.toJson<String?>(notes),
      'veterinarianId': serializer.toJson<String?>(veterinarianId),
      'veterinarianName': serializer.toJson<String?>(veterinarianName),
      'campaignId': serializer.toJson<String?>(campaignId),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TreatmentsTableData copyWith(
          {String? id,
          String? farmId,
          String? animalId,
          String? productId,
          String? productName,
          double? dose,
          DateTime? treatmentDate,
          DateTime? withdrawalEndDate,
          Value<String?> notes = const Value.absent(),
          Value<String?> veterinarianId = const Value.absent(),
          Value<String?> veterinarianName = const Value.absent(),
          Value<String?> campaignId = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<int?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      TreatmentsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        animalId: animalId ?? this.animalId,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        dose: dose ?? this.dose,
        treatmentDate: treatmentDate ?? this.treatmentDate,
        withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
        notes: notes.present ? notes.value : this.notes,
        veterinarianId:
            veterinarianId.present ? veterinarianId.value : this.veterinarianId,
        veterinarianName: veterinarianName.present
            ? veterinarianName.value
            : this.veterinarianName,
        campaignId: campaignId.present ? campaignId.value : this.campaignId,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  TreatmentsTableData copyWithCompanion(TreatmentsTableCompanion data) {
    return TreatmentsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      dose: data.dose.present ? data.dose.value : this.dose,
      treatmentDate: data.treatmentDate.present
          ? data.treatmentDate.value
          : this.treatmentDate,
      withdrawalEndDate: data.withdrawalEndDate.present
          ? data.withdrawalEndDate.value
          : this.withdrawalEndDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      veterinarianId: data.veterinarianId.present
          ? data.veterinarianId.value
          : this.veterinarianId,
      veterinarianName: data.veterinarianName.present
          ? data.veterinarianName.value
          : this.veterinarianName,
      campaignId:
          data.campaignId.present ? data.campaignId.value : this.campaignId,
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
    return (StringBuffer('TreatmentsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('dose: $dose, ')
          ..write('treatmentDate: $treatmentDate, ')
          ..write('withdrawalEndDate: $withdrawalEndDate, ')
          ..write('notes: $notes, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('campaignId: $campaignId, ')
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
      animalId,
      productId,
      productName,
      dose,
      treatmentDate,
      withdrawalEndDate,
      notes,
      veterinarianId,
      veterinarianName,
      campaignId,
      synced,
      lastSyncedAt,
      serverVersion,
      deletedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TreatmentsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.animalId == this.animalId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.dose == this.dose &&
          other.treatmentDate == this.treatmentDate &&
          other.withdrawalEndDate == this.withdrawalEndDate &&
          other.notes == this.notes &&
          other.veterinarianId == this.veterinarianId &&
          other.veterinarianName == this.veterinarianName &&
          other.campaignId == this.campaignId &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TreatmentsTableCompanion extends UpdateCompanion<TreatmentsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> animalId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<double> dose;
  final Value<DateTime> treatmentDate;
  final Value<DateTime> withdrawalEndDate;
  final Value<String?> notes;
  final Value<String?> veterinarianId;
  final Value<String?> veterinarianName;
  final Value<String?> campaignId;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<int?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TreatmentsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.animalId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.dose = const Value.absent(),
    this.treatmentDate = const Value.absent(),
    this.withdrawalEndDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.campaignId = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TreatmentsTableCompanion.insert({
    required String id,
    required String farmId,
    required String animalId,
    required String productId,
    required String productName,
    required double dose,
    required DateTime treatmentDate,
    required DateTime withdrawalEndDate,
    this.notes = const Value.absent(),
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.campaignId = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        animalId = Value(animalId),
        productId = Value(productId),
        productName = Value(productName),
        dose = Value(dose),
        treatmentDate = Value(treatmentDate),
        withdrawalEndDate = Value(withdrawalEndDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<TreatmentsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? animalId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<double>? dose,
    Expression<DateTime>? treatmentDate,
    Expression<DateTime>? withdrawalEndDate,
    Expression<String>? notes,
    Expression<String>? veterinarianId,
    Expression<String>? veterinarianName,
    Expression<String>? campaignId,
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
      if (animalId != null) 'animal_id': animalId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (dose != null) 'dose': dose,
      if (treatmentDate != null) 'treatment_date': treatmentDate,
      if (withdrawalEndDate != null) 'withdrawal_end_date': withdrawalEndDate,
      if (notes != null) 'notes': notes,
      if (veterinarianId != null) 'veterinarian_id': veterinarianId,
      if (veterinarianName != null) 'veterinarian_name': veterinarianName,
      if (campaignId != null) 'campaign_id': campaignId,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TreatmentsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? animalId,
      Value<String>? productId,
      Value<String>? productName,
      Value<double>? dose,
      Value<DateTime>? treatmentDate,
      Value<DateTime>? withdrawalEndDate,
      Value<String?>? notes,
      Value<String?>? veterinarianId,
      Value<String?>? veterinarianName,
      Value<String?>? campaignId,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<int?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return TreatmentsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      dose: dose ?? this.dose,
      treatmentDate: treatmentDate ?? this.treatmentDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      notes: notes ?? this.notes,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      campaignId: campaignId ?? this.campaignId,
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
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (dose.present) {
      map['dose'] = Variable<double>(dose.value);
    }
    if (treatmentDate.present) {
      map['treatment_date'] = Variable<DateTime>(treatmentDate.value);
    }
    if (withdrawalEndDate.present) {
      map['withdrawal_end_date'] = Variable<DateTime>(withdrawalEndDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (veterinarianId.present) {
      map['veterinarian_id'] = Variable<String>(veterinarianId.value);
    }
    if (veterinarianName.present) {
      map['veterinarian_name'] = Variable<String>(veterinarianName.value);
    }
    if (campaignId.present) {
      map['campaign_id'] = Variable<String>(campaignId.value);
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
    return (StringBuffer('TreatmentsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('dose: $dose, ')
          ..write('treatmentDate: $treatmentDate, ')
          ..write('withdrawalEndDate: $withdrawalEndDate, ')
          ..write('notes: $notes, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('campaignId: $campaignId, ')
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

class $VaccinationsTableTable extends VaccinationsTable
    with TableInfo<$VaccinationsTableTable, VaccinationsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VaccinationsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _animalIdMeta =
      const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
      'animal_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _animalIdsMeta =
      const VerificationMeta('animalIds');
  @override
  late final GeneratedColumn<String> animalIds = GeneratedColumn<String>(
      'animal_ids', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _protocolIdMeta =
      const VerificationMeta('protocolId');
  @override
  late final GeneratedColumn<String> protocolId = GeneratedColumn<String>(
      'protocol_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _vaccineNameMeta =
      const VerificationMeta('vaccineName');
  @override
  late final GeneratedColumn<String> vaccineName = GeneratedColumn<String>(
      'vaccine_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _diseaseMeta =
      const VerificationMeta('disease');
  @override
  late final GeneratedColumn<String> disease = GeneratedColumn<String>(
      'disease', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _vaccinationDateMeta =
      const VerificationMeta('vaccinationDate');
  @override
  late final GeneratedColumn<DateTime> vaccinationDate =
      GeneratedColumn<DateTime>('vaccination_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
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
  static const VerificationMeta _doseMeta = const VerificationMeta('dose');
  @override
  late final GeneratedColumn<String> dose = GeneratedColumn<String>(
      'dose', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _administrationRouteMeta =
      const VerificationMeta('administrationRoute');
  @override
  late final GeneratedColumn<String> administrationRoute =
      GeneratedColumn<String>('administration_route', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _veterinarianIdMeta =
      const VerificationMeta('veterinarianId');
  @override
  late final GeneratedColumn<String> veterinarianId = GeneratedColumn<String>(
      'veterinarian_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _veterinarianNameMeta =
      const VerificationMeta('veterinarianName');
  @override
  late final GeneratedColumn<String> veterinarianName = GeneratedColumn<String>(
      'veterinarian_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nextDueDateMeta =
      const VerificationMeta('nextDueDate');
  @override
  late final GeneratedColumn<DateTime> nextDueDate = GeneratedColumn<DateTime>(
      'next_due_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _withdrawalPeriodDaysMeta =
      const VerificationMeta('withdrawalPeriodDays');
  @override
  late final GeneratedColumn<int> withdrawalPeriodDays = GeneratedColumn<int>(
      'withdrawal_period_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
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
        animalId,
        animalIds,
        protocolId,
        vaccineName,
        type,
        disease,
        vaccinationDate,
        batchNumber,
        expiryDate,
        dose,
        administrationRoute,
        veterinarianId,
        veterinarianName,
        nextDueDate,
        withdrawalPeriodDays,
        notes,
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
  static const String $name = 'vaccinations';
  @override
  VerificationContext validateIntegrity(
      Insertable<VaccinationsTableData> instance,
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
    if (data.containsKey('animal_id')) {
      context.handle(_animalIdMeta,
          animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta));
    }
    if (data.containsKey('animal_ids')) {
      context.handle(_animalIdsMeta,
          animalIds.isAcceptableOrUnknown(data['animal_ids']!, _animalIdsMeta));
    } else if (isInserting) {
      context.missing(_animalIdsMeta);
    }
    if (data.containsKey('protocol_id')) {
      context.handle(
          _protocolIdMeta,
          protocolId.isAcceptableOrUnknown(
              data['protocol_id']!, _protocolIdMeta));
    }
    if (data.containsKey('vaccine_name')) {
      context.handle(
          _vaccineNameMeta,
          vaccineName.isAcceptableOrUnknown(
              data['vaccine_name']!, _vaccineNameMeta));
    } else if (isInserting) {
      context.missing(_vaccineNameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('disease')) {
      context.handle(_diseaseMeta,
          disease.isAcceptableOrUnknown(data['disease']!, _diseaseMeta));
    } else if (isInserting) {
      context.missing(_diseaseMeta);
    }
    if (data.containsKey('vaccination_date')) {
      context.handle(
          _vaccinationDateMeta,
          vaccinationDate.isAcceptableOrUnknown(
              data['vaccination_date']!, _vaccinationDateMeta));
    } else if (isInserting) {
      context.missing(_vaccinationDateMeta);
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
    if (data.containsKey('dose')) {
      context.handle(
          _doseMeta, dose.isAcceptableOrUnknown(data['dose']!, _doseMeta));
    } else if (isInserting) {
      context.missing(_doseMeta);
    }
    if (data.containsKey('administration_route')) {
      context.handle(
          _administrationRouteMeta,
          administrationRoute.isAcceptableOrUnknown(
              data['administration_route']!, _administrationRouteMeta));
    } else if (isInserting) {
      context.missing(_administrationRouteMeta);
    }
    if (data.containsKey('veterinarian_id')) {
      context.handle(
          _veterinarianIdMeta,
          veterinarianId.isAcceptableOrUnknown(
              data['veterinarian_id']!, _veterinarianIdMeta));
    }
    if (data.containsKey('veterinarian_name')) {
      context.handle(
          _veterinarianNameMeta,
          veterinarianName.isAcceptableOrUnknown(
              data['veterinarian_name']!, _veterinarianNameMeta));
    }
    if (data.containsKey('next_due_date')) {
      context.handle(
          _nextDueDateMeta,
          nextDueDate.isAcceptableOrUnknown(
              data['next_due_date']!, _nextDueDateMeta));
    }
    if (data.containsKey('withdrawal_period_days')) {
      context.handle(
          _withdrawalPeriodDaysMeta,
          withdrawalPeriodDays.isAcceptableOrUnknown(
              data['withdrawal_period_days']!, _withdrawalPeriodDaysMeta));
    } else if (isInserting) {
      context.missing(_withdrawalPeriodDaysMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
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
  VaccinationsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VaccinationsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      animalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}animal_id']),
      animalIds: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}animal_ids'])!,
      protocolId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}protocol_id']),
      vaccineName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vaccine_name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      disease: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}disease'])!,
      vaccinationDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}vaccination_date'])!,
      batchNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_number']),
      expiryDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}expiry_date']),
      dose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}dose'])!,
      administrationRoute: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}administration_route'])!,
      veterinarianId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}veterinarian_id']),
      veterinarianName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}veterinarian_name']),
      nextDueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_due_date']),
      withdrawalPeriodDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}withdrawal_period_days'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
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
  $VaccinationsTableTable createAlias(String alias) {
    return $VaccinationsTableTable(attachedDatabase, alias);
  }
}

class VaccinationsTableData extends DataClass
    implements Insertable<VaccinationsTableData> {
  final String id;
  final String farmId;

  /// ID animal simple (vaccination individuelle) - nullable
  final String? animalId;

  /// Liste IDs animaux (JSON array) pour vaccination de groupe
  /// Ex: ["animal-1", "animal-2", "animal-3"]
  final String animalIds;
  final String? protocolId;
  final String vaccineName;

  /// Type: "obligatoire", "recommandee", "optionnelle" (VaccinationType enum)
  final String type;
  final String disease;
  final DateTime vaccinationDate;
  final String? batchNumber;
  final DateTime? expiryDate;
  final String dose;
  final String administrationRoute;
  final String? veterinarianId;
  final String? veterinarianName;
  final DateTime? nextDueDate;
  final int withdrawalPeriodDays;
  final String? notes;
  final bool synced;
  final DateTime? lastSyncedAt;
  final int? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const VaccinationsTableData(
      {required this.id,
      required this.farmId,
      this.animalId,
      required this.animalIds,
      this.protocolId,
      required this.vaccineName,
      required this.type,
      required this.disease,
      required this.vaccinationDate,
      this.batchNumber,
      this.expiryDate,
      required this.dose,
      required this.administrationRoute,
      this.veterinarianId,
      this.veterinarianName,
      this.nextDueDate,
      required this.withdrawalPeriodDays,
      this.notes,
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
    if (!nullToAbsent || animalId != null) {
      map['animal_id'] = Variable<String>(animalId);
    }
    map['animal_ids'] = Variable<String>(animalIds);
    if (!nullToAbsent || protocolId != null) {
      map['protocol_id'] = Variable<String>(protocolId);
    }
    map['vaccine_name'] = Variable<String>(vaccineName);
    map['type'] = Variable<String>(type);
    map['disease'] = Variable<String>(disease);
    map['vaccination_date'] = Variable<DateTime>(vaccinationDate);
    if (!nullToAbsent || batchNumber != null) {
      map['batch_number'] = Variable<String>(batchNumber);
    }
    if (!nullToAbsent || expiryDate != null) {
      map['expiry_date'] = Variable<DateTime>(expiryDate);
    }
    map['dose'] = Variable<String>(dose);
    map['administration_route'] = Variable<String>(administrationRoute);
    if (!nullToAbsent || veterinarianId != null) {
      map['veterinarian_id'] = Variable<String>(veterinarianId);
    }
    if (!nullToAbsent || veterinarianName != null) {
      map['veterinarian_name'] = Variable<String>(veterinarianName);
    }
    if (!nullToAbsent || nextDueDate != null) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate);
    }
    map['withdrawal_period_days'] = Variable<int>(withdrawalPeriodDays);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
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

  VaccinationsTableCompanion toCompanion(bool nullToAbsent) {
    return VaccinationsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      animalId: animalId == null && nullToAbsent
          ? const Value.absent()
          : Value(animalId),
      animalIds: Value(animalIds),
      protocolId: protocolId == null && nullToAbsent
          ? const Value.absent()
          : Value(protocolId),
      vaccineName: Value(vaccineName),
      type: Value(type),
      disease: Value(disease),
      vaccinationDate: Value(vaccinationDate),
      batchNumber: batchNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(batchNumber),
      expiryDate: expiryDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expiryDate),
      dose: Value(dose),
      administrationRoute: Value(administrationRoute),
      veterinarianId: veterinarianId == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianId),
      veterinarianName: veterinarianName == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianName),
      nextDueDate: nextDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueDate),
      withdrawalPeriodDays: Value(withdrawalPeriodDays),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
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

  factory VaccinationsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VaccinationsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      animalId: serializer.fromJson<String?>(json['animalId']),
      animalIds: serializer.fromJson<String>(json['animalIds']),
      protocolId: serializer.fromJson<String?>(json['protocolId']),
      vaccineName: serializer.fromJson<String>(json['vaccineName']),
      type: serializer.fromJson<String>(json['type']),
      disease: serializer.fromJson<String>(json['disease']),
      vaccinationDate: serializer.fromJson<DateTime>(json['vaccinationDate']),
      batchNumber: serializer.fromJson<String?>(json['batchNumber']),
      expiryDate: serializer.fromJson<DateTime?>(json['expiryDate']),
      dose: serializer.fromJson<String>(json['dose']),
      administrationRoute:
          serializer.fromJson<String>(json['administrationRoute']),
      veterinarianId: serializer.fromJson<String?>(json['veterinarianId']),
      veterinarianName: serializer.fromJson<String?>(json['veterinarianName']),
      nextDueDate: serializer.fromJson<DateTime?>(json['nextDueDate']),
      withdrawalPeriodDays:
          serializer.fromJson<int>(json['withdrawalPeriodDays']),
      notes: serializer.fromJson<String?>(json['notes']),
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
      'animalId': serializer.toJson<String?>(animalId),
      'animalIds': serializer.toJson<String>(animalIds),
      'protocolId': serializer.toJson<String?>(protocolId),
      'vaccineName': serializer.toJson<String>(vaccineName),
      'type': serializer.toJson<String>(type),
      'disease': serializer.toJson<String>(disease),
      'vaccinationDate': serializer.toJson<DateTime>(vaccinationDate),
      'batchNumber': serializer.toJson<String?>(batchNumber),
      'expiryDate': serializer.toJson<DateTime?>(expiryDate),
      'dose': serializer.toJson<String>(dose),
      'administrationRoute': serializer.toJson<String>(administrationRoute),
      'veterinarianId': serializer.toJson<String?>(veterinarianId),
      'veterinarianName': serializer.toJson<String?>(veterinarianName),
      'nextDueDate': serializer.toJson<DateTime?>(nextDueDate),
      'withdrawalPeriodDays': serializer.toJson<int>(withdrawalPeriodDays),
      'notes': serializer.toJson<String?>(notes),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  VaccinationsTableData copyWith(
          {String? id,
          String? farmId,
          Value<String?> animalId = const Value.absent(),
          String? animalIds,
          Value<String?> protocolId = const Value.absent(),
          String? vaccineName,
          String? type,
          String? disease,
          DateTime? vaccinationDate,
          Value<String?> batchNumber = const Value.absent(),
          Value<DateTime?> expiryDate = const Value.absent(),
          String? dose,
          String? administrationRoute,
          Value<String?> veterinarianId = const Value.absent(),
          Value<String?> veterinarianName = const Value.absent(),
          Value<DateTime?> nextDueDate = const Value.absent(),
          int? withdrawalPeriodDays,
          Value<String?> notes = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<int?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      VaccinationsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        animalId: animalId.present ? animalId.value : this.animalId,
        animalIds: animalIds ?? this.animalIds,
        protocolId: protocolId.present ? protocolId.value : this.protocolId,
        vaccineName: vaccineName ?? this.vaccineName,
        type: type ?? this.type,
        disease: disease ?? this.disease,
        vaccinationDate: vaccinationDate ?? this.vaccinationDate,
        batchNumber: batchNumber.present ? batchNumber.value : this.batchNumber,
        expiryDate: expiryDate.present ? expiryDate.value : this.expiryDate,
        dose: dose ?? this.dose,
        administrationRoute: administrationRoute ?? this.administrationRoute,
        veterinarianId:
            veterinarianId.present ? veterinarianId.value : this.veterinarianId,
        veterinarianName: veterinarianName.present
            ? veterinarianName.value
            : this.veterinarianName,
        nextDueDate: nextDueDate.present ? nextDueDate.value : this.nextDueDate,
        withdrawalPeriodDays: withdrawalPeriodDays ?? this.withdrawalPeriodDays,
        notes: notes.present ? notes.value : this.notes,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  VaccinationsTableData copyWithCompanion(VaccinationsTableCompanion data) {
    return VaccinationsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      animalIds: data.animalIds.present ? data.animalIds.value : this.animalIds,
      protocolId:
          data.protocolId.present ? data.protocolId.value : this.protocolId,
      vaccineName:
          data.vaccineName.present ? data.vaccineName.value : this.vaccineName,
      type: data.type.present ? data.type.value : this.type,
      disease: data.disease.present ? data.disease.value : this.disease,
      vaccinationDate: data.vaccinationDate.present
          ? data.vaccinationDate.value
          : this.vaccinationDate,
      batchNumber:
          data.batchNumber.present ? data.batchNumber.value : this.batchNumber,
      expiryDate:
          data.expiryDate.present ? data.expiryDate.value : this.expiryDate,
      dose: data.dose.present ? data.dose.value : this.dose,
      administrationRoute: data.administrationRoute.present
          ? data.administrationRoute.value
          : this.administrationRoute,
      veterinarianId: data.veterinarianId.present
          ? data.veterinarianId.value
          : this.veterinarianId,
      veterinarianName: data.veterinarianName.present
          ? data.veterinarianName.value
          : this.veterinarianName,
      nextDueDate:
          data.nextDueDate.present ? data.nextDueDate.value : this.nextDueDate,
      withdrawalPeriodDays: data.withdrawalPeriodDays.present
          ? data.withdrawalPeriodDays.value
          : this.withdrawalPeriodDays,
      notes: data.notes.present ? data.notes.value : this.notes,
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
    return (StringBuffer('VaccinationsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('animalIds: $animalIds, ')
          ..write('protocolId: $protocolId, ')
          ..write('vaccineName: $vaccineName, ')
          ..write('type: $type, ')
          ..write('disease: $disease, ')
          ..write('vaccinationDate: $vaccinationDate, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('dose: $dose, ')
          ..write('administrationRoute: $administrationRoute, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('withdrawalPeriodDays: $withdrawalPeriodDays, ')
          ..write('notes: $notes, ')
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
        animalId,
        animalIds,
        protocolId,
        vaccineName,
        type,
        disease,
        vaccinationDate,
        batchNumber,
        expiryDate,
        dose,
        administrationRoute,
        veterinarianId,
        veterinarianName,
        nextDueDate,
        withdrawalPeriodDays,
        notes,
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
      (other is VaccinationsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.animalId == this.animalId &&
          other.animalIds == this.animalIds &&
          other.protocolId == this.protocolId &&
          other.vaccineName == this.vaccineName &&
          other.type == this.type &&
          other.disease == this.disease &&
          other.vaccinationDate == this.vaccinationDate &&
          other.batchNumber == this.batchNumber &&
          other.expiryDate == this.expiryDate &&
          other.dose == this.dose &&
          other.administrationRoute == this.administrationRoute &&
          other.veterinarianId == this.veterinarianId &&
          other.veterinarianName == this.veterinarianName &&
          other.nextDueDate == this.nextDueDate &&
          other.withdrawalPeriodDays == this.withdrawalPeriodDays &&
          other.notes == this.notes &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class VaccinationsTableCompanion
    extends UpdateCompanion<VaccinationsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String?> animalId;
  final Value<String> animalIds;
  final Value<String?> protocolId;
  final Value<String> vaccineName;
  final Value<String> type;
  final Value<String> disease;
  final Value<DateTime> vaccinationDate;
  final Value<String?> batchNumber;
  final Value<DateTime?> expiryDate;
  final Value<String> dose;
  final Value<String> administrationRoute;
  final Value<String?> veterinarianId;
  final Value<String?> veterinarianName;
  final Value<DateTime?> nextDueDate;
  final Value<int> withdrawalPeriodDays;
  final Value<String?> notes;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<int?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const VaccinationsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.animalId = const Value.absent(),
    this.animalIds = const Value.absent(),
    this.protocolId = const Value.absent(),
    this.vaccineName = const Value.absent(),
    this.type = const Value.absent(),
    this.disease = const Value.absent(),
    this.vaccinationDate = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.dose = const Value.absent(),
    this.administrationRoute = const Value.absent(),
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    this.withdrawalPeriodDays = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VaccinationsTableCompanion.insert({
    required String id,
    required String farmId,
    this.animalId = const Value.absent(),
    required String animalIds,
    this.protocolId = const Value.absent(),
    required String vaccineName,
    required String type,
    required String disease,
    required DateTime vaccinationDate,
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    required String dose,
    required String administrationRoute,
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.nextDueDate = const Value.absent(),
    required int withdrawalPeriodDays,
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        animalIds = Value(animalIds),
        vaccineName = Value(vaccineName),
        type = Value(type),
        disease = Value(disease),
        vaccinationDate = Value(vaccinationDate),
        dose = Value(dose),
        administrationRoute = Value(administrationRoute),
        withdrawalPeriodDays = Value(withdrawalPeriodDays),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<VaccinationsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? animalId,
    Expression<String>? animalIds,
    Expression<String>? protocolId,
    Expression<String>? vaccineName,
    Expression<String>? type,
    Expression<String>? disease,
    Expression<DateTime>? vaccinationDate,
    Expression<String>? batchNumber,
    Expression<DateTime>? expiryDate,
    Expression<String>? dose,
    Expression<String>? administrationRoute,
    Expression<String>? veterinarianId,
    Expression<String>? veterinarianName,
    Expression<DateTime>? nextDueDate,
    Expression<int>? withdrawalPeriodDays,
    Expression<String>? notes,
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
      if (animalId != null) 'animal_id': animalId,
      if (animalIds != null) 'animal_ids': animalIds,
      if (protocolId != null) 'protocol_id': protocolId,
      if (vaccineName != null) 'vaccine_name': vaccineName,
      if (type != null) 'type': type,
      if (disease != null) 'disease': disease,
      if (vaccinationDate != null) 'vaccination_date': vaccinationDate,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (dose != null) 'dose': dose,
      if (administrationRoute != null)
        'administration_route': administrationRoute,
      if (veterinarianId != null) 'veterinarian_id': veterinarianId,
      if (veterinarianName != null) 'veterinarian_name': veterinarianName,
      if (nextDueDate != null) 'next_due_date': nextDueDate,
      if (withdrawalPeriodDays != null)
        'withdrawal_period_days': withdrawalPeriodDays,
      if (notes != null) 'notes': notes,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VaccinationsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String?>? animalId,
      Value<String>? animalIds,
      Value<String?>? protocolId,
      Value<String>? vaccineName,
      Value<String>? type,
      Value<String>? disease,
      Value<DateTime>? vaccinationDate,
      Value<String?>? batchNumber,
      Value<DateTime?>? expiryDate,
      Value<String>? dose,
      Value<String>? administrationRoute,
      Value<String?>? veterinarianId,
      Value<String?>? veterinarianName,
      Value<DateTime?>? nextDueDate,
      Value<int>? withdrawalPeriodDays,
      Value<String?>? notes,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<int?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return VaccinationsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      animalIds: animalIds ?? this.animalIds,
      protocolId: protocolId ?? this.protocolId,
      vaccineName: vaccineName ?? this.vaccineName,
      type: type ?? this.type,
      disease: disease ?? this.disease,
      vaccinationDate: vaccinationDate ?? this.vaccinationDate,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      dose: dose ?? this.dose,
      administrationRoute: administrationRoute ?? this.administrationRoute,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      withdrawalPeriodDays: withdrawalPeriodDays ?? this.withdrawalPeriodDays,
      notes: notes ?? this.notes,
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
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (animalIds.present) {
      map['animal_ids'] = Variable<String>(animalIds.value);
    }
    if (protocolId.present) {
      map['protocol_id'] = Variable<String>(protocolId.value);
    }
    if (vaccineName.present) {
      map['vaccine_name'] = Variable<String>(vaccineName.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (disease.present) {
      map['disease'] = Variable<String>(disease.value);
    }
    if (vaccinationDate.present) {
      map['vaccination_date'] = Variable<DateTime>(vaccinationDate.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (dose.present) {
      map['dose'] = Variable<String>(dose.value);
    }
    if (administrationRoute.present) {
      map['administration_route'] = Variable<String>(administrationRoute.value);
    }
    if (veterinarianId.present) {
      map['veterinarian_id'] = Variable<String>(veterinarianId.value);
    }
    if (veterinarianName.present) {
      map['veterinarian_name'] = Variable<String>(veterinarianName.value);
    }
    if (nextDueDate.present) {
      map['next_due_date'] = Variable<DateTime>(nextDueDate.value);
    }
    if (withdrawalPeriodDays.present) {
      map['withdrawal_period_days'] = Variable<int>(withdrawalPeriodDays.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('VaccinationsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('animalIds: $animalIds, ')
          ..write('protocolId: $protocolId, ')
          ..write('vaccineName: $vaccineName, ')
          ..write('type: $type, ')
          ..write('disease: $disease, ')
          ..write('vaccinationDate: $vaccinationDate, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('dose: $dose, ')
          ..write('administrationRoute: $administrationRoute, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('nextDueDate: $nextDueDate, ')
          ..write('withdrawalPeriodDays: $withdrawalPeriodDays, ')
          ..write('notes: $notes, ')
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

class $WeightsTableTable extends WeightsTable
    with TableInfo<$WeightsTableTable, WeightsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _animalIdMeta =
      const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
      'animal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
      'weight', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _recordedAtMeta =
      const VerificationMeta('recordedAt');
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
      'recorded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
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
        animalId,
        weight,
        recordedAt,
        source,
        notes,
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
  static const String $name = 'weights';
  @override
  VerificationContext validateIntegrity(Insertable<WeightsTableData> instance,
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
    if (data.containsKey('animal_id')) {
      context.handle(_animalIdMeta,
          animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta));
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(_weightMeta,
          weight.isAcceptableOrUnknown(data['weight']!, _weightMeta));
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
          _recordedAtMeta,
          recordedAt.isAcceptableOrUnknown(
              data['recorded_at']!, _recordedAtMeta));
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
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
  WeightsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      animalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}animal_id'])!,
      weight: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight'])!,
      recordedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}recorded_at'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
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
  $WeightsTableTable createAlias(String alias) {
    return $WeightsTableTable(attachedDatabase, alias);
  }
}

class WeightsTableData extends DataClass
    implements Insertable<WeightsTableData> {
  final String id;
  final String farmId;
  final String animalId;

  /// Poids en kilogrammes
  final double weight;

  /// Date et heure de la pesée
  final DateTime recordedAt;

  /// Source: "scale", "manual", "estimated", "veterinary" (WeightSource enum)
  final String source;

  /// Notes optionnelles
  final String? notes;
  final bool synced;
  final DateTime? lastSyncedAt;
  final int? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WeightsTableData(
      {required this.id,
      required this.farmId,
      required this.animalId,
      required this.weight,
      required this.recordedAt,
      required this.source,
      this.notes,
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
    map['animal_id'] = Variable<String>(animalId);
    map['weight'] = Variable<double>(weight);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
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

  WeightsTableCompanion toCompanion(bool nullToAbsent) {
    return WeightsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      animalId: Value(animalId),
      weight: Value(weight),
      recordedAt: Value(recordedAt),
      source: Value(source),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
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

  factory WeightsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      animalId: serializer.fromJson<String>(json['animalId']),
      weight: serializer.fromJson<double>(json['weight']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      source: serializer.fromJson<String>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
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
      'animalId': serializer.toJson<String>(animalId),
      'weight': serializer.toJson<double>(weight),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WeightsTableData copyWith(
          {String? id,
          String? farmId,
          String? animalId,
          double? weight,
          DateTime? recordedAt,
          String? source,
          Value<String?> notes = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<int?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      WeightsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        animalId: animalId ?? this.animalId,
        weight: weight ?? this.weight,
        recordedAt: recordedAt ?? this.recordedAt,
        source: source ?? this.source,
        notes: notes.present ? notes.value : this.notes,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  WeightsTableData copyWithCompanion(WeightsTableCompanion data) {
    return WeightsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      weight: data.weight.present ? data.weight.value : this.weight,
      recordedAt:
          data.recordedAt.present ? data.recordedAt.value : this.recordedAt,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
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
    return (StringBuffer('WeightsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('weight: $weight, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
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
      animalId,
      weight,
      recordedAt,
      source,
      notes,
      synced,
      lastSyncedAt,
      serverVersion,
      deletedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.animalId == this.animalId &&
          other.weight == this.weight &&
          other.recordedAt == this.recordedAt &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class WeightsTableCompanion extends UpdateCompanion<WeightsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> animalId;
  final Value<double> weight;
  final Value<DateTime> recordedAt;
  final Value<String> source;
  final Value<String?> notes;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<int?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const WeightsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.animalId = const Value.absent(),
    this.weight = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WeightsTableCompanion.insert({
    required String id,
    required String farmId,
    required String animalId,
    required double weight,
    required DateTime recordedAt,
    required String source,
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        animalId = Value(animalId),
        weight = Value(weight),
        recordedAt = Value(recordedAt),
        source = Value(source),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<WeightsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? animalId,
    Expression<double>? weight,
    Expression<DateTime>? recordedAt,
    Expression<String>? source,
    Expression<String>? notes,
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
      if (animalId != null) 'animal_id': animalId,
      if (weight != null) 'weight': weight,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WeightsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? animalId,
      Value<double>? weight,
      Value<DateTime>? recordedAt,
      Value<String>? source,
      Value<String?>? notes,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<int?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return WeightsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      weight: weight ?? this.weight,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
      notes: notes ?? this.notes,
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
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('WeightsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('weight: $weight, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
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

class $MovementsTableTable extends MovementsTable
    with TableInfo<$MovementsTableTable, MovementsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MovementsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _animalIdMeta =
      const VerificationMeta('animalId');
  @override
  late final GeneratedColumn<String> animalId = GeneratedColumn<String>(
      'animal_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _movementDateMeta =
      const VerificationMeta('movementDate');
  @override
  late final GeneratedColumn<DateTime> movementDate = GeneratedColumn<DateTime>(
      'movement_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _fromFarmIdMeta =
      const VerificationMeta('fromFarmId');
  @override
  late final GeneratedColumn<String> fromFarmId = GeneratedColumn<String>(
      'from_farm_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _toFarmIdMeta =
      const VerificationMeta('toFarmId');
  @override
  late final GeneratedColumn<String> toFarmId = GeneratedColumn<String>(
      'to_farm_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buyerQrSignatureMeta =
      const VerificationMeta('buyerQrSignature');
  @override
  late final GeneratedColumn<String> buyerQrSignature = GeneratedColumn<String>(
      'buyer_qr_signature', aliasedName, true,
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
        animalId,
        type,
        movementDate,
        fromFarmId,
        toFarmId,
        price,
        notes,
        buyerQrSignature,
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
  static const String $name = 'movements';
  @override
  VerificationContext validateIntegrity(Insertable<MovementsTableData> instance,
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
    if (data.containsKey('animal_id')) {
      context.handle(_animalIdMeta,
          animalId.isAcceptableOrUnknown(data['animal_id']!, _animalIdMeta));
    } else if (isInserting) {
      context.missing(_animalIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('movement_date')) {
      context.handle(
          _movementDateMeta,
          movementDate.isAcceptableOrUnknown(
              data['movement_date']!, _movementDateMeta));
    } else if (isInserting) {
      context.missing(_movementDateMeta);
    }
    if (data.containsKey('from_farm_id')) {
      context.handle(
          _fromFarmIdMeta,
          fromFarmId.isAcceptableOrUnknown(
              data['from_farm_id']!, _fromFarmIdMeta));
    }
    if (data.containsKey('to_farm_id')) {
      context.handle(_toFarmIdMeta,
          toFarmId.isAcceptableOrUnknown(data['to_farm_id']!, _toFarmIdMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('buyer_qr_signature')) {
      context.handle(
          _buyerQrSignatureMeta,
          buyerQrSignature.isAcceptableOrUnknown(
              data['buyer_qr_signature']!, _buyerQrSignatureMeta));
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
  MovementsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MovementsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      animalId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}animal_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      movementDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}movement_date'])!,
      fromFarmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_farm_id']),
      toFarmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_farm_id']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      buyerQrSignature: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}buyer_qr_signature']),
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
  $MovementsTableTable createAlias(String alias) {
    return $MovementsTableTable(attachedDatabase, alias);
  }
}

class MovementsTableData extends DataClass
    implements Insertable<MovementsTableData> {
  final String id;
  final String farmId;
  final String animalId;

  /// Type: "birth", "purchase", "sale", "death", "slaughter" (MovementType enum)
  final String type;

  /// Date du mouvement
  final DateTime movementDate;

  /// ID de la ferme d'origine (pour purchase)
  final String? fromFarmId;

  /// ID de la ferme de destination (pour sale)
  final String? toFarmId;

  /// Prix (pour purchase/sale)
  final double? price;

  /// Notes optionnelles
  final String? notes;

  /// Signature QR de l'acheteur (pour sale)
  final String? buyerQrSignature;
  final bool synced;
  final DateTime? lastSyncedAt;
  final int? serverVersion;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const MovementsTableData(
      {required this.id,
      required this.farmId,
      required this.animalId,
      required this.type,
      required this.movementDate,
      this.fromFarmId,
      this.toFarmId,
      this.price,
      this.notes,
      this.buyerQrSignature,
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
    map['animal_id'] = Variable<String>(animalId);
    map['type'] = Variable<String>(type);
    map['movement_date'] = Variable<DateTime>(movementDate);
    if (!nullToAbsent || fromFarmId != null) {
      map['from_farm_id'] = Variable<String>(fromFarmId);
    }
    if (!nullToAbsent || toFarmId != null) {
      map['to_farm_id'] = Variable<String>(toFarmId);
    }
    if (!nullToAbsent || price != null) {
      map['price'] = Variable<double>(price);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || buyerQrSignature != null) {
      map['buyer_qr_signature'] = Variable<String>(buyerQrSignature);
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

  MovementsTableCompanion toCompanion(bool nullToAbsent) {
    return MovementsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      animalId: Value(animalId),
      type: Value(type),
      movementDate: Value(movementDate),
      fromFarmId: fromFarmId == null && nullToAbsent
          ? const Value.absent()
          : Value(fromFarmId),
      toFarmId: toFarmId == null && nullToAbsent
          ? const Value.absent()
          : Value(toFarmId),
      price:
          price == null && nullToAbsent ? const Value.absent() : Value(price),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      buyerQrSignature: buyerQrSignature == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerQrSignature),
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

  factory MovementsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MovementsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      animalId: serializer.fromJson<String>(json['animalId']),
      type: serializer.fromJson<String>(json['type']),
      movementDate: serializer.fromJson<DateTime>(json['movementDate']),
      fromFarmId: serializer.fromJson<String?>(json['fromFarmId']),
      toFarmId: serializer.fromJson<String?>(json['toFarmId']),
      price: serializer.fromJson<double?>(json['price']),
      notes: serializer.fromJson<String?>(json['notes']),
      buyerQrSignature: serializer.fromJson<String?>(json['buyerQrSignature']),
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
      'animalId': serializer.toJson<String>(animalId),
      'type': serializer.toJson<String>(type),
      'movementDate': serializer.toJson<DateTime>(movementDate),
      'fromFarmId': serializer.toJson<String?>(fromFarmId),
      'toFarmId': serializer.toJson<String?>(toFarmId),
      'price': serializer.toJson<double?>(price),
      'notes': serializer.toJson<String?>(notes),
      'buyerQrSignature': serializer.toJson<String?>(buyerQrSignature),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<int?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MovementsTableData copyWith(
          {String? id,
          String? farmId,
          String? animalId,
          String? type,
          DateTime? movementDate,
          Value<String?> fromFarmId = const Value.absent(),
          Value<String?> toFarmId = const Value.absent(),
          Value<double?> price = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          Value<String?> buyerQrSignature = const Value.absent(),
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<int?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      MovementsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        animalId: animalId ?? this.animalId,
        type: type ?? this.type,
        movementDate: movementDate ?? this.movementDate,
        fromFarmId: fromFarmId.present ? fromFarmId.value : this.fromFarmId,
        toFarmId: toFarmId.present ? toFarmId.value : this.toFarmId,
        price: price.present ? price.value : this.price,
        notes: notes.present ? notes.value : this.notes,
        buyerQrSignature: buyerQrSignature.present
            ? buyerQrSignature.value
            : this.buyerQrSignature,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  MovementsTableData copyWithCompanion(MovementsTableCompanion data) {
    return MovementsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      animalId: data.animalId.present ? data.animalId.value : this.animalId,
      type: data.type.present ? data.type.value : this.type,
      movementDate: data.movementDate.present
          ? data.movementDate.value
          : this.movementDate,
      fromFarmId:
          data.fromFarmId.present ? data.fromFarmId.value : this.fromFarmId,
      toFarmId: data.toFarmId.present ? data.toFarmId.value : this.toFarmId,
      price: data.price.present ? data.price.value : this.price,
      notes: data.notes.present ? data.notes.value : this.notes,
      buyerQrSignature: data.buyerQrSignature.present
          ? data.buyerQrSignature.value
          : this.buyerQrSignature,
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
    return (StringBuffer('MovementsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('type: $type, ')
          ..write('movementDate: $movementDate, ')
          ..write('fromFarmId: $fromFarmId, ')
          ..write('toFarmId: $toFarmId, ')
          ..write('price: $price, ')
          ..write('notes: $notes, ')
          ..write('buyerQrSignature: $buyerQrSignature, ')
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
      animalId,
      type,
      movementDate,
      fromFarmId,
      toFarmId,
      price,
      notes,
      buyerQrSignature,
      synced,
      lastSyncedAt,
      serverVersion,
      deletedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MovementsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.animalId == this.animalId &&
          other.type == this.type &&
          other.movementDate == this.movementDate &&
          other.fromFarmId == this.fromFarmId &&
          other.toFarmId == this.toFarmId &&
          other.price == this.price &&
          other.notes == this.notes &&
          other.buyerQrSignature == this.buyerQrSignature &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MovementsTableCompanion extends UpdateCompanion<MovementsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> animalId;
  final Value<String> type;
  final Value<DateTime> movementDate;
  final Value<String?> fromFarmId;
  final Value<String?> toFarmId;
  final Value<double?> price;
  final Value<String?> notes;
  final Value<String?> buyerQrSignature;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<int?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const MovementsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.animalId = const Value.absent(),
    this.type = const Value.absent(),
    this.movementDate = const Value.absent(),
    this.fromFarmId = const Value.absent(),
    this.toFarmId = const Value.absent(),
    this.price = const Value.absent(),
    this.notes = const Value.absent(),
    this.buyerQrSignature = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MovementsTableCompanion.insert({
    required String id,
    required String farmId,
    required String animalId,
    required String type,
    required DateTime movementDate,
    this.fromFarmId = const Value.absent(),
    this.toFarmId = const Value.absent(),
    this.price = const Value.absent(),
    this.notes = const Value.absent(),
    this.buyerQrSignature = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        animalId = Value(animalId),
        type = Value(type),
        movementDate = Value(movementDate),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<MovementsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? animalId,
    Expression<String>? type,
    Expression<DateTime>? movementDate,
    Expression<String>? fromFarmId,
    Expression<String>? toFarmId,
    Expression<double>? price,
    Expression<String>? notes,
    Expression<String>? buyerQrSignature,
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
      if (animalId != null) 'animal_id': animalId,
      if (type != null) 'type': type,
      if (movementDate != null) 'movement_date': movementDate,
      if (fromFarmId != null) 'from_farm_id': fromFarmId,
      if (toFarmId != null) 'to_farm_id': toFarmId,
      if (price != null) 'price': price,
      if (notes != null) 'notes': notes,
      if (buyerQrSignature != null) 'buyer_qr_signature': buyerQrSignature,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MovementsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? animalId,
      Value<String>? type,
      Value<DateTime>? movementDate,
      Value<String?>? fromFarmId,
      Value<String?>? toFarmId,
      Value<double?>? price,
      Value<String?>? notes,
      Value<String?>? buyerQrSignature,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<int?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return MovementsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      animalId: animalId ?? this.animalId,
      type: type ?? this.type,
      movementDate: movementDate ?? this.movementDate,
      fromFarmId: fromFarmId ?? this.fromFarmId,
      toFarmId: toFarmId ?? this.toFarmId,
      price: price ?? this.price,
      notes: notes ?? this.notes,
      buyerQrSignature: buyerQrSignature ?? this.buyerQrSignature,
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
    if (animalId.present) {
      map['animal_id'] = Variable<String>(animalId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (movementDate.present) {
      map['movement_date'] = Variable<DateTime>(movementDate.value);
    }
    if (fromFarmId.present) {
      map['from_farm_id'] = Variable<String>(fromFarmId.value);
    }
    if (toFarmId.present) {
      map['to_farm_id'] = Variable<String>(toFarmId.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (buyerQrSignature.present) {
      map['buyer_qr_signature'] = Variable<String>(buyerQrSignature.value);
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
    return (StringBuffer('MovementsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('animalId: $animalId, ')
          ..write('type: $type, ')
          ..write('movementDate: $movementDate, ')
          ..write('fromFarmId: $fromFarmId, ')
          ..write('toFarmId: $toFarmId, ')
          ..write('price: $price, ')
          ..write('notes: $notes, ')
          ..write('buyerQrSignature: $buyerQrSignature, ')
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

class $BatchesTableTable extends BatchesTable
    with TableInfo<$BatchesTableTable, BatchesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatchesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _purposeMeta =
      const VerificationMeta('purpose');
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
      'purpose', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _animalIdsJsonMeta =
      const VerificationMeta('animalIdsJson');
  @override
  late final GeneratedColumn<String> animalIdsJson = GeneratedColumn<String>(
      'animal_ids_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _usedAtMeta = const VerificationMeta('usedAt');
  @override
  late final GeneratedColumn<DateTime> usedAt = GeneratedColumn<DateTime>(
      'used_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        purpose,
        animalIdsJson,
        usedAt,
        completed,
        notes,
        synced,
        createdAt,
        updatedAt,
        lastSyncedAt,
        serverVersion,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batches';
  @override
  VerificationContext validateIntegrity(Insertable<BatchesTableData> instance,
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
    if (data.containsKey('purpose')) {
      context.handle(_purposeMeta,
          purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta));
    } else if (isInserting) {
      context.missing(_purposeMeta);
    }
    if (data.containsKey('animal_ids_json')) {
      context.handle(
          _animalIdsJsonMeta,
          animalIdsJson.isAcceptableOrUnknown(
              data['animal_ids_json']!, _animalIdsJsonMeta));
    } else if (isInserting) {
      context.missing(_animalIdsJsonMeta);
    }
    if (data.containsKey('used_at')) {
      context.handle(_usedAtMeta,
          usedAt.isAcceptableOrUnknown(data['used_at']!, _usedAtMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {farmId, name},
      ];
  @override
  BatchesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BatchesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      purpose: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purpose'])!,
      animalIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}animal_ids_json'])!,
      usedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}used_at']),
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_version']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $BatchesTableTable createAlias(String alias) {
    return $BatchesTableTable(attachedDatabase, alias);
  }
}

class BatchesTableData extends DataClass
    implements Insertable<BatchesTableData> {
  final String id;
  final String farmId;
  final String name;
  final String purpose;
  final String animalIdsJson;
  final DateTime? usedAt;
  final bool completed;
  final String? notes;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  final DateTime? deletedAt;
  const BatchesTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      required this.purpose,
      required this.animalIdsJson,
      this.usedAt,
      required this.completed,
      this.notes,
      required this.synced,
      required this.createdAt,
      required this.updatedAt,
      this.lastSyncedAt,
      this.serverVersion,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    map['purpose'] = Variable<String>(purpose);
    map['animal_ids_json'] = Variable<String>(animalIdsJson);
    if (!nullToAbsent || usedAt != null) {
      map['used_at'] = Variable<DateTime>(usedAt);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<String>(serverVersion);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  BatchesTableCompanion toCompanion(bool nullToAbsent) {
    return BatchesTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      purpose: Value(purpose),
      animalIdsJson: Value(animalIdsJson),
      usedAt:
          usedAt == null && nullToAbsent ? const Value.absent() : Value(usedAt),
      completed: Value(completed),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      synced: Value(synced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory BatchesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BatchesTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      purpose: serializer.fromJson<String>(json['purpose']),
      animalIdsJson: serializer.fromJson<String>(json['animalIdsJson']),
      usedAt: serializer.fromJson<DateTime?>(json['usedAt']),
      completed: serializer.fromJson<bool>(json['completed']),
      notes: serializer.fromJson<String?>(json['notes']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      serverVersion: serializer.fromJson<String?>(json['serverVersion']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'purpose': serializer.toJson<String>(purpose),
      'animalIdsJson': serializer.toJson<String>(animalIdsJson),
      'usedAt': serializer.toJson<DateTime?>(usedAt),
      'completed': serializer.toJson<bool>(completed),
      'notes': serializer.toJson<String?>(notes),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<String?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  BatchesTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          String? purpose,
          String? animalIdsJson,
          Value<DateTime?> usedAt = const Value.absent(),
          bool? completed,
          Value<String?> notes = const Value.absent(),
          bool? synced,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      BatchesTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        purpose: purpose ?? this.purpose,
        animalIdsJson: animalIdsJson ?? this.animalIdsJson,
        usedAt: usedAt.present ? usedAt.value : this.usedAt,
        completed: completed ?? this.completed,
        notes: notes.present ? notes.value : this.notes,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  BatchesTableData copyWithCompanion(BatchesTableCompanion data) {
    return BatchesTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      animalIdsJson: data.animalIdsJson.present
          ? data.animalIdsJson.value
          : this.animalIdsJson,
      usedAt: data.usedAt.present ? data.usedAt.value : this.usedAt,
      completed: data.completed.present ? data.completed.value : this.completed,
      notes: data.notes.present ? data.notes.value : this.notes,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BatchesTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('purpose: $purpose, ')
          ..write('animalIdsJson: $animalIdsJson, ')
          ..write('usedAt: $usedAt, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      farmId,
      name,
      purpose,
      animalIdsJson,
      usedAt,
      completed,
      notes,
      synced,
      createdAt,
      updatedAt,
      lastSyncedAt,
      serverVersion,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BatchesTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.purpose == this.purpose &&
          other.animalIdsJson == this.animalIdsJson &&
          other.usedAt == this.usedAt &&
          other.completed == this.completed &&
          other.notes == this.notes &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt);
}

class BatchesTableCompanion extends UpdateCompanion<BatchesTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String> purpose;
  final Value<String> animalIdsJson;
  final Value<DateTime?> usedAt;
  final Value<bool> completed;
  final Value<String?> notes;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const BatchesTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.purpose = const Value.absent(),
    this.animalIdsJson = const Value.absent(),
    this.usedAt = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BatchesTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    required String purpose,
    required String animalIdsJson,
    this.usedAt = const Value.absent(),
    this.completed = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        purpose = Value(purpose),
        animalIdsJson = Value(animalIdsJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<BatchesTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? purpose,
    Expression<String>? animalIdsJson,
    Expression<DateTime>? usedAt,
    Expression<bool>? completed,
    Expression<String>? notes,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? serverVersion,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (purpose != null) 'purpose': purpose,
      if (animalIdsJson != null) 'animal_ids_json': animalIdsJson,
      if (usedAt != null) 'used_at': usedAt,
      if (completed != null) 'completed': completed,
      if (notes != null) 'notes': notes,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BatchesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String>? purpose,
      Value<String>? animalIdsJson,
      Value<DateTime?>? usedAt,
      Value<bool>? completed,
      Value<String?>? notes,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return BatchesTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      purpose: purpose ?? this.purpose,
      animalIdsJson: animalIdsJson ?? this.animalIdsJson,
      usedAt: usedAt ?? this.usedAt,
      completed: completed ?? this.completed,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (animalIdsJson.present) {
      map['animal_ids_json'] = Variable<String>(animalIdsJson.value);
    }
    if (usedAt.present) {
      map['used_at'] = Variable<DateTime>(usedAt.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatchesTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('purpose: $purpose, ')
          ..write('animalIdsJson: $animalIdsJson, ')
          ..write('usedAt: $usedAt, ')
          ..write('completed: $completed, ')
          ..write('notes: $notes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LotsTableTable extends LotsTable
    with TableInfo<$LotsTableTable, LotsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LotsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _animalIdsJsonMeta =
      const VerificationMeta('animalIdsJson');
  @override
  late final GeneratedColumn<String> animalIdsJson = GeneratedColumn<String>(
      'animal_ids_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _treatmentDateMeta =
      const VerificationMeta('treatmentDate');
  @override
  late final GeneratedColumn<DateTime> treatmentDate =
      GeneratedColumn<DateTime>('treatment_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _withdrawalEndDateMeta =
      const VerificationMeta('withdrawalEndDate');
  @override
  late final GeneratedColumn<DateTime> withdrawalEndDate =
      GeneratedColumn<DateTime>('withdrawal_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _veterinarianIdMeta =
      const VerificationMeta('veterinarianId');
  @override
  late final GeneratedColumn<String> veterinarianId = GeneratedColumn<String>(
      'veterinarian_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _veterinarianNameMeta =
      const VerificationMeta('veterinarianName');
  @override
  late final GeneratedColumn<String> veterinarianName = GeneratedColumn<String>(
      'veterinarian_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buyerNameMeta =
      const VerificationMeta('buyerName');
  @override
  late final GeneratedColumn<String> buyerName = GeneratedColumn<String>(
      'buyer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _buyerFarmIdMeta =
      const VerificationMeta('buyerFarmId');
  @override
  late final GeneratedColumn<String> buyerFarmId = GeneratedColumn<String>(
      'buyer_farm_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalPriceMeta =
      const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
      'total_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _pricePerAnimalMeta =
      const VerificationMeta('pricePerAnimal');
  @override
  late final GeneratedColumn<double> pricePerAnimal = GeneratedColumn<double>(
      'price_per_animal', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _saleDateMeta =
      const VerificationMeta('saleDate');
  @override
  late final GeneratedColumn<DateTime> saleDate = GeneratedColumn<DateTime>(
      'sale_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _slaughterhouseNameMeta =
      const VerificationMeta('slaughterhouseName');
  @override
  late final GeneratedColumn<String> slaughterhouseName =
      GeneratedColumn<String>('slaughterhouse_name', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _slaughterhouseIdMeta =
      const VerificationMeta('slaughterhouseId');
  @override
  late final GeneratedColumn<String> slaughterhouseId = GeneratedColumn<String>(
      'slaughterhouse_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _slaughterDateMeta =
      const VerificationMeta('slaughterDate');
  @override
  late final GeneratedColumn<DateTime> slaughterDate =
      GeneratedColumn<DateTime>('slaughter_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        type,
        animalIdsJson,
        status,
        completed,
        completedAt,
        productId,
        productName,
        treatmentDate,
        withdrawalEndDate,
        veterinarianId,
        veterinarianName,
        buyerName,
        buyerFarmId,
        totalPrice,
        pricePerAnimal,
        saleDate,
        slaughterhouseName,
        slaughterhouseId,
        slaughterDate,
        notes,
        synced,
        createdAt,
        updatedAt,
        lastSyncedAt,
        serverVersion
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lots';
  @override
  VerificationContext validateIntegrity(Insertable<LotsTableData> instance,
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
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('animal_ids_json')) {
      context.handle(
          _animalIdsJsonMeta,
          animalIdsJson.isAcceptableOrUnknown(
              data['animal_ids_json']!, _animalIdsJsonMeta));
    } else if (isInserting) {
      context.missing(_animalIdsJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    }
    if (data.containsKey('treatment_date')) {
      context.handle(
          _treatmentDateMeta,
          treatmentDate.isAcceptableOrUnknown(
              data['treatment_date']!, _treatmentDateMeta));
    }
    if (data.containsKey('withdrawal_end_date')) {
      context.handle(
          _withdrawalEndDateMeta,
          withdrawalEndDate.isAcceptableOrUnknown(
              data['withdrawal_end_date']!, _withdrawalEndDateMeta));
    }
    if (data.containsKey('veterinarian_id')) {
      context.handle(
          _veterinarianIdMeta,
          veterinarianId.isAcceptableOrUnknown(
              data['veterinarian_id']!, _veterinarianIdMeta));
    }
    if (data.containsKey('veterinarian_name')) {
      context.handle(
          _veterinarianNameMeta,
          veterinarianName.isAcceptableOrUnknown(
              data['veterinarian_name']!, _veterinarianNameMeta));
    }
    if (data.containsKey('buyer_name')) {
      context.handle(_buyerNameMeta,
          buyerName.isAcceptableOrUnknown(data['buyer_name']!, _buyerNameMeta));
    }
    if (data.containsKey('buyer_farm_id')) {
      context.handle(
          _buyerFarmIdMeta,
          buyerFarmId.isAcceptableOrUnknown(
              data['buyer_farm_id']!, _buyerFarmIdMeta));
    }
    if (data.containsKey('total_price')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['total_price']!, _totalPriceMeta));
    }
    if (data.containsKey('price_per_animal')) {
      context.handle(
          _pricePerAnimalMeta,
          pricePerAnimal.isAcceptableOrUnknown(
              data['price_per_animal']!, _pricePerAnimalMeta));
    }
    if (data.containsKey('sale_date')) {
      context.handle(_saleDateMeta,
          saleDate.isAcceptableOrUnknown(data['sale_date']!, _saleDateMeta));
    }
    if (data.containsKey('slaughterhouse_name')) {
      context.handle(
          _slaughterhouseNameMeta,
          slaughterhouseName.isAcceptableOrUnknown(
              data['slaughterhouse_name']!, _slaughterhouseNameMeta));
    }
    if (data.containsKey('slaughterhouse_id')) {
      context.handle(
          _slaughterhouseIdMeta,
          slaughterhouseId.isAcceptableOrUnknown(
              data['slaughterhouse_id']!, _slaughterhouseIdMeta));
    }
    if (data.containsKey('slaughter_date')) {
      context.handle(
          _slaughterDateMeta,
          slaughterDate.isAcceptableOrUnknown(
              data['slaughter_date']!, _slaughterDateMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LotsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LotsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type']),
      animalIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}animal_ids_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status']),
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id']),
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name']),
      treatmentDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}treatment_date']),
      withdrawalEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}withdrawal_end_date']),
      veterinarianId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}veterinarian_id']),
      veterinarianName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}veterinarian_name']),
      buyerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}buyer_name']),
      buyerFarmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}buyer_farm_id']),
      totalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_price']),
      pricePerAnimal: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}price_per_animal']),
      saleDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sale_date']),
      slaughterhouseName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}slaughterhouse_name']),
      slaughterhouseId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}slaughterhouse_id']),
      slaughterDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}slaughter_date']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_version']),
    );
  }

  @override
  $LotsTableTable createAlias(String alias) {
    return $LotsTableTable(attachedDatabase, alias);
  }
}

class LotsTableData extends DataClass implements Insertable<LotsTableData> {
  final String id;
  final String farmId;
  final String name;
  final String? type;
  final String animalIdsJson;
  final String? status;
  final bool completed;
  final DateTime? completedAt;
  final String? productId;
  final String? productName;
  final DateTime? treatmentDate;
  final DateTime? withdrawalEndDate;
  final String? veterinarianId;
  final String? veterinarianName;
  final String? buyerName;
  final String? buyerFarmId;
  final double? totalPrice;
  final double? pricePerAnimal;
  final DateTime? saleDate;
  final String? slaughterhouseName;
  final String? slaughterhouseId;
  final DateTime? slaughterDate;
  final String? notes;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  const LotsTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      this.type,
      required this.animalIdsJson,
      this.status,
      required this.completed,
      this.completedAt,
      this.productId,
      this.productName,
      this.treatmentDate,
      this.withdrawalEndDate,
      this.veterinarianId,
      this.veterinarianName,
      this.buyerName,
      this.buyerFarmId,
      this.totalPrice,
      this.pricePerAnimal,
      this.saleDate,
      this.slaughterhouseName,
      this.slaughterhouseId,
      this.slaughterDate,
      this.notes,
      required this.synced,
      required this.createdAt,
      required this.updatedAt,
      this.lastSyncedAt,
      this.serverVersion});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    map['animal_ids_json'] = Variable<String>(animalIdsJson);
    if (!nullToAbsent || status != null) {
      map['status'] = Variable<String>(status);
    }
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || productName != null) {
      map['product_name'] = Variable<String>(productName);
    }
    if (!nullToAbsent || treatmentDate != null) {
      map['treatment_date'] = Variable<DateTime>(treatmentDate);
    }
    if (!nullToAbsent || withdrawalEndDate != null) {
      map['withdrawal_end_date'] = Variable<DateTime>(withdrawalEndDate);
    }
    if (!nullToAbsent || veterinarianId != null) {
      map['veterinarian_id'] = Variable<String>(veterinarianId);
    }
    if (!nullToAbsent || veterinarianName != null) {
      map['veterinarian_name'] = Variable<String>(veterinarianName);
    }
    if (!nullToAbsent || buyerName != null) {
      map['buyer_name'] = Variable<String>(buyerName);
    }
    if (!nullToAbsent || buyerFarmId != null) {
      map['buyer_farm_id'] = Variable<String>(buyerFarmId);
    }
    if (!nullToAbsent || totalPrice != null) {
      map['total_price'] = Variable<double>(totalPrice);
    }
    if (!nullToAbsent || pricePerAnimal != null) {
      map['price_per_animal'] = Variable<double>(pricePerAnimal);
    }
    if (!nullToAbsent || saleDate != null) {
      map['sale_date'] = Variable<DateTime>(saleDate);
    }
    if (!nullToAbsent || slaughterhouseName != null) {
      map['slaughterhouse_name'] = Variable<String>(slaughterhouseName);
    }
    if (!nullToAbsent || slaughterhouseId != null) {
      map['slaughterhouse_id'] = Variable<String>(slaughterhouseId);
    }
    if (!nullToAbsent || slaughterDate != null) {
      map['slaughter_date'] = Variable<DateTime>(slaughterDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<String>(serverVersion);
    }
    return map;
  }

  LotsTableCompanion toCompanion(bool nullToAbsent) {
    return LotsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      animalIdsJson: Value(animalIdsJson),
      status:
          status == null && nullToAbsent ? const Value.absent() : Value(status),
      completed: Value(completed),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      productName: productName == null && nullToAbsent
          ? const Value.absent()
          : Value(productName),
      treatmentDate: treatmentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(treatmentDate),
      withdrawalEndDate: withdrawalEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(withdrawalEndDate),
      veterinarianId: veterinarianId == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianId),
      veterinarianName: veterinarianName == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianName),
      buyerName: buyerName == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerName),
      buyerFarmId: buyerFarmId == null && nullToAbsent
          ? const Value.absent()
          : Value(buyerFarmId),
      totalPrice: totalPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPrice),
      pricePerAnimal: pricePerAnimal == null && nullToAbsent
          ? const Value.absent()
          : Value(pricePerAnimal),
      saleDate: saleDate == null && nullToAbsent
          ? const Value.absent()
          : Value(saleDate),
      slaughterhouseName: slaughterhouseName == null && nullToAbsent
          ? const Value.absent()
          : Value(slaughterhouseName),
      slaughterhouseId: slaughterhouseId == null && nullToAbsent
          ? const Value.absent()
          : Value(slaughterhouseId),
      slaughterDate: slaughterDate == null && nullToAbsent
          ? const Value.absent()
          : Value(slaughterDate),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      synced: Value(synced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
    );
  }

  factory LotsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LotsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String?>(json['type']),
      animalIdsJson: serializer.fromJson<String>(json['animalIdsJson']),
      status: serializer.fromJson<String?>(json['status']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      productId: serializer.fromJson<String?>(json['productId']),
      productName: serializer.fromJson<String?>(json['productName']),
      treatmentDate: serializer.fromJson<DateTime?>(json['treatmentDate']),
      withdrawalEndDate:
          serializer.fromJson<DateTime?>(json['withdrawalEndDate']),
      veterinarianId: serializer.fromJson<String?>(json['veterinarianId']),
      veterinarianName: serializer.fromJson<String?>(json['veterinarianName']),
      buyerName: serializer.fromJson<String?>(json['buyerName']),
      buyerFarmId: serializer.fromJson<String?>(json['buyerFarmId']),
      totalPrice: serializer.fromJson<double?>(json['totalPrice']),
      pricePerAnimal: serializer.fromJson<double?>(json['pricePerAnimal']),
      saleDate: serializer.fromJson<DateTime?>(json['saleDate']),
      slaughterhouseName:
          serializer.fromJson<String?>(json['slaughterhouseName']),
      slaughterhouseId: serializer.fromJson<String?>(json['slaughterhouseId']),
      slaughterDate: serializer.fromJson<DateTime?>(json['slaughterDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      serverVersion: serializer.fromJson<String?>(json['serverVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String?>(type),
      'animalIdsJson': serializer.toJson<String>(animalIdsJson),
      'status': serializer.toJson<String?>(status),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'productId': serializer.toJson<String?>(productId),
      'productName': serializer.toJson<String?>(productName),
      'treatmentDate': serializer.toJson<DateTime?>(treatmentDate),
      'withdrawalEndDate': serializer.toJson<DateTime?>(withdrawalEndDate),
      'veterinarianId': serializer.toJson<String?>(veterinarianId),
      'veterinarianName': serializer.toJson<String?>(veterinarianName),
      'buyerName': serializer.toJson<String?>(buyerName),
      'buyerFarmId': serializer.toJson<String?>(buyerFarmId),
      'totalPrice': serializer.toJson<double?>(totalPrice),
      'pricePerAnimal': serializer.toJson<double?>(pricePerAnimal),
      'saleDate': serializer.toJson<DateTime?>(saleDate),
      'slaughterhouseName': serializer.toJson<String?>(slaughterhouseName),
      'slaughterhouseId': serializer.toJson<String?>(slaughterhouseId),
      'slaughterDate': serializer.toJson<DateTime?>(slaughterDate),
      'notes': serializer.toJson<String?>(notes),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<String?>(serverVersion),
    };
  }

  LotsTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          Value<String?> type = const Value.absent(),
          String? animalIdsJson,
          Value<String?> status = const Value.absent(),
          bool? completed,
          Value<DateTime?> completedAt = const Value.absent(),
          Value<String?> productId = const Value.absent(),
          Value<String?> productName = const Value.absent(),
          Value<DateTime?> treatmentDate = const Value.absent(),
          Value<DateTime?> withdrawalEndDate = const Value.absent(),
          Value<String?> veterinarianId = const Value.absent(),
          Value<String?> veterinarianName = const Value.absent(),
          Value<String?> buyerName = const Value.absent(),
          Value<String?> buyerFarmId = const Value.absent(),
          Value<double?> totalPrice = const Value.absent(),
          Value<double?> pricePerAnimal = const Value.absent(),
          Value<DateTime?> saleDate = const Value.absent(),
          Value<String?> slaughterhouseName = const Value.absent(),
          Value<String?> slaughterhouseId = const Value.absent(),
          Value<DateTime?> slaughterDate = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          bool? synced,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> serverVersion = const Value.absent()}) =>
      LotsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        type: type.present ? type.value : this.type,
        animalIdsJson: animalIdsJson ?? this.animalIdsJson,
        status: status.present ? status.value : this.status,
        completed: completed ?? this.completed,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        productId: productId.present ? productId.value : this.productId,
        productName: productName.present ? productName.value : this.productName,
        treatmentDate:
            treatmentDate.present ? treatmentDate.value : this.treatmentDate,
        withdrawalEndDate: withdrawalEndDate.present
            ? withdrawalEndDate.value
            : this.withdrawalEndDate,
        veterinarianId:
            veterinarianId.present ? veterinarianId.value : this.veterinarianId,
        veterinarianName: veterinarianName.present
            ? veterinarianName.value
            : this.veterinarianName,
        buyerName: buyerName.present ? buyerName.value : this.buyerName,
        buyerFarmId: buyerFarmId.present ? buyerFarmId.value : this.buyerFarmId,
        totalPrice: totalPrice.present ? totalPrice.value : this.totalPrice,
        pricePerAnimal:
            pricePerAnimal.present ? pricePerAnimal.value : this.pricePerAnimal,
        saleDate: saleDate.present ? saleDate.value : this.saleDate,
        slaughterhouseName: slaughterhouseName.present
            ? slaughterhouseName.value
            : this.slaughterhouseName,
        slaughterhouseId: slaughterhouseId.present
            ? slaughterhouseId.value
            : this.slaughterhouseId,
        slaughterDate:
            slaughterDate.present ? slaughterDate.value : this.slaughterDate,
        notes: notes.present ? notes.value : this.notes,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
      );
  LotsTableData copyWithCompanion(LotsTableCompanion data) {
    return LotsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      animalIdsJson: data.animalIdsJson.present
          ? data.animalIdsJson.value
          : this.animalIdsJson,
      status: data.status.present ? data.status.value : this.status,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      treatmentDate: data.treatmentDate.present
          ? data.treatmentDate.value
          : this.treatmentDate,
      withdrawalEndDate: data.withdrawalEndDate.present
          ? data.withdrawalEndDate.value
          : this.withdrawalEndDate,
      veterinarianId: data.veterinarianId.present
          ? data.veterinarianId.value
          : this.veterinarianId,
      veterinarianName: data.veterinarianName.present
          ? data.veterinarianName.value
          : this.veterinarianName,
      buyerName: data.buyerName.present ? data.buyerName.value : this.buyerName,
      buyerFarmId:
          data.buyerFarmId.present ? data.buyerFarmId.value : this.buyerFarmId,
      totalPrice:
          data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      pricePerAnimal: data.pricePerAnimal.present
          ? data.pricePerAnimal.value
          : this.pricePerAnimal,
      saleDate: data.saleDate.present ? data.saleDate.value : this.saleDate,
      slaughterhouseName: data.slaughterhouseName.present
          ? data.slaughterhouseName.value
          : this.slaughterhouseName,
      slaughterhouseId: data.slaughterhouseId.present
          ? data.slaughterhouseId.value
          : this.slaughterhouseId,
      slaughterDate: data.slaughterDate.present
          ? data.slaughterDate.value
          : this.slaughterDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LotsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('animalIdsJson: $animalIdsJson, ')
          ..write('status: $status, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('treatmentDate: $treatmentDate, ')
          ..write('withdrawalEndDate: $withdrawalEndDate, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('buyerName: $buyerName, ')
          ..write('buyerFarmId: $buyerFarmId, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('pricePerAnimal: $pricePerAnimal, ')
          ..write('saleDate: $saleDate, ')
          ..write('slaughterhouseName: $slaughterhouseName, ')
          ..write('slaughterhouseId: $slaughterhouseId, ')
          ..write('slaughterDate: $slaughterDate, ')
          ..write('notes: $notes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        farmId,
        name,
        type,
        animalIdsJson,
        status,
        completed,
        completedAt,
        productId,
        productName,
        treatmentDate,
        withdrawalEndDate,
        veterinarianId,
        veterinarianName,
        buyerName,
        buyerFarmId,
        totalPrice,
        pricePerAnimal,
        saleDate,
        slaughterhouseName,
        slaughterhouseId,
        slaughterDate,
        notes,
        synced,
        createdAt,
        updatedAt,
        lastSyncedAt,
        serverVersion
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LotsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.type == this.type &&
          other.animalIdsJson == this.animalIdsJson &&
          other.status == this.status &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.treatmentDate == this.treatmentDate &&
          other.withdrawalEndDate == this.withdrawalEndDate &&
          other.veterinarianId == this.veterinarianId &&
          other.veterinarianName == this.veterinarianName &&
          other.buyerName == this.buyerName &&
          other.buyerFarmId == this.buyerFarmId &&
          other.totalPrice == this.totalPrice &&
          other.pricePerAnimal == this.pricePerAnimal &&
          other.saleDate == this.saleDate &&
          other.slaughterhouseName == this.slaughterhouseName &&
          other.slaughterhouseId == this.slaughterhouseId &&
          other.slaughterDate == this.slaughterDate &&
          other.notes == this.notes &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion);
}

class LotsTableCompanion extends UpdateCompanion<LotsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String?> type;
  final Value<String> animalIdsJson;
  final Value<String?> status;
  final Value<bool> completed;
  final Value<DateTime?> completedAt;
  final Value<String?> productId;
  final Value<String?> productName;
  final Value<DateTime?> treatmentDate;
  final Value<DateTime?> withdrawalEndDate;
  final Value<String?> veterinarianId;
  final Value<String?> veterinarianName;
  final Value<String?> buyerName;
  final Value<String?> buyerFarmId;
  final Value<double?> totalPrice;
  final Value<double?> pricePerAnimal;
  final Value<DateTime?> saleDate;
  final Value<String?> slaughterhouseName;
  final Value<String?> slaughterhouseId;
  final Value<DateTime?> slaughterDate;
  final Value<String?> notes;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> serverVersion;
  final Value<int> rowid;
  const LotsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.animalIdsJson = const Value.absent(),
    this.status = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.treatmentDate = const Value.absent(),
    this.withdrawalEndDate = const Value.absent(),
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.buyerName = const Value.absent(),
    this.buyerFarmId = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.pricePerAnimal = const Value.absent(),
    this.saleDate = const Value.absent(),
    this.slaughterhouseName = const Value.absent(),
    this.slaughterhouseId = const Value.absent(),
    this.slaughterDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LotsTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    this.type = const Value.absent(),
    required String animalIdsJson,
    this.status = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.treatmentDate = const Value.absent(),
    this.withdrawalEndDate = const Value.absent(),
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.buyerName = const Value.absent(),
    this.buyerFarmId = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.pricePerAnimal = const Value.absent(),
    this.saleDate = const Value.absent(),
    this.slaughterhouseName = const Value.absent(),
    this.slaughterhouseId = const Value.absent(),
    this.slaughterDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        animalIdsJson = Value(animalIdsJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<LotsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? animalIdsJson,
    Expression<String>? status,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<DateTime>? treatmentDate,
    Expression<DateTime>? withdrawalEndDate,
    Expression<String>? veterinarianId,
    Expression<String>? veterinarianName,
    Expression<String>? buyerName,
    Expression<String>? buyerFarmId,
    Expression<double>? totalPrice,
    Expression<double>? pricePerAnimal,
    Expression<DateTime>? saleDate,
    Expression<String>? slaughterhouseName,
    Expression<String>? slaughterhouseId,
    Expression<DateTime>? slaughterDate,
    Expression<String>? notes,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? serverVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (animalIdsJson != null) 'animal_ids_json': animalIdsJson,
      if (status != null) 'status': status,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (treatmentDate != null) 'treatment_date': treatmentDate,
      if (withdrawalEndDate != null) 'withdrawal_end_date': withdrawalEndDate,
      if (veterinarianId != null) 'veterinarian_id': veterinarianId,
      if (veterinarianName != null) 'veterinarian_name': veterinarianName,
      if (buyerName != null) 'buyer_name': buyerName,
      if (buyerFarmId != null) 'buyer_farm_id': buyerFarmId,
      if (totalPrice != null) 'total_price': totalPrice,
      if (pricePerAnimal != null) 'price_per_animal': pricePerAnimal,
      if (saleDate != null) 'sale_date': saleDate,
      if (slaughterhouseName != null) 'slaughterhouse_name': slaughterhouseName,
      if (slaughterhouseId != null) 'slaughterhouse_id': slaughterhouseId,
      if (slaughterDate != null) 'slaughter_date': slaughterDate,
      if (notes != null) 'notes': notes,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LotsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String?>? type,
      Value<String>? animalIdsJson,
      Value<String?>? status,
      Value<bool>? completed,
      Value<DateTime?>? completedAt,
      Value<String?>? productId,
      Value<String?>? productName,
      Value<DateTime?>? treatmentDate,
      Value<DateTime?>? withdrawalEndDate,
      Value<String?>? veterinarianId,
      Value<String?>? veterinarianName,
      Value<String?>? buyerName,
      Value<String?>? buyerFarmId,
      Value<double?>? totalPrice,
      Value<double?>? pricePerAnimal,
      Value<DateTime?>? saleDate,
      Value<String?>? slaughterhouseName,
      Value<String?>? slaughterhouseId,
      Value<DateTime?>? slaughterDate,
      Value<String?>? notes,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String?>? serverVersion,
      Value<int>? rowid}) {
    return LotsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      type: type ?? this.type,
      animalIdsJson: animalIdsJson ?? this.animalIdsJson,
      status: status ?? this.status,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      treatmentDate: treatmentDate ?? this.treatmentDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      buyerName: buyerName ?? this.buyerName,
      buyerFarmId: buyerFarmId ?? this.buyerFarmId,
      totalPrice: totalPrice ?? this.totalPrice,
      pricePerAnimal: pricePerAnimal ?? this.pricePerAnimal,
      saleDate: saleDate ?? this.saleDate,
      slaughterhouseName: slaughterhouseName ?? this.slaughterhouseName,
      slaughterhouseId: slaughterhouseId ?? this.slaughterhouseId,
      slaughterDate: slaughterDate ?? this.slaughterDate,
      notes: notes ?? this.notes,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
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
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (animalIdsJson.present) {
      map['animal_ids_json'] = Variable<String>(animalIdsJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (treatmentDate.present) {
      map['treatment_date'] = Variable<DateTime>(treatmentDate.value);
    }
    if (withdrawalEndDate.present) {
      map['withdrawal_end_date'] = Variable<DateTime>(withdrawalEndDate.value);
    }
    if (veterinarianId.present) {
      map['veterinarian_id'] = Variable<String>(veterinarianId.value);
    }
    if (veterinarianName.present) {
      map['veterinarian_name'] = Variable<String>(veterinarianName.value);
    }
    if (buyerName.present) {
      map['buyer_name'] = Variable<String>(buyerName.value);
    }
    if (buyerFarmId.present) {
      map['buyer_farm_id'] = Variable<String>(buyerFarmId.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (pricePerAnimal.present) {
      map['price_per_animal'] = Variable<double>(pricePerAnimal.value);
    }
    if (saleDate.present) {
      map['sale_date'] = Variable<DateTime>(saleDate.value);
    }
    if (slaughterhouseName.present) {
      map['slaughterhouse_name'] = Variable<String>(slaughterhouseName.value);
    }
    if (slaughterhouseId.present) {
      map['slaughterhouse_id'] = Variable<String>(slaughterhouseId.value);
    }
    if (slaughterDate.present) {
      map['slaughter_date'] = Variable<DateTime>(slaughterDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (serverVersion.present) {
      map['server_version'] = Variable<String>(serverVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LotsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('animalIdsJson: $animalIdsJson, ')
          ..write('status: $status, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('treatmentDate: $treatmentDate, ')
          ..write('withdrawalEndDate: $withdrawalEndDate, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('buyerName: $buyerName, ')
          ..write('buyerFarmId: $buyerFarmId, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('pricePerAnimal: $pricePerAnimal, ')
          ..write('saleDate: $saleDate, ')
          ..write('slaughterhouseName: $slaughterhouseName, ')
          ..write('slaughterhouseId: $slaughterhouseId, ')
          ..write('slaughterDate: $slaughterDate, ')
          ..write('notes: $notes, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CampaignsTableTable extends CampaignsTable
    with TableInfo<$CampaignsTableTable, CampaignsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CampaignsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _campaignDateMeta =
      const VerificationMeta('campaignDate');
  @override
  late final GeneratedColumn<DateTime> campaignDate = GeneratedColumn<DateTime>(
      'campaign_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _withdrawalEndDateMeta =
      const VerificationMeta('withdrawalEndDate');
  @override
  late final GeneratedColumn<DateTime> withdrawalEndDate =
      GeneratedColumn<DateTime>('withdrawal_end_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _veterinarianIdMeta =
      const VerificationMeta('veterinarianId');
  @override
  late final GeneratedColumn<String> veterinarianId = GeneratedColumn<String>(
      'veterinarian_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _veterinarianNameMeta =
      const VerificationMeta('veterinarianName');
  @override
  late final GeneratedColumn<String> veterinarianName = GeneratedColumn<String>(
      'veterinarian_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _animalIdsJsonMeta =
      const VerificationMeta('animalIdsJson');
  @override
  late final GeneratedColumn<String> animalIdsJson = GeneratedColumn<String>(
      'animal_ids_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _completedMeta =
      const VerificationMeta('completed');
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
      'completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
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
  @override
  List<GeneratedColumn> get $columns => [
        id,
        farmId,
        name,
        productId,
        productName,
        campaignDate,
        withdrawalEndDate,
        veterinarianId,
        veterinarianName,
        animalIdsJson,
        completed,
        synced,
        createdAt,
        updatedAt,
        lastSyncedAt,
        serverVersion,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'campaigns';
  @override
  VerificationContext validateIntegrity(Insertable<CampaignsTableData> instance,
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
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('campaign_date')) {
      context.handle(
          _campaignDateMeta,
          campaignDate.isAcceptableOrUnknown(
              data['campaign_date']!, _campaignDateMeta));
    } else if (isInserting) {
      context.missing(_campaignDateMeta);
    }
    if (data.containsKey('withdrawal_end_date')) {
      context.handle(
          _withdrawalEndDateMeta,
          withdrawalEndDate.isAcceptableOrUnknown(
              data['withdrawal_end_date']!, _withdrawalEndDateMeta));
    } else if (isInserting) {
      context.missing(_withdrawalEndDateMeta);
    }
    if (data.containsKey('veterinarian_id')) {
      context.handle(
          _veterinarianIdMeta,
          veterinarianId.isAcceptableOrUnknown(
              data['veterinarian_id']!, _veterinarianIdMeta));
    }
    if (data.containsKey('veterinarian_name')) {
      context.handle(
          _veterinarianNameMeta,
          veterinarianName.isAcceptableOrUnknown(
              data['veterinarian_name']!, _veterinarianNameMeta));
    }
    if (data.containsKey('animal_ids_json')) {
      context.handle(
          _animalIdsJsonMeta,
          animalIdsJson.isAcceptableOrUnknown(
              data['animal_ids_json']!, _animalIdsJsonMeta));
    } else if (isInserting) {
      context.missing(_animalIdsJsonMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(_completedMeta,
          completed.isAcceptableOrUnknown(data['completed']!, _completedMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CampaignsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CampaignsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      campaignDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}campaign_date'])!,
      withdrawalEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}withdrawal_end_date'])!,
      veterinarianId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}veterinarian_id']),
      veterinarianName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}veterinarian_name']),
      animalIdsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}animal_ids_json'])!,
      completed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_synced_at']),
      serverVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server_version']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $CampaignsTableTable createAlias(String alias) {
    return $CampaignsTableTable(attachedDatabase, alias);
  }
}

class CampaignsTableData extends DataClass
    implements Insertable<CampaignsTableData> {
  final String id;
  final String farmId;
  final String name;
  final String productId;
  final String productName;
  final DateTime campaignDate;
  final DateTime withdrawalEndDate;
  final String? veterinarianId;
  final String? veterinarianName;
  final String animalIdsJson;
  final bool completed;
  final bool synced;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastSyncedAt;
  final String? serverVersion;
  final DateTime? deletedAt;
  const CampaignsTableData(
      {required this.id,
      required this.farmId,
      required this.name,
      required this.productId,
      required this.productName,
      required this.campaignDate,
      required this.withdrawalEndDate,
      this.veterinarianId,
      this.veterinarianName,
      required this.animalIdsJson,
      required this.completed,
      required this.synced,
      required this.createdAt,
      required this.updatedAt,
      this.lastSyncedAt,
      this.serverVersion,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['farm_id'] = Variable<String>(farmId);
    map['name'] = Variable<String>(name);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    map['campaign_date'] = Variable<DateTime>(campaignDate);
    map['withdrawal_end_date'] = Variable<DateTime>(withdrawalEndDate);
    if (!nullToAbsent || veterinarianId != null) {
      map['veterinarian_id'] = Variable<String>(veterinarianId);
    }
    if (!nullToAbsent || veterinarianName != null) {
      map['veterinarian_name'] = Variable<String>(veterinarianName);
    }
    map['animal_ids_json'] = Variable<String>(animalIdsJson);
    map['completed'] = Variable<bool>(completed);
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || serverVersion != null) {
      map['server_version'] = Variable<String>(serverVersion);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CampaignsTableCompanion toCompanion(bool nullToAbsent) {
    return CampaignsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      name: Value(name),
      productId: Value(productId),
      productName: Value(productName),
      campaignDate: Value(campaignDate),
      withdrawalEndDate: Value(withdrawalEndDate),
      veterinarianId: veterinarianId == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianId),
      veterinarianName: veterinarianName == null && nullToAbsent
          ? const Value.absent()
          : Value(veterinarianName),
      animalIdsJson: Value(animalIdsJson),
      completed: Value(completed),
      synced: Value(synced),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      serverVersion: serverVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(serverVersion),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CampaignsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CampaignsTableData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      name: serializer.fromJson<String>(json['name']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      campaignDate: serializer.fromJson<DateTime>(json['campaignDate']),
      withdrawalEndDate:
          serializer.fromJson<DateTime>(json['withdrawalEndDate']),
      veterinarianId: serializer.fromJson<String?>(json['veterinarianId']),
      veterinarianName: serializer.fromJson<String?>(json['veterinarianName']),
      animalIdsJson: serializer.fromJson<String>(json['animalIdsJson']),
      completed: serializer.fromJson<bool>(json['completed']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      serverVersion: serializer.fromJson<String?>(json['serverVersion']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'farmId': serializer.toJson<String>(farmId),
      'name': serializer.toJson<String>(name),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'campaignDate': serializer.toJson<DateTime>(campaignDate),
      'withdrawalEndDate': serializer.toJson<DateTime>(withdrawalEndDate),
      'veterinarianId': serializer.toJson<String?>(veterinarianId),
      'veterinarianName': serializer.toJson<String?>(veterinarianName),
      'animalIdsJson': serializer.toJson<String>(animalIdsJson),
      'completed': serializer.toJson<bool>(completed),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<String?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CampaignsTableData copyWith(
          {String? id,
          String? farmId,
          String? name,
          String? productId,
          String? productName,
          DateTime? campaignDate,
          DateTime? withdrawalEndDate,
          Value<String?> veterinarianId = const Value.absent(),
          Value<String?> veterinarianName = const Value.absent(),
          String? animalIdsJson,
          bool? completed,
          bool? synced,
          DateTime? createdAt,
          DateTime? updatedAt,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      CampaignsTableData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        name: name ?? this.name,
        productId: productId ?? this.productId,
        productName: productName ?? this.productName,
        campaignDate: campaignDate ?? this.campaignDate,
        withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
        veterinarianId:
            veterinarianId.present ? veterinarianId.value : this.veterinarianId,
        veterinarianName: veterinarianName.present
            ? veterinarianName.value
            : this.veterinarianName,
        animalIdsJson: animalIdsJson ?? this.animalIdsJson,
        completed: completed ?? this.completed,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  CampaignsTableData copyWithCompanion(CampaignsTableCompanion data) {
    return CampaignsTableData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      name: data.name.present ? data.name.value : this.name,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      campaignDate: data.campaignDate.present
          ? data.campaignDate.value
          : this.campaignDate,
      withdrawalEndDate: data.withdrawalEndDate.present
          ? data.withdrawalEndDate.value
          : this.withdrawalEndDate,
      veterinarianId: data.veterinarianId.present
          ? data.veterinarianId.value
          : this.veterinarianId,
      veterinarianName: data.veterinarianName.present
          ? data.veterinarianName.value
          : this.veterinarianName,
      animalIdsJson: data.animalIdsJson.present
          ? data.animalIdsJson.value
          : this.animalIdsJson,
      completed: data.completed.present ? data.completed.value : this.completed,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      serverVersion: data.serverVersion.present
          ? data.serverVersion.value
          : this.serverVersion,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CampaignsTableData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('campaignDate: $campaignDate, ')
          ..write('withdrawalEndDate: $withdrawalEndDate, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('animalIdsJson: $animalIdsJson, ')
          ..write('completed: $completed, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      farmId,
      name,
      productId,
      productName,
      campaignDate,
      withdrawalEndDate,
      veterinarianId,
      veterinarianName,
      animalIdsJson,
      completed,
      synced,
      createdAt,
      updatedAt,
      lastSyncedAt,
      serverVersion,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CampaignsTableData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.name == this.name &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.campaignDate == this.campaignDate &&
          other.withdrawalEndDate == this.withdrawalEndDate &&
          other.veterinarianId == this.veterinarianId &&
          other.veterinarianName == this.veterinarianName &&
          other.animalIdsJson == this.animalIdsJson &&
          other.completed == this.completed &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt);
}

class CampaignsTableCompanion extends UpdateCompanion<CampaignsTableData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> name;
  final Value<String> productId;
  final Value<String> productName;
  final Value<DateTime> campaignDate;
  final Value<DateTime> withdrawalEndDate;
  final Value<String?> veterinarianId;
  final Value<String?> veterinarianName;
  final Value<String> animalIdsJson;
  final Value<bool> completed;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const CampaignsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.name = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.campaignDate = const Value.absent(),
    this.withdrawalEndDate = const Value.absent(),
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    this.animalIdsJson = const Value.absent(),
    this.completed = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CampaignsTableCompanion.insert({
    required String id,
    required String farmId,
    required String name,
    required String productId,
    required String productName,
    required DateTime campaignDate,
    required DateTime withdrawalEndDate,
    this.veterinarianId = const Value.absent(),
    this.veterinarianName = const Value.absent(),
    required String animalIdsJson,
    this.completed = const Value.absent(),
    this.synced = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        name = Value(name),
        productId = Value(productId),
        productName = Value(productName),
        campaignDate = Value(campaignDate),
        withdrawalEndDate = Value(withdrawalEndDate),
        animalIdsJson = Value(animalIdsJson),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CampaignsTableData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? name,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<DateTime>? campaignDate,
    Expression<DateTime>? withdrawalEndDate,
    Expression<String>? veterinarianId,
    Expression<String>? veterinarianName,
    Expression<String>? animalIdsJson,
    Expression<bool>? completed,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? serverVersion,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (farmId != null) 'farm_id': farmId,
      if (name != null) 'name': name,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (campaignDate != null) 'campaign_date': campaignDate,
      if (withdrawalEndDate != null) 'withdrawal_end_date': withdrawalEndDate,
      if (veterinarianId != null) 'veterinarian_id': veterinarianId,
      if (veterinarianName != null) 'veterinarian_name': veterinarianName,
      if (animalIdsJson != null) 'animal_ids_json': animalIdsJson,
      if (completed != null) 'completed': completed,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CampaignsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? name,
      Value<String>? productId,
      Value<String>? productName,
      Value<DateTime>? campaignDate,
      Value<DateTime>? withdrawalEndDate,
      Value<String?>? veterinarianId,
      Value<String?>? veterinarianName,
      Value<String>? animalIdsJson,
      Value<bool>? completed,
      Value<bool>? synced,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<DateTime?>? lastSyncedAt,
      Value<String?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<int>? rowid}) {
    return CampaignsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      name: name ?? this.name,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      campaignDate: campaignDate ?? this.campaignDate,
      withdrawalEndDate: withdrawalEndDate ?? this.withdrawalEndDate,
      veterinarianId: veterinarianId ?? this.veterinarianId,
      veterinarianName: veterinarianName ?? this.veterinarianName,
      animalIdsJson: animalIdsJson ?? this.animalIdsJson,
      completed: completed ?? this.completed,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      serverVersion: serverVersion ?? this.serverVersion,
      deletedAt: deletedAt ?? this.deletedAt,
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
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (campaignDate.present) {
      map['campaign_date'] = Variable<DateTime>(campaignDate.value);
    }
    if (withdrawalEndDate.present) {
      map['withdrawal_end_date'] = Variable<DateTime>(withdrawalEndDate.value);
    }
    if (veterinarianId.present) {
      map['veterinarian_id'] = Variable<String>(veterinarianId.value);
    }
    if (veterinarianName.present) {
      map['veterinarian_name'] = Variable<String>(veterinarianName.value);
    }
    if (animalIdsJson.present) {
      map['animal_ids_json'] = Variable<String>(animalIdsJson.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CampaignsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('name: $name, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('campaignDate: $campaignDate, ')
          ..write('withdrawalEndDate: $withdrawalEndDate, ')
          ..write('veterinarianId: $veterinarianId, ')
          ..write('veterinarianName: $veterinarianName, ')
          ..write('animalIdsJson: $animalIdsJson, ')
          ..write('completed: $completed, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('serverVersion: $serverVersion, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertConfigurationsTableTable extends AlertConfigurationsTable
    with TableInfo<$AlertConfigurationsTableTable, AlertConfigurationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertConfigurationsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _evaluationTypeMeta =
      const VerificationMeta('evaluationType');
  @override
  late final GeneratedColumn<String> evaluationType = GeneratedColumn<String>(
      'evaluation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleKeyMeta =
      const VerificationMeta('titleKey');
  @override
  late final GeneratedColumn<String> titleKey = GeneratedColumn<String>(
      'title_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _messageKeyMeta =
      const VerificationMeta('messageKey');
  @override
  late final GeneratedColumn<String> messageKey = GeneratedColumn<String>(
      'message_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<int> severity = GeneratedColumn<int>(
      'severity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _enabledMeta =
      const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
      'enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
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
        evaluationType,
        type,
        category,
        titleKey,
        messageKey,
        severity,
        iconName,
        colorHex,
        enabled,
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
  static const String $name = 'alert_configurations_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AlertConfigurationData> instance,
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
    if (data.containsKey('evaluation_type')) {
      context.handle(
          _evaluationTypeMeta,
          evaluationType.isAcceptableOrUnknown(
              data['evaluation_type']!, _evaluationTypeMeta));
    } else if (isInserting) {
      context.missing(_evaluationTypeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title_key')) {
      context.handle(_titleKeyMeta,
          titleKey.isAcceptableOrUnknown(data['title_key']!, _titleKeyMeta));
    } else if (isInserting) {
      context.missing(_titleKeyMeta);
    }
    if (data.containsKey('message_key')) {
      context.handle(
          _messageKeyMeta,
          messageKey.isAcceptableOrUnknown(
              data['message_key']!, _messageKeyMeta));
    } else if (isInserting) {
      context.missing(_messageKeyMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta,
          enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
        {farmId, evaluationType},
      ];
  @override
  AlertConfigurationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertConfigurationData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      farmId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}farm_id'])!,
      evaluationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}evaluation_type'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      titleKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_key'])!,
      messageKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message_key'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}severity'])!,
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      enabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
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
  $AlertConfigurationsTableTable createAlias(String alias) {
    return $AlertConfigurationsTableTable(attachedDatabase, alias);
  }
}

class AlertConfigurationData extends DataClass
    implements Insertable<AlertConfigurationData> {
  /// Identifiant unique (UUID)
  final String id;

  /// Ferme propriétaire (multi-tenancy)
  final String farmId;

  /// Type d'évaluation (remanence, weighing, vaccination, etc.)
  final String evaluationType;

  /// Type d'alerte (urgent, important, routine)
  final String type;

  /// Catégorie d'alerte (remanence, identification, registre, etc.)
  final String category;

  /// Clé de traduction pour le titre (ex: alertRemanenceTitle)
  final String titleKey;

  /// Clé de traduction pour le message (ex: alertRemanenceMsg)
  final String messageKey;

  /// Niveau de sévérité (1 = faible, 2 = moyen, 3 = critique)
  final int severity;

  /// Emoji ou nom d'icône pour affichage
  final String iconName;

  /// Couleur en hexadécimal (#D32F2F)
  final String colorHex;

  /// Activation/désactivation de cette configuration par l'éleveur
  final bool enabled;

  /// Flag de synchronisation serveur
  final bool synced;

  /// Timestamp de la dernière synchronisation
  final DateTime? lastSyncedAt;

  /// Version serveur pour résolution de conflits
  final String? serverVersion;

  /// Timestamp de suppression (soft-delete)
  final DateTime? deletedAt;

  /// Timestamp de création
  final DateTime createdAt;

  /// Timestamp de dernière modification
  final DateTime updatedAt;
  const AlertConfigurationData(
      {required this.id,
      required this.farmId,
      required this.evaluationType,
      required this.type,
      required this.category,
      required this.titleKey,
      required this.messageKey,
      required this.severity,
      required this.iconName,
      required this.colorHex,
      required this.enabled,
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
    map['evaluation_type'] = Variable<String>(evaluationType);
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['title_key'] = Variable<String>(titleKey);
    map['message_key'] = Variable<String>(messageKey);
    map['severity'] = Variable<int>(severity);
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['enabled'] = Variable<bool>(enabled);
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

  AlertConfigurationsTableCompanion toCompanion(bool nullToAbsent) {
    return AlertConfigurationsTableCompanion(
      id: Value(id),
      farmId: Value(farmId),
      evaluationType: Value(evaluationType),
      type: Value(type),
      category: Value(category),
      titleKey: Value(titleKey),
      messageKey: Value(messageKey),
      severity: Value(severity),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      enabled: Value(enabled),
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

  factory AlertConfigurationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertConfigurationData(
      id: serializer.fromJson<String>(json['id']),
      farmId: serializer.fromJson<String>(json['farmId']),
      evaluationType: serializer.fromJson<String>(json['evaluationType']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      titleKey: serializer.fromJson<String>(json['titleKey']),
      messageKey: serializer.fromJson<String>(json['messageKey']),
      severity: serializer.fromJson<int>(json['severity']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      enabled: serializer.fromJson<bool>(json['enabled']),
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
      'evaluationType': serializer.toJson<String>(evaluationType),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'titleKey': serializer.toJson<String>(titleKey),
      'messageKey': serializer.toJson<String>(messageKey),
      'severity': serializer.toJson<int>(severity),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'enabled': serializer.toJson<bool>(enabled),
      'synced': serializer.toJson<bool>(synced),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'serverVersion': serializer.toJson<String?>(serverVersion),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AlertConfigurationData copyWith(
          {String? id,
          String? farmId,
          String? evaluationType,
          String? type,
          String? category,
          String? titleKey,
          String? messageKey,
          int? severity,
          String? iconName,
          String? colorHex,
          bool? enabled,
          bool? synced,
          Value<DateTime?> lastSyncedAt = const Value.absent(),
          Value<String?> serverVersion = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      AlertConfigurationData(
        id: id ?? this.id,
        farmId: farmId ?? this.farmId,
        evaluationType: evaluationType ?? this.evaluationType,
        type: type ?? this.type,
        category: category ?? this.category,
        titleKey: titleKey ?? this.titleKey,
        messageKey: messageKey ?? this.messageKey,
        severity: severity ?? this.severity,
        iconName: iconName ?? this.iconName,
        colorHex: colorHex ?? this.colorHex,
        enabled: enabled ?? this.enabled,
        synced: synced ?? this.synced,
        lastSyncedAt:
            lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
        serverVersion:
            serverVersion.present ? serverVersion.value : this.serverVersion,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AlertConfigurationData copyWithCompanion(
      AlertConfigurationsTableCompanion data) {
    return AlertConfigurationData(
      id: data.id.present ? data.id.value : this.id,
      farmId: data.farmId.present ? data.farmId.value : this.farmId,
      evaluationType: data.evaluationType.present
          ? data.evaluationType.value
          : this.evaluationType,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      titleKey: data.titleKey.present ? data.titleKey.value : this.titleKey,
      messageKey:
          data.messageKey.present ? data.messageKey.value : this.messageKey,
      severity: data.severity.present ? data.severity.value : this.severity,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
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
    return (StringBuffer('AlertConfigurationData(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('evaluationType: $evaluationType, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('titleKey: $titleKey, ')
          ..write('messageKey: $messageKey, ')
          ..write('severity: $severity, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('enabled: $enabled, ')
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
      evaluationType,
      type,
      category,
      titleKey,
      messageKey,
      severity,
      iconName,
      colorHex,
      enabled,
      synced,
      lastSyncedAt,
      serverVersion,
      deletedAt,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertConfigurationData &&
          other.id == this.id &&
          other.farmId == this.farmId &&
          other.evaluationType == this.evaluationType &&
          other.type == this.type &&
          other.category == this.category &&
          other.titleKey == this.titleKey &&
          other.messageKey == this.messageKey &&
          other.severity == this.severity &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.enabled == this.enabled &&
          other.synced == this.synced &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.serverVersion == this.serverVersion &&
          other.deletedAt == this.deletedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AlertConfigurationsTableCompanion
    extends UpdateCompanion<AlertConfigurationData> {
  final Value<String> id;
  final Value<String> farmId;
  final Value<String> evaluationType;
  final Value<String> type;
  final Value<String> category;
  final Value<String> titleKey;
  final Value<String> messageKey;
  final Value<int> severity;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<bool> enabled;
  final Value<bool> synced;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> serverVersion;
  final Value<DateTime?> deletedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AlertConfigurationsTableCompanion({
    this.id = const Value.absent(),
    this.farmId = const Value.absent(),
    this.evaluationType = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.titleKey = const Value.absent(),
    this.messageKey = const Value.absent(),
    this.severity = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.enabled = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertConfigurationsTableCompanion.insert({
    required String id,
    required String farmId,
    required String evaluationType,
    required String type,
    required String category,
    required String titleKey,
    required String messageKey,
    required int severity,
    required String iconName,
    required String colorHex,
    this.enabled = const Value.absent(),
    this.synced = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.serverVersion = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        farmId = Value(farmId),
        evaluationType = Value(evaluationType),
        type = Value(type),
        category = Value(category),
        titleKey = Value(titleKey),
        messageKey = Value(messageKey),
        severity = Value(severity),
        iconName = Value(iconName),
        colorHex = Value(colorHex),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<AlertConfigurationData> custom({
    Expression<String>? id,
    Expression<String>? farmId,
    Expression<String>? evaluationType,
    Expression<String>? type,
    Expression<String>? category,
    Expression<String>? titleKey,
    Expression<String>? messageKey,
    Expression<int>? severity,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<bool>? enabled,
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
      if (evaluationType != null) 'evaluation_type': evaluationType,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (titleKey != null) 'title_key': titleKey,
      if (messageKey != null) 'message_key': messageKey,
      if (severity != null) 'severity': severity,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (enabled != null) 'enabled': enabled,
      if (synced != null) 'synced': synced,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (serverVersion != null) 'server_version': serverVersion,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertConfigurationsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? farmId,
      Value<String>? evaluationType,
      Value<String>? type,
      Value<String>? category,
      Value<String>? titleKey,
      Value<String>? messageKey,
      Value<int>? severity,
      Value<String>? iconName,
      Value<String>? colorHex,
      Value<bool>? enabled,
      Value<bool>? synced,
      Value<DateTime?>? lastSyncedAt,
      Value<String?>? serverVersion,
      Value<DateTime?>? deletedAt,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return AlertConfigurationsTableCompanion(
      id: id ?? this.id,
      farmId: farmId ?? this.farmId,
      evaluationType: evaluationType ?? this.evaluationType,
      type: type ?? this.type,
      category: category ?? this.category,
      titleKey: titleKey ?? this.titleKey,
      messageKey: messageKey ?? this.messageKey,
      severity: severity ?? this.severity,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      enabled: enabled ?? this.enabled,
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
    if (evaluationType.present) {
      map['evaluation_type'] = Variable<String>(evaluationType.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (titleKey.present) {
      map['title_key'] = Variable<String>(titleKey.value);
    }
    if (messageKey.present) {
      map['message_key'] = Variable<String>(messageKey.value);
    }
    if (severity.present) {
      map['severity'] = Variable<int>(severity.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
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
    return (StringBuffer('AlertConfigurationsTableCompanion(')
          ..write('id: $id, ')
          ..write('farmId: $farmId, ')
          ..write('evaluationType: $evaluationType, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('titleKey: $titleKey, ')
          ..write('messageKey: $messageKey, ')
          ..write('severity: $severity, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('enabled: $enabled, ')
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
  late final $BreedingsTableTable breedingsTable = $BreedingsTableTable(this);
  late final $DocumentsTableTable documentsTable = $DocumentsTableTable(this);
  late final $TreatmentsTableTable treatmentsTable =
      $TreatmentsTableTable(this);
  late final $VaccinationsTableTable vaccinationsTable =
      $VaccinationsTableTable(this);
  late final $WeightsTableTable weightsTable = $WeightsTableTable(this);
  late final $MovementsTableTable movementsTable = $MovementsTableTable(this);
  late final $SpeciesTableTable speciesTable = $SpeciesTableTable(this);
  late final $BreedsTableTable breedsTable = $BreedsTableTable(this);
  late final $MedicalProductsTableTable medicalProductsTable =
      $MedicalProductsTableTable(this);
  late final $VaccinesTableTable vaccinesTable = $VaccinesTableTable(this);
  late final $VeterinariansTableTable veterinariansTable =
      $VeterinariansTableTable(this);
  late final $BatchesTableTable batchesTable = $BatchesTableTable(this);
  late final $LotsTableTable lotsTable = $LotsTableTable(this);
  late final $CampaignsTableTable campaignsTable = $CampaignsTableTable(this);
  late final $AlertConfigurationsTableTable alertConfigurationsTable =
      $AlertConfigurationsTableTable(this);
  late final FarmDao farmDao = FarmDao(this as AppDatabase);
  late final AnimalDao animalDao = AnimalDao(this as AppDatabase);
  late final BreedingDao breedingDao = BreedingDao(this as AppDatabase);
  late final DocumentDao documentDao = DocumentDao(this as AppDatabase);
  late final TreatmentDao treatmentDao = TreatmentDao(this as AppDatabase);
  late final VaccinationDao vaccinationDao =
      VaccinationDao(this as AppDatabase);
  late final WeightDao weightDao = WeightDao(this as AppDatabase);
  late final MovementDao movementDao = MovementDao(this as AppDatabase);
  late final SpeciesDao speciesDao = SpeciesDao(this as AppDatabase);
  late final BreedDao breedDao = BreedDao(this as AppDatabase);
  late final MedicalProductDao medicalProductDao =
      MedicalProductDao(this as AppDatabase);
  late final VaccineDao vaccineDao = VaccineDao(this as AppDatabase);
  late final VeterinarianDao veterinarianDao =
      VeterinarianDao(this as AppDatabase);
  late final BatchDao batchDao = BatchDao(this as AppDatabase);
  late final LotDao lotDao = LotDao(this as AppDatabase);
  late final CampaignDao campaignDao = CampaignDao(this as AppDatabase);
  late final AlertConfigurationDao alertConfigurationDao =
      AlertConfigurationDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        farmsTable,
        animalsTable,
        breedingsTable,
        documentsTable,
        treatmentsTable,
        vaccinationsTable,
        weightsTable,
        movementsTable,
        speciesTable,
        breedsTable,
        medicalProductsTable,
        vaccinesTable,
        veterinariansTable,
        batchesTable,
        lotsTable,
        campaignsTable,
        alertConfigurationsTable
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
  Value<bool> isDefault,
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
  Value<bool> isDefault,
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

  ColumnFilters<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<bool> get isDefault => $composableBuilder(
      column: $table.isDefault, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

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
            Value<bool> isDefault = const Value.absent(),
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
            isDefault: isDefault,
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
            Value<bool> isDefault = const Value.absent(),
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
            isDefault: isDefault,
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
  Value<DateTime?> validatedAt,
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
  Value<DateTime?> validatedAt,
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

  ColumnFilters<DateTime> get validatedAt => $composableBuilder(
      column: $table.validatedAt, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<DateTime> get validatedAt => $composableBuilder(
      column: $table.validatedAt, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<DateTime> get validatedAt => $composableBuilder(
      column: $table.validatedAt, builder: (column) => column);

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
            Value<DateTime?> validatedAt = const Value.absent(),
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
            validatedAt: validatedAt,
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
            Value<DateTime?> validatedAt = const Value.absent(),
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
            validatedAt: validatedAt,
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
typedef $$BreedingsTableTableCreateCompanionBuilder = BreedingsTableCompanion
    Function({
  required String id,
  required String farmId,
  required String motherId,
  Value<String?> fatherId,
  Value<String?> fatherName,
  required String method,
  required DateTime breedingDate,
  required DateTime expectedBirthDate,
  Value<DateTime?> actualBirthDate,
  Value<int?> expectedOffspringCount,
  Value<String?> offspringIds,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<String?> notes,
  required String status,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$BreedingsTableTableUpdateCompanionBuilder = BreedingsTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> motherId,
  Value<String?> fatherId,
  Value<String?> fatherName,
  Value<String> method,
  Value<DateTime> breedingDate,
  Value<DateTime> expectedBirthDate,
  Value<DateTime?> actualBirthDate,
  Value<int?> expectedOffspringCount,
  Value<String?> offspringIds,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<String?> notes,
  Value<String> status,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$BreedingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BreedingsTableTable> {
  $$BreedingsTableTableFilterComposer({
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

  ColumnFilters<String> get motherId => $composableBuilder(
      column: $table.motherId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherId => $composableBuilder(
      column: $table.fatherId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get breedingDate => $composableBuilder(
      column: $table.breedingDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expectedBirthDate => $composableBuilder(
      column: $table.expectedBirthDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get actualBirthDate => $composableBuilder(
      column: $table.actualBirthDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedOffspringCount => $composableBuilder(
      column: $table.expectedOffspringCount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get offspringIds => $composableBuilder(
      column: $table.offspringIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

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

class $$BreedingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BreedingsTableTable> {
  $$BreedingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get motherId => $composableBuilder(
      column: $table.motherId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherId => $composableBuilder(
      column: $table.fatherId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get method => $composableBuilder(
      column: $table.method, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get breedingDate => $composableBuilder(
      column: $table.breedingDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expectedBirthDate => $composableBuilder(
      column: $table.expectedBirthDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get actualBirthDate => $composableBuilder(
      column: $table.actualBirthDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedOffspringCount => $composableBuilder(
      column: $table.expectedOffspringCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get offspringIds => $composableBuilder(
      column: $table.offspringIds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

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

class $$BreedingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BreedingsTableTable> {
  $$BreedingsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get motherId =>
      $composableBuilder(column: $table.motherId, builder: (column) => column);

  GeneratedColumn<String> get fatherId =>
      $composableBuilder(column: $table.fatherId, builder: (column) => column);

  GeneratedColumn<String> get fatherName => $composableBuilder(
      column: $table.fatherName, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<DateTime> get breedingDate => $composableBuilder(
      column: $table.breedingDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expectedBirthDate => $composableBuilder(
      column: $table.expectedBirthDate, builder: (column) => column);

  GeneratedColumn<DateTime> get actualBirthDate => $composableBuilder(
      column: $table.actualBirthDate, builder: (column) => column);

  GeneratedColumn<int> get expectedOffspringCount => $composableBuilder(
      column: $table.expectedOffspringCount, builder: (column) => column);

  GeneratedColumn<String> get offspringIds => $composableBuilder(
      column: $table.offspringIds, builder: (column) => column);

  GeneratedColumn<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId, builder: (column) => column);

  GeneratedColumn<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

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

class $$BreedingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BreedingsTableTable,
    BreedingsTableData,
    $$BreedingsTableTableFilterComposer,
    $$BreedingsTableTableOrderingComposer,
    $$BreedingsTableTableAnnotationComposer,
    $$BreedingsTableTableCreateCompanionBuilder,
    $$BreedingsTableTableUpdateCompanionBuilder,
    (
      BreedingsTableData,
      BaseReferences<_$AppDatabase, $BreedingsTableTable, BreedingsTableData>
    ),
    BreedingsTableData,
    PrefetchHooks Function()> {
  $$BreedingsTableTableTableManager(
      _$AppDatabase db, $BreedingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BreedingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BreedingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BreedingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> motherId = const Value.absent(),
            Value<String?> fatherId = const Value.absent(),
            Value<String?> fatherName = const Value.absent(),
            Value<String> method = const Value.absent(),
            Value<DateTime> breedingDate = const Value.absent(),
            Value<DateTime> expectedBirthDate = const Value.absent(),
            Value<DateTime?> actualBirthDate = const Value.absent(),
            Value<int?> expectedOffspringCount = const Value.absent(),
            Value<String?> offspringIds = const Value.absent(),
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BreedingsTableCompanion(
            id: id,
            farmId: farmId,
            motherId: motherId,
            fatherId: fatherId,
            fatherName: fatherName,
            method: method,
            breedingDate: breedingDate,
            expectedBirthDate: expectedBirthDate,
            actualBirthDate: actualBirthDate,
            expectedOffspringCount: expectedOffspringCount,
            offspringIds: offspringIds,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            notes: notes,
            status: status,
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
            required String motherId,
            Value<String?> fatherId = const Value.absent(),
            Value<String?> fatherName = const Value.absent(),
            required String method,
            required DateTime breedingDate,
            required DateTime expectedBirthDate,
            Value<DateTime?> actualBirthDate = const Value.absent(),
            Value<int?> expectedOffspringCount = const Value.absent(),
            Value<String?> offspringIds = const Value.absent(),
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required String status,
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              BreedingsTableCompanion.insert(
            id: id,
            farmId: farmId,
            motherId: motherId,
            fatherId: fatherId,
            fatherName: fatherName,
            method: method,
            breedingDate: breedingDate,
            expectedBirthDate: expectedBirthDate,
            actualBirthDate: actualBirthDate,
            expectedOffspringCount: expectedOffspringCount,
            offspringIds: offspringIds,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            notes: notes,
            status: status,
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

typedef $$BreedingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BreedingsTableTable,
    BreedingsTableData,
    $$BreedingsTableTableFilterComposer,
    $$BreedingsTableTableOrderingComposer,
    $$BreedingsTableTableAnnotationComposer,
    $$BreedingsTableTableCreateCompanionBuilder,
    $$BreedingsTableTableUpdateCompanionBuilder,
    (
      BreedingsTableData,
      BaseReferences<_$AppDatabase, $BreedingsTableTable, BreedingsTableData>
    ),
    BreedingsTableData,
    PrefetchHooks Function()>;
typedef $$DocumentsTableTableCreateCompanionBuilder = DocumentsTableCompanion
    Function({
  required String id,
  required String farmId,
  Value<String?> animalId,
  required String type,
  required String fileName,
  required String fileUrl,
  Value<int?> fileSizeBytes,
  Value<String?> mimeType,
  required DateTime uploadDate,
  Value<DateTime?> expiryDate,
  Value<String?> notes,
  Value<String?> uploadedBy,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$DocumentsTableTableUpdateCompanionBuilder = DocumentsTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String?> animalId,
  Value<String> type,
  Value<String> fileName,
  Value<String> fileUrl,
  Value<int?> fileSizeBytes,
  Value<String?> mimeType,
  Value<DateTime> uploadDate,
  Value<DateTime?> expiryDate,
  Value<String?> notes,
  Value<String?> uploadedBy,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$DocumentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableFilterComposer({
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

  ColumnFilters<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
      column: $table.fileSizeBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnFilters(column));

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

class $$DocumentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableOrderingComposer({
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

  ColumnOrderings<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileUrl => $composableBuilder(
      column: $table.fileUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
      column: $table.fileSizeBytes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mimeType => $composableBuilder(
      column: $table.mimeType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => ColumnOrderings(column));

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

class $$DocumentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTableTable> {
  $$DocumentsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileUrl =>
      $composableBuilder(column: $table.fileUrl, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
      column: $table.fileSizeBytes, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadDate => $composableBuilder(
      column: $table.uploadDate, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get uploadedBy => $composableBuilder(
      column: $table.uploadedBy, builder: (column) => column);

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

class $$DocumentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTableTable,
    DocumentsTableData,
    $$DocumentsTableTableFilterComposer,
    $$DocumentsTableTableOrderingComposer,
    $$DocumentsTableTableAnnotationComposer,
    $$DocumentsTableTableCreateCompanionBuilder,
    $$DocumentsTableTableUpdateCompanionBuilder,
    (
      DocumentsTableData,
      BaseReferences<_$AppDatabase, $DocumentsTableTable, DocumentsTableData>
    ),
    DocumentsTableData,
    PrefetchHooks Function()> {
  $$DocumentsTableTableTableManager(
      _$AppDatabase db, $DocumentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String?> animalId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> fileUrl = const Value.absent(),
            Value<int?> fileSizeBytes = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            Value<DateTime> uploadDate = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> uploadedBy = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsTableCompanion(
            id: id,
            farmId: farmId,
            animalId: animalId,
            type: type,
            fileName: fileName,
            fileUrl: fileUrl,
            fileSizeBytes: fileSizeBytes,
            mimeType: mimeType,
            uploadDate: uploadDate,
            expiryDate: expiryDate,
            notes: notes,
            uploadedBy: uploadedBy,
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
            Value<String?> animalId = const Value.absent(),
            required String type,
            required String fileName,
            required String fileUrl,
            Value<int?> fileSizeBytes = const Value.absent(),
            Value<String?> mimeType = const Value.absent(),
            required DateTime uploadDate,
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> uploadedBy = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              DocumentsTableCompanion.insert(
            id: id,
            farmId: farmId,
            animalId: animalId,
            type: type,
            fileName: fileName,
            fileUrl: fileUrl,
            fileSizeBytes: fileSizeBytes,
            mimeType: mimeType,
            uploadDate: uploadDate,
            expiryDate: expiryDate,
            notes: notes,
            uploadedBy: uploadedBy,
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

typedef $$DocumentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTableTable,
    DocumentsTableData,
    $$DocumentsTableTableFilterComposer,
    $$DocumentsTableTableOrderingComposer,
    $$DocumentsTableTableAnnotationComposer,
    $$DocumentsTableTableCreateCompanionBuilder,
    $$DocumentsTableTableUpdateCompanionBuilder,
    (
      DocumentsTableData,
      BaseReferences<_$AppDatabase, $DocumentsTableTable, DocumentsTableData>
    ),
    DocumentsTableData,
    PrefetchHooks Function()>;
typedef $$TreatmentsTableTableCreateCompanionBuilder = TreatmentsTableCompanion
    Function({
  required String id,
  required String farmId,
  required String animalId,
  required String productId,
  required String productName,
  required double dose,
  required DateTime treatmentDate,
  required DateTime withdrawalEndDate,
  Value<String?> notes,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<String?> campaignId,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$TreatmentsTableTableUpdateCompanionBuilder = TreatmentsTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> animalId,
  Value<String> productId,
  Value<String> productName,
  Value<double> dose,
  Value<DateTime> treatmentDate,
  Value<DateTime> withdrawalEndDate,
  Value<String?> notes,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<String?> campaignId,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$TreatmentsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TreatmentsTableTable> {
  $$TreatmentsTableTableFilterComposer({
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

  ColumnFilters<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get treatmentDate => $composableBuilder(
      column: $table.treatmentDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get campaignId => $composableBuilder(
      column: $table.campaignId, builder: (column) => ColumnFilters(column));

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

class $$TreatmentsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TreatmentsTableTable> {
  $$TreatmentsTableTableOrderingComposer({
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

  ColumnOrderings<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get treatmentDate => $composableBuilder(
      column: $table.treatmentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get campaignId => $composableBuilder(
      column: $table.campaignId, builder: (column) => ColumnOrderings(column));

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

class $$TreatmentsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TreatmentsTableTable> {
  $$TreatmentsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<double> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<DateTime> get treatmentDate => $composableBuilder(
      column: $table.treatmentDate, builder: (column) => column);

  GeneratedColumn<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId, builder: (column) => column);

  GeneratedColumn<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName, builder: (column) => column);

  GeneratedColumn<String> get campaignId => $composableBuilder(
      column: $table.campaignId, builder: (column) => column);

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

class $$TreatmentsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TreatmentsTableTable,
    TreatmentsTableData,
    $$TreatmentsTableTableFilterComposer,
    $$TreatmentsTableTableOrderingComposer,
    $$TreatmentsTableTableAnnotationComposer,
    $$TreatmentsTableTableCreateCompanionBuilder,
    $$TreatmentsTableTableUpdateCompanionBuilder,
    (
      TreatmentsTableData,
      BaseReferences<_$AppDatabase, $TreatmentsTableTable, TreatmentsTableData>
    ),
    TreatmentsTableData,
    PrefetchHooks Function()> {
  $$TreatmentsTableTableTableManager(
      _$AppDatabase db, $TreatmentsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TreatmentsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TreatmentsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TreatmentsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> animalId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<double> dose = const Value.absent(),
            Value<DateTime> treatmentDate = const Value.absent(),
            Value<DateTime> withdrawalEndDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<String?> campaignId = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TreatmentsTableCompanion(
            id: id,
            farmId: farmId,
            animalId: animalId,
            productId: productId,
            productName: productName,
            dose: dose,
            treatmentDate: treatmentDate,
            withdrawalEndDate: withdrawalEndDate,
            notes: notes,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            campaignId: campaignId,
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
            required String animalId,
            required String productId,
            required String productName,
            required double dose,
            required DateTime treatmentDate,
            required DateTime withdrawalEndDate,
            Value<String?> notes = const Value.absent(),
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<String?> campaignId = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TreatmentsTableCompanion.insert(
            id: id,
            farmId: farmId,
            animalId: animalId,
            productId: productId,
            productName: productName,
            dose: dose,
            treatmentDate: treatmentDate,
            withdrawalEndDate: withdrawalEndDate,
            notes: notes,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            campaignId: campaignId,
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

typedef $$TreatmentsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TreatmentsTableTable,
    TreatmentsTableData,
    $$TreatmentsTableTableFilterComposer,
    $$TreatmentsTableTableOrderingComposer,
    $$TreatmentsTableTableAnnotationComposer,
    $$TreatmentsTableTableCreateCompanionBuilder,
    $$TreatmentsTableTableUpdateCompanionBuilder,
    (
      TreatmentsTableData,
      BaseReferences<_$AppDatabase, $TreatmentsTableTable, TreatmentsTableData>
    ),
    TreatmentsTableData,
    PrefetchHooks Function()>;
typedef $$VaccinationsTableTableCreateCompanionBuilder
    = VaccinationsTableCompanion Function({
  required String id,
  required String farmId,
  Value<String?> animalId,
  required String animalIds,
  Value<String?> protocolId,
  required String vaccineName,
  required String type,
  required String disease,
  required DateTime vaccinationDate,
  Value<String?> batchNumber,
  Value<DateTime?> expiryDate,
  required String dose,
  required String administrationRoute,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<DateTime?> nextDueDate,
  required int withdrawalPeriodDays,
  Value<String?> notes,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$VaccinationsTableTableUpdateCompanionBuilder
    = VaccinationsTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String?> animalId,
  Value<String> animalIds,
  Value<String?> protocolId,
  Value<String> vaccineName,
  Value<String> type,
  Value<String> disease,
  Value<DateTime> vaccinationDate,
  Value<String?> batchNumber,
  Value<DateTime?> expiryDate,
  Value<String> dose,
  Value<String> administrationRoute,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<DateTime?> nextDueDate,
  Value<int> withdrawalPeriodDays,
  Value<String?> notes,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$VaccinationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $VaccinationsTableTable> {
  $$VaccinationsTableTableFilterComposer({
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

  ColumnFilters<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get animalIds => $composableBuilder(
      column: $table.animalIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get protocolId => $composableBuilder(
      column: $table.protocolId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vaccineName => $composableBuilder(
      column: $table.vaccineName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get disease => $composableBuilder(
      column: $table.disease, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get vaccinationDate => $composableBuilder(
      column: $table.vaccinationDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get administrationRoute => $composableBuilder(
      column: $table.administrationRoute,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get withdrawalPeriodDays => $composableBuilder(
      column: $table.withdrawalPeriodDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

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

class $$VaccinationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $VaccinationsTableTable> {
  $$VaccinationsTableTableOrderingComposer({
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

  ColumnOrderings<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get animalIds => $composableBuilder(
      column: $table.animalIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get protocolId => $composableBuilder(
      column: $table.protocolId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vaccineName => $composableBuilder(
      column: $table.vaccineName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get disease => $composableBuilder(
      column: $table.disease, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get vaccinationDate => $composableBuilder(
      column: $table.vaccinationDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get dose => $composableBuilder(
      column: $table.dose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get administrationRoute => $composableBuilder(
      column: $table.administrationRoute,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get withdrawalPeriodDays => $composableBuilder(
      column: $table.withdrawalPeriodDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

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

class $$VaccinationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $VaccinationsTableTable> {
  $$VaccinationsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get animalIds =>
      $composableBuilder(column: $table.animalIds, builder: (column) => column);

  GeneratedColumn<String> get protocolId => $composableBuilder(
      column: $table.protocolId, builder: (column) => column);

  GeneratedColumn<String> get vaccineName => $composableBuilder(
      column: $table.vaccineName, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get disease =>
      $composableBuilder(column: $table.disease, builder: (column) => column);

  GeneratedColumn<DateTime> get vaccinationDate => $composableBuilder(
      column: $table.vaccinationDate, builder: (column) => column);

  GeneratedColumn<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
      column: $table.expiryDate, builder: (column) => column);

  GeneratedColumn<String> get dose =>
      $composableBuilder(column: $table.dose, builder: (column) => column);

  GeneratedColumn<String> get administrationRoute => $composableBuilder(
      column: $table.administrationRoute, builder: (column) => column);

  GeneratedColumn<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId, builder: (column) => column);

  GeneratedColumn<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName, builder: (column) => column);

  GeneratedColumn<DateTime> get nextDueDate => $composableBuilder(
      column: $table.nextDueDate, builder: (column) => column);

  GeneratedColumn<int> get withdrawalPeriodDays => $composableBuilder(
      column: $table.withdrawalPeriodDays, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

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

class $$VaccinationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $VaccinationsTableTable,
    VaccinationsTableData,
    $$VaccinationsTableTableFilterComposer,
    $$VaccinationsTableTableOrderingComposer,
    $$VaccinationsTableTableAnnotationComposer,
    $$VaccinationsTableTableCreateCompanionBuilder,
    $$VaccinationsTableTableUpdateCompanionBuilder,
    (
      VaccinationsTableData,
      BaseReferences<_$AppDatabase, $VaccinationsTableTable,
          VaccinationsTableData>
    ),
    VaccinationsTableData,
    PrefetchHooks Function()> {
  $$VaccinationsTableTableTableManager(
      _$AppDatabase db, $VaccinationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VaccinationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VaccinationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VaccinationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String?> animalId = const Value.absent(),
            Value<String> animalIds = const Value.absent(),
            Value<String?> protocolId = const Value.absent(),
            Value<String> vaccineName = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> disease = const Value.absent(),
            Value<DateTime> vaccinationDate = const Value.absent(),
            Value<String?> batchNumber = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            Value<String> dose = const Value.absent(),
            Value<String> administrationRoute = const Value.absent(),
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<DateTime?> nextDueDate = const Value.absent(),
            Value<int> withdrawalPeriodDays = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              VaccinationsTableCompanion(
            id: id,
            farmId: farmId,
            animalId: animalId,
            animalIds: animalIds,
            protocolId: protocolId,
            vaccineName: vaccineName,
            type: type,
            disease: disease,
            vaccinationDate: vaccinationDate,
            batchNumber: batchNumber,
            expiryDate: expiryDate,
            dose: dose,
            administrationRoute: administrationRoute,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            nextDueDate: nextDueDate,
            withdrawalPeriodDays: withdrawalPeriodDays,
            notes: notes,
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
            Value<String?> animalId = const Value.absent(),
            required String animalIds,
            Value<String?> protocolId = const Value.absent(),
            required String vaccineName,
            required String type,
            required String disease,
            required DateTime vaccinationDate,
            Value<String?> batchNumber = const Value.absent(),
            Value<DateTime?> expiryDate = const Value.absent(),
            required String dose,
            required String administrationRoute,
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<DateTime?> nextDueDate = const Value.absent(),
            required int withdrawalPeriodDays,
            Value<String?> notes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              VaccinationsTableCompanion.insert(
            id: id,
            farmId: farmId,
            animalId: animalId,
            animalIds: animalIds,
            protocolId: protocolId,
            vaccineName: vaccineName,
            type: type,
            disease: disease,
            vaccinationDate: vaccinationDate,
            batchNumber: batchNumber,
            expiryDate: expiryDate,
            dose: dose,
            administrationRoute: administrationRoute,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            nextDueDate: nextDueDate,
            withdrawalPeriodDays: withdrawalPeriodDays,
            notes: notes,
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

typedef $$VaccinationsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $VaccinationsTableTable,
    VaccinationsTableData,
    $$VaccinationsTableTableFilterComposer,
    $$VaccinationsTableTableOrderingComposer,
    $$VaccinationsTableTableAnnotationComposer,
    $$VaccinationsTableTableCreateCompanionBuilder,
    $$VaccinationsTableTableUpdateCompanionBuilder,
    (
      VaccinationsTableData,
      BaseReferences<_$AppDatabase, $VaccinationsTableTable,
          VaccinationsTableData>
    ),
    VaccinationsTableData,
    PrefetchHooks Function()>;
typedef $$WeightsTableTableCreateCompanionBuilder = WeightsTableCompanion
    Function({
  required String id,
  required String farmId,
  required String animalId,
  required double weight,
  required DateTime recordedAt,
  required String source,
  Value<String?> notes,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$WeightsTableTableUpdateCompanionBuilder = WeightsTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> animalId,
  Value<double> weight,
  Value<DateTime> recordedAt,
  Value<String> source,
  Value<String?> notes,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$WeightsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WeightsTableTable> {
  $$WeightsTableTableFilterComposer({
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

  ColumnFilters<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

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

class $$WeightsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightsTableTable> {
  $$WeightsTableTableOrderingComposer({
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

  ColumnOrderings<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weight => $composableBuilder(
      column: $table.weight, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

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

class $$WeightsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightsTableTable> {
  $$WeightsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
      column: $table.recordedAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

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

class $$WeightsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $WeightsTableTable,
    WeightsTableData,
    $$WeightsTableTableFilterComposer,
    $$WeightsTableTableOrderingComposer,
    $$WeightsTableTableAnnotationComposer,
    $$WeightsTableTableCreateCompanionBuilder,
    $$WeightsTableTableUpdateCompanionBuilder,
    (
      WeightsTableData,
      BaseReferences<_$AppDatabase, $WeightsTableTable, WeightsTableData>
    ),
    WeightsTableData,
    PrefetchHooks Function()> {
  $$WeightsTableTableTableManager(_$AppDatabase db, $WeightsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> animalId = const Value.absent(),
            Value<double> weight = const Value.absent(),
            Value<DateTime> recordedAt = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WeightsTableCompanion(
            id: id,
            farmId: farmId,
            animalId: animalId,
            weight: weight,
            recordedAt: recordedAt,
            source: source,
            notes: notes,
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
            required String animalId,
            required double weight,
            required DateTime recordedAt,
            required String source,
            Value<String?> notes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              WeightsTableCompanion.insert(
            id: id,
            farmId: farmId,
            animalId: animalId,
            weight: weight,
            recordedAt: recordedAt,
            source: source,
            notes: notes,
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

typedef $$WeightsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $WeightsTableTable,
    WeightsTableData,
    $$WeightsTableTableFilterComposer,
    $$WeightsTableTableOrderingComposer,
    $$WeightsTableTableAnnotationComposer,
    $$WeightsTableTableCreateCompanionBuilder,
    $$WeightsTableTableUpdateCompanionBuilder,
    (
      WeightsTableData,
      BaseReferences<_$AppDatabase, $WeightsTableTable, WeightsTableData>
    ),
    WeightsTableData,
    PrefetchHooks Function()>;
typedef $$MovementsTableTableCreateCompanionBuilder = MovementsTableCompanion
    Function({
  required String id,
  required String farmId,
  required String animalId,
  required String type,
  required DateTime movementDate,
  Value<String?> fromFarmId,
  Value<String?> toFarmId,
  Value<double?> price,
  Value<String?> notes,
  Value<String?> buyerQrSignature,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$MovementsTableTableUpdateCompanionBuilder = MovementsTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> animalId,
  Value<String> type,
  Value<DateTime> movementDate,
  Value<String?> fromFarmId,
  Value<String?> toFarmId,
  Value<double?> price,
  Value<String?> notes,
  Value<String?> buyerQrSignature,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<int?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$MovementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $MovementsTableTable> {
  $$MovementsTableTableFilterComposer({
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

  ColumnFilters<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get movementDate => $composableBuilder(
      column: $table.movementDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromFarmId => $composableBuilder(
      column: $table.fromFarmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toFarmId => $composableBuilder(
      column: $table.toFarmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buyerQrSignature => $composableBuilder(
      column: $table.buyerQrSignature,
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

class $$MovementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MovementsTableTable> {
  $$MovementsTableTableOrderingComposer({
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

  ColumnOrderings<String> get animalId => $composableBuilder(
      column: $table.animalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get movementDate => $composableBuilder(
      column: $table.movementDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromFarmId => $composableBuilder(
      column: $table.fromFarmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toFarmId => $composableBuilder(
      column: $table.toFarmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buyerQrSignature => $composableBuilder(
      column: $table.buyerQrSignature,
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

class $$MovementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MovementsTableTable> {
  $$MovementsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get animalId =>
      $composableBuilder(column: $table.animalId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get movementDate => $composableBuilder(
      column: $table.movementDate, builder: (column) => column);

  GeneratedColumn<String> get fromFarmId => $composableBuilder(
      column: $table.fromFarmId, builder: (column) => column);

  GeneratedColumn<String> get toFarmId =>
      $composableBuilder(column: $table.toFarmId, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get buyerQrSignature => $composableBuilder(
      column: $table.buyerQrSignature, builder: (column) => column);

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

class $$MovementsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MovementsTableTable,
    MovementsTableData,
    $$MovementsTableTableFilterComposer,
    $$MovementsTableTableOrderingComposer,
    $$MovementsTableTableAnnotationComposer,
    $$MovementsTableTableCreateCompanionBuilder,
    $$MovementsTableTableUpdateCompanionBuilder,
    (
      MovementsTableData,
      BaseReferences<_$AppDatabase, $MovementsTableTable, MovementsTableData>
    ),
    MovementsTableData,
    PrefetchHooks Function()> {
  $$MovementsTableTableTableManager(
      _$AppDatabase db, $MovementsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MovementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MovementsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MovementsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> animalId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> movementDate = const Value.absent(),
            Value<String?> fromFarmId = const Value.absent(),
            Value<String?> toFarmId = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> buyerQrSignature = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MovementsTableCompanion(
            id: id,
            farmId: farmId,
            animalId: animalId,
            type: type,
            movementDate: movementDate,
            fromFarmId: fromFarmId,
            toFarmId: toFarmId,
            price: price,
            notes: notes,
            buyerQrSignature: buyerQrSignature,
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
            required String animalId,
            required String type,
            required DateTime movementDate,
            Value<String?> fromFarmId = const Value.absent(),
            Value<String?> toFarmId = const Value.absent(),
            Value<double?> price = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<String?> buyerQrSignature = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<int?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              MovementsTableCompanion.insert(
            id: id,
            farmId: farmId,
            animalId: animalId,
            type: type,
            movementDate: movementDate,
            fromFarmId: fromFarmId,
            toFarmId: toFarmId,
            price: price,
            notes: notes,
            buyerQrSignature: buyerQrSignature,
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

typedef $$MovementsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MovementsTableTable,
    MovementsTableData,
    $$MovementsTableTableFilterComposer,
    $$MovementsTableTableOrderingComposer,
    $$MovementsTableTableAnnotationComposer,
    $$MovementsTableTableCreateCompanionBuilder,
    $$MovementsTableTableUpdateCompanionBuilder,
    (
      MovementsTableData,
      BaseReferences<_$AppDatabase, $MovementsTableTable, MovementsTableData>
    ),
    MovementsTableData,
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
typedef $$BatchesTableTableCreateCompanionBuilder = BatchesTableCompanion
    Function({
  required String id,
  required String farmId,
  required String name,
  required String purpose,
  required String animalIdsJson,
  Value<DateTime?> usedAt,
  Value<bool> completed,
  Value<String?> notes,
  Value<bool> synced,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$BatchesTableTableUpdateCompanionBuilder = BatchesTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String> purpose,
  Value<String> animalIdsJson,
  Value<DateTime?> usedAt,
  Value<bool> completed,
  Value<String?> notes,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$BatchesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BatchesTableTable> {
  $$BatchesTableTableFilterComposer({
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

  ColumnFilters<String> get purpose => $composableBuilder(
      column: $table.purpose, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get usedAt => $composableBuilder(
      column: $table.usedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$BatchesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BatchesTableTable> {
  $$BatchesTableTableOrderingComposer({
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

  ColumnOrderings<String> get purpose => $composableBuilder(
      column: $table.purpose, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get usedAt => $composableBuilder(
      column: $table.usedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$BatchesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatchesTableTable> {
  $$BatchesTableTableAnnotationComposer({
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

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson, builder: (column) => column);

  GeneratedColumn<DateTime> get usedAt =>
      $composableBuilder(column: $table.usedAt, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$BatchesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BatchesTableTable,
    BatchesTableData,
    $$BatchesTableTableFilterComposer,
    $$BatchesTableTableOrderingComposer,
    $$BatchesTableTableAnnotationComposer,
    $$BatchesTableTableCreateCompanionBuilder,
    $$BatchesTableTableUpdateCompanionBuilder,
    (
      BatchesTableData,
      BaseReferences<_$AppDatabase, $BatchesTableTable, BatchesTableData>
    ),
    BatchesTableData,
    PrefetchHooks Function()> {
  $$BatchesTableTableTableManager(_$AppDatabase db, $BatchesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatchesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatchesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatchesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> purpose = const Value.absent(),
            Value<String> animalIdsJson = const Value.absent(),
            Value<DateTime?> usedAt = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BatchesTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            purpose: purpose,
            animalIdsJson: animalIdsJson,
            usedAt: usedAt,
            completed: completed,
            notes: notes,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            required String purpose,
            required String animalIdsJson,
            Value<DateTime?> usedAt = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BatchesTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            purpose: purpose,
            animalIdsJson: animalIdsJson,
            usedAt: usedAt,
            completed: completed,
            notes: notes,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BatchesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BatchesTableTable,
    BatchesTableData,
    $$BatchesTableTableFilterComposer,
    $$BatchesTableTableOrderingComposer,
    $$BatchesTableTableAnnotationComposer,
    $$BatchesTableTableCreateCompanionBuilder,
    $$BatchesTableTableUpdateCompanionBuilder,
    (
      BatchesTableData,
      BaseReferences<_$AppDatabase, $BatchesTableTable, BatchesTableData>
    ),
    BatchesTableData,
    PrefetchHooks Function()>;
typedef $$LotsTableTableCreateCompanionBuilder = LotsTableCompanion Function({
  required String id,
  required String farmId,
  required String name,
  Value<String?> type,
  required String animalIdsJson,
  Value<String?> status,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<String?> productId,
  Value<String?> productName,
  Value<DateTime?> treatmentDate,
  Value<DateTime?> withdrawalEndDate,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<String?> buyerName,
  Value<String?> buyerFarmId,
  Value<double?> totalPrice,
  Value<double?> pricePerAnimal,
  Value<DateTime?> saleDate,
  Value<String?> slaughterhouseName,
  Value<String?> slaughterhouseId,
  Value<DateTime?> slaughterDate,
  Value<String?> notes,
  Value<bool> synced,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<int> rowid,
});
typedef $$LotsTableTableUpdateCompanionBuilder = LotsTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String?> type,
  Value<String> animalIdsJson,
  Value<String?> status,
  Value<bool> completed,
  Value<DateTime?> completedAt,
  Value<String?> productId,
  Value<String?> productName,
  Value<DateTime?> treatmentDate,
  Value<DateTime?> withdrawalEndDate,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<String?> buyerName,
  Value<String?> buyerFarmId,
  Value<double?> totalPrice,
  Value<double?> pricePerAnimal,
  Value<DateTime?> saleDate,
  Value<String?> slaughterhouseName,
  Value<String?> slaughterhouseId,
  Value<DateTime?> slaughterDate,
  Value<String?> notes,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<int> rowid,
});

class $$LotsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LotsTableTable> {
  $$LotsTableTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get treatmentDate => $composableBuilder(
      column: $table.treatmentDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buyerName => $composableBuilder(
      column: $table.buyerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get buyerFarmId => $composableBuilder(
      column: $table.buyerFarmId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get pricePerAnimal => $composableBuilder(
      column: $table.pricePerAnimal,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get saleDate => $composableBuilder(
      column: $table.saleDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slaughterhouseName => $composableBuilder(
      column: $table.slaughterhouseName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get slaughterhouseId => $composableBuilder(
      column: $table.slaughterhouseId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get slaughterDate => $composableBuilder(
      column: $table.slaughterDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));
}

class $$LotsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LotsTableTable> {
  $$LotsTableTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get treatmentDate => $composableBuilder(
      column: $table.treatmentDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buyerName => $composableBuilder(
      column: $table.buyerName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get buyerFarmId => $composableBuilder(
      column: $table.buyerFarmId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get pricePerAnimal => $composableBuilder(
      column: $table.pricePerAnimal,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get saleDate => $composableBuilder(
      column: $table.saleDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slaughterhouseName => $composableBuilder(
      column: $table.slaughterhouseName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get slaughterhouseId => $composableBuilder(
      column: $table.slaughterhouseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get slaughterDate => $composableBuilder(
      column: $table.slaughterDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));
}

class $$LotsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LotsTableTable> {
  $$LotsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<DateTime> get treatmentDate => $composableBuilder(
      column: $table.treatmentDate, builder: (column) => column);

  GeneratedColumn<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate, builder: (column) => column);

  GeneratedColumn<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId, builder: (column) => column);

  GeneratedColumn<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName, builder: (column) => column);

  GeneratedColumn<String> get buyerName =>
      $composableBuilder(column: $table.buyerName, builder: (column) => column);

  GeneratedColumn<String> get buyerFarmId => $composableBuilder(
      column: $table.buyerFarmId, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => column);

  GeneratedColumn<double> get pricePerAnimal => $composableBuilder(
      column: $table.pricePerAnimal, builder: (column) => column);

  GeneratedColumn<DateTime> get saleDate =>
      $composableBuilder(column: $table.saleDate, builder: (column) => column);

  GeneratedColumn<String> get slaughterhouseName => $composableBuilder(
      column: $table.slaughterhouseName, builder: (column) => column);

  GeneratedColumn<String> get slaughterhouseId => $composableBuilder(
      column: $table.slaughterhouseId, builder: (column) => column);

  GeneratedColumn<DateTime> get slaughterDate => $composableBuilder(
      column: $table.slaughterDate, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);
}

class $$LotsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LotsTableTable,
    LotsTableData,
    $$LotsTableTableFilterComposer,
    $$LotsTableTableOrderingComposer,
    $$LotsTableTableAnnotationComposer,
    $$LotsTableTableCreateCompanionBuilder,
    $$LotsTableTableUpdateCompanionBuilder,
    (
      LotsTableData,
      BaseReferences<_$AppDatabase, $LotsTableTable, LotsTableData>
    ),
    LotsTableData,
    PrefetchHooks Function()> {
  $$LotsTableTableTableManager(_$AppDatabase db, $LotsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LotsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LotsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LotsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> type = const Value.absent(),
            Value<String> animalIdsJson = const Value.absent(),
            Value<String?> status = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String?> productName = const Value.absent(),
            Value<DateTime?> treatmentDate = const Value.absent(),
            Value<DateTime?> withdrawalEndDate = const Value.absent(),
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<String?> buyerName = const Value.absent(),
            Value<String?> buyerFarmId = const Value.absent(),
            Value<double?> totalPrice = const Value.absent(),
            Value<double?> pricePerAnimal = const Value.absent(),
            Value<DateTime?> saleDate = const Value.absent(),
            Value<String?> slaughterhouseName = const Value.absent(),
            Value<String?> slaughterhouseId = const Value.absent(),
            Value<DateTime?> slaughterDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LotsTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            type: type,
            animalIdsJson: animalIdsJson,
            status: status,
            completed: completed,
            completedAt: completedAt,
            productId: productId,
            productName: productName,
            treatmentDate: treatmentDate,
            withdrawalEndDate: withdrawalEndDate,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            buyerName: buyerName,
            buyerFarmId: buyerFarmId,
            totalPrice: totalPrice,
            pricePerAnimal: pricePerAnimal,
            saleDate: saleDate,
            slaughterhouseName: slaughterhouseName,
            slaughterhouseId: slaughterhouseId,
            slaughterDate: slaughterDate,
            notes: notes,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            Value<String?> type = const Value.absent(),
            required String animalIdsJson,
            Value<String?> status = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String?> productId = const Value.absent(),
            Value<String?> productName = const Value.absent(),
            Value<DateTime?> treatmentDate = const Value.absent(),
            Value<DateTime?> withdrawalEndDate = const Value.absent(),
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<String?> buyerName = const Value.absent(),
            Value<String?> buyerFarmId = const Value.absent(),
            Value<double?> totalPrice = const Value.absent(),
            Value<double?> pricePerAnimal = const Value.absent(),
            Value<DateTime?> saleDate = const Value.absent(),
            Value<String?> slaughterhouseName = const Value.absent(),
            Value<String?> slaughterhouseId = const Value.absent(),
            Value<DateTime?> slaughterDate = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LotsTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            type: type,
            animalIdsJson: animalIdsJson,
            status: status,
            completed: completed,
            completedAt: completedAt,
            productId: productId,
            productName: productName,
            treatmentDate: treatmentDate,
            withdrawalEndDate: withdrawalEndDate,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            buyerName: buyerName,
            buyerFarmId: buyerFarmId,
            totalPrice: totalPrice,
            pricePerAnimal: pricePerAnimal,
            saleDate: saleDate,
            slaughterhouseName: slaughterhouseName,
            slaughterhouseId: slaughterhouseId,
            slaughterDate: slaughterDate,
            notes: notes,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LotsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LotsTableTable,
    LotsTableData,
    $$LotsTableTableFilterComposer,
    $$LotsTableTableOrderingComposer,
    $$LotsTableTableAnnotationComposer,
    $$LotsTableTableCreateCompanionBuilder,
    $$LotsTableTableUpdateCompanionBuilder,
    (
      LotsTableData,
      BaseReferences<_$AppDatabase, $LotsTableTable, LotsTableData>
    ),
    LotsTableData,
    PrefetchHooks Function()>;
typedef $$CampaignsTableTableCreateCompanionBuilder = CampaignsTableCompanion
    Function({
  required String id,
  required String farmId,
  required String name,
  required String productId,
  required String productName,
  required DateTime campaignDate,
  required DateTime withdrawalEndDate,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  required String animalIdsJson,
  Value<bool> completed,
  Value<bool> synced,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});
typedef $$CampaignsTableTableUpdateCompanionBuilder = CampaignsTableCompanion
    Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> name,
  Value<String> productId,
  Value<String> productName,
  Value<DateTime> campaignDate,
  Value<DateTime> withdrawalEndDate,
  Value<String?> veterinarianId,
  Value<String?> veterinarianName,
  Value<String> animalIdsJson,
  Value<bool> completed,
  Value<bool> synced,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<int> rowid,
});

class $$CampaignsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CampaignsTableTable> {
  $$CampaignsTableTableFilterComposer({
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

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get campaignDate => $composableBuilder(
      column: $table.campaignDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));
}

class $$CampaignsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CampaignsTableTable> {
  $$CampaignsTableTableOrderingComposer({
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

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get campaignDate => $composableBuilder(
      column: $table.campaignDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get completed => $composableBuilder(
      column: $table.completed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get synced => $composableBuilder(
      column: $table.synced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$CampaignsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CampaignsTableTable> {
  $$CampaignsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<DateTime> get campaignDate => $composableBuilder(
      column: $table.campaignDate, builder: (column) => column);

  GeneratedColumn<DateTime> get withdrawalEndDate => $composableBuilder(
      column: $table.withdrawalEndDate, builder: (column) => column);

  GeneratedColumn<String> get veterinarianId => $composableBuilder(
      column: $table.veterinarianId, builder: (column) => column);

  GeneratedColumn<String> get veterinarianName => $composableBuilder(
      column: $table.veterinarianName, builder: (column) => column);

  GeneratedColumn<String> get animalIdsJson => $composableBuilder(
      column: $table.animalIdsJson, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
      column: $table.lastSyncedAt, builder: (column) => column);

  GeneratedColumn<String> get serverVersion => $composableBuilder(
      column: $table.serverVersion, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$CampaignsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CampaignsTableTable,
    CampaignsTableData,
    $$CampaignsTableTableFilterComposer,
    $$CampaignsTableTableOrderingComposer,
    $$CampaignsTableTableAnnotationComposer,
    $$CampaignsTableTableCreateCompanionBuilder,
    $$CampaignsTableTableUpdateCompanionBuilder,
    (
      CampaignsTableData,
      BaseReferences<_$AppDatabase, $CampaignsTableTable, CampaignsTableData>
    ),
    CampaignsTableData,
    PrefetchHooks Function()> {
  $$CampaignsTableTableTableManager(
      _$AppDatabase db, $CampaignsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CampaignsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CampaignsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CampaignsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<DateTime> campaignDate = const Value.absent(),
            Value<DateTime> withdrawalEndDate = const Value.absent(),
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            Value<String> animalIdsJson = const Value.absent(),
            Value<bool> completed = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CampaignsTableCompanion(
            id: id,
            farmId: farmId,
            name: name,
            productId: productId,
            productName: productName,
            campaignDate: campaignDate,
            withdrawalEndDate: withdrawalEndDate,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            animalIdsJson: animalIdsJson,
            completed: completed,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String farmId,
            required String name,
            required String productId,
            required String productName,
            required DateTime campaignDate,
            required DateTime withdrawalEndDate,
            Value<String?> veterinarianId = const Value.absent(),
            Value<String?> veterinarianName = const Value.absent(),
            required String animalIdsJson,
            Value<bool> completed = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CampaignsTableCompanion.insert(
            id: id,
            farmId: farmId,
            name: name,
            productId: productId,
            productName: productName,
            campaignDate: campaignDate,
            withdrawalEndDate: withdrawalEndDate,
            veterinarianId: veterinarianId,
            veterinarianName: veterinarianName,
            animalIdsJson: animalIdsJson,
            completed: completed,
            synced: synced,
            createdAt: createdAt,
            updatedAt: updatedAt,
            lastSyncedAt: lastSyncedAt,
            serverVersion: serverVersion,
            deletedAt: deletedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CampaignsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CampaignsTableTable,
    CampaignsTableData,
    $$CampaignsTableTableFilterComposer,
    $$CampaignsTableTableOrderingComposer,
    $$CampaignsTableTableAnnotationComposer,
    $$CampaignsTableTableCreateCompanionBuilder,
    $$CampaignsTableTableUpdateCompanionBuilder,
    (
      CampaignsTableData,
      BaseReferences<_$AppDatabase, $CampaignsTableTable, CampaignsTableData>
    ),
    CampaignsTableData,
    PrefetchHooks Function()>;
typedef $$AlertConfigurationsTableTableCreateCompanionBuilder
    = AlertConfigurationsTableCompanion Function({
  required String id,
  required String farmId,
  required String evaluationType,
  required String type,
  required String category,
  required String titleKey,
  required String messageKey,
  required int severity,
  required String iconName,
  required String colorHex,
  Value<bool> enabled,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$AlertConfigurationsTableTableUpdateCompanionBuilder
    = AlertConfigurationsTableCompanion Function({
  Value<String> id,
  Value<String> farmId,
  Value<String> evaluationType,
  Value<String> type,
  Value<String> category,
  Value<String> titleKey,
  Value<String> messageKey,
  Value<int> severity,
  Value<String> iconName,
  Value<String> colorHex,
  Value<bool> enabled,
  Value<bool> synced,
  Value<DateTime?> lastSyncedAt,
  Value<String?> serverVersion,
  Value<DateTime?> deletedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$AlertConfigurationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AlertConfigurationsTableTable> {
  $$AlertConfigurationsTableTableFilterComposer({
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

  ColumnFilters<String> get evaluationType => $composableBuilder(
      column: $table.evaluationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get titleKey => $composableBuilder(
      column: $table.titleKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get messageKey => $composableBuilder(
      column: $table.messageKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnFilters(column));

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

class $$AlertConfigurationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertConfigurationsTableTable> {
  $$AlertConfigurationsTableTableOrderingComposer({
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

  ColumnOrderings<String> get evaluationType => $composableBuilder(
      column: $table.evaluationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get titleKey => $composableBuilder(
      column: $table.titleKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get messageKey => $composableBuilder(
      column: $table.messageKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled => $composableBuilder(
      column: $table.enabled, builder: (column) => ColumnOrderings(column));

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

class $$AlertConfigurationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertConfigurationsTableTable> {
  $$AlertConfigurationsTableTableAnnotationComposer({
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

  GeneratedColumn<String> get evaluationType => $composableBuilder(
      column: $table.evaluationType, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get titleKey =>
      $composableBuilder(column: $table.titleKey, builder: (column) => column);

  GeneratedColumn<String> get messageKey => $composableBuilder(
      column: $table.messageKey, builder: (column) => column);

  GeneratedColumn<int> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

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

class $$AlertConfigurationsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertConfigurationsTableTable,
    AlertConfigurationData,
    $$AlertConfigurationsTableTableFilterComposer,
    $$AlertConfigurationsTableTableOrderingComposer,
    $$AlertConfigurationsTableTableAnnotationComposer,
    $$AlertConfigurationsTableTableCreateCompanionBuilder,
    $$AlertConfigurationsTableTableUpdateCompanionBuilder,
    (
      AlertConfigurationData,
      BaseReferences<_$AppDatabase, $AlertConfigurationsTableTable,
          AlertConfigurationData>
    ),
    AlertConfigurationData,
    PrefetchHooks Function()> {
  $$AlertConfigurationsTableTableTableManager(
      _$AppDatabase db, $AlertConfigurationsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertConfigurationsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertConfigurationsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertConfigurationsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> farmId = const Value.absent(),
            Value<String> evaluationType = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> titleKey = const Value.absent(),
            Value<String> messageKey = const Value.absent(),
            Value<int> severity = const Value.absent(),
            Value<String> iconName = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<bool> enabled = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertConfigurationsTableCompanion(
            id: id,
            farmId: farmId,
            evaluationType: evaluationType,
            type: type,
            category: category,
            titleKey: titleKey,
            messageKey: messageKey,
            severity: severity,
            iconName: iconName,
            colorHex: colorHex,
            enabled: enabled,
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
            required String evaluationType,
            required String type,
            required String category,
            required String titleKey,
            required String messageKey,
            required int severity,
            required String iconName,
            required String colorHex,
            Value<bool> enabled = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime?> lastSyncedAt = const Value.absent(),
            Value<String?> serverVersion = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertConfigurationsTableCompanion.insert(
            id: id,
            farmId: farmId,
            evaluationType: evaluationType,
            type: type,
            category: category,
            titleKey: titleKey,
            messageKey: messageKey,
            severity: severity,
            iconName: iconName,
            colorHex: colorHex,
            enabled: enabled,
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

typedef $$AlertConfigurationsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $AlertConfigurationsTableTable,
        AlertConfigurationData,
        $$AlertConfigurationsTableTableFilterComposer,
        $$AlertConfigurationsTableTableOrderingComposer,
        $$AlertConfigurationsTableTableAnnotationComposer,
        $$AlertConfigurationsTableTableCreateCompanionBuilder,
        $$AlertConfigurationsTableTableUpdateCompanionBuilder,
        (
          AlertConfigurationData,
          BaseReferences<_$AppDatabase, $AlertConfigurationsTableTable,
              AlertConfigurationData>
        ),
        AlertConfigurationData,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FarmsTableTableTableManager get farmsTable =>
      $$FarmsTableTableTableManager(_db, _db.farmsTable);
  $$AnimalsTableTableTableManager get animalsTable =>
      $$AnimalsTableTableTableManager(_db, _db.animalsTable);
  $$BreedingsTableTableTableManager get breedingsTable =>
      $$BreedingsTableTableTableManager(_db, _db.breedingsTable);
  $$DocumentsTableTableTableManager get documentsTable =>
      $$DocumentsTableTableTableManager(_db, _db.documentsTable);
  $$TreatmentsTableTableTableManager get treatmentsTable =>
      $$TreatmentsTableTableTableManager(_db, _db.treatmentsTable);
  $$VaccinationsTableTableTableManager get vaccinationsTable =>
      $$VaccinationsTableTableTableManager(_db, _db.vaccinationsTable);
  $$WeightsTableTableTableManager get weightsTable =>
      $$WeightsTableTableTableManager(_db, _db.weightsTable);
  $$MovementsTableTableTableManager get movementsTable =>
      $$MovementsTableTableTableManager(_db, _db.movementsTable);
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
  $$BatchesTableTableTableManager get batchesTable =>
      $$BatchesTableTableTableManager(_db, _db.batchesTable);
  $$LotsTableTableTableManager get lotsTable =>
      $$LotsTableTableTableManager(_db, _db.lotsTable);
  $$CampaignsTableTableTableManager get campaignsTable =>
      $$CampaignsTableTableTableManager(_db, _db.campaignsTable);
  $$AlertConfigurationsTableTableTableManager get alertConfigurationsTable =>
      $$AlertConfigurationsTableTableTableManager(
          _db, _db.alertConfigurationsTable);
}
