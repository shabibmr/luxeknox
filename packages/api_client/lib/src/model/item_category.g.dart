// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_category.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ItemCategory extends ItemCategory {
  @override
  final int id;
  @override
  final String name;
  @override
  final int? parentId;
  @override
  final bool isActive;

  factory _$ItemCategory([void Function(ItemCategoryBuilder)? updates]) =>
      (ItemCategoryBuilder()..update(updates))._build();

  _$ItemCategory._(
      {required this.id,
      required this.name,
      this.parentId,
      required this.isActive})
      : super._();
  @override
  ItemCategory rebuild(void Function(ItemCategoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ItemCategoryBuilder toBuilder() => ItemCategoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ItemCategory &&
        id == other.id &&
        name == other.name &&
        parentId == other.parentId &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ItemCategory')
          ..add('id', id)
          ..add('name', name)
          ..add('parentId', parentId)
          ..add('isActive', isActive))
        .toString();
  }
}

class ItemCategoryBuilder
    implements Builder<ItemCategory, ItemCategoryBuilder> {
  _$ItemCategory? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _parentId;
  int? get parentId => _$this._parentId;
  set parentId(int? parentId) => _$this._parentId = parentId;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  ItemCategoryBuilder() {
    ItemCategory._defaults(this);
  }

  ItemCategoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _parentId = $v.parentId;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ItemCategory other) {
    _$v = other as _$ItemCategory;
  }

  @override
  void update(void Function(ItemCategoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ItemCategory build() => _build();

  _$ItemCategory _build() {
    final _$result = _$v ??
        _$ItemCategory._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ItemCategory', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ItemCategory', 'name'),
          parentId: parentId,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'ItemCategory', 'isActive'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
