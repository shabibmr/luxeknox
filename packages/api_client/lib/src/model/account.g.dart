// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Account extends Account {
  @override
  final int id;
  @override
  final String code;
  @override
  final String name;
  @override
  final AccountType accountType;
  @override
  final int? parentId;
  @override
  final bool isActive;
  @override
  final bool isBank;
  @override
  final bool isControl;
  @override
  final String? controlRole;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  factory _$Account([void Function(AccountBuilder)? updates]) =>
      (AccountBuilder()..update(updates))._build();

  _$Account._(
      {required this.id,
      required this.code,
      required this.name,
      required this.accountType,
      this.parentId,
      required this.isActive,
      required this.isBank,
      required this.isControl,
      this.controlRole,
      required this.createdAt,
      this.updatedAt})
      : super._();
  @override
  Account rebuild(void Function(AccountBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountBuilder toBuilder() => AccountBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Account &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        accountType == other.accountType &&
        parentId == other.parentId &&
        isActive == other.isActive &&
        isBank == other.isBank &&
        isControl == other.isControl &&
        controlRole == other.controlRole &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, accountType.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, isBank.hashCode);
    _$hash = $jc(_$hash, isControl.hashCode);
    _$hash = $jc(_$hash, controlRole.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Account')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('accountType', accountType)
          ..add('parentId', parentId)
          ..add('isActive', isActive)
          ..add('isBank', isBank)
          ..add('isControl', isControl)
          ..add('controlRole', controlRole)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AccountBuilder implements Builder<Account, AccountBuilder> {
  _$Account? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AccountType? _accountType;
  AccountType? get accountType => _$this._accountType;
  set accountType(AccountType? accountType) =>
      _$this._accountType = accountType;

  int? _parentId;
  int? get parentId => _$this._parentId;
  set parentId(int? parentId) => _$this._parentId = parentId;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _isBank;
  bool? get isBank => _$this._isBank;
  set isBank(bool? isBank) => _$this._isBank = isBank;

  bool? _isControl;
  bool? get isControl => _$this._isControl;
  set isControl(bool? isControl) => _$this._isControl = isControl;

  String? _controlRole;
  String? get controlRole => _$this._controlRole;
  set controlRole(String? controlRole) => _$this._controlRole = controlRole;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  AccountBuilder() {
    Account._defaults(this);
  }

  AccountBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _accountType = $v.accountType;
      _parentId = $v.parentId;
      _isActive = $v.isActive;
      _isBank = $v.isBank;
      _isControl = $v.isControl;
      _controlRole = $v.controlRole;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Account other) {
    _$v = other as _$Account;
  }

  @override
  void update(void Function(AccountBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Account build() => _build();

  _$Account _build() {
    final _$result = _$v ??
        _$Account._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Account', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(code, r'Account', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'Account', 'name'),
          accountType: BuiltValueNullFieldError.checkNotNull(
              accountType, r'Account', 'accountType'),
          parentId: parentId,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'Account', 'isActive'),
          isBank: BuiltValueNullFieldError.checkNotNull(
              isBank, r'Account', 'isBank'),
          isControl: BuiltValueNullFieldError.checkNotNull(
              isControl, r'Account', 'isControl'),
          controlRole: controlRole,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'Account', 'createdAt'),
          updatedAt: updatedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
