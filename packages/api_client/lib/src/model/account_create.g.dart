// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountCreate extends AccountCreate {
  @override
  final String name;
  @override
  final AccountType accountType;
  @override
  final int? parentId;
  @override
  final bool? isActive;
  @override
  final bool? isBank;
  @override
  final bool? isControl;
  @override
  final String? controlRole;

  factory _$AccountCreate([void Function(AccountCreateBuilder)? updates]) =>
      (AccountCreateBuilder()..update(updates))._build();

  _$AccountCreate._(
      {required this.name,
      required this.accountType,
      this.parentId,
      this.isActive,
      this.isBank,
      this.isControl,
      this.controlRole})
      : super._();
  @override
  AccountCreate rebuild(void Function(AccountCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountCreateBuilder toBuilder() => AccountCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountCreate &&
        name == other.name &&
        accountType == other.accountType &&
        parentId == other.parentId &&
        isActive == other.isActive &&
        isBank == other.isBank &&
        isControl == other.isControl &&
        controlRole == other.controlRole;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, accountType.hashCode);
    _$hash = $jc(_$hash, parentId.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, isBank.hashCode);
    _$hash = $jc(_$hash, isControl.hashCode);
    _$hash = $jc(_$hash, controlRole.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountCreate')
          ..add('name', name)
          ..add('accountType', accountType)
          ..add('parentId', parentId)
          ..add('isActive', isActive)
          ..add('isBank', isBank)
          ..add('isControl', isControl)
          ..add('controlRole', controlRole))
        .toString();
  }
}

class AccountCreateBuilder
    implements Builder<AccountCreate, AccountCreateBuilder> {
  _$AccountCreate? _$v;

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

  AccountCreateBuilder() {
    AccountCreate._defaults(this);
  }

  AccountCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _accountType = $v.accountType;
      _parentId = $v.parentId;
      _isActive = $v.isActive;
      _isBank = $v.isBank;
      _isControl = $v.isControl;
      _controlRole = $v.controlRole;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountCreate other) {
    _$v = other as _$AccountCreate;
  }

  @override
  void update(void Function(AccountCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountCreate build() => _build();

  _$AccountCreate _build() {
    final _$result = _$v ??
        _$AccountCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'AccountCreate', 'name'),
          accountType: BuiltValueNullFieldError.checkNotNull(
              accountType, r'AccountCreate', 'accountType'),
          parentId: parentId,
          isActive: isActive,
          isBank: isBank,
          isControl: isControl,
          controlRole: controlRole,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
