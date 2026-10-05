// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    name,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final String name;
  final int sortOrder;
  const Category({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    String? name,
    int? sortOrder,
  }) => Category(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(syncId, createdAt, updatedAt, id, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<String>? name,
    Value<int>? sortOrder,
  }) {
    return CategoriesCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $CategoryFieldsTable extends CategoryFields
    with TableInfo<$CategoryFieldsTable, CategoryField> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryFieldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    categoryId,
    label,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_fields';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryField> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryField map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryField(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoryFieldsTable createAlias(String alias) {
    return $CategoryFieldsTable(attachedDatabase, alias);
  }
}

class CategoryField extends DataClass implements Insertable<CategoryField> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final int categoryId;
  final String label;
  final int sortOrder;
  const CategoryField({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.categoryId,
    required this.label,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<int>(categoryId);
    map['label'] = Variable<String>(label);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoryFieldsCompanion toCompanion(bool nullToAbsent) {
    return CategoryFieldsCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      categoryId: Value(categoryId),
      label: Value(label),
      sortOrder: Value(sortOrder),
    );
  }

  factory CategoryField.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryField(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      label: serializer.fromJson<String>(json['label']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<int>(categoryId),
      'label': serializer.toJson<String>(label),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CategoryField copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    int? categoryId,
    String? label,
    int? sortOrder,
  }) => CategoryField(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    label: label ?? this.label,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CategoryField copyWithCompanion(CategoryFieldsCompanion data) {
    return CategoryField(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      label: data.label.present ? data.label.value : this.label,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryField(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncId,
    createdAt,
    updatedAt,
    id,
    categoryId,
    label,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryField &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.label == this.label &&
          other.sortOrder == this.sortOrder);
}

class CategoryFieldsCompanion extends UpdateCompanion<CategoryField> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<int> categoryId;
  final Value<String> label;
  final Value<int> sortOrder;
  const CategoryFieldsCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.label = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoryFieldsCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required int categoryId,
    required String label,
    this.sortOrder = const Value.absent(),
  }) : categoryId = Value(categoryId),
       label = Value(label);
  static Insertable<CategoryField> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<int>? categoryId,
    Expression<String>? label,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (label != null) 'label': label,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoryFieldsCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<int>? categoryId,
    Value<String>? label,
    Value<int>? sortOrder,
  }) {
    return CategoryFieldsCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      label: label ?? this.label,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryFieldsCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('label: $label, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $PlatformsTable extends Platforms
    with TableInfo<$PlatformsTable, Platform> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlatformsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feeBasisPointsMeta = const VerificationMeta(
    'feeBasisPoints',
  );
  @override
  late final GeneratedColumn<int> feeBasisPoints = GeneratedColumn<int>(
    'fee_basis_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fixedFeeCentsMeta = const VerificationMeta(
    'fixedFeeCents',
  );
  @override
  late final GeneratedColumn<int> fixedFeeCents = GeneratedColumn<int>(
    'fixed_fee_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _processingBasisPointsMeta =
      const VerificationMeta('processingBasisPoints');
  @override
  late final GeneratedColumn<int> processingBasisPoints = GeneratedColumn<int>(
    'processing_basis_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    name,
    feeBasisPoints,
    fixedFeeCents,
    processingBasisPoints,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'platforms';
  @override
  VerificationContext validateIntegrity(
    Insertable<Platform> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('fee_basis_points')) {
      context.handle(
        _feeBasisPointsMeta,
        feeBasisPoints.isAcceptableOrUnknown(
          data['fee_basis_points']!,
          _feeBasisPointsMeta,
        ),
      );
    }
    if (data.containsKey('fixed_fee_cents')) {
      context.handle(
        _fixedFeeCentsMeta,
        fixedFeeCents.isAcceptableOrUnknown(
          data['fixed_fee_cents']!,
          _fixedFeeCentsMeta,
        ),
      );
    }
    if (data.containsKey('processing_basis_points')) {
      context.handle(
        _processingBasisPointsMeta,
        processingBasisPoints.isAcceptableOrUnknown(
          data['processing_basis_points']!,
          _processingBasisPointsMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Platform map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Platform(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      feeBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fee_basis_points'],
      )!,
      fixedFeeCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fixed_fee_cents'],
      )!,
      processingBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processing_basis_points'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
    );
  }

  @override
  $PlatformsTable createAlias(String alias) {
    return $PlatformsTable(attachedDatabase, alias);
  }
}

class Platform extends DataClass implements Insertable<Platform> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final String name;
  final int feeBasisPoints;
  final int fixedFeeCents;
  final int processingBasisPoints;
  final bool isCustom;
  const Platform({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.name,
    required this.feeBasisPoints,
    required this.fixedFeeCents,
    required this.processingBasisPoints,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['fee_basis_points'] = Variable<int>(feeBasisPoints);
    map['fixed_fee_cents'] = Variable<int>(fixedFeeCents);
    map['processing_basis_points'] = Variable<int>(processingBasisPoints);
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  PlatformsCompanion toCompanion(bool nullToAbsent) {
    return PlatformsCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      name: Value(name),
      feeBasisPoints: Value(feeBasisPoints),
      fixedFeeCents: Value(fixedFeeCents),
      processingBasisPoints: Value(processingBasisPoints),
      isCustom: Value(isCustom),
    );
  }

  factory Platform.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Platform(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      feeBasisPoints: serializer.fromJson<int>(json['feeBasisPoints']),
      fixedFeeCents: serializer.fromJson<int>(json['fixedFeeCents']),
      processingBasisPoints: serializer.fromJson<int>(
        json['processingBasisPoints'],
      ),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'feeBasisPoints': serializer.toJson<int>(feeBasisPoints),
      'fixedFeeCents': serializer.toJson<int>(fixedFeeCents),
      'processingBasisPoints': serializer.toJson<int>(processingBasisPoints),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  Platform copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    String? name,
    int? feeBasisPoints,
    int? fixedFeeCents,
    int? processingBasisPoints,
    bool? isCustom,
  }) => Platform(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    feeBasisPoints: feeBasisPoints ?? this.feeBasisPoints,
    fixedFeeCents: fixedFeeCents ?? this.fixedFeeCents,
    processingBasisPoints: processingBasisPoints ?? this.processingBasisPoints,
    isCustom: isCustom ?? this.isCustom,
  );
  Platform copyWithCompanion(PlatformsCompanion data) {
    return Platform(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      feeBasisPoints: data.feeBasisPoints.present
          ? data.feeBasisPoints.value
          : this.feeBasisPoints,
      fixedFeeCents: data.fixedFeeCents.present
          ? data.fixedFeeCents.value
          : this.fixedFeeCents,
      processingBasisPoints: data.processingBasisPoints.present
          ? data.processingBasisPoints.value
          : this.processingBasisPoints,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Platform(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('feeBasisPoints: $feeBasisPoints, ')
          ..write('fixedFeeCents: $fixedFeeCents, ')
          ..write('processingBasisPoints: $processingBasisPoints, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncId,
    createdAt,
    updatedAt,
    id,
    name,
    feeBasisPoints,
    fixedFeeCents,
    processingBasisPoints,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Platform &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.feeBasisPoints == this.feeBasisPoints &&
          other.fixedFeeCents == this.fixedFeeCents &&
          other.processingBasisPoints == this.processingBasisPoints &&
          other.isCustom == this.isCustom);
}

class PlatformsCompanion extends UpdateCompanion<Platform> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<String> name;
  final Value<int> feeBasisPoints;
  final Value<int> fixedFeeCents;
  final Value<int> processingBasisPoints;
  final Value<bool> isCustom;
  const PlatformsCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.feeBasisPoints = const Value.absent(),
    this.fixedFeeCents = const Value.absent(),
    this.processingBasisPoints = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  PlatformsCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.feeBasisPoints = const Value.absent(),
    this.fixedFeeCents = const Value.absent(),
    this.processingBasisPoints = const Value.absent(),
    this.isCustom = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Platform> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? feeBasisPoints,
    Expression<int>? fixedFeeCents,
    Expression<int>? processingBasisPoints,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (feeBasisPoints != null) 'fee_basis_points': feeBasisPoints,
      if (fixedFeeCents != null) 'fixed_fee_cents': fixedFeeCents,
      if (processingBasisPoints != null)
        'processing_basis_points': processingBasisPoints,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  PlatformsCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<String>? name,
    Value<int>? feeBasisPoints,
    Value<int>? fixedFeeCents,
    Value<int>? processingBasisPoints,
    Value<bool>? isCustom,
  }) {
    return PlatformsCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      feeBasisPoints: feeBasisPoints ?? this.feeBasisPoints,
      fixedFeeCents: fixedFeeCents ?? this.fixedFeeCents,
      processingBasisPoints:
          processingBasisPoints ?? this.processingBasisPoints,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (feeBasisPoints.present) {
      map['fee_basis_points'] = Variable<int>(feeBasisPoints.value);
    }
    if (fixedFeeCents.present) {
      map['fixed_fee_cents'] = Variable<int>(fixedFeeCents.value);
    }
    if (processingBasisPoints.present) {
      map['processing_basis_points'] = Variable<int>(
        processingBasisPoints.value,
      );
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlatformsCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('feeBasisPoints: $feeBasisPoints, ')
          ..write('fixedFeeCents: $fixedFeeCents, ')
          ..write('processingBasisPoints: $processingBasisPoints, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $PurchaseSourcesTable extends PurchaseSources
    with TableInfo<$PurchaseSourcesTable, PurchaseSource> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    name,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseSource> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseSource map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseSource(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $PurchaseSourcesTable createAlias(String alias) {
    return $PurchaseSourcesTable(attachedDatabase, alias);
  }
}

class PurchaseSource extends DataClass implements Insertable<PurchaseSource> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final String name;
  const PurchaseSource({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  PurchaseSourcesCompanion toCompanion(bool nullToAbsent) {
    return PurchaseSourcesCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      name: Value(name),
    );
  }

  factory PurchaseSource.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseSource(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  PurchaseSource copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    String? name,
  }) => PurchaseSource(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    name: name ?? this.name,
  );
  PurchaseSource copyWithCompanion(PurchaseSourcesCompanion data) {
    return PurchaseSource(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseSource(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(syncId, createdAt, updatedAt, id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseSource &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.name == this.name);
}

class PurchaseSourcesCompanion extends UpdateCompanion<PurchaseSource> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<String> name;
  const PurchaseSourcesCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  PurchaseSourcesCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<PurchaseSource> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  PurchaseSourcesCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<String>? name,
  }) {
    return PurchaseSourcesCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseSourcesCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ItemsTable extends Items with TableInfo<$ItemsTable, Item> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sizeVariantMeta = const VerificationMeta(
    'sizeVariant',
  );
  @override
  late final GeneratedColumn<String> sizeVariant = GeneratedColumn<String>(
    'size_variant',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionMeta = const VerificationMeta(
    'condition',
  );
  @override
  late final GeneratedColumn<String> condition = GeneratedColumn<String>(
    'condition',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ItemStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: Constant(ItemStatus.inStock.name),
      ).withConverter<ItemStatus>($ItemsTable.$converterstatus);
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchaseSourceIdMeta = const VerificationMeta(
    'purchaseSourceId',
  );
  @override
  late final GeneratedColumn<int> purchaseSourceId = GeneratedColumn<int>(
    'purchase_source_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES purchase_sources (id)',
    ),
  );
  static const VerificationMeta _storageLocationMeta = const VerificationMeta(
    'storageLocation',
  );
  @override
  late final GeneratedColumn<String> storageLocation = GeneratedColumn<String>(
    'storage_location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purchasePriceCentsMeta =
      const VerificationMeta('purchasePriceCents');
  @override
  late final GeneratedColumn<int> purchasePriceCents = GeneratedColumn<int>(
    'purchase_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _purchaseTaxCentsMeta = const VerificationMeta(
    'purchaseTaxCents',
  );
  @override
  late final GeneratedColumn<int> purchaseTaxCents = GeneratedColumn<int>(
    'purchase_tax_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _inboundShippingCentsMeta =
      const VerificationMeta('inboundShippingCents');
  @override
  late final GeneratedColumn<int> inboundShippingCents = GeneratedColumn<int>(
    'inbound_shipping_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _otherCostsCentsMeta = const VerificationMeta(
    'otherCostsCents',
  );
  @override
  late final GeneratedColumn<int> otherCostsCents = GeneratedColumn<int>(
    'other_costs_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    name,
    categoryId,
    brand,
    sizeVariant,
    condition,
    sku,
    quantity,
    status,
    purchaseDate,
    purchaseSourceId,
    storageLocation,
    notes,
    purchasePriceCents,
    purchaseTaxCents,
    inboundShippingCents,
    otherCostsCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'items';
  @override
  VerificationContext validateIntegrity(
    Insertable<Item> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('size_variant')) {
      context.handle(
        _sizeVariantMeta,
        sizeVariant.isAcceptableOrUnknown(
          data['size_variant']!,
          _sizeVariantMeta,
        ),
      );
    }
    if (data.containsKey('condition')) {
      context.handle(
        _conditionMeta,
        condition.isAcceptableOrUnknown(data['condition']!, _conditionMeta),
      );
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    }
    if (data.containsKey('purchase_source_id')) {
      context.handle(
        _purchaseSourceIdMeta,
        purchaseSourceId.isAcceptableOrUnknown(
          data['purchase_source_id']!,
          _purchaseSourceIdMeta,
        ),
      );
    }
    if (data.containsKey('storage_location')) {
      context.handle(
        _storageLocationMeta,
        storageLocation.isAcceptableOrUnknown(
          data['storage_location']!,
          _storageLocationMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('purchase_price_cents')) {
      context.handle(
        _purchasePriceCentsMeta,
        purchasePriceCents.isAcceptableOrUnknown(
          data['purchase_price_cents']!,
          _purchasePriceCentsMeta,
        ),
      );
    }
    if (data.containsKey('purchase_tax_cents')) {
      context.handle(
        _purchaseTaxCentsMeta,
        purchaseTaxCents.isAcceptableOrUnknown(
          data['purchase_tax_cents']!,
          _purchaseTaxCentsMeta,
        ),
      );
    }
    if (data.containsKey('inbound_shipping_cents')) {
      context.handle(
        _inboundShippingCentsMeta,
        inboundShippingCents.isAcceptableOrUnknown(
          data['inbound_shipping_cents']!,
          _inboundShippingCentsMeta,
        ),
      );
    }
    if (data.containsKey('other_costs_cents')) {
      context.handle(
        _otherCostsCentsMeta,
        otherCostsCents.isAcceptableOrUnknown(
          data['other_costs_cents']!,
          _otherCostsCentsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Item map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Item(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      sizeVariant: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}size_variant'],
      ),
      condition: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}condition'],
      ),
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      status: $ItemsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      ),
      purchaseSourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_source_id'],
      ),
      storageLocation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_location'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      purchasePriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_price_cents'],
      )!,
      purchaseTaxCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_tax_cents'],
      )!,
      inboundShippingCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inbound_shipping_cents'],
      )!,
      otherCostsCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}other_costs_cents'],
      )!,
    );
  }

  @override
  $ItemsTable createAlias(String alias) {
    return $ItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ItemStatus, String, String> $converterstatus =
      const EnumNameConverter<ItemStatus>(ItemStatus.values);
}

class Item extends DataClass implements Insertable<Item> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final String name;
  final int? categoryId;
  final String? brand;
  final String? sizeVariant;
  final String? condition;
  final String? sku;
  final int quantity;
  final ItemStatus status;
  final DateTime? purchaseDate;
  final int? purchaseSourceId;
  final String? storageLocation;
  final String? notes;

  /// Costs per unit, in cents.
  final int purchasePriceCents;
  final int purchaseTaxCents;
  final int inboundShippingCents;
  final int otherCostsCents;
  const Item({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.name,
    this.categoryId,
    this.brand,
    this.sizeVariant,
    this.condition,
    this.sku,
    required this.quantity,
    required this.status,
    this.purchaseDate,
    this.purchaseSourceId,
    this.storageLocation,
    this.notes,
    required this.purchasePriceCents,
    required this.purchaseTaxCents,
    required this.inboundShippingCents,
    required this.otherCostsCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || sizeVariant != null) {
      map['size_variant'] = Variable<String>(sizeVariant);
    }
    if (!nullToAbsent || condition != null) {
      map['condition'] = Variable<String>(condition);
    }
    if (!nullToAbsent || sku != null) {
      map['sku'] = Variable<String>(sku);
    }
    map['quantity'] = Variable<int>(quantity);
    {
      map['status'] = Variable<String>(
        $ItemsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || purchaseDate != null) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate);
    }
    if (!nullToAbsent || purchaseSourceId != null) {
      map['purchase_source_id'] = Variable<int>(purchaseSourceId);
    }
    if (!nullToAbsent || storageLocation != null) {
      map['storage_location'] = Variable<String>(storageLocation);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['purchase_price_cents'] = Variable<int>(purchasePriceCents);
    map['purchase_tax_cents'] = Variable<int>(purchaseTaxCents);
    map['inbound_shipping_cents'] = Variable<int>(inboundShippingCents);
    map['other_costs_cents'] = Variable<int>(otherCostsCents);
    return map;
  }

  ItemsCompanion toCompanion(bool nullToAbsent) {
    return ItemsCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      name: Value(name),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      sizeVariant: sizeVariant == null && nullToAbsent
          ? const Value.absent()
          : Value(sizeVariant),
      condition: condition == null && nullToAbsent
          ? const Value.absent()
          : Value(condition),
      sku: sku == null && nullToAbsent ? const Value.absent() : Value(sku),
      quantity: Value(quantity),
      status: Value(status),
      purchaseDate: purchaseDate == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseDate),
      purchaseSourceId: purchaseSourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseSourceId),
      storageLocation: storageLocation == null && nullToAbsent
          ? const Value.absent()
          : Value(storageLocation),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      purchasePriceCents: Value(purchasePriceCents),
      purchaseTaxCents: Value(purchaseTaxCents),
      inboundShippingCents: Value(inboundShippingCents),
      otherCostsCents: Value(otherCostsCents),
    );
  }

  factory Item.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Item(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      brand: serializer.fromJson<String?>(json['brand']),
      sizeVariant: serializer.fromJson<String?>(json['sizeVariant']),
      condition: serializer.fromJson<String?>(json['condition']),
      sku: serializer.fromJson<String?>(json['sku']),
      quantity: serializer.fromJson<int>(json['quantity']),
      status: $ItemsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      purchaseDate: serializer.fromJson<DateTime?>(json['purchaseDate']),
      purchaseSourceId: serializer.fromJson<int?>(json['purchaseSourceId']),
      storageLocation: serializer.fromJson<String?>(json['storageLocation']),
      notes: serializer.fromJson<String?>(json['notes']),
      purchasePriceCents: serializer.fromJson<int>(json['purchasePriceCents']),
      purchaseTaxCents: serializer.fromJson<int>(json['purchaseTaxCents']),
      inboundShippingCents: serializer.fromJson<int>(
        json['inboundShippingCents'],
      ),
      otherCostsCents: serializer.fromJson<int>(json['otherCostsCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'categoryId': serializer.toJson<int?>(categoryId),
      'brand': serializer.toJson<String?>(brand),
      'sizeVariant': serializer.toJson<String?>(sizeVariant),
      'condition': serializer.toJson<String?>(condition),
      'sku': serializer.toJson<String?>(sku),
      'quantity': serializer.toJson<int>(quantity),
      'status': serializer.toJson<String>(
        $ItemsTable.$converterstatus.toJson(status),
      ),
      'purchaseDate': serializer.toJson<DateTime?>(purchaseDate),
      'purchaseSourceId': serializer.toJson<int?>(purchaseSourceId),
      'storageLocation': serializer.toJson<String?>(storageLocation),
      'notes': serializer.toJson<String?>(notes),
      'purchasePriceCents': serializer.toJson<int>(purchasePriceCents),
      'purchaseTaxCents': serializer.toJson<int>(purchaseTaxCents),
      'inboundShippingCents': serializer.toJson<int>(inboundShippingCents),
      'otherCostsCents': serializer.toJson<int>(otherCostsCents),
    };
  }

  Item copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    String? name,
    Value<int?> categoryId = const Value.absent(),
    Value<String?> brand = const Value.absent(),
    Value<String?> sizeVariant = const Value.absent(),
    Value<String?> condition = const Value.absent(),
    Value<String?> sku = const Value.absent(),
    int? quantity,
    ItemStatus? status,
    Value<DateTime?> purchaseDate = const Value.absent(),
    Value<int?> purchaseSourceId = const Value.absent(),
    Value<String?> storageLocation = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    int? purchasePriceCents,
    int? purchaseTaxCents,
    int? inboundShippingCents,
    int? otherCostsCents,
  }) => Item(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    name: name ?? this.name,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    brand: brand.present ? brand.value : this.brand,
    sizeVariant: sizeVariant.present ? sizeVariant.value : this.sizeVariant,
    condition: condition.present ? condition.value : this.condition,
    sku: sku.present ? sku.value : this.sku,
    quantity: quantity ?? this.quantity,
    status: status ?? this.status,
    purchaseDate: purchaseDate.present ? purchaseDate.value : this.purchaseDate,
    purchaseSourceId: purchaseSourceId.present
        ? purchaseSourceId.value
        : this.purchaseSourceId,
    storageLocation: storageLocation.present
        ? storageLocation.value
        : this.storageLocation,
    notes: notes.present ? notes.value : this.notes,
    purchasePriceCents: purchasePriceCents ?? this.purchasePriceCents,
    purchaseTaxCents: purchaseTaxCents ?? this.purchaseTaxCents,
    inboundShippingCents: inboundShippingCents ?? this.inboundShippingCents,
    otherCostsCents: otherCostsCents ?? this.otherCostsCents,
  );
  Item copyWithCompanion(ItemsCompanion data) {
    return Item(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      brand: data.brand.present ? data.brand.value : this.brand,
      sizeVariant: data.sizeVariant.present
          ? data.sizeVariant.value
          : this.sizeVariant,
      condition: data.condition.present ? data.condition.value : this.condition,
      sku: data.sku.present ? data.sku.value : this.sku,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      status: data.status.present ? data.status.value : this.status,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      purchaseSourceId: data.purchaseSourceId.present
          ? data.purchaseSourceId.value
          : this.purchaseSourceId,
      storageLocation: data.storageLocation.present
          ? data.storageLocation.value
          : this.storageLocation,
      notes: data.notes.present ? data.notes.value : this.notes,
      purchasePriceCents: data.purchasePriceCents.present
          ? data.purchasePriceCents.value
          : this.purchasePriceCents,
      purchaseTaxCents: data.purchaseTaxCents.present
          ? data.purchaseTaxCents.value
          : this.purchaseTaxCents,
      inboundShippingCents: data.inboundShippingCents.present
          ? data.inboundShippingCents.value
          : this.inboundShippingCents,
      otherCostsCents: data.otherCostsCents.present
          ? data.otherCostsCents.value
          : this.otherCostsCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Item(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('brand: $brand, ')
          ..write('sizeVariant: $sizeVariant, ')
          ..write('condition: $condition, ')
          ..write('sku: $sku, ')
          ..write('quantity: $quantity, ')
          ..write('status: $status, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchaseSourceId: $purchaseSourceId, ')
          ..write('storageLocation: $storageLocation, ')
          ..write('notes: $notes, ')
          ..write('purchasePriceCents: $purchasePriceCents, ')
          ..write('purchaseTaxCents: $purchaseTaxCents, ')
          ..write('inboundShippingCents: $inboundShippingCents, ')
          ..write('otherCostsCents: $otherCostsCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncId,
    createdAt,
    updatedAt,
    id,
    name,
    categoryId,
    brand,
    sizeVariant,
    condition,
    sku,
    quantity,
    status,
    purchaseDate,
    purchaseSourceId,
    storageLocation,
    notes,
    purchasePriceCents,
    purchaseTaxCents,
    inboundShippingCents,
    otherCostsCents,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Item &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.name == this.name &&
          other.categoryId == this.categoryId &&
          other.brand == this.brand &&
          other.sizeVariant == this.sizeVariant &&
          other.condition == this.condition &&
          other.sku == this.sku &&
          other.quantity == this.quantity &&
          other.status == this.status &&
          other.purchaseDate == this.purchaseDate &&
          other.purchaseSourceId == this.purchaseSourceId &&
          other.storageLocation == this.storageLocation &&
          other.notes == this.notes &&
          other.purchasePriceCents == this.purchasePriceCents &&
          other.purchaseTaxCents == this.purchaseTaxCents &&
          other.inboundShippingCents == this.inboundShippingCents &&
          other.otherCostsCents == this.otherCostsCents);
}

class ItemsCompanion extends UpdateCompanion<Item> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<String> name;
  final Value<int?> categoryId;
  final Value<String?> brand;
  final Value<String?> sizeVariant;
  final Value<String?> condition;
  final Value<String?> sku;
  final Value<int> quantity;
  final Value<ItemStatus> status;
  final Value<DateTime?> purchaseDate;
  final Value<int?> purchaseSourceId;
  final Value<String?> storageLocation;
  final Value<String?> notes;
  final Value<int> purchasePriceCents;
  final Value<int> purchaseTaxCents;
  final Value<int> inboundShippingCents;
  final Value<int> otherCostsCents;
  const ItemsCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.brand = const Value.absent(),
    this.sizeVariant = const Value.absent(),
    this.condition = const Value.absent(),
    this.sku = const Value.absent(),
    this.quantity = const Value.absent(),
    this.status = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchaseSourceId = const Value.absent(),
    this.storageLocation = const Value.absent(),
    this.notes = const Value.absent(),
    this.purchasePriceCents = const Value.absent(),
    this.purchaseTaxCents = const Value.absent(),
    this.inboundShippingCents = const Value.absent(),
    this.otherCostsCents = const Value.absent(),
  });
  ItemsCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required String name,
    this.categoryId = const Value.absent(),
    this.brand = const Value.absent(),
    this.sizeVariant = const Value.absent(),
    this.condition = const Value.absent(),
    this.sku = const Value.absent(),
    this.quantity = const Value.absent(),
    this.status = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.purchaseSourceId = const Value.absent(),
    this.storageLocation = const Value.absent(),
    this.notes = const Value.absent(),
    this.purchasePriceCents = const Value.absent(),
    this.purchaseTaxCents = const Value.absent(),
    this.inboundShippingCents = const Value.absent(),
    this.otherCostsCents = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Item> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? categoryId,
    Expression<String>? brand,
    Expression<String>? sizeVariant,
    Expression<String>? condition,
    Expression<String>? sku,
    Expression<int>? quantity,
    Expression<String>? status,
    Expression<DateTime>? purchaseDate,
    Expression<int>? purchaseSourceId,
    Expression<String>? storageLocation,
    Expression<String>? notes,
    Expression<int>? purchasePriceCents,
    Expression<int>? purchaseTaxCents,
    Expression<int>? inboundShippingCents,
    Expression<int>? otherCostsCents,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (categoryId != null) 'category_id': categoryId,
      if (brand != null) 'brand': brand,
      if (sizeVariant != null) 'size_variant': sizeVariant,
      if (condition != null) 'condition': condition,
      if (sku != null) 'sku': sku,
      if (quantity != null) 'quantity': quantity,
      if (status != null) 'status': status,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (purchaseSourceId != null) 'purchase_source_id': purchaseSourceId,
      if (storageLocation != null) 'storage_location': storageLocation,
      if (notes != null) 'notes': notes,
      if (purchasePriceCents != null)
        'purchase_price_cents': purchasePriceCents,
      if (purchaseTaxCents != null) 'purchase_tax_cents': purchaseTaxCents,
      if (inboundShippingCents != null)
        'inbound_shipping_cents': inboundShippingCents,
      if (otherCostsCents != null) 'other_costs_cents': otherCostsCents,
    });
  }

  ItemsCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<String>? name,
    Value<int?>? categoryId,
    Value<String?>? brand,
    Value<String?>? sizeVariant,
    Value<String?>? condition,
    Value<String?>? sku,
    Value<int>? quantity,
    Value<ItemStatus>? status,
    Value<DateTime?>? purchaseDate,
    Value<int?>? purchaseSourceId,
    Value<String?>? storageLocation,
    Value<String?>? notes,
    Value<int>? purchasePriceCents,
    Value<int>? purchaseTaxCents,
    Value<int>? inboundShippingCents,
    Value<int>? otherCostsCents,
  }) {
    return ItemsCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      brand: brand ?? this.brand,
      sizeVariant: sizeVariant ?? this.sizeVariant,
      condition: condition ?? this.condition,
      sku: sku ?? this.sku,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      purchaseSourceId: purchaseSourceId ?? this.purchaseSourceId,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      purchasePriceCents: purchasePriceCents ?? this.purchasePriceCents,
      purchaseTaxCents: purchaseTaxCents ?? this.purchaseTaxCents,
      inboundShippingCents: inboundShippingCents ?? this.inboundShippingCents,
      otherCostsCents: otherCostsCents ?? this.otherCostsCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (sizeVariant.present) {
      map['size_variant'] = Variable<String>(sizeVariant.value);
    }
    if (condition.present) {
      map['condition'] = Variable<String>(condition.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ItemsTable.$converterstatus.toSql(status.value),
      );
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (purchaseSourceId.present) {
      map['purchase_source_id'] = Variable<int>(purchaseSourceId.value);
    }
    if (storageLocation.present) {
      map['storage_location'] = Variable<String>(storageLocation.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (purchasePriceCents.present) {
      map['purchase_price_cents'] = Variable<int>(purchasePriceCents.value);
    }
    if (purchaseTaxCents.present) {
      map['purchase_tax_cents'] = Variable<int>(purchaseTaxCents.value);
    }
    if (inboundShippingCents.present) {
      map['inbound_shipping_cents'] = Variable<int>(inboundShippingCents.value);
    }
    if (otherCostsCents.present) {
      map['other_costs_cents'] = Variable<int>(otherCostsCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemsCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('categoryId: $categoryId, ')
          ..write('brand: $brand, ')
          ..write('sizeVariant: $sizeVariant, ')
          ..write('condition: $condition, ')
          ..write('sku: $sku, ')
          ..write('quantity: $quantity, ')
          ..write('status: $status, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('purchaseSourceId: $purchaseSourceId, ')
          ..write('storageLocation: $storageLocation, ')
          ..write('notes: $notes, ')
          ..write('purchasePriceCents: $purchasePriceCents, ')
          ..write('purchaseTaxCents: $purchaseTaxCents, ')
          ..write('inboundShippingCents: $inboundShippingCents, ')
          ..write('otherCostsCents: $otherCostsCents')
          ..write(')'))
        .toString();
  }
}

class $ItemFieldValuesTable extends ItemFieldValues
    with TableInfo<$ItemFieldValuesTable, ItemFieldValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemFieldValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _fieldIdMeta = const VerificationMeta(
    'fieldId',
  );
  @override
  late final GeneratedColumn<int> fieldId = GeneratedColumn<int>(
    'field_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES category_fields (id)',
    ),
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    itemId,
    fieldId,
    value,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_field_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemFieldValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('field_id')) {
      context.handle(
        _fieldIdMeta,
        fieldId.isAcceptableOrUnknown(data['field_id']!, _fieldIdMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemFieldValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemFieldValue(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      fieldId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}field_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $ItemFieldValuesTable createAlias(String alias) {
    return $ItemFieldValuesTable(attachedDatabase, alias);
  }
}

class ItemFieldValue extends DataClass implements Insertable<ItemFieldValue> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final int itemId;
  final int fieldId;
  final String value;
  const ItemFieldValue({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.itemId,
    required this.fieldId,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['field_id'] = Variable<int>(fieldId);
    map['value'] = Variable<String>(value);
    return map;
  }

  ItemFieldValuesCompanion toCompanion(bool nullToAbsent) {
    return ItemFieldValuesCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      itemId: Value(itemId),
      fieldId: Value(fieldId),
      value: Value(value),
    );
  }

  factory ItemFieldValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemFieldValue(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      fieldId: serializer.fromJson<int>(json['fieldId']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'fieldId': serializer.toJson<int>(fieldId),
      'value': serializer.toJson<String>(value),
    };
  }

  ItemFieldValue copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    int? itemId,
    int? fieldId,
    String? value,
  }) => ItemFieldValue(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    fieldId: fieldId ?? this.fieldId,
    value: value ?? this.value,
  );
  ItemFieldValue copyWithCompanion(ItemFieldValuesCompanion data) {
    return ItemFieldValue(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      fieldId: data.fieldId.present ? data.fieldId.value : this.fieldId,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemFieldValue(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('fieldId: $fieldId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(syncId, createdAt, updatedAt, id, itemId, fieldId, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemFieldValue &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.fieldId == this.fieldId &&
          other.value == this.value);
}

class ItemFieldValuesCompanion extends UpdateCompanion<ItemFieldValue> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<int> itemId;
  final Value<int> fieldId;
  final Value<String> value;
  const ItemFieldValuesCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.fieldId = const Value.absent(),
    this.value = const Value.absent(),
  });
  ItemFieldValuesCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required int itemId,
    required int fieldId,
    required String value,
  }) : itemId = Value(itemId),
       fieldId = Value(fieldId),
       value = Value(value);
  static Insertable<ItemFieldValue> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? fieldId,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (fieldId != null) 'field_id': fieldId,
      if (value != null) 'value': value,
    });
  }

  ItemFieldValuesCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<int>? itemId,
    Value<int>? fieldId,
    Value<String>? value,
  }) {
    return ItemFieldValuesCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      fieldId: fieldId ?? this.fieldId,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (fieldId.present) {
      map['field_id'] = Variable<int>(fieldId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemFieldValuesCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('fieldId: $fieldId, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $ItemPhotosTable extends ItemPhotos
    with TableInfo<$ItemPhotosTable, ItemPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _localPathMeta = const VerificationMeta(
    'localPath',
  );
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
    'local_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remotePathMeta = const VerificationMeta(
    'remotePath',
  );
  @override
  late final GeneratedColumn<String> remotePath = GeneratedColumn<String>(
    'remote_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    itemId,
    localPath,
    remotePath,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('local_path')) {
      context.handle(
        _localPathMeta,
        localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta),
      );
    } else if (isInserting) {
      context.missing(_localPathMeta);
    }
    if (data.containsKey('remote_path')) {
      context.handle(
        _remotePathMeta,
        remotePath.isAcceptableOrUnknown(data['remote_path']!, _remotePathMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemPhoto(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      localPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_path'],
      )!,
      remotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_path'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ItemPhotosTable createAlias(String alias) {
    return $ItemPhotosTable(attachedDatabase, alias);
  }
}

class ItemPhoto extends DataClass implements Insertable<ItemPhoto> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final int itemId;
  final String localPath;
  final String? remotePath;
  final int sortOrder;
  const ItemPhoto({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.itemId,
    required this.localPath,
    this.remotePath,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['local_path'] = Variable<String>(localPath);
    if (!nullToAbsent || remotePath != null) {
      map['remote_path'] = Variable<String>(remotePath);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ItemPhotosCompanion toCompanion(bool nullToAbsent) {
    return ItemPhotosCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      itemId: Value(itemId),
      localPath: Value(localPath),
      remotePath: remotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(remotePath),
      sortOrder: Value(sortOrder),
    );
  }

  factory ItemPhoto.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemPhoto(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      localPath: serializer.fromJson<String>(json['localPath']),
      remotePath: serializer.fromJson<String?>(json['remotePath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'localPath': serializer.toJson<String>(localPath),
      'remotePath': serializer.toJson<String?>(remotePath),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  ItemPhoto copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    int? itemId,
    String? localPath,
    Value<String?> remotePath = const Value.absent(),
    int? sortOrder,
  }) => ItemPhoto(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    localPath: localPath ?? this.localPath,
    remotePath: remotePath.present ? remotePath.value : this.remotePath,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  ItemPhoto copyWithCompanion(ItemPhotosCompanion data) {
    return ItemPhoto(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      remotePath: data.remotePath.present
          ? data.remotePath.value
          : this.remotePath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemPhoto(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncId,
    createdAt,
    updatedAt,
    id,
    itemId,
    localPath,
    remotePath,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemPhoto &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.localPath == this.localPath &&
          other.remotePath == this.remotePath &&
          other.sortOrder == this.sortOrder);
}

class ItemPhotosCompanion extends UpdateCompanion<ItemPhoto> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<int> itemId;
  final Value<String> localPath;
  final Value<String?> remotePath;
  final Value<int> sortOrder;
  const ItemPhotosCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.localPath = const Value.absent(),
    this.remotePath = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  ItemPhotosCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required int itemId,
    required String localPath,
    this.remotePath = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : itemId = Value(itemId),
       localPath = Value(localPath);
  static Insertable<ItemPhoto> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? localPath,
    Expression<String>? remotePath,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (localPath != null) 'local_path': localPath,
      if (remotePath != null) 'remote_path': remotePath,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  ItemPhotosCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<int>? itemId,
    Value<String>? localPath,
    Value<String?>? remotePath,
    Value<int>? sortOrder,
  }) {
    return ItemPhotosCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      localPath: localPath ?? this.localPath,
      remotePath: remotePath ?? this.remotePath,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (remotePath.present) {
      map['remote_path'] = Variable<String>(remotePath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemPhotosCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('localPath: $localPath, ')
          ..write('remotePath: $remotePath, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES items (id)',
    ),
  );
  static const VerificationMeta _platformIdMeta = const VerificationMeta(
    'platformId',
  );
  @override
  late final GeneratedColumn<int> platformId = GeneratedColumn<int>(
    'platform_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES platforms (id)',
    ),
  );
  static const VerificationMeta _soldAtMeta = const VerificationMeta('soldAt');
  @override
  late final GeneratedColumn<DateTime> soldAt = GeneratedColumn<DateTime>(
    'sold_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _salePriceCentsMeta = const VerificationMeta(
    'salePriceCents',
  );
  @override
  late final GeneratedColumn<int> salePriceCents = GeneratedColumn<int>(
    'sale_price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformFeesCentsMeta = const VerificationMeta(
    'platformFeesCents',
  );
  @override
  late final GeneratedColumn<int> platformFeesCents = GeneratedColumn<int>(
    'platform_fees_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _outboundShippingCentsMeta =
      const VerificationMeta('outboundShippingCents');
  @override
  late final GeneratedColumn<int> outboundShippingCents = GeneratedColumn<int>(
    'outbound_shipping_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _packagingCentsMeta = const VerificationMeta(
    'packagingCents',
  );
  @override
  late final GeneratedColumn<int> packagingCents = GeneratedColumn<int>(
    'packaging_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _trackingNumberMeta = const VerificationMeta(
    'trackingNumber',
  );
  @override
  late final GeneratedColumn<String> trackingNumber = GeneratedColumn<String>(
    'tracking_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    itemId,
    platformId,
    soldAt,
    quantity,
    salePriceCents,
    platformFeesCents,
    outboundShippingCents,
    packagingCents,
    trackingNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('platform_id')) {
      context.handle(
        _platformIdMeta,
        platformId.isAcceptableOrUnknown(data['platform_id']!, _platformIdMeta),
      );
    }
    if (data.containsKey('sold_at')) {
      context.handle(
        _soldAtMeta,
        soldAt.isAcceptableOrUnknown(data['sold_at']!, _soldAtMeta),
      );
    } else if (isInserting) {
      context.missing(_soldAtMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('sale_price_cents')) {
      context.handle(
        _salePriceCentsMeta,
        salePriceCents.isAcceptableOrUnknown(
          data['sale_price_cents']!,
          _salePriceCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salePriceCentsMeta);
    }
    if (data.containsKey('platform_fees_cents')) {
      context.handle(
        _platformFeesCentsMeta,
        platformFeesCents.isAcceptableOrUnknown(
          data['platform_fees_cents']!,
          _platformFeesCentsMeta,
        ),
      );
    }
    if (data.containsKey('outbound_shipping_cents')) {
      context.handle(
        _outboundShippingCentsMeta,
        outboundShippingCents.isAcceptableOrUnknown(
          data['outbound_shipping_cents']!,
          _outboundShippingCentsMeta,
        ),
      );
    }
    if (data.containsKey('packaging_cents')) {
      context.handle(
        _packagingCentsMeta,
        packagingCents.isAcceptableOrUnknown(
          data['packaging_cents']!,
          _packagingCentsMeta,
        ),
      );
    }
    if (data.containsKey('tracking_number')) {
      context.handle(
        _trackingNumberMeta,
        trackingNumber.isAcceptableOrUnknown(
          data['tracking_number']!,
          _trackingNumberMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      platformId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}platform_id'],
      ),
      soldAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sold_at'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      salePriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_price_cents'],
      )!,
      platformFeesCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}platform_fees_cents'],
      )!,
      outboundShippingCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}outbound_shipping_cents'],
      )!,
      packagingCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}packaging_cents'],
      )!,
      trackingNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracking_number'],
      ),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final int itemId;
  final int? platformId;
  final DateTime soldAt;
  final int quantity;
  final int salePriceCents;
  final int platformFeesCents;
  final int outboundShippingCents;
  final int packagingCents;
  final String? trackingNumber;
  const Sale({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.itemId,
    this.platformId,
    required this.soldAt,
    required this.quantity,
    required this.salePriceCents,
    required this.platformFeesCents,
    required this.outboundShippingCents,
    required this.packagingCents,
    this.trackingNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    if (!nullToAbsent || platformId != null) {
      map['platform_id'] = Variable<int>(platformId);
    }
    map['sold_at'] = Variable<DateTime>(soldAt);
    map['quantity'] = Variable<int>(quantity);
    map['sale_price_cents'] = Variable<int>(salePriceCents);
    map['platform_fees_cents'] = Variable<int>(platformFeesCents);
    map['outbound_shipping_cents'] = Variable<int>(outboundShippingCents);
    map['packaging_cents'] = Variable<int>(packagingCents);
    if (!nullToAbsent || trackingNumber != null) {
      map['tracking_number'] = Variable<String>(trackingNumber);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      itemId: Value(itemId),
      platformId: platformId == null && nullToAbsent
          ? const Value.absent()
          : Value(platformId),
      soldAt: Value(soldAt),
      quantity: Value(quantity),
      salePriceCents: Value(salePriceCents),
      platformFeesCents: Value(platformFeesCents),
      outboundShippingCents: Value(outboundShippingCents),
      packagingCents: Value(packagingCents),
      trackingNumber: trackingNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(trackingNumber),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      platformId: serializer.fromJson<int?>(json['platformId']),
      soldAt: serializer.fromJson<DateTime>(json['soldAt']),
      quantity: serializer.fromJson<int>(json['quantity']),
      salePriceCents: serializer.fromJson<int>(json['salePriceCents']),
      platformFeesCents: serializer.fromJson<int>(json['platformFeesCents']),
      outboundShippingCents: serializer.fromJson<int>(
        json['outboundShippingCents'],
      ),
      packagingCents: serializer.fromJson<int>(json['packagingCents']),
      trackingNumber: serializer.fromJson<String?>(json['trackingNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'platformId': serializer.toJson<int?>(platformId),
      'soldAt': serializer.toJson<DateTime>(soldAt),
      'quantity': serializer.toJson<int>(quantity),
      'salePriceCents': serializer.toJson<int>(salePriceCents),
      'platformFeesCents': serializer.toJson<int>(platformFeesCents),
      'outboundShippingCents': serializer.toJson<int>(outboundShippingCents),
      'packagingCents': serializer.toJson<int>(packagingCents),
      'trackingNumber': serializer.toJson<String?>(trackingNumber),
    };
  }

  Sale copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    int? itemId,
    Value<int?> platformId = const Value.absent(),
    DateTime? soldAt,
    int? quantity,
    int? salePriceCents,
    int? platformFeesCents,
    int? outboundShippingCents,
    int? packagingCents,
    Value<String?> trackingNumber = const Value.absent(),
  }) => Sale(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    platformId: platformId.present ? platformId.value : this.platformId,
    soldAt: soldAt ?? this.soldAt,
    quantity: quantity ?? this.quantity,
    salePriceCents: salePriceCents ?? this.salePriceCents,
    platformFeesCents: platformFeesCents ?? this.platformFeesCents,
    outboundShippingCents: outboundShippingCents ?? this.outboundShippingCents,
    packagingCents: packagingCents ?? this.packagingCents,
    trackingNumber: trackingNumber.present
        ? trackingNumber.value
        : this.trackingNumber,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      platformId: data.platformId.present
          ? data.platformId.value
          : this.platformId,
      soldAt: data.soldAt.present ? data.soldAt.value : this.soldAt,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      salePriceCents: data.salePriceCents.present
          ? data.salePriceCents.value
          : this.salePriceCents,
      platformFeesCents: data.platformFeesCents.present
          ? data.platformFeesCents.value
          : this.platformFeesCents,
      outboundShippingCents: data.outboundShippingCents.present
          ? data.outboundShippingCents.value
          : this.outboundShippingCents,
      packagingCents: data.packagingCents.present
          ? data.packagingCents.value
          : this.packagingCents,
      trackingNumber: data.trackingNumber.present
          ? data.trackingNumber.value
          : this.trackingNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('platformId: $platformId, ')
          ..write('soldAt: $soldAt, ')
          ..write('quantity: $quantity, ')
          ..write('salePriceCents: $salePriceCents, ')
          ..write('platformFeesCents: $platformFeesCents, ')
          ..write('outboundShippingCents: $outboundShippingCents, ')
          ..write('packagingCents: $packagingCents, ')
          ..write('trackingNumber: $trackingNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncId,
    createdAt,
    updatedAt,
    id,
    itemId,
    platformId,
    soldAt,
    quantity,
    salePriceCents,
    platformFeesCents,
    outboundShippingCents,
    packagingCents,
    trackingNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.platformId == this.platformId &&
          other.soldAt == this.soldAt &&
          other.quantity == this.quantity &&
          other.salePriceCents == this.salePriceCents &&
          other.platformFeesCents == this.platformFeesCents &&
          other.outboundShippingCents == this.outboundShippingCents &&
          other.packagingCents == this.packagingCents &&
          other.trackingNumber == this.trackingNumber);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<int> itemId;
  final Value<int?> platformId;
  final Value<DateTime> soldAt;
  final Value<int> quantity;
  final Value<int> salePriceCents;
  final Value<int> platformFeesCents;
  final Value<int> outboundShippingCents;
  final Value<int> packagingCents;
  final Value<String?> trackingNumber;
  const SalesCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.platformId = const Value.absent(),
    this.soldAt = const Value.absent(),
    this.quantity = const Value.absent(),
    this.salePriceCents = const Value.absent(),
    this.platformFeesCents = const Value.absent(),
    this.outboundShippingCents = const Value.absent(),
    this.packagingCents = const Value.absent(),
    this.trackingNumber = const Value.absent(),
  });
  SalesCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required int itemId,
    this.platformId = const Value.absent(),
    required DateTime soldAt,
    this.quantity = const Value.absent(),
    required int salePriceCents,
    this.platformFeesCents = const Value.absent(),
    this.outboundShippingCents = const Value.absent(),
    this.packagingCents = const Value.absent(),
    this.trackingNumber = const Value.absent(),
  }) : itemId = Value(itemId),
       soldAt = Value(soldAt),
       salePriceCents = Value(salePriceCents);
  static Insertable<Sale> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? platformId,
    Expression<DateTime>? soldAt,
    Expression<int>? quantity,
    Expression<int>? salePriceCents,
    Expression<int>? platformFeesCents,
    Expression<int>? outboundShippingCents,
    Expression<int>? packagingCents,
    Expression<String>? trackingNumber,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (platformId != null) 'platform_id': platformId,
      if (soldAt != null) 'sold_at': soldAt,
      if (quantity != null) 'quantity': quantity,
      if (salePriceCents != null) 'sale_price_cents': salePriceCents,
      if (platformFeesCents != null) 'platform_fees_cents': platformFeesCents,
      if (outboundShippingCents != null)
        'outbound_shipping_cents': outboundShippingCents,
      if (packagingCents != null) 'packaging_cents': packagingCents,
      if (trackingNumber != null) 'tracking_number': trackingNumber,
    });
  }

  SalesCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<int>? itemId,
    Value<int?>? platformId,
    Value<DateTime>? soldAt,
    Value<int>? quantity,
    Value<int>? salePriceCents,
    Value<int>? platformFeesCents,
    Value<int>? outboundShippingCents,
    Value<int>? packagingCents,
    Value<String?>? trackingNumber,
  }) {
    return SalesCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      platformId: platformId ?? this.platformId,
      soldAt: soldAt ?? this.soldAt,
      quantity: quantity ?? this.quantity,
      salePriceCents: salePriceCents ?? this.salePriceCents,
      platformFeesCents: platformFeesCents ?? this.platformFeesCents,
      outboundShippingCents:
          outboundShippingCents ?? this.outboundShippingCents,
      packagingCents: packagingCents ?? this.packagingCents,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (platformId.present) {
      map['platform_id'] = Variable<int>(platformId.value);
    }
    if (soldAt.present) {
      map['sold_at'] = Variable<DateTime>(soldAt.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (salePriceCents.present) {
      map['sale_price_cents'] = Variable<int>(salePriceCents.value);
    }
    if (platformFeesCents.present) {
      map['platform_fees_cents'] = Variable<int>(platformFeesCents.value);
    }
    if (outboundShippingCents.present) {
      map['outbound_shipping_cents'] = Variable<int>(
        outboundShippingCents.value,
      );
    }
    if (packagingCents.present) {
      map['packaging_cents'] = Variable<int>(packagingCents.value);
    }
    if (trackingNumber.present) {
      map['tracking_number'] = Variable<String>(trackingNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('platformId: $platformId, ')
          ..write('soldAt: $soldAt, ')
          ..write('quantity: $quantity, ')
          ..write('salePriceCents: $salePriceCents, ')
          ..write('platformFeesCents: $platformFeesCents, ')
          ..write('outboundShippingCents: $outboundShippingCents, ')
          ..write('packagingCents: $packagingCents, ')
          ..write('trackingNumber: $trackingNumber')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _syncIdMeta = const VerificationMeta('syncId');
  @override
  late final GeneratedColumn<String> syncId = GeneratedColumn<String>(
    'sync_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
    clientDefault: newSyncId,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spentAtMeta = const VerificationMeta(
    'spentAt',
  );
  @override
  late final GeneratedColumn<DateTime> spentAt = GeneratedColumn<DateTime>(
    'spent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _milesMeta = const VerificationMeta('miles');
  @override
  late final GeneratedColumn<double> miles = GeneratedColumn<double>(
    'miles',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    syncId,
    createdAt,
    updatedAt,
    id,
    description,
    kind,
    spentAt,
    amountCents,
    miles,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sync_id')) {
      context.handle(
        _syncIdMeta,
        syncId.isAcceptableOrUnknown(data['sync_id']!, _syncIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('spent_at')) {
      context.handle(
        _spentAtMeta,
        spentAt.isAcceptableOrUnknown(data['spent_at']!, _spentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_spentAtMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('miles')) {
      context.handle(
        _milesMeta,
        miles.isAcceptableOrUnknown(data['miles']!, _milesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      syncId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      spentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}spent_at'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      miles: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}miles'],
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String syncId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int id;
  final String description;
  final String kind;
  final DateTime spentAt;
  final int amountCents;
  final double? miles;
  const Expense({
    required this.syncId,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.description,
    required this.kind,
    required this.spentAt,
    required this.amountCents,
    this.miles,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sync_id'] = Variable<String>(syncId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    map['kind'] = Variable<String>(kind);
    map['spent_at'] = Variable<DateTime>(spentAt);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || miles != null) {
      map['miles'] = Variable<double>(miles);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      syncId: Value(syncId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      id: Value(id),
      description: Value(description),
      kind: Value(kind),
      spentAt: Value(spentAt),
      amountCents: Value(amountCents),
      miles: miles == null && nullToAbsent
          ? const Value.absent()
          : Value(miles),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      syncId: serializer.fromJson<String>(json['syncId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      kind: serializer.fromJson<String>(json['kind']),
      spentAt: serializer.fromJson<DateTime>(json['spentAt']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      miles: serializer.fromJson<double?>(json['miles']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'syncId': serializer.toJson<String>(syncId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'kind': serializer.toJson<String>(kind),
      'spentAt': serializer.toJson<DateTime>(spentAt),
      'amountCents': serializer.toJson<int>(amountCents),
      'miles': serializer.toJson<double?>(miles),
    };
  }

  Expense copyWith({
    String? syncId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id,
    String? description,
    String? kind,
    DateTime? spentAt,
    int? amountCents,
    Value<double?> miles = const Value.absent(),
  }) => Expense(
    syncId: syncId ?? this.syncId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    id: id ?? this.id,
    description: description ?? this.description,
    kind: kind ?? this.kind,
    spentAt: spentAt ?? this.spentAt,
    amountCents: amountCents ?? this.amountCents,
    miles: miles.present ? miles.value : this.miles,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      syncId: data.syncId.present ? data.syncId.value : this.syncId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      id: data.id.present ? data.id.value : this.id,
      description: data.description.present
          ? data.description.value
          : this.description,
      kind: data.kind.present ? data.kind.value : this.kind,
      spentAt: data.spentAt.present ? data.spentAt.value : this.spentAt,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      miles: data.miles.present ? data.miles.value : this.miles,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('kind: $kind, ')
          ..write('spentAt: $spentAt, ')
          ..write('amountCents: $amountCents, ')
          ..write('miles: $miles')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    syncId,
    createdAt,
    updatedAt,
    id,
    description,
    kind,
    spentAt,
    amountCents,
    miles,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.syncId == this.syncId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.id == this.id &&
          other.description == this.description &&
          other.kind == this.kind &&
          other.spentAt == this.spentAt &&
          other.amountCents == this.amountCents &&
          other.miles == this.miles);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> syncId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> id;
  final Value<String> description;
  final Value<String> kind;
  final Value<DateTime> spentAt;
  final Value<int> amountCents;
  final Value<double?> miles;
  const ExpensesCompanion({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.kind = const Value.absent(),
    this.spentAt = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.miles = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.syncId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.id = const Value.absent(),
    required String description,
    required String kind,
    required DateTime spentAt,
    required int amountCents,
    this.miles = const Value.absent(),
  }) : description = Value(description),
       kind = Value(kind),
       spentAt = Value(spentAt),
       amountCents = Value(amountCents);
  static Insertable<Expense> custom({
    Expression<String>? syncId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? id,
    Expression<String>? description,
    Expression<String>? kind,
    Expression<DateTime>? spentAt,
    Expression<int>? amountCents,
    Expression<double>? miles,
  }) {
    return RawValuesInsertable({
      if (syncId != null) 'sync_id': syncId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (kind != null) 'kind': kind,
      if (spentAt != null) 'spent_at': spentAt,
      if (amountCents != null) 'amount_cents': amountCents,
      if (miles != null) 'miles': miles,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? syncId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? id,
    Value<String>? description,
    Value<String>? kind,
    Value<DateTime>? spentAt,
    Value<int>? amountCents,
    Value<double?>? miles,
  }) {
    return ExpensesCompanion(
      syncId: syncId ?? this.syncId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      description: description ?? this.description,
      kind: kind ?? this.kind,
      spentAt: spentAt ?? this.spentAt,
      amountCents: amountCents ?? this.amountCents,
      miles: miles ?? this.miles,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (syncId.present) {
      map['sync_id'] = Variable<String>(syncId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (spentAt.present) {
      map['spent_at'] = Variable<DateTime>(spentAt.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (miles.present) {
      map['miles'] = Variable<double>(miles.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('syncId: $syncId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('kind: $kind, ')
          ..write('spentAt: $spentAt, ')
          ..write('amountCents: $amountCents, ')
          ..write('miles: $miles')
          ..write(')'))
        .toString();
  }
}

abstract class _$GrimstockDatabase extends GeneratedDatabase {
  _$GrimstockDatabase(QueryExecutor e) : super(e);
  $GrimstockDatabaseManager get managers => $GrimstockDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $CategoryFieldsTable categoryFields = $CategoryFieldsTable(this);
  late final $PlatformsTable platforms = $PlatformsTable(this);
  late final $PurchaseSourcesTable purchaseSources = $PurchaseSourcesTable(
    this,
  );
  late final $ItemsTable items = $ItemsTable(this);
  late final $ItemFieldValuesTable itemFieldValues = $ItemFieldValuesTable(
    this,
  );
  late final $ItemPhotosTable itemPhotos = $ItemPhotosTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    categoryFields,
    platforms,
    purchaseSources,
    items,
    itemFieldValues,
    itemPhotos,
    sales,
    expenses,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  required String name,
  Value<int> sortOrder,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  Value<String> name,
  Value<int> sortOrder,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$GrimstockDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CategoryFieldsTable, List<CategoryField>>
  _categoryFieldsRefsTable(_$GrimstockDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryFields,
        aliasName: 'categories__id__category_fields__category_id',
      );

  $$CategoryFieldsTableProcessedTableManager get categoryFieldsRefs {
    final manager = $$CategoryFieldsTableTableManager(
      $_db,
      $_db.categoryFields,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoryFieldsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemsTable, List<Item>> _itemsRefsTable(
    _$GrimstockDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'categories__id__items__category_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$GrimstockDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoryFieldsRefs(
    Expression<bool> Function($$CategoryFieldsTableFilterComposer f) f,
  ) {
    final $$CategoryFieldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryFields,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryFieldsTableFilterComposer(
            $db: $db,
            $table: $db.categoryFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> categoryFieldsRefs<T extends Object>(
    Expression<T> Function($$CategoryFieldsTableAnnotationComposer a) f,
  ) {
    final $$CategoryFieldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryFields,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryFieldsTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool categoryFieldsRefs, bool itemsRefs})
        > {
  $$CategoriesTableTableManager(_$GrimstockDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> sortOrder = const Value.absent(),
              }) => CategoriesCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryFieldsRefs = false, itemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoryFieldsRefs) db.categoryFields,
                    if (itemsRefs) db.items,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoryFieldsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          CategoryField
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._categoryFieldsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryFieldsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemsRefs)
                        await $_getPrefetchedData<
                          Category,
                          $CategoriesTable,
                          Item
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._itemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).itemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool categoryFieldsRefs, bool itemsRefs})
    >;
typedef $$CategoryFieldsTableCreateCompanionBuilder =
    CategoryFieldsCompanion Function({
      Value<String> syncId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      required int categoryId,
      required String label,
      Value<int> sortOrder,
    });
typedef $$CategoryFieldsTableUpdateCompanionBuilder =
    CategoryFieldsCompanion Function({
      Value<String> syncId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<int> categoryId,
      Value<String> label,
      Value<int> sortOrder,
    });

final class $$CategoryFieldsTableReferences
    extends
        BaseReferences<
          _$GrimstockDatabase,
          $CategoryFieldsTable,
          CategoryField
        > {
  $$CategoryFieldsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$GrimstockDatabase db) =>
      db.categories.createAlias('category_fields__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemFieldValuesTable, List<ItemFieldValue>>
  _itemFieldValuesRefsTable(_$GrimstockDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.itemFieldValues,
        aliasName: 'category_fields__id__item_field_values__field_id',
      );

  $$ItemFieldValuesTableProcessedTableManager get itemFieldValuesRefs {
    final manager = $$ItemFieldValuesTableTableManager(
      $_db,
      $_db.itemFieldValues,
    ).filter((f) => f.fieldId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _itemFieldValuesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoryFieldsTableFilterComposer
    extends Composer<_$GrimstockDatabase, $CategoryFieldsTable> {
  $$CategoryFieldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemFieldValuesRefs(
    Expression<bool> Function($$ItemFieldValuesTableFilterComposer f) f,
  ) {
    final $$ItemFieldValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemFieldValues,
      getReferencedColumn: (t) => t.fieldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemFieldValuesTableFilterComposer(
            $db: $db,
            $table: $db.itemFieldValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryFieldsTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $CategoryFieldsTable> {
  $$CategoryFieldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryFieldsTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $CategoryFieldsTable> {
  $$CategoryFieldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemFieldValuesRefs<T extends Object>(
    Expression<T> Function($$ItemFieldValuesTableAnnotationComposer a) f,
  ) {
    final $$ItemFieldValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemFieldValues,
      getReferencedColumn: (t) => t.fieldId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemFieldValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.itemFieldValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoryFieldsTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $CategoryFieldsTable,
          CategoryField,
          $$CategoryFieldsTableFilterComposer,
          $$CategoryFieldsTableOrderingComposer,
          $$CategoryFieldsTableAnnotationComposer,
          $$CategoryFieldsTableCreateCompanionBuilder,
          $$CategoryFieldsTableUpdateCompanionBuilder,
          (CategoryField, $$CategoryFieldsTableReferences),
          CategoryField,
          PrefetchHooks Function({bool categoryId, bool itemFieldValuesRefs})
        > {
  $$CategoryFieldsTableTableManager(
    _$GrimstockDatabase db,
    $CategoryFieldsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryFieldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryFieldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryFieldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => CategoryFieldsCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                categoryId: categoryId,
                label: label,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required int categoryId,
                required String label,
                Value<int> sortOrder = const Value.absent(),
              }) => CategoryFieldsCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                categoryId: categoryId,
                label: label,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoryFieldsTable, CategoryField>(table),
                  $$CategoryFieldsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, itemFieldValuesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemFieldValuesRefs) db.itemFieldValues,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$CategoryFieldsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$CategoryFieldsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemFieldValuesRefs)
                        await $_getPrefetchedData<
                          CategoryField,
                          $CategoryFieldsTable,
                          ItemFieldValue
                        >(
                          currentTable: table,
                          referencedTable: $$CategoryFieldsTableReferences
                              ._itemFieldValuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoryFieldsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemFieldValuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fieldId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoryFieldsTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $CategoryFieldsTable,
      CategoryField,
      $$CategoryFieldsTableFilterComposer,
      $$CategoryFieldsTableOrderingComposer,
      $$CategoryFieldsTableAnnotationComposer,
      $$CategoryFieldsTableCreateCompanionBuilder,
      $$CategoryFieldsTableUpdateCompanionBuilder,
      (CategoryField, $$CategoryFieldsTableReferences),
      CategoryField,
      PrefetchHooks Function({bool categoryId, bool itemFieldValuesRefs})
    >;
typedef $$PlatformsTableCreateCompanionBuilder = PlatformsCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  required String name,
  Value<int> feeBasisPoints,
  Value<int> fixedFeeCents,
  Value<int> processingBasisPoints,
  Value<bool> isCustom,
});
typedef $$PlatformsTableUpdateCompanionBuilder = PlatformsCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  Value<String> name,
  Value<int> feeBasisPoints,
  Value<int> fixedFeeCents,
  Value<int> processingBasisPoints,
  Value<bool> isCustom,
});

final class $$PlatformsTableReferences
    extends BaseReferences<_$GrimstockDatabase, $PlatformsTable, Platform> {
  $$PlatformsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
    _$GrimstockDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: 'platforms__id__sales__platform_id',
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.platformId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlatformsTableFilterComposer
    extends Composer<_$GrimstockDatabase, $PlatformsTable> {
  $$PlatformsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get feeBasisPoints => $composableBuilder(
    column: $table.feeBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fixedFeeCents => $composableBuilder(
    column: $table.fixedFeeCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processingBasisPoints => $composableBuilder(
    column: $table.processingBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlatformsTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $PlatformsTable> {
  $$PlatformsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get feeBasisPoints => $composableBuilder(
    column: $table.feeBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fixedFeeCents => $composableBuilder(
    column: $table.fixedFeeCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processingBasisPoints => $composableBuilder(
    column: $table.processingBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlatformsTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $PlatformsTable> {
  $$PlatformsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get feeBasisPoints => $composableBuilder(
    column: $table.feeBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fixedFeeCents => $composableBuilder(
    column: $table.fixedFeeCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get processingBasisPoints => $composableBuilder(
    column: $table.processingBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.platformId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlatformsTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $PlatformsTable,
          Platform,
          $$PlatformsTableFilterComposer,
          $$PlatformsTableOrderingComposer,
          $$PlatformsTableAnnotationComposer,
          $$PlatformsTableCreateCompanionBuilder,
          $$PlatformsTableUpdateCompanionBuilder,
          (Platform, $$PlatformsTableReferences),
          Platform,
          PrefetchHooks Function({bool salesRefs})
        > {
  $$PlatformsTableTableManager(_$GrimstockDatabase db, $PlatformsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlatformsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlatformsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlatformsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> feeBasisPoints = const Value.absent(),
                Value<int> fixedFeeCents = const Value.absent(),
                Value<int> processingBasisPoints = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => PlatformsCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
                feeBasisPoints: feeBasisPoints,
                fixedFeeCents: fixedFeeCents,
                processingBasisPoints: processingBasisPoints,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> feeBasisPoints = const Value.absent(),
                Value<int> fixedFeeCents = const Value.absent(),
                Value<int> processingBasisPoints = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => PlatformsCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
                feeBasisPoints: feeBasisPoints,
                fixedFeeCents: fixedFeeCents,
                processingBasisPoints: processingBasisPoints,
                isCustom: isCustom,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlatformsTable, Platform>(table),
                  $$PlatformsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (salesRefs) db.sales],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (salesRefs)
                    await $_getPrefetchedData<Platform, $PlatformsTable, Sale>(
                      currentTable: table,
                      referencedTable: $$PlatformsTableReferences
                          ._salesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PlatformsTableReferences(db, table, p0).salesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.platformId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlatformsTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $PlatformsTable,
      Platform,
      $$PlatformsTableFilterComposer,
      $$PlatformsTableOrderingComposer,
      $$PlatformsTableAnnotationComposer,
      $$PlatformsTableCreateCompanionBuilder,
      $$PlatformsTableUpdateCompanionBuilder,
      (Platform, $$PlatformsTableReferences),
      Platform,
      PrefetchHooks Function({bool salesRefs})
    >;
typedef $$PurchaseSourcesTableCreateCompanionBuilder =
    PurchaseSourcesCompanion Function({
      Value<String> syncId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      required String name,
    });
typedef $$PurchaseSourcesTableUpdateCompanionBuilder =
    PurchaseSourcesCompanion Function({
      Value<String> syncId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<String> name,
    });

final class $$PurchaseSourcesTableReferences
    extends
        BaseReferences<
          _$GrimstockDatabase,
          $PurchaseSourcesTable,
          PurchaseSource
        > {
  $$PurchaseSourcesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ItemsTable, List<Item>> _itemsRefsTable(
    _$GrimstockDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.items,
    aliasName: 'purchase_sources__id__items__purchase_source_id',
  );

  $$ItemsTableProcessedTableManager get itemsRefs {
    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.purchaseSourceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PurchaseSourcesTableFilterComposer
    extends Composer<_$GrimstockDatabase, $PurchaseSourcesTable> {
  $$PurchaseSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> itemsRefs(
    Expression<bool> Function($$ItemsTableFilterComposer f) f,
  ) {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.purchaseSourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchaseSourcesTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $PurchaseSourcesTable> {
  $$PurchaseSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseSourcesTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $PurchaseSourcesTable> {
  $$PurchaseSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> itemsRefs<T extends Object>(
    Expression<T> Function($$ItemsTableAnnotationComposer a) f,
  ) {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.purchaseSourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PurchaseSourcesTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $PurchaseSourcesTable,
          PurchaseSource,
          $$PurchaseSourcesTableFilterComposer,
          $$PurchaseSourcesTableOrderingComposer,
          $$PurchaseSourcesTableAnnotationComposer,
          $$PurchaseSourcesTableCreateCompanionBuilder,
          $$PurchaseSourcesTableUpdateCompanionBuilder,
          (PurchaseSource, $$PurchaseSourcesTableReferences),
          PurchaseSource,
          PrefetchHooks Function({bool itemsRefs})
        > {
  $$PurchaseSourcesTableTableManager(
    _$GrimstockDatabase db,
    $PurchaseSourcesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
              }) => PurchaseSourcesCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
              }) => PurchaseSourcesCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PurchaseSourcesTable, PurchaseSource>(table),
                  $$PurchaseSourcesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (itemsRefs) db.items],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (itemsRefs)
                    await $_getPrefetchedData<
                      PurchaseSource,
                      $PurchaseSourcesTable,
                      Item
                    >(
                      currentTable: table,
                      referencedTable: $$PurchaseSourcesTableReferences
                          ._itemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PurchaseSourcesTableReferences(
                            db,
                            table,
                            p0,
                          ).itemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.purchaseSourceId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PurchaseSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $PurchaseSourcesTable,
      PurchaseSource,
      $$PurchaseSourcesTableFilterComposer,
      $$PurchaseSourcesTableOrderingComposer,
      $$PurchaseSourcesTableAnnotationComposer,
      $$PurchaseSourcesTableCreateCompanionBuilder,
      $$PurchaseSourcesTableUpdateCompanionBuilder,
      (PurchaseSource, $$PurchaseSourcesTableReferences),
      PurchaseSource,
      PrefetchHooks Function({bool itemsRefs})
    >;
typedef $$ItemsTableCreateCompanionBuilder = ItemsCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  required String name,
  Value<int?> categoryId,
  Value<String?> brand,
  Value<String?> sizeVariant,
  Value<String?> condition,
  Value<String?> sku,
  Value<int> quantity,
  Value<ItemStatus> status,
  Value<DateTime?> purchaseDate,
  Value<int?> purchaseSourceId,
  Value<String?> storageLocation,
  Value<String?> notes,
  Value<int> purchasePriceCents,
  Value<int> purchaseTaxCents,
  Value<int> inboundShippingCents,
  Value<int> otherCostsCents,
});
typedef $$ItemsTableUpdateCompanionBuilder = ItemsCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  Value<String> name,
  Value<int?> categoryId,
  Value<String?> brand,
  Value<String?> sizeVariant,
  Value<String?> condition,
  Value<String?> sku,
  Value<int> quantity,
  Value<ItemStatus> status,
  Value<DateTime?> purchaseDate,
  Value<int?> purchaseSourceId,
  Value<String?> storageLocation,
  Value<String?> notes,
  Value<int> purchasePriceCents,
  Value<int> purchaseTaxCents,
  Value<int> inboundShippingCents,
  Value<int> otherCostsCents,
});

final class $$ItemsTableReferences
    extends BaseReferences<_$GrimstockDatabase, $ItemsTable, Item> {
  $$ItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$GrimstockDatabase db) =>
      db.categories.createAlias('items__category_id__categories__id');

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<int>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PurchaseSourcesTable _purchaseSourceIdTable(_$GrimstockDatabase db) =>
      db.purchaseSources.createAlias(
        'items__purchase_source_id__purchase_sources__id',
      );

  $$PurchaseSourcesTableProcessedTableManager? get purchaseSourceId {
    final $_column = $_itemColumn<int>('purchase_source_id');
    if ($_column == null) return null;
    final manager = $$PurchaseSourcesTableTableManager(
      $_db,
      $_db.purchaseSources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_purchaseSourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ItemFieldValuesTable, List<ItemFieldValue>>
  _itemFieldValuesRefsTable(_$GrimstockDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.itemFieldValues,
        aliasName: 'items__id__item_field_values__item_id',
      );

  $$ItemFieldValuesTableProcessedTableManager get itemFieldValuesRefs {
    final manager = $$ItemFieldValuesTableTableManager(
      $_db,
      $_db.itemFieldValues,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _itemFieldValuesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ItemPhotosTable, List<ItemPhoto>>
  _itemPhotosRefsTable(_$GrimstockDatabase db) => MultiTypedResultKey.fromTable(
    db.itemPhotos,
    aliasName: 'items__id__item_photos__item_id',
  );

  $$ItemPhotosTableProcessedTableManager get itemPhotosRefs {
    final manager = $$ItemPhotosTableTableManager(
      $_db,
      $_db.itemPhotos,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_itemPhotosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
    _$GrimstockDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: 'items__id__sales__item_id',
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.itemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ItemsTableFilterComposer
    extends Composer<_$GrimstockDatabase, $ItemsTable> {
  $$ItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sizeVariant => $composableBuilder(
    column: $table.sizeVariant,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ItemStatus, ItemStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchaseTaxCents => $composableBuilder(
    column: $table.purchaseTaxCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get inboundShippingCents => $composableBuilder(
    column: $table.inboundShippingCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get otherCostsCents => $composableBuilder(
    column: $table.otherCostsCents,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseSourcesTableFilterComposer get purchaseSourceId {
    final $$PurchaseSourcesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseSourceId,
      referencedTable: $db.purchaseSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseSourcesTableFilterComposer(
            $db: $db,
            $table: $db.purchaseSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> itemFieldValuesRefs(
    Expression<bool> Function($$ItemFieldValuesTableFilterComposer f) f,
  ) {
    final $$ItemFieldValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemFieldValues,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemFieldValuesTableFilterComposer(
            $db: $db,
            $table: $db.itemFieldValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> itemPhotosRefs(
    Expression<bool> Function($$ItemPhotosTableFilterComposer f) f,
  ) {
    final $$ItemPhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableFilterComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $ItemsTable> {
  $$ItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sizeVariant => $composableBuilder(
    column: $table.sizeVariant,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get condition => $composableBuilder(
    column: $table.condition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchaseTaxCents => $composableBuilder(
    column: $table.purchaseTaxCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get inboundShippingCents => $composableBuilder(
    column: $table.inboundShippingCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get otherCostsCents => $composableBuilder(
    column: $table.otherCostsCents,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseSourcesTableOrderingComposer get purchaseSourceId {
    final $$PurchaseSourcesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseSourceId,
      referencedTable: $db.purchaseSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseSourcesTableOrderingComposer(
            $db: $db,
            $table: $db.purchaseSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemsTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $ItemsTable> {
  $$ItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get sizeVariant => $composableBuilder(
    column: $table.sizeVariant,
    builder: (column) => column,
  );

  GeneratedColumn<String> get condition =>
      $composableBuilder(column: $table.condition, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ItemStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storageLocation => $composableBuilder(
    column: $table.storageLocation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get purchasePriceCents => $composableBuilder(
    column: $table.purchasePriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get purchaseTaxCents => $composableBuilder(
    column: $table.purchaseTaxCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get inboundShippingCents => $composableBuilder(
    column: $table.inboundShippingCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get otherCostsCents => $composableBuilder(
    column: $table.otherCostsCents,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PurchaseSourcesTableAnnotationComposer get purchaseSourceId {
    final $$PurchaseSourcesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.purchaseSourceId,
      referencedTable: $db.purchaseSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PurchaseSourcesTableAnnotationComposer(
            $db: $db,
            $table: $db.purchaseSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> itemFieldValuesRefs<T extends Object>(
    Expression<T> Function($$ItemFieldValuesTableAnnotationComposer a) f,
  ) {
    final $$ItemFieldValuesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemFieldValues,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemFieldValuesTableAnnotationComposer(
            $db: $db,
            $table: $db.itemFieldValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> itemPhotosRefs<T extends Object>(
    Expression<T> Function($$ItemPhotosTableAnnotationComposer a) f,
  ) {
    final $$ItemPhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.itemPhotos,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemPhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.itemPhotos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.itemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ItemsTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $ItemsTable,
          Item,
          $$ItemsTableFilterComposer,
          $$ItemsTableOrderingComposer,
          $$ItemsTableAnnotationComposer,
          $$ItemsTableCreateCompanionBuilder,
          $$ItemsTableUpdateCompanionBuilder,
          (Item, $$ItemsTableReferences),
          Item,
          PrefetchHooks Function({
            bool categoryId,
            bool purchaseSourceId,
            bool itemFieldValuesRefs,
            bool itemPhotosRefs,
            bool salesRefs,
          })
        > {
  $$ItemsTableTableManager(_$GrimstockDatabase db, $ItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> sizeVariant = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<ItemStatus> status = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<int?> purchaseSourceId = const Value.absent(),
                Value<String?> storageLocation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> purchasePriceCents = const Value.absent(),
                Value<int> purchaseTaxCents = const Value.absent(),
                Value<int> inboundShippingCents = const Value.absent(),
                Value<int> otherCostsCents = const Value.absent(),
              }) => ItemsCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
                categoryId: categoryId,
                brand: brand,
                sizeVariant: sizeVariant,
                condition: condition,
                sku: sku,
                quantity: quantity,
                status: status,
                purchaseDate: purchaseDate,
                purchaseSourceId: purchaseSourceId,
                storageLocation: storageLocation,
                notes: notes,
                purchasePriceCents: purchasePriceCents,
                purchaseTaxCents: purchaseTaxCents,
                inboundShippingCents: inboundShippingCents,
                otherCostsCents: otherCostsCents,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> categoryId = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> sizeVariant = const Value.absent(),
                Value<String?> condition = const Value.absent(),
                Value<String?> sku = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<ItemStatus> status = const Value.absent(),
                Value<DateTime?> purchaseDate = const Value.absent(),
                Value<int?> purchaseSourceId = const Value.absent(),
                Value<String?> storageLocation = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> purchasePriceCents = const Value.absent(),
                Value<int> purchaseTaxCents = const Value.absent(),
                Value<int> inboundShippingCents = const Value.absent(),
                Value<int> otherCostsCents = const Value.absent(),
              }) => ItemsCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                name: name,
                categoryId: categoryId,
                brand: brand,
                sizeVariant: sizeVariant,
                condition: condition,
                sku: sku,
                quantity: quantity,
                status: status,
                purchaseDate: purchaseDate,
                purchaseSourceId: purchaseSourceId,
                storageLocation: storageLocation,
                notes: notes,
                purchasePriceCents: purchasePriceCents,
                purchaseTaxCents: purchaseTaxCents,
                inboundShippingCents: inboundShippingCents,
                otherCostsCents: otherCostsCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemsTable, Item>(table),
                  $$ItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                purchaseSourceId = false,
                itemFieldValuesRefs = false,
                itemPhotosRefs = false,
                salesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (itemFieldValuesRefs) db.itemFieldValues,
                    if (itemPhotosRefs) db.itemPhotos,
                    if (salesRefs) db.sales,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$ItemsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$ItemsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (purchaseSourceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.purchaseSourceId,
                            referencedTable: $$ItemsTableReferences
                                ._purchaseSourceIdTable(db),
                            referencedColumn: $$ItemsTableReferences
                                ._purchaseSourceIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (itemFieldValuesRefs)
                        await $_getPrefetchedData<
                          Item,
                          $ItemsTable,
                          ItemFieldValue
                        >(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemFieldValuesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemFieldValuesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (itemPhotosRefs)
                        await $_getPrefetchedData<Item, $ItemsTable, ItemPhoto>(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._itemPhotosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).itemPhotosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (salesRefs)
                        await $_getPrefetchedData<Item, $ItemsTable, Sale>(
                          currentTable: table,
                          referencedTable: $$ItemsTableReferences
                              ._salesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ItemsTableReferences(db, table, p0).salesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.itemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $ItemsTable,
      Item,
      $$ItemsTableFilterComposer,
      $$ItemsTableOrderingComposer,
      $$ItemsTableAnnotationComposer,
      $$ItemsTableCreateCompanionBuilder,
      $$ItemsTableUpdateCompanionBuilder,
      (Item, $$ItemsTableReferences),
      Item,
      PrefetchHooks Function({
        bool categoryId,
        bool purchaseSourceId,
        bool itemFieldValuesRefs,
        bool itemPhotosRefs,
        bool salesRefs,
      })
    >;
typedef $$ItemFieldValuesTableCreateCompanionBuilder =
    ItemFieldValuesCompanion Function({
      Value<String> syncId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      required int itemId,
      required int fieldId,
      required String value,
    });
typedef $$ItemFieldValuesTableUpdateCompanionBuilder =
    ItemFieldValuesCompanion Function({
      Value<String> syncId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> id,
      Value<int> itemId,
      Value<int> fieldId,
      Value<String> value,
    });

final class $$ItemFieldValuesTableReferences
    extends
        BaseReferences<
          _$GrimstockDatabase,
          $ItemFieldValuesTable,
          ItemFieldValue
        > {
  $$ItemFieldValuesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ItemsTable _itemIdTable(_$GrimstockDatabase db) =>
      db.items.createAlias('item_field_values__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoryFieldsTable _fieldIdTable(_$GrimstockDatabase db) => db
      .categoryFields
      .createAlias('item_field_values__field_id__category_fields__id');

  $$CategoryFieldsTableProcessedTableManager get fieldId {
    final $_column = $_itemColumn<int>('field_id')!;

    final manager = $$CategoryFieldsTableTableManager(
      $_db,
      $_db.categoryFields,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fieldIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemFieldValuesTableFilterComposer
    extends Composer<_$GrimstockDatabase, $ItemFieldValuesTable> {
  $$ItemFieldValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryFieldsTableFilterComposer get fieldId {
    final $$CategoryFieldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fieldId,
      referencedTable: $db.categoryFields,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryFieldsTableFilterComposer(
            $db: $db,
            $table: $db.categoryFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemFieldValuesTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $ItemFieldValuesTable> {
  $$ItemFieldValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryFieldsTableOrderingComposer get fieldId {
    final $$CategoryFieldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fieldId,
      referencedTable: $db.categoryFields,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryFieldsTableOrderingComposer(
            $db: $db,
            $table: $db.categoryFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemFieldValuesTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $ItemFieldValuesTable> {
  $$ItemFieldValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoryFieldsTableAnnotationComposer get fieldId {
    final $$CategoryFieldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fieldId,
      referencedTable: $db.categoryFields,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoryFieldsTableAnnotationComposer(
            $db: $db,
            $table: $db.categoryFields,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemFieldValuesTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $ItemFieldValuesTable,
          ItemFieldValue,
          $$ItemFieldValuesTableFilterComposer,
          $$ItemFieldValuesTableOrderingComposer,
          $$ItemFieldValuesTableAnnotationComposer,
          $$ItemFieldValuesTableCreateCompanionBuilder,
          $$ItemFieldValuesTableUpdateCompanionBuilder,
          (ItemFieldValue, $$ItemFieldValuesTableReferences),
          ItemFieldValue,
          PrefetchHooks Function({bool itemId, bool fieldId})
        > {
  $$ItemFieldValuesTableTableManager(
    _$GrimstockDatabase db,
    $ItemFieldValuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemFieldValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemFieldValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemFieldValuesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int> fieldId = const Value.absent(),
                Value<String> value = const Value.absent(),
              }) => ItemFieldValuesCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                itemId: itemId,
                fieldId: fieldId,
                value: value,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required int itemId,
                required int fieldId,
                required String value,
              }) => ItemFieldValuesCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                itemId: itemId,
                fieldId: fieldId,
                value: value,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemFieldValuesTable, ItemFieldValue>(table),
                  $$ItemFieldValuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false, fieldId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ItemFieldValuesTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$ItemFieldValuesTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (fieldId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.fieldId,
                        referencedTable: $$ItemFieldValuesTableReferences
                            ._fieldIdTable(db),
                        referencedColumn: $$ItemFieldValuesTableReferences
                            ._fieldIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemFieldValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $ItemFieldValuesTable,
      ItemFieldValue,
      $$ItemFieldValuesTableFilterComposer,
      $$ItemFieldValuesTableOrderingComposer,
      $$ItemFieldValuesTableAnnotationComposer,
      $$ItemFieldValuesTableCreateCompanionBuilder,
      $$ItemFieldValuesTableUpdateCompanionBuilder,
      (ItemFieldValue, $$ItemFieldValuesTableReferences),
      ItemFieldValue,
      PrefetchHooks Function({bool itemId, bool fieldId})
    >;
typedef $$ItemPhotosTableCreateCompanionBuilder = ItemPhotosCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  required int itemId,
  required String localPath,
  Value<String?> remotePath,
  Value<int> sortOrder,
});
typedef $$ItemPhotosTableUpdateCompanionBuilder = ItemPhotosCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  Value<int> itemId,
  Value<String> localPath,
  Value<String?> remotePath,
  Value<int> sortOrder,
});

final class $$ItemPhotosTableReferences
    extends BaseReferences<_$GrimstockDatabase, $ItemPhotosTable, ItemPhoto> {
  $$ItemPhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$GrimstockDatabase db) =>
      db.items.createAlias('item_photos__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ItemPhotosTableFilterComposer
    extends Composer<_$GrimstockDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localPath => $composableBuilder(
    column: $table.localPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $ItemPhotosTable> {
  $$ItemPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<String> get remotePath => $composableBuilder(
    column: $table.remotePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ItemPhotosTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $ItemPhotosTable,
          ItemPhoto,
          $$ItemPhotosTableFilterComposer,
          $$ItemPhotosTableOrderingComposer,
          $$ItemPhotosTableAnnotationComposer,
          $$ItemPhotosTableCreateCompanionBuilder,
          $$ItemPhotosTableUpdateCompanionBuilder,
          (ItemPhoto, $$ItemPhotosTableReferences),
          ItemPhoto,
          PrefetchHooks Function({bool itemId})
        > {
  $$ItemPhotosTableTableManager(_$GrimstockDatabase db, $ItemPhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<String> localPath = const Value.absent(),
                Value<String?> remotePath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => ItemPhotosCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                itemId: itemId,
                localPath: localPath,
                remotePath: remotePath,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required int itemId,
                required String localPath,
                Value<String?> remotePath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => ItemPhotosCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                itemId: itemId,
                localPath: localPath,
                remotePath: remotePath,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ItemPhotosTable, ItemPhoto>(table),
                  $$ItemPhotosTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$ItemPhotosTableReferences
                            ._itemIdTable(db),
                        referencedColumn: $$ItemPhotosTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ItemPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $ItemPhotosTable,
      ItemPhoto,
      $$ItemPhotosTableFilterComposer,
      $$ItemPhotosTableOrderingComposer,
      $$ItemPhotosTableAnnotationComposer,
      $$ItemPhotosTableCreateCompanionBuilder,
      $$ItemPhotosTableUpdateCompanionBuilder,
      (ItemPhoto, $$ItemPhotosTableReferences),
      ItemPhoto,
      PrefetchHooks Function({bool itemId})
    >;
typedef $$SalesTableCreateCompanionBuilder = SalesCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  required int itemId,
  Value<int?> platformId,
  required DateTime soldAt,
  Value<int> quantity,
  required int salePriceCents,
  Value<int> platformFeesCents,
  Value<int> outboundShippingCents,
  Value<int> packagingCents,
  Value<String?> trackingNumber,
});
typedef $$SalesTableUpdateCompanionBuilder = SalesCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  Value<int> itemId,
  Value<int?> platformId,
  Value<DateTime> soldAt,
  Value<int> quantity,
  Value<int> salePriceCents,
  Value<int> platformFeesCents,
  Value<int> outboundShippingCents,
  Value<int> packagingCents,
  Value<String?> trackingNumber,
});

final class $$SalesTableReferences
    extends BaseReferences<_$GrimstockDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ItemsTable _itemIdTable(_$GrimstockDatabase db) =>
      db.items.createAlias('sales__item_id__items__id');

  $$ItemsTableProcessedTableManager get itemId {
    final $_column = $_itemColumn<int>('item_id')!;

    final manager = $$ItemsTableTableManager(
      $_db,
      $_db.items,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_itemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlatformsTable _platformIdTable(_$GrimstockDatabase db) =>
      db.platforms.createAlias('sales__platform_id__platforms__id');

  $$PlatformsTableProcessedTableManager? get platformId {
    final $_column = $_itemColumn<int>('platform_id');
    if ($_column == null) return null;
    final manager = $$PlatformsTableTableManager(
      $_db,
      $_db.platforms,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_platformIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SalesTableFilterComposer
    extends Composer<_$GrimstockDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salePriceCents => $composableBuilder(
    column: $table.salePriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get platformFeesCents => $composableBuilder(
    column: $table.platformFeesCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get outboundShippingCents => $composableBuilder(
    column: $table.outboundShippingCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packagingCents => $composableBuilder(
    column: $table.packagingCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackingNumber => $composableBuilder(
    column: $table.trackingNumber,
    builder: (column) => ColumnFilters(column),
  );

  $$ItemsTableFilterComposer get itemId {
    final $$ItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableFilterComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlatformsTableFilterComposer get platformId {
    final $$PlatformsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableFilterComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get soldAt => $composableBuilder(
    column: $table.soldAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salePriceCents => $composableBuilder(
    column: $table.salePriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get platformFeesCents => $composableBuilder(
    column: $table.platformFeesCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outboundShippingCents => $composableBuilder(
    column: $table.outboundShippingCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packagingCents => $composableBuilder(
    column: $table.packagingCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackingNumber => $composableBuilder(
    column: $table.trackingNumber,
    builder: (column) => ColumnOrderings(column),
  );

  $$ItemsTableOrderingComposer get itemId {
    final $$ItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableOrderingComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlatformsTableOrderingComposer get platformId {
    final $$PlatformsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableOrderingComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalesTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get soldAt =>
      $composableBuilder(column: $table.soldAt, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get salePriceCents => $composableBuilder(
    column: $table.salePriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get platformFeesCents => $composableBuilder(
    column: $table.platformFeesCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get outboundShippingCents => $composableBuilder(
    column: $table.outboundShippingCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get packagingCents => $composableBuilder(
    column: $table.packagingCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trackingNumber => $composableBuilder(
    column: $table.trackingNumber,
    builder: (column) => column,
  );

  $$ItemsTableAnnotationComposer get itemId {
    final $$ItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.itemId,
      referencedTable: $db.items,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.items,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlatformsTableAnnotationComposer get platformId {
    final $$PlatformsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.platformId,
      referencedTable: $db.platforms,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlatformsTableAnnotationComposer(
            $db: $db,
            $table: $db.platforms,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, $$SalesTableReferences),
          Sale,
          PrefetchHooks Function({bool itemId, bool platformId})
        > {
  $$SalesTableTableManager(_$GrimstockDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int?> platformId = const Value.absent(),
                Value<DateTime> soldAt = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> salePriceCents = const Value.absent(),
                Value<int> platformFeesCents = const Value.absent(),
                Value<int> outboundShippingCents = const Value.absent(),
                Value<int> packagingCents = const Value.absent(),
                Value<String?> trackingNumber = const Value.absent(),
              }) => SalesCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                itemId: itemId,
                platformId: platformId,
                soldAt: soldAt,
                quantity: quantity,
                salePriceCents: salePriceCents,
                platformFeesCents: platformFeesCents,
                outboundShippingCents: outboundShippingCents,
                packagingCents: packagingCents,
                trackingNumber: trackingNumber,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required int itemId,
                Value<int?> platformId = const Value.absent(),
                required DateTime soldAt,
                Value<int> quantity = const Value.absent(),
                required int salePriceCents,
                Value<int> platformFeesCents = const Value.absent(),
                Value<int> outboundShippingCents = const Value.absent(),
                Value<int> packagingCents = const Value.absent(),
                Value<String?> trackingNumber = const Value.absent(),
              }) => SalesCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                itemId: itemId,
                platformId: platformId,
                soldAt: soldAt,
                quantity: quantity,
                salePriceCents: salePriceCents,
                platformFeesCents: platformFeesCents,
                outboundShippingCents: outboundShippingCents,
                packagingCents: packagingCents,
                trackingNumber: trackingNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SalesTable, Sale>(table),
                  $$SalesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({itemId = false, platformId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (itemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.itemId,
                        referencedTable: $$SalesTableReferences._itemIdTable(
                          db,
                        ),
                        referencedColumn: $$SalesTableReferences
                            ._itemIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (platformId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.platformId,
                        referencedTable: $$SalesTableReferences
                            ._platformIdTable(db),
                        referencedColumn: $$SalesTableReferences
                            ._platformIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, $$SalesTableReferences),
      Sale,
      PrefetchHooks Function({bool itemId, bool platformId})
    >;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  required String description,
  required String kind,
  required DateTime spentAt,
  required int amountCents,
  Value<double?> miles,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<String> syncId,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> id,
  Value<String> description,
  Value<String> kind,
  Value<DateTime> spentAt,
  Value<int> amountCents,
  Value<double?> miles,
});

class $$ExpensesTableFilterComposer
    extends Composer<_$GrimstockDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get miles => $composableBuilder(
    column: $table.miles,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$GrimstockDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get syncId => $composableBuilder(
    column: $table.syncId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get spentAt => $composableBuilder(
    column: $table.spentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get miles => $composableBuilder(
    column: $table.miles,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$GrimstockDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get syncId =>
      $composableBuilder(column: $table.syncId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<DateTime> get spentAt =>
      $composableBuilder(column: $table.spentAt, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<double> get miles =>
      $composableBuilder(column: $table.miles, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$GrimstockDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (
            Expense,
            BaseReferences<_$GrimstockDatabase, $ExpensesTable, Expense>,
          ),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$GrimstockDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<DateTime> spentAt = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<double?> miles = const Value.absent(),
              }) => ExpensesCompanion(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                description: description,
                kind: kind,
                spentAt: spentAt,
                amountCents: amountCents,
                miles: miles,
              ),
          createCompanionCallback:
              ({
                Value<String> syncId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> id = const Value.absent(),
                required String description,
                required String kind,
                required DateTime spentAt,
                required int amountCents,
                Value<double?> miles = const Value.absent(),
              }) => ExpensesCompanion.insert(
                syncId: syncId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                id: id,
                description: description,
                kind: kind,
                spentAt: spentAt,
                amountCents: amountCents,
                miles: miles,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, Expense>(table),
                  BaseReferences<_$GrimstockDatabase, $ExpensesTable, Expense>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$GrimstockDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$GrimstockDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;

class $GrimstockDatabaseManager {
  final _$GrimstockDatabase _db;
  $GrimstockDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$CategoryFieldsTableTableManager get categoryFields =>
      $$CategoryFieldsTableTableManager(_db, _db.categoryFields);
  $$PlatformsTableTableManager get platforms =>
      $$PlatformsTableTableManager(_db, _db.platforms);
  $$PurchaseSourcesTableTableManager get purchaseSources =>
      $$PurchaseSourcesTableTableManager(_db, _db.purchaseSources);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db, _db.items);
  $$ItemFieldValuesTableTableManager get itemFieldValues =>
      $$ItemFieldValuesTableTableManager(_db, _db.itemFieldValues);
  $$ItemPhotosTableTableManager get itemPhotos =>
      $$ItemPhotosTableTableManager(_db, _db.itemPhotos);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
}
