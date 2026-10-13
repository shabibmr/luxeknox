// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_code.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxCode extends TaxCode {
  @override
  final int id;
  @override
  final String name;
  @override
  final String code;
  @override
  final String ratePercent;
  @override
  final bool isActive;
  @override
  final BuiltList<TaxCodeComponent> components;

  factory _$TaxCode([void Function(TaxCodeBuilder)? updates]) =>
      (TaxCodeBuilder()..update(updates))._build();

  _$TaxCode._(
      {required this.id,
      required this.name,
      required this.code,
      required this.ratePercent,
      required this.isActive,
      required this.components})
      : super._();
  @override
  TaxCode rebuild(void Function(TaxCodeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxCodeBuilder toBuilder() => TaxCodeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxCode &&
        id == other.id &&
        name == other.name &&
        code == other.code &&
        ratePercent == other.ratePercent &&
        isActive == other.isActive &&
        components == other.components;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, ratePercent.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, components.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxCode')
          ..add('id', id)
          ..add('name', name)
          ..add('code', code)
          ..add('ratePercent', ratePercent)
          ..add('isActive', isActive)
          ..add('components', components))
        .toString();
  }
}

class TaxCodeBuilder implements Builder<TaxCode, TaxCodeBuilder> {
  _$TaxCode? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _ratePercent;
  String? get ratePercent => _$this._ratePercent;
  set ratePercent(String? ratePercent) => _$this._ratePercent = ratePercent;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  ListBuilder<TaxCodeComponent>? _components;
  ListBuilder<TaxCodeComponent> get components =>
      _$this._components ??= ListBuilder<TaxCodeComponent>();
  set components(ListBuilder<TaxCodeComponent>? components) =>
      _$this._components = components;

  TaxCodeBuilder() {
    TaxCode._defaults(this);
  }

  TaxCodeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _code = $v.code;
      _ratePercent = $v.ratePercent;
      _isActive = $v.isActive;
      _components = $v.components.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxCode other) {
    _$v = other as _$TaxCode;
  }

  @override
  void update(void Function(TaxCodeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxCode build() => _build();

  _$TaxCode _build() {
    _$TaxCode _$result;
    try {
      _$result = _$v ??
          _$TaxCode._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'TaxCode', 'id'),
            name:
                BuiltValueNullFieldError.checkNotNull(name, r'TaxCode', 'name'),
            code:
                BuiltValueNullFieldError.checkNotNull(code, r'TaxCode', 'code'),
            ratePercent: BuiltValueNullFieldError.checkNotNull(
                ratePercent, r'TaxCode', 'ratePercent'),
            isActive: BuiltValueNullFieldError.checkNotNull(
                isActive, r'TaxCode', 'isActive'),
            components: components.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'components';
        components.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TaxCode', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
