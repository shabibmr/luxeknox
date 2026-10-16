// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uom.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Uom extends Uom {
  @override
  final int id;
  @override
  final String code;
  @override
  final String name;
  @override
  final int decimalPlaces;
  @override
  final bool isActive;

  factory _$Uom([void Function(UomBuilder)? updates]) =>
      (UomBuilder()..update(updates))._build();

  _$Uom._(
      {required this.id,
      required this.code,
      required this.name,
      required this.decimalPlaces,
      required this.isActive})
      : super._();
  @override
  Uom rebuild(void Function(UomBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UomBuilder toBuilder() => UomBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Uom &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        decimalPlaces == other.decimalPlaces &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, decimalPlaces.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Uom')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('decimalPlaces', decimalPlaces)
          ..add('isActive', isActive))
        .toString();
  }
}

class UomBuilder implements Builder<Uom, UomBuilder> {
  _$Uom? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _decimalPlaces;
  int? get decimalPlaces => _$this._decimalPlaces;
  set decimalPlaces(int? decimalPlaces) =>
      _$this._decimalPlaces = decimalPlaces;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  UomBuilder() {
    Uom._defaults(this);
  }

  UomBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _decimalPlaces = $v.decimalPlaces;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Uom other) {
    _$v = other as _$Uom;
  }

  @override
  void update(void Function(UomBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Uom build() => _build();

  _$Uom _build() {
    final _$result = _$v ??
        _$Uom._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Uom', 'id'),
          code: BuiltValueNullFieldError.checkNotNull(code, r'Uom', 'code'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'Uom', 'name'),
          decimalPlaces: BuiltValueNullFieldError.checkNotNull(
              decimalPlaces, r'Uom', 'decimalPlaces'),
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'Uom', 'isActive'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
