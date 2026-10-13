// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_code_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxCodeUpdate extends TaxCodeUpdate {
  @override
  final String? name;
  @override
  final String? ratePercent;
  @override
  final bool? isActive;
  @override
  final BuiltList<TaxCodeComponentWrite>? components;

  factory _$TaxCodeUpdate([void Function(TaxCodeUpdateBuilder)? updates]) =>
      (TaxCodeUpdateBuilder()..update(updates))._build();

  _$TaxCodeUpdate._(
      {this.name, this.ratePercent, this.isActive, this.components})
      : super._();
  @override
  TaxCodeUpdate rebuild(void Function(TaxCodeUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxCodeUpdateBuilder toBuilder() => TaxCodeUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxCodeUpdate &&
        name == other.name &&
        ratePercent == other.ratePercent &&
        isActive == other.isActive &&
        components == other.components;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ratePercent.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, components.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxCodeUpdate')
          ..add('name', name)
          ..add('ratePercent', ratePercent)
          ..add('isActive', isActive)
          ..add('components', components))
        .toString();
  }
}

class TaxCodeUpdateBuilder
    implements Builder<TaxCodeUpdate, TaxCodeUpdateBuilder> {
  _$TaxCodeUpdate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

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

  TaxCodeUpdateBuilder() {
    TaxCodeUpdate._defaults(this);
  }

  TaxCodeUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _ratePercent = $v.ratePercent;
      _isActive = $v.isActive;
      _components = $v.components?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxCodeUpdate other) {
    _$v = other as _$TaxCodeUpdate;
  }

  @override
  void update(void Function(TaxCodeUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxCodeUpdate build() => _build();

  _$TaxCodeUpdate _build() {
    _$TaxCodeUpdate _$result;
    try {
      _$result = _$v ??
          _$TaxCodeUpdate._(
            name: name,
            ratePercent: ratePercent,
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
            r'TaxCodeUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
