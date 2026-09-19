// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Dashboard extends Dashboard {
  @override
  final UserType? role;
  @override
  final BuiltMap<String, JsonObject?>? member;
  @override
  final BuiltMap<String, JsonObject?>? trainer;
  @override
  final BuiltMap<String, JsonObject?>? admin;

  factory _$Dashboard([void Function(DashboardBuilder)? updates]) =>
      (DashboardBuilder()..update(updates))._build();

  _$Dashboard._({this.role, this.member, this.trainer, this.admin}) : super._();
  @override
  Dashboard rebuild(void Function(DashboardBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DashboardBuilder toBuilder() => DashboardBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Dashboard &&
        role == other.role &&
        member == other.member &&
        trainer == other.trainer &&
        admin == other.admin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, role.hashCode);
    _$hash = $jc(_$hash, member.hashCode);
    _$hash = $jc(_$hash, trainer.hashCode);
    _$hash = $jc(_$hash, admin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Dashboard')
          ..add('role', role)
          ..add('member', member)
          ..add('trainer', trainer)
          ..add('admin', admin))
        .toString();
  }
}

class DashboardBuilder implements Builder<Dashboard, DashboardBuilder> {
  _$Dashboard? _$v;

  UserType? _role;
  UserType? get role => _$this._role;
  set role(UserType? role) => _$this._role = role;

  MapBuilder<String, JsonObject?>? _member;
  MapBuilder<String, JsonObject?> get member =>
      _$this._member ??= MapBuilder<String, JsonObject?>();
  set member(MapBuilder<String, JsonObject?>? member) =>
      _$this._member = member;

  MapBuilder<String, JsonObject?>? _trainer;
  MapBuilder<String, JsonObject?> get trainer =>
      _$this._trainer ??= MapBuilder<String, JsonObject?>();
  set trainer(MapBuilder<String, JsonObject?>? trainer) =>
      _$this._trainer = trainer;

  MapBuilder<String, JsonObject?>? _admin;
  MapBuilder<String, JsonObject?> get admin =>
      _$this._admin ??= MapBuilder<String, JsonObject?>();
  set admin(MapBuilder<String, JsonObject?>? admin) => _$this._admin = admin;

  DashboardBuilder() {
    Dashboard._defaults(this);
  }

  DashboardBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _role = $v.role;
      _member = $v.member?.toBuilder();
      _trainer = $v.trainer?.toBuilder();
      _admin = $v.admin?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Dashboard other) {
    _$v = other as _$Dashboard;
  }

  @override
  void update(void Function(DashboardBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Dashboard build() => _build();

  _$Dashboard _build() {
    _$Dashboard _$result;
    try {
      _$result = _$v ??
          _$Dashboard._(
            role: role,
            member: _member?.build(),
            trainer: _trainer?.build(),
            admin: _admin?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'member';
        _member?.build();
        _$failedField = 'trainer';
        _trainer?.build();
        _$failedField = 'admin';
        _admin?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Dashboard', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
