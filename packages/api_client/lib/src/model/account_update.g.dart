// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountUpdate extends AccountUpdate {
  @override
  final String? name;
  @override
  final int? parentId;
  @override
  final bool? clearParentId;
  @override
  final bool? isActive;
  @override
  final bool? isBank;

  factory _$AccountUpdate([void Function(AccountUpdateBuilder)? updates]) =>
      (AccountUpdateBuilder()..update(updates))._build();

  _$AccountUpdate._(
      {this.name,
      this.parentId,
      this.clearParentId,
      this.isActive,
      this.isBank})
      : super._();
  @override
  AccountUpdate rebuild(void Function(AccountUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountUpdateBuilder toBuilder() => AccountUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountUpdate &&
        name == other.name &&
        parentId == other.parentId &&
        clearParentId == other.clearParentId &&
        isActive == other.isActive &&
        isBank == other.isBank;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, clearParentId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, isBank.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountUpdate')
          ..add('name', name)
          ..add('parentId', parentId)
          ..add('clearParentId', clearParentId)
          ..add('isActive', isActive)
          ..add('isBank', isBank))
        .toString();
  }
}

class AccountUpdateBuilder
    implements Builder<AccountUpdate, AccountUpdateBuilder> {
  _$AccountUpdate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _parentId;
  int? get parentId => _$this._parentId;
  set parentId(int? parentId) => _$this._parentId = parentId;

  bool? _clearParentId;
  bool? get clearParentId => _$this._clearParentId;
  set clearParentId(bool? clearParentId) =>
      _$this._clearParentId = clearParentId;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _isBank;
  bool? get isBank => _$this._isBank;
  set isBank(bool? isBank) => _$this._isBank = isBank;

  AccountUpdateBuilder() {
    AccountUpdate._defaults(this);
  }

  AccountUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _parentId = $v.parentId;
      _clearParentId = $v.clearParentId;
      _isActive = $v.isActive;
      _isBank = $v.isBank;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountUpdate other) {
    _$v = other as _$AccountUpdate;
  }

  @override
  void update(void Function(AccountUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountUpdate build() => _build();

  _$AccountUpdate _build() {
    final _$result = _$v ??
        _$AccountUpdate._(
          name: name,
          parentId: parentId,
          clearParentId: clearParentId,
          isActive: isActive,
          isBank: isBank,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
