// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CloudMusicOrderEntityTable extends CloudMusicOrderEntity
    with TableInfo<$CloudMusicOrderEntityTable, CloudMusicOrderEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CloudMusicOrderEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
      'origin', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subNameMeta =
      const VerificationMeta('subName');
  @override
  late final GeneratedColumn<String> subName = GeneratedColumn<String>(
      'sub_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _configMeta = const VerificationMeta('config');
  @override
  late final GeneratedColumn<String> config = GeneratedColumn<String>(
      'config', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, origin, subName, config, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cloud_music_order';
  @override
  VerificationContext validateIntegrity(
      Insertable<CloudMusicOrderEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('origin')) {
      context.handle(_originMeta,
          origin.isAcceptableOrUnknown(data['origin']!, _originMeta));
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('sub_name')) {
      context.handle(_subNameMeta,
          subName.isAcceptableOrUnknown(data['sub_name']!, _subNameMeta));
    } else if (isInserting) {
      context.missing(_subNameMeta);
    }
    if (data.containsKey('config')) {
      context.handle(_configMeta,
          config.isAcceptableOrUnknown(data['config']!, _configMeta));
    } else if (isInserting) {
      context.missing(_configMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CloudMusicOrderEntityData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CloudMusicOrderEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      origin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin'])!,
      subName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sub_name'])!,
      config: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}config'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $CloudMusicOrderEntityTable createAlias(String alias) {
    return $CloudMusicOrderEntityTable(attachedDatabase, alias);
  }
}

class CloudMusicOrderEntityData extends DataClass
    implements Insertable<CloudMusicOrderEntityData> {
  final String id;
  final String origin;
  final String subName;
  final String config;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const CloudMusicOrderEntityData(
      {required this.id,
      required this.origin,
      required this.subName,
      required this.config,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['origin'] = Variable<String>(origin);
    map['sub_name'] = Variable<String>(subName);
    map['config'] = Variable<String>(config);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  CloudMusicOrderEntityCompanion toCompanion(bool nullToAbsent) {
    return CloudMusicOrderEntityCompanion(
      id: Value(id),
      origin: Value(origin),
      subName: Value(subName),
      config: Value(config),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory CloudMusicOrderEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CloudMusicOrderEntityData(
      id: serializer.fromJson<String>(json['id']),
      origin: serializer.fromJson<String>(json['origin']),
      subName: serializer.fromJson<String>(json['subName']),
      config: serializer.fromJson<String>(json['config']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'origin': serializer.toJson<String>(origin),
      'subName': serializer.toJson<String>(subName),
      'config': serializer.toJson<String>(config),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  CloudMusicOrderEntityData copyWith(
          {String? id,
          String? origin,
          String? subName,
          String? config,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      CloudMusicOrderEntityData(
        id: id ?? this.id,
        origin: origin ?? this.origin,
        subName: subName ?? this.subName,
        config: config ?? this.config,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  CloudMusicOrderEntityData copyWithCompanion(
      CloudMusicOrderEntityCompanion data) {
    return CloudMusicOrderEntityData(
      id: data.id.present ? data.id.value : this.id,
      origin: data.origin.present ? data.origin.value : this.origin,
      subName: data.subName.present ? data.subName.value : this.subName,
      config: data.config.present ? data.config.value : this.config,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CloudMusicOrderEntityData(')
          ..write('id: $id, ')
          ..write('origin: $origin, ')
          ..write('subName: $subName, ')
          ..write('config: $config, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, origin, subName, config, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CloudMusicOrderEntityData &&
          other.id == this.id &&
          other.origin == this.origin &&
          other.subName == this.subName &&
          other.config == this.config &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CloudMusicOrderEntityCompanion
    extends UpdateCompanion<CloudMusicOrderEntityData> {
  final Value<String> id;
  final Value<String> origin;
  final Value<String> subName;
  final Value<String> config;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const CloudMusicOrderEntityCompanion({
    this.id = const Value.absent(),
    this.origin = const Value.absent(),
    this.subName = const Value.absent(),
    this.config = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CloudMusicOrderEntityCompanion.insert({
    required String id,
    required String origin,
    required String subName,
    required String config,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        origin = Value(origin),
        subName = Value(subName),
        config = Value(config);
  static Insertable<CloudMusicOrderEntityData> custom({
    Expression<String>? id,
    Expression<String>? origin,
    Expression<String>? subName,
    Expression<String>? config,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (origin != null) 'origin': origin,
      if (subName != null) 'sub_name': subName,
      if (config != null) 'config': config,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CloudMusicOrderEntityCompanion copyWith(
      {Value<String>? id,
      Value<String>? origin,
      Value<String>? subName,
      Value<String>? config,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return CloudMusicOrderEntityCompanion(
      id: id ?? this.id,
      origin: origin ?? this.origin,
      subName: subName ?? this.subName,
      config: config ?? this.config,
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
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
    }
    if (subName.present) {
      map['sub_name'] = Variable<String>(subName.value);
    }
    if (config.present) {
      map['config'] = Variable<String>(config.value);
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
    return (StringBuffer('CloudMusicOrderEntityCompanion(')
          ..write('id: $id, ')
          ..write('origin: $origin, ')
          ..write('subName: $subName, ')
          ..write('config: $config, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMusicOrderEntityTable extends LocalMusicOrderEntity
    with TableInfo<$LocalMusicOrderEntityTable, LocalMusicOrderEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMusicOrderEntityTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descMeta = const VerificationMeta('desc');
  @override
  late final GeneratedColumn<String> desc = GeneratedColumn<String>(
      'desc', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
      'cover', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, desc, cover, author, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_music_order';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalMusicOrderEntityData> instance,
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
    if (data.containsKey('desc')) {
      context.handle(
          _descMeta, desc.isAcceptableOrUnknown(data['desc']!, _descMeta));
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalMusicOrderEntityData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMusicOrderEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      desc: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}desc']),
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover']),
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $LocalMusicOrderEntityTable createAlias(String alias) {
    return $LocalMusicOrderEntityTable(attachedDatabase, alias);
  }
}

class LocalMusicOrderEntityData extends DataClass
    implements Insertable<LocalMusicOrderEntityData> {
  final String id;
  final String name;
  final String? desc;
  final String? cover;
  final String? author;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const LocalMusicOrderEntityData(
      {required this.id,
      required this.name,
      this.desc,
      this.cover,
      this.author,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || desc != null) {
      map['desc'] = Variable<String>(desc);
    }
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<String>(cover);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  LocalMusicOrderEntityCompanion toCompanion(bool nullToAbsent) {
    return LocalMusicOrderEntityCompanion(
      id: Value(id),
      name: Value(name),
      desc: desc == null && nullToAbsent ? const Value.absent() : Value(desc),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory LocalMusicOrderEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMusicOrderEntityData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      desc: serializer.fromJson<String?>(json['desc']),
      cover: serializer.fromJson<String?>(json['cover']),
      author: serializer.fromJson<String?>(json['author']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'desc': serializer.toJson<String?>(desc),
      'cover': serializer.toJson<String?>(cover),
      'author': serializer.toJson<String?>(author),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  LocalMusicOrderEntityData copyWith(
          {String? id,
          String? name,
          Value<String?> desc = const Value.absent(),
          Value<String?> cover = const Value.absent(),
          Value<String?> author = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      LocalMusicOrderEntityData(
        id: id ?? this.id,
        name: name ?? this.name,
        desc: desc.present ? desc.value : this.desc,
        cover: cover.present ? cover.value : this.cover,
        author: author.present ? author.value : this.author,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  LocalMusicOrderEntityData copyWithCompanion(
      LocalMusicOrderEntityCompanion data) {
    return LocalMusicOrderEntityData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      desc: data.desc.present ? data.desc.value : this.desc,
      cover: data.cover.present ? data.cover.value : this.cover,
      author: data.author.present ? data.author.value : this.author,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMusicOrderEntityData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('desc: $desc, ')
          ..write('cover: $cover, ')
          ..write('author: $author, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, desc, cover, author, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMusicOrderEntityData &&
          other.id == this.id &&
          other.name == this.name &&
          other.desc == this.desc &&
          other.cover == this.cover &&
          other.author == this.author &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalMusicOrderEntityCompanion
    extends UpdateCompanion<LocalMusicOrderEntityData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> desc;
  final Value<String?> cover;
  final Value<String?> author;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const LocalMusicOrderEntityCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.desc = const Value.absent(),
    this.cover = const Value.absent(),
    this.author = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMusicOrderEntityCompanion.insert({
    required String id,
    required String name,
    this.desc = const Value.absent(),
    this.cover = const Value.absent(),
    this.author = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<LocalMusicOrderEntityData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? desc,
    Expression<String>? cover,
    Expression<String>? author,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (desc != null) 'desc': desc,
      if (cover != null) 'cover': cover,
      if (author != null) 'author': author,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMusicOrderEntityCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? desc,
      Value<String?>? cover,
      Value<String?>? author,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return LocalMusicOrderEntityCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      cover: cover ?? this.cover,
      author: author ?? this.author,
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
    if (desc.present) {
      map['desc'] = Variable<String>(desc.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
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
    return (StringBuffer('LocalMusicOrderEntityCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('desc: $desc, ')
          ..write('cover: $cover, ')
          ..write('author: $author, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalMusicListEntityTable extends LocalMusicListEntity
    with TableInfo<$LocalMusicListEntityTable, LocalMusicListEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMusicListEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
      'order_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _musicIdMeta =
      const VerificationMeta('musicId');
  @override
  late final GeneratedColumn<String> musicId = GeneratedColumn<String>(
      'music_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
      'cover', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
      'origin', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        musicId,
        name,
        duration,
        cover,
        author,
        origin,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_music_list';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalMusicListEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('music_id')) {
      context.handle(_musicIdMeta,
          musicId.isAcceptableOrUnknown(data['music_id']!, _musicIdMeta));
    } else if (isInserting) {
      context.missing(_musicIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('origin')) {
      context.handle(_originMeta,
          origin.isAcceptableOrUnknown(data['origin']!, _originMeta));
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalMusicListEntityData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMusicListEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_id'])!,
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}music_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover']),
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      origin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $LocalMusicListEntityTable createAlias(String alias) {
    return $LocalMusicListEntityTable(attachedDatabase, alias);
  }
}

class LocalMusicListEntityData extends DataClass
    implements Insertable<LocalMusicListEntityData> {
  final String id;
  final String orderId;
  final String musicId;
  final String name;
  final int duration;
  final String? cover;
  final String? author;
  final String origin;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const LocalMusicListEntityData(
      {required this.id,
      required this.orderId,
      required this.musicId,
      required this.name,
      required this.duration,
      this.cover,
      this.author,
      required this.origin,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['music_id'] = Variable<String>(musicId);
    map['name'] = Variable<String>(name);
    map['duration'] = Variable<int>(duration);
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<String>(cover);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['origin'] = Variable<String>(origin);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  LocalMusicListEntityCompanion toCompanion(bool nullToAbsent) {
    return LocalMusicListEntityCompanion(
      id: Value(id),
      orderId: Value(orderId),
      musicId: Value(musicId),
      name: Value(name),
      duration: Value(duration),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      origin: Value(origin),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory LocalMusicListEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMusicListEntityData(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      musicId: serializer.fromJson<String>(json['musicId']),
      name: serializer.fromJson<String>(json['name']),
      duration: serializer.fromJson<int>(json['duration']),
      cover: serializer.fromJson<String?>(json['cover']),
      author: serializer.fromJson<String?>(json['author']),
      origin: serializer.fromJson<String>(json['origin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'musicId': serializer.toJson<String>(musicId),
      'name': serializer.toJson<String>(name),
      'duration': serializer.toJson<int>(duration),
      'cover': serializer.toJson<String?>(cover),
      'author': serializer.toJson<String?>(author),
      'origin': serializer.toJson<String>(origin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  LocalMusicListEntityData copyWith(
          {String? id,
          String? orderId,
          String? musicId,
          String? name,
          int? duration,
          Value<String?> cover = const Value.absent(),
          Value<String?> author = const Value.absent(),
          String? origin,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      LocalMusicListEntityData(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        musicId: musicId ?? this.musicId,
        name: name ?? this.name,
        duration: duration ?? this.duration,
        cover: cover.present ? cover.value : this.cover,
        author: author.present ? author.value : this.author,
        origin: origin ?? this.origin,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  LocalMusicListEntityData copyWithCompanion(
      LocalMusicListEntityCompanion data) {
    return LocalMusicListEntityData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      musicId: data.musicId.present ? data.musicId.value : this.musicId,
      name: data.name.present ? data.name.value : this.name,
      duration: data.duration.present ? data.duration.value : this.duration,
      cover: data.cover.present ? data.cover.value : this.cover,
      author: data.author.present ? data.author.value : this.author,
      origin: data.origin.present ? data.origin.value : this.origin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMusicListEntityData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('musicId: $musicId, ')
          ..write('name: $name, ')
          ..write('duration: $duration, ')
          ..write('cover: $cover, ')
          ..write('author: $author, ')
          ..write('origin: $origin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, musicId, name, duration, cover,
      author, origin, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMusicListEntityData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.musicId == this.musicId &&
          other.name == this.name &&
          other.duration == this.duration &&
          other.cover == this.cover &&
          other.author == this.author &&
          other.origin == this.origin &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LocalMusicListEntityCompanion
    extends UpdateCompanion<LocalMusicListEntityData> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> musicId;
  final Value<String> name;
  final Value<int> duration;
  final Value<String?> cover;
  final Value<String?> author;
  final Value<String> origin;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const LocalMusicListEntityCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.musicId = const Value.absent(),
    this.name = const Value.absent(),
    this.duration = const Value.absent(),
    this.cover = const Value.absent(),
    this.author = const Value.absent(),
    this.origin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMusicListEntityCompanion.insert({
    required String id,
    required String orderId,
    required String musicId,
    required String name,
    required int duration,
    this.cover = const Value.absent(),
    this.author = const Value.absent(),
    required String origin,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        orderId = Value(orderId),
        musicId = Value(musicId),
        name = Value(name),
        duration = Value(duration),
        origin = Value(origin);
  static Insertable<LocalMusicListEntityData> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? musicId,
    Expression<String>? name,
    Expression<int>? duration,
    Expression<String>? cover,
    Expression<String>? author,
    Expression<String>? origin,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (musicId != null) 'music_id': musicId,
      if (name != null) 'name': name,
      if (duration != null) 'duration': duration,
      if (cover != null) 'cover': cover,
      if (author != null) 'author': author,
      if (origin != null) 'origin': origin,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMusicListEntityCompanion copyWith(
      {Value<String>? id,
      Value<String>? orderId,
      Value<String>? musicId,
      Value<String>? name,
      Value<int>? duration,
      Value<String?>? cover,
      Value<String?>? author,
      Value<String>? origin,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return LocalMusicListEntityCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      musicId: musicId ?? this.musicId,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      cover: cover ?? this.cover,
      author: author ?? this.author,
      origin: origin ?? this.origin,
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
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (musicId.present) {
      map['music_id'] = Variable<String>(musicId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
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
    return (StringBuffer('LocalMusicListEntityCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('musicId: $musicId, ')
          ..write('name: $name, ')
          ..write('duration: $duration, ')
          ..write('cover: $cover, ')
          ..write('author: $author, ')
          ..write('origin: $origin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OpenMusicOrderUrlEntityTable extends OpenMusicOrderUrlEntity
    with TableInfo<$OpenMusicOrderUrlEntityTable, OpenMusicOrderUrlEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OpenMusicOrderUrlEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, url, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'open_music_order_url';
  @override
  VerificationContext validateIntegrity(
      Insertable<OpenMusicOrderUrlEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OpenMusicOrderUrlEntityData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OpenMusicOrderUrlEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $OpenMusicOrderUrlEntityTable createAlias(String alias) {
    return $OpenMusicOrderUrlEntityTable(attachedDatabase, alias);
  }
}

class OpenMusicOrderUrlEntityData extends DataClass
    implements Insertable<OpenMusicOrderUrlEntityData> {
  final String id;
  final String url;
  final DateTime createdAt;
  const OpenMusicOrderUrlEntityData(
      {required this.id, required this.url, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['url'] = Variable<String>(url);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OpenMusicOrderUrlEntityCompanion toCompanion(bool nullToAbsent) {
    return OpenMusicOrderUrlEntityCompanion(
      id: Value(id),
      url: Value(url),
      createdAt: Value(createdAt),
    );
  }

  factory OpenMusicOrderUrlEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OpenMusicOrderUrlEntityData(
      id: serializer.fromJson<String>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'url': serializer.toJson<String>(url),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OpenMusicOrderUrlEntityData copyWith(
          {String? id, String? url, DateTime? createdAt}) =>
      OpenMusicOrderUrlEntityData(
        id: id ?? this.id,
        url: url ?? this.url,
        createdAt: createdAt ?? this.createdAt,
      );
  OpenMusicOrderUrlEntityData copyWithCompanion(
      OpenMusicOrderUrlEntityCompanion data) {
    return OpenMusicOrderUrlEntityData(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OpenMusicOrderUrlEntityData(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, url, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OpenMusicOrderUrlEntityData &&
          other.id == this.id &&
          other.url == this.url &&
          other.createdAt == this.createdAt);
}

class OpenMusicOrderUrlEntityCompanion
    extends UpdateCompanion<OpenMusicOrderUrlEntityData> {
  final Value<String> id;
  final Value<String> url;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OpenMusicOrderUrlEntityCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OpenMusicOrderUrlEntityCompanion.insert({
    required String id,
    required String url,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        url = Value(url);
  static Insertable<OpenMusicOrderUrlEntityData> custom({
    Expression<String>? id,
    Expression<String>? url,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OpenMusicOrderUrlEntityCompanion copyWith(
      {Value<String>? id,
      Value<String>? url,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return OpenMusicOrderUrlEntityCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OpenMusicOrderUrlEntityCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayerListEntityTable extends PlayerListEntity
    with TableInfo<$PlayerListEntityTable, PlayerListEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerListEntityTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
      'cover', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _originMeta = const VerificationMeta('origin');
  @override
  late final GeneratedColumn<String> origin = GeneratedColumn<String>(
      'origin', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, duration, cover, author, origin, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_list';
  @override
  VerificationContext validateIntegrity(
      Insertable<PlayerListEntityData> instance,
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
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    }
    if (data.containsKey('origin')) {
      context.handle(_originMeta,
          origin.isAcceptableOrUnknown(data['origin']!, _originMeta));
    } else if (isInserting) {
      context.missing(_originMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerListEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerListEntityData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover']),
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author']),
      origin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}origin'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $PlayerListEntityTable createAlias(String alias) {
    return $PlayerListEntityTable(attachedDatabase, alias);
  }
}

class PlayerListEntityData extends DataClass
    implements Insertable<PlayerListEntityData> {
  final String id;
  final String name;
  final int duration;
  final String? cover;
  final String? author;
  final String origin;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const PlayerListEntityData(
      {required this.id,
      required this.name,
      required this.duration,
      this.cover,
      this.author,
      required this.origin,
      required this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['duration'] = Variable<int>(duration);
    if (!nullToAbsent || cover != null) {
      map['cover'] = Variable<String>(cover);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['origin'] = Variable<String>(origin);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  PlayerListEntityCompanion toCompanion(bool nullToAbsent) {
    return PlayerListEntityCompanion(
      id: Value(id),
      name: Value(name),
      duration: Value(duration),
      cover:
          cover == null && nullToAbsent ? const Value.absent() : Value(cover),
      author:
          author == null && nullToAbsent ? const Value.absent() : Value(author),
      origin: Value(origin),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory PlayerListEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerListEntityData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      duration: serializer.fromJson<int>(json['duration']),
      cover: serializer.fromJson<String?>(json['cover']),
      author: serializer.fromJson<String?>(json['author']),
      origin: serializer.fromJson<String>(json['origin']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'duration': serializer.toJson<int>(duration),
      'cover': serializer.toJson<String?>(cover),
      'author': serializer.toJson<String?>(author),
      'origin': serializer.toJson<String>(origin),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  PlayerListEntityData copyWith(
          {String? id,
          String? name,
          int? duration,
          Value<String?> cover = const Value.absent(),
          Value<String?> author = const Value.absent(),
          String? origin,
          DateTime? createdAt,
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      PlayerListEntityData(
        id: id ?? this.id,
        name: name ?? this.name,
        duration: duration ?? this.duration,
        cover: cover.present ? cover.value : this.cover,
        author: author.present ? author.value : this.author,
        origin: origin ?? this.origin,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  PlayerListEntityData copyWithCompanion(PlayerListEntityCompanion data) {
    return PlayerListEntityData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      duration: data.duration.present ? data.duration.value : this.duration,
      cover: data.cover.present ? data.cover.value : this.cover,
      author: data.author.present ? data.author.value : this.author,
      origin: data.origin.present ? data.origin.value : this.origin,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerListEntityData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('duration: $duration, ')
          ..write('cover: $cover, ')
          ..write('author: $author, ')
          ..write('origin: $origin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, duration, cover, author, origin, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerListEntityData &&
          other.id == this.id &&
          other.name == this.name &&
          other.duration == this.duration &&
          other.cover == this.cover &&
          other.author == this.author &&
          other.origin == this.origin &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PlayerListEntityCompanion extends UpdateCompanion<PlayerListEntityData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> duration;
  final Value<String?> cover;
  final Value<String?> author;
  final Value<String> origin;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const PlayerListEntityCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.duration = const Value.absent(),
    this.cover = const Value.absent(),
    this.author = const Value.absent(),
    this.origin = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlayerListEntityCompanion.insert({
    required String id,
    required String name,
    required int duration,
    this.cover = const Value.absent(),
    this.author = const Value.absent(),
    required String origin,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        duration = Value(duration),
        origin = Value(origin);
  static Insertable<PlayerListEntityData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? duration,
    Expression<String>? cover,
    Expression<String>? author,
    Expression<String>? origin,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (duration != null) 'duration': duration,
      if (cover != null) 'cover': cover,
      if (author != null) 'author': author,
      if (origin != null) 'origin': origin,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlayerListEntityCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? duration,
      Value<String?>? cover,
      Value<String?>? author,
      Value<String>? origin,
      Value<DateTime>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return PlayerListEntityCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      cover: cover ?? this.cover,
      author: author ?? this.author,
      origin: origin ?? this.origin,
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
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (origin.present) {
      map['origin'] = Variable<String>(origin.value);
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
    return (StringBuffer('PlayerListEntityCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('duration: $duration, ')
          ..write('cover: $cover, ')
          ..write('author: $author, ')
          ..write('origin: $origin, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryEntityTable extends SearchHistoryEntity
    with TableInfo<$SearchHistoryEntityTable, SearchHistoryEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history';
  @override
  VerificationContext validateIntegrity(
      Insertable<SearchHistoryEntityData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  SearchHistoryEntityData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryEntityData(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SearchHistoryEntityTable createAlias(String alias) {
    return $SearchHistoryEntityTable(attachedDatabase, alias);
  }
}

class SearchHistoryEntityData extends DataClass
    implements Insertable<SearchHistoryEntityData> {
  final String name;
  final DateTime createdAt;
  const SearchHistoryEntityData({required this.name, required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SearchHistoryEntityCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryEntityCompanion(
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory SearchHistoryEntityData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryEntityData(
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SearchHistoryEntityData copyWith({String? name, DateTime? createdAt}) =>
      SearchHistoryEntityData(
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  SearchHistoryEntityData copyWithCompanion(SearchHistoryEntityCompanion data) {
    return SearchHistoryEntityData(
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryEntityData(')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryEntityData &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class SearchHistoryEntityCompanion
    extends UpdateCompanion<SearchHistoryEntityData> {
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SearchHistoryEntityCompanion({
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SearchHistoryEntityCompanion.insert({
    required String name,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<SearchHistoryEntityData> custom({
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SearchHistoryEntityCompanion copyWith(
      {Value<String>? name, Value<DateTime>? createdAt, Value<int>? rowid}) {
    return SearchHistoryEntityCompanion(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryEntityCompanion(')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CloudMusicOrderEntityTable cloudMusicOrderEntity =
      $CloudMusicOrderEntityTable(this);
  late final $LocalMusicOrderEntityTable localMusicOrderEntity =
      $LocalMusicOrderEntityTable(this);
  late final $LocalMusicListEntityTable localMusicListEntity =
      $LocalMusicListEntityTable(this);
  late final $OpenMusicOrderUrlEntityTable openMusicOrderUrlEntity =
      $OpenMusicOrderUrlEntityTable(this);
  late final $PlayerListEntityTable playerListEntity =
      $PlayerListEntityTable(this);
  late final $SearchHistoryEntityTable searchHistoryEntity =
      $SearchHistoryEntityTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        cloudMusicOrderEntity,
        localMusicOrderEntity,
        localMusicListEntity,
        openMusicOrderUrlEntity,
        playerListEntity,
        searchHistoryEntity
      ];
}

typedef $$CloudMusicOrderEntityTableCreateCompanionBuilder
    = CloudMusicOrderEntityCompanion Function({
  required String id,
  required String origin,
  required String subName,
  required String config,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$CloudMusicOrderEntityTableUpdateCompanionBuilder
    = CloudMusicOrderEntityCompanion Function({
  Value<String> id,
  Value<String> origin,
  Value<String> subName,
  Value<String> config,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$CloudMusicOrderEntityTableFilterComposer
    extends Composer<_$AppDatabase, $CloudMusicOrderEntityTable> {
  $$CloudMusicOrderEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get subName => $composableBuilder(
      column: $table.subName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CloudMusicOrderEntityTableOrderingComposer
    extends Composer<_$AppDatabase, $CloudMusicOrderEntityTable> {
  $$CloudMusicOrderEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get subName => $composableBuilder(
      column: $table.subName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get config => $composableBuilder(
      column: $table.config, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CloudMusicOrderEntityTableAnnotationComposer
    extends Composer<_$AppDatabase, $CloudMusicOrderEntityTable> {
  $$CloudMusicOrderEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<String> get subName =>
      $composableBuilder(column: $table.subName, builder: (column) => column);

  GeneratedColumn<String> get config =>
      $composableBuilder(column: $table.config, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CloudMusicOrderEntityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CloudMusicOrderEntityTable,
    CloudMusicOrderEntityData,
    $$CloudMusicOrderEntityTableFilterComposer,
    $$CloudMusicOrderEntityTableOrderingComposer,
    $$CloudMusicOrderEntityTableAnnotationComposer,
    $$CloudMusicOrderEntityTableCreateCompanionBuilder,
    $$CloudMusicOrderEntityTableUpdateCompanionBuilder,
    (
      CloudMusicOrderEntityData,
      BaseReferences<_$AppDatabase, $CloudMusicOrderEntityTable,
          CloudMusicOrderEntityData>
    ),
    CloudMusicOrderEntityData,
    PrefetchHooks Function()> {
  $$CloudMusicOrderEntityTableTableManager(
      _$AppDatabase db, $CloudMusicOrderEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CloudMusicOrderEntityTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CloudMusicOrderEntityTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CloudMusicOrderEntityTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> origin = const Value.absent(),
            Value<String> subName = const Value.absent(),
            Value<String> config = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CloudMusicOrderEntityCompanion(
            id: id,
            origin: origin,
            subName: subName,
            config: config,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String origin,
            required String subName,
            required String config,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CloudMusicOrderEntityCompanion.insert(
            id: id,
            origin: origin,
            subName: subName,
            config: config,
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

typedef $$CloudMusicOrderEntityTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CloudMusicOrderEntityTable,
        CloudMusicOrderEntityData,
        $$CloudMusicOrderEntityTableFilterComposer,
        $$CloudMusicOrderEntityTableOrderingComposer,
        $$CloudMusicOrderEntityTableAnnotationComposer,
        $$CloudMusicOrderEntityTableCreateCompanionBuilder,
        $$CloudMusicOrderEntityTableUpdateCompanionBuilder,
        (
          CloudMusicOrderEntityData,
          BaseReferences<_$AppDatabase, $CloudMusicOrderEntityTable,
              CloudMusicOrderEntityData>
        ),
        CloudMusicOrderEntityData,
        PrefetchHooks Function()>;
typedef $$LocalMusicOrderEntityTableCreateCompanionBuilder
    = LocalMusicOrderEntityCompanion Function({
  required String id,
  required String name,
  Value<String?> desc,
  Value<String?> cover,
  Value<String?> author,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$LocalMusicOrderEntityTableUpdateCompanionBuilder
    = LocalMusicOrderEntityCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> desc,
  Value<String?> cover,
  Value<String?> author,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$LocalMusicOrderEntityTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMusicOrderEntityTable> {
  $$LocalMusicOrderEntityTableFilterComposer({
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

  ColumnFilters<String> get desc => $composableBuilder(
      column: $table.desc, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalMusicOrderEntityTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMusicOrderEntityTable> {
  $$LocalMusicOrderEntityTableOrderingComposer({
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

  ColumnOrderings<String> get desc => $composableBuilder(
      column: $table.desc, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalMusicOrderEntityTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMusicOrderEntityTable> {
  $$LocalMusicOrderEntityTableAnnotationComposer({
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

  GeneratedColumn<String> get desc =>
      $composableBuilder(column: $table.desc, builder: (column) => column);

  GeneratedColumn<String> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalMusicOrderEntityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalMusicOrderEntityTable,
    LocalMusicOrderEntityData,
    $$LocalMusicOrderEntityTableFilterComposer,
    $$LocalMusicOrderEntityTableOrderingComposer,
    $$LocalMusicOrderEntityTableAnnotationComposer,
    $$LocalMusicOrderEntityTableCreateCompanionBuilder,
    $$LocalMusicOrderEntityTableUpdateCompanionBuilder,
    (
      LocalMusicOrderEntityData,
      BaseReferences<_$AppDatabase, $LocalMusicOrderEntityTable,
          LocalMusicOrderEntityData>
    ),
    LocalMusicOrderEntityData,
    PrefetchHooks Function()> {
  $$LocalMusicOrderEntityTableTableManager(
      _$AppDatabase db, $LocalMusicOrderEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMusicOrderEntityTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalMusicOrderEntityTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalMusicOrderEntityTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> desc = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalMusicOrderEntityCompanion(
            id: id,
            name: name,
            desc: desc,
            cover: cover,
            author: author,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> desc = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalMusicOrderEntityCompanion.insert(
            id: id,
            name: name,
            desc: desc,
            cover: cover,
            author: author,
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

typedef $$LocalMusicOrderEntityTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $LocalMusicOrderEntityTable,
        LocalMusicOrderEntityData,
        $$LocalMusicOrderEntityTableFilterComposer,
        $$LocalMusicOrderEntityTableOrderingComposer,
        $$LocalMusicOrderEntityTableAnnotationComposer,
        $$LocalMusicOrderEntityTableCreateCompanionBuilder,
        $$LocalMusicOrderEntityTableUpdateCompanionBuilder,
        (
          LocalMusicOrderEntityData,
          BaseReferences<_$AppDatabase, $LocalMusicOrderEntityTable,
              LocalMusicOrderEntityData>
        ),
        LocalMusicOrderEntityData,
        PrefetchHooks Function()>;
typedef $$LocalMusicListEntityTableCreateCompanionBuilder
    = LocalMusicListEntityCompanion Function({
  required String id,
  required String orderId,
  required String musicId,
  required String name,
  required int duration,
  Value<String?> cover,
  Value<String?> author,
  required String origin,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$LocalMusicListEntityTableUpdateCompanionBuilder
    = LocalMusicListEntityCompanion Function({
  Value<String> id,
  Value<String> orderId,
  Value<String> musicId,
  Value<String> name,
  Value<int> duration,
  Value<String?> cover,
  Value<String?> author,
  Value<String> origin,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$LocalMusicListEntityTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMusicListEntityTable> {
  $$LocalMusicListEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get musicId => $composableBuilder(
      column: $table.musicId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$LocalMusicListEntityTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMusicListEntityTable> {
  $$LocalMusicListEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get musicId => $composableBuilder(
      column: $table.musicId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalMusicListEntityTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMusicListEntityTable> {
  $$LocalMusicListEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get musicId =>
      $composableBuilder(column: $table.musicId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LocalMusicListEntityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalMusicListEntityTable,
    LocalMusicListEntityData,
    $$LocalMusicListEntityTableFilterComposer,
    $$LocalMusicListEntityTableOrderingComposer,
    $$LocalMusicListEntityTableAnnotationComposer,
    $$LocalMusicListEntityTableCreateCompanionBuilder,
    $$LocalMusicListEntityTableUpdateCompanionBuilder,
    (
      LocalMusicListEntityData,
      BaseReferences<_$AppDatabase, $LocalMusicListEntityTable,
          LocalMusicListEntityData>
    ),
    LocalMusicListEntityData,
    PrefetchHooks Function()> {
  $$LocalMusicListEntityTableTableManager(
      _$AppDatabase db, $LocalMusicListEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMusicListEntityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalMusicListEntityTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalMusicListEntityTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> orderId = const Value.absent(),
            Value<String> musicId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String> origin = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalMusicListEntityCompanion(
            id: id,
            orderId: orderId,
            musicId: musicId,
            name: name,
            duration: duration,
            cover: cover,
            author: author,
            origin: origin,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String orderId,
            required String musicId,
            required String name,
            required int duration,
            Value<String?> cover = const Value.absent(),
            Value<String?> author = const Value.absent(),
            required String origin,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalMusicListEntityCompanion.insert(
            id: id,
            orderId: orderId,
            musicId: musicId,
            name: name,
            duration: duration,
            cover: cover,
            author: author,
            origin: origin,
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

typedef $$LocalMusicListEntityTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $LocalMusicListEntityTable,
        LocalMusicListEntityData,
        $$LocalMusicListEntityTableFilterComposer,
        $$LocalMusicListEntityTableOrderingComposer,
        $$LocalMusicListEntityTableAnnotationComposer,
        $$LocalMusicListEntityTableCreateCompanionBuilder,
        $$LocalMusicListEntityTableUpdateCompanionBuilder,
        (
          LocalMusicListEntityData,
          BaseReferences<_$AppDatabase, $LocalMusicListEntityTable,
              LocalMusicListEntityData>
        ),
        LocalMusicListEntityData,
        PrefetchHooks Function()>;
typedef $$OpenMusicOrderUrlEntityTableCreateCompanionBuilder
    = OpenMusicOrderUrlEntityCompanion Function({
  required String id,
  required String url,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$OpenMusicOrderUrlEntityTableUpdateCompanionBuilder
    = OpenMusicOrderUrlEntityCompanion Function({
  Value<String> id,
  Value<String> url,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$OpenMusicOrderUrlEntityTableFilterComposer
    extends Composer<_$AppDatabase, $OpenMusicOrderUrlEntityTable> {
  $$OpenMusicOrderUrlEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$OpenMusicOrderUrlEntityTableOrderingComposer
    extends Composer<_$AppDatabase, $OpenMusicOrderUrlEntityTable> {
  $$OpenMusicOrderUrlEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$OpenMusicOrderUrlEntityTableAnnotationComposer
    extends Composer<_$AppDatabase, $OpenMusicOrderUrlEntityTable> {
  $$OpenMusicOrderUrlEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$OpenMusicOrderUrlEntityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OpenMusicOrderUrlEntityTable,
    OpenMusicOrderUrlEntityData,
    $$OpenMusicOrderUrlEntityTableFilterComposer,
    $$OpenMusicOrderUrlEntityTableOrderingComposer,
    $$OpenMusicOrderUrlEntityTableAnnotationComposer,
    $$OpenMusicOrderUrlEntityTableCreateCompanionBuilder,
    $$OpenMusicOrderUrlEntityTableUpdateCompanionBuilder,
    (
      OpenMusicOrderUrlEntityData,
      BaseReferences<_$AppDatabase, $OpenMusicOrderUrlEntityTable,
          OpenMusicOrderUrlEntityData>
    ),
    OpenMusicOrderUrlEntityData,
    PrefetchHooks Function()> {
  $$OpenMusicOrderUrlEntityTableTableManager(
      _$AppDatabase db, $OpenMusicOrderUrlEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OpenMusicOrderUrlEntityTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$OpenMusicOrderUrlEntityTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OpenMusicOrderUrlEntityTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OpenMusicOrderUrlEntityCompanion(
            id: id,
            url: url,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String url,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OpenMusicOrderUrlEntityCompanion.insert(
            id: id,
            url: url,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OpenMusicOrderUrlEntityTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $OpenMusicOrderUrlEntityTable,
        OpenMusicOrderUrlEntityData,
        $$OpenMusicOrderUrlEntityTableFilterComposer,
        $$OpenMusicOrderUrlEntityTableOrderingComposer,
        $$OpenMusicOrderUrlEntityTableAnnotationComposer,
        $$OpenMusicOrderUrlEntityTableCreateCompanionBuilder,
        $$OpenMusicOrderUrlEntityTableUpdateCompanionBuilder,
        (
          OpenMusicOrderUrlEntityData,
          BaseReferences<_$AppDatabase, $OpenMusicOrderUrlEntityTable,
              OpenMusicOrderUrlEntityData>
        ),
        OpenMusicOrderUrlEntityData,
        PrefetchHooks Function()>;
typedef $$PlayerListEntityTableCreateCompanionBuilder
    = PlayerListEntityCompanion Function({
  required String id,
  required String name,
  required int duration,
  Value<String?> cover,
  Value<String?> author,
  required String origin,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$PlayerListEntityTableUpdateCompanionBuilder
    = PlayerListEntityCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<int> duration,
  Value<String?> cover,
  Value<String?> author,
  Value<String> origin,
  Value<DateTime> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$PlayerListEntityTableFilterComposer
    extends Composer<_$AppDatabase, $PlayerListEntityTable> {
  $$PlayerListEntityTableFilterComposer({
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

  ColumnFilters<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$PlayerListEntityTableOrderingComposer
    extends Composer<_$AppDatabase, $PlayerListEntityTable> {
  $$PlayerListEntityTableOrderingComposer({
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

  ColumnOrderings<int> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cover => $composableBuilder(
      column: $table.cover, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get origin => $composableBuilder(
      column: $table.origin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$PlayerListEntityTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlayerListEntityTable> {
  $$PlayerListEntityTableAnnotationComposer({
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

  GeneratedColumn<int> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get origin =>
      $composableBuilder(column: $table.origin, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlayerListEntityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PlayerListEntityTable,
    PlayerListEntityData,
    $$PlayerListEntityTableFilterComposer,
    $$PlayerListEntityTableOrderingComposer,
    $$PlayerListEntityTableAnnotationComposer,
    $$PlayerListEntityTableCreateCompanionBuilder,
    $$PlayerListEntityTableUpdateCompanionBuilder,
    (
      PlayerListEntityData,
      BaseReferences<_$AppDatabase, $PlayerListEntityTable,
          PlayerListEntityData>
    ),
    PlayerListEntityData,
    PrefetchHooks Function()> {
  $$PlayerListEntityTableTableManager(
      _$AppDatabase db, $PlayerListEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlayerListEntityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlayerListEntityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlayerListEntityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<String?> cover = const Value.absent(),
            Value<String?> author = const Value.absent(),
            Value<String> origin = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlayerListEntityCompanion(
            id: id,
            name: name,
            duration: duration,
            cover: cover,
            author: author,
            origin: origin,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int duration,
            Value<String?> cover = const Value.absent(),
            Value<String?> author = const Value.absent(),
            required String origin,
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PlayerListEntityCompanion.insert(
            id: id,
            name: name,
            duration: duration,
            cover: cover,
            author: author,
            origin: origin,
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

typedef $$PlayerListEntityTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PlayerListEntityTable,
    PlayerListEntityData,
    $$PlayerListEntityTableFilterComposer,
    $$PlayerListEntityTableOrderingComposer,
    $$PlayerListEntityTableAnnotationComposer,
    $$PlayerListEntityTableCreateCompanionBuilder,
    $$PlayerListEntityTableUpdateCompanionBuilder,
    (
      PlayerListEntityData,
      BaseReferences<_$AppDatabase, $PlayerListEntityTable,
          PlayerListEntityData>
    ),
    PlayerListEntityData,
    PrefetchHooks Function()>;
typedef $$SearchHistoryEntityTableCreateCompanionBuilder
    = SearchHistoryEntityCompanion Function({
  required String name,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$SearchHistoryEntityTableUpdateCompanionBuilder
    = SearchHistoryEntityCompanion Function({
  Value<String> name,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SearchHistoryEntityTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryEntityTable> {
  $$SearchHistoryEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SearchHistoryEntityTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryEntityTable> {
  $$SearchHistoryEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SearchHistoryEntityTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryEntityTable> {
  $$SearchHistoryEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SearchHistoryEntityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SearchHistoryEntityTable,
    SearchHistoryEntityData,
    $$SearchHistoryEntityTableFilterComposer,
    $$SearchHistoryEntityTableOrderingComposer,
    $$SearchHistoryEntityTableAnnotationComposer,
    $$SearchHistoryEntityTableCreateCompanionBuilder,
    $$SearchHistoryEntityTableUpdateCompanionBuilder,
    (
      SearchHistoryEntityData,
      BaseReferences<_$AppDatabase, $SearchHistoryEntityTable,
          SearchHistoryEntityData>
    ),
    SearchHistoryEntityData,
    PrefetchHooks Function()> {
  $$SearchHistoryEntityTableTableManager(
      _$AppDatabase db, $SearchHistoryEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryEntityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryEntityTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryEntityTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> name = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SearchHistoryEntityCompanion(
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String name,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SearchHistoryEntityCompanion.insert(
            name: name,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SearchHistoryEntityTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SearchHistoryEntityTable,
    SearchHistoryEntityData,
    $$SearchHistoryEntityTableFilterComposer,
    $$SearchHistoryEntityTableOrderingComposer,
    $$SearchHistoryEntityTableAnnotationComposer,
    $$SearchHistoryEntityTableCreateCompanionBuilder,
    $$SearchHistoryEntityTableUpdateCompanionBuilder,
    (
      SearchHistoryEntityData,
      BaseReferences<_$AppDatabase, $SearchHistoryEntityTable,
          SearchHistoryEntityData>
    ),
    SearchHistoryEntityData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CloudMusicOrderEntityTableTableManager get cloudMusicOrderEntity =>
      $$CloudMusicOrderEntityTableTableManager(_db, _db.cloudMusicOrderEntity);
  $$LocalMusicOrderEntityTableTableManager get localMusicOrderEntity =>
      $$LocalMusicOrderEntityTableTableManager(_db, _db.localMusicOrderEntity);
  $$LocalMusicListEntityTableTableManager get localMusicListEntity =>
      $$LocalMusicListEntityTableTableManager(_db, _db.localMusicListEntity);
  $$OpenMusicOrderUrlEntityTableTableManager get openMusicOrderUrlEntity =>
      $$OpenMusicOrderUrlEntityTableTableManager(
          _db, _db.openMusicOrderUrlEntity);
  $$PlayerListEntityTableTableManager get playerListEntity =>
      $$PlayerListEntityTableTableManager(_db, _db.playerListEntity);
  $$SearchHistoryEntityTableTableManager get searchHistoryEntity =>
      $$SearchHistoryEntityTableTableManager(_db, _db.searchHistoryEntity);
}
