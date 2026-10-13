// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_code_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxCodeCreate extends TaxCodeCreate {
  @override
  final String name;
  @override
  final String code;
  @override
  final String ratePercent;
  @override
  final bool? isActive;
  @override
  final BuiltList<TaxCodeComponentWrite>? components;

  factory _$TaxCodeCreate([void Function(TaxCodeCreateBuilder)? updates]) =>
      (TaxCodeCreateBuilder()..update(updates))._build();

  _$TaxCodeCreate._(
      {required this.name,
      required this.code,
      required this.ratePercent,
      this.isActive,
      this.components})
      : super._();
  @override
  TaxCodeCreate rebuild(void Function(TaxCodeCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxCodeCreateBuilder toBuilder() => TaxCodeCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxCodeCreate &&
        name == other.name &&
        code == other.code &&
        ratePercent == other.ratePercent &&
        isActive == other.isActive &&
        components == other.components;
  }

  @override
  int get hashCode {
    var _$hash = 0;
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
    return (newBuiltValueToStringHelper(r'TaxCodeCreate')
          ..add('name', name)
          ..add('code', code)
          ..add('ratePercent', ratePercent)
          ..add('isActive', isActive)
          ..add('components', components))
        .toString();
  }
}

class TaxCodeCreateBuilder
    implements Builder<TaxCodeCreate, TaxCodeCreateBuilder> {
  _$TaxCodeCreate? _$v;

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

  ListBuilder<TaxCodeComponentWrite>? _components;
  ListBuilder<TaxCodeComponentWrite> get components =>
      _$this._components ??= ListBuilder<TaxCodeComponentWrite>();
  set components(ListBuilder<TaxCodeComponentWrite>? components) =>
      _$this._components = components;

  TaxCodeCreateBuilder() {
    TaxCodeCreate._defaults(this);
  }

  TaxCodeCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _code = $v.code;
      _ratePercent = $v.ratePercent;
      _isActive = $v.isActive;
      _components = $v.components?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxCodeCreate other) {
    _$v = other as _$TaxCodeCreate;
  }

  @override
  void update(void Function(TaxCodeCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxCodeCreate build() => _build();

  _$TaxCodeCreate _build() {
    _$TaxCodeCreate _$result;
    try {
      _$result = _$v ??
          _$TaxCodeCreate._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'TaxCodeCreate', 'name'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'TaxCodeCreate', 'code'),
            ratePercent: BuiltValueNullFieldError.checkNotNull(
                ratePercent, r'TaxCodeCreate', 'ratePercent'),
            isActive: isActive,
            components: _components?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'components';
        _components?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'TaxCodeCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
