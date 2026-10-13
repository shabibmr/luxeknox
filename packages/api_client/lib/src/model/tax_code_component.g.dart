// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_code_component.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxCodeComponent extends TaxCodeComponent {
  @override
  final int id;
  @override
  final int taxCodeId;
  @override
  final String name;
  @override
  final String ratePercent;
  @override
  final int outputAccountId;
  @override
  final int inputAccountId;

  factory _$TaxCodeComponent(
          [void Function(TaxCodeComponentBuilder)? updates]) =>
      (TaxCodeComponentBuilder()..update(updates))._build();

  _$TaxCodeComponent._(
      {required this.id,
      required this.taxCodeId,
      required this.name,
      required this.ratePercent,
      required this.outputAccountId,
      required this.inputAccountId})
      : super._();
  @override
  TaxCodeComponent rebuild(void Function(TaxCodeComponentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxCodeComponentBuilder toBuilder() =>
      TaxCodeComponentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxCodeComponent &&
        id == other.id &&
        taxCodeId == other.taxCodeId &&
        name == other.name &&
        ratePercent == other.ratePercent &&
        outputAccountId == other.outputAccountId &&
        inputAccountId == other.inputAccountId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, taxCodeId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ratePercent.hashCode);
    _$hash = $jc(_$hash, outputAccountId.hashCode);
    _$hash = $jc(_$hash, inputAccountId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxCodeComponent')
          ..add('id', id)
          ..add('taxCodeId', taxCodeId)
          ..add('name', name)
          ..add('ratePercent', ratePercent)
          ..add('outputAccountId', outputAccountId)
          ..add('inputAccountId', inputAccountId))
        .toString();
  }
}

class TaxCodeComponentBuilder
    implements Builder<TaxCodeComponent, TaxCodeComponentBuilder> {
  _$TaxCodeComponent? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _taxCodeId;
  int? get taxCodeId => _$this._taxCodeId;
  set taxCodeId(int? taxCodeId) => _$this._taxCodeId = taxCodeId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _ratePercent;
  String? get ratePercent => _$this._ratePercent;
  set ratePercent(String? ratePercent) => _$this._ratePercent = ratePercent;

  int? _outputAccountId;
  int? get outputAccountId => _$this._outputAccountId;
  set outputAccountId(int? outputAccountId) =>
      _$this._outputAccountId = outputAccountId;

  int? _inputAccountId;
  int? get inputAccountId => _$this._inputAccountId;
  set inputAccountId(int? inputAccountId) =>
      _$this._inputAccountId = inputAccountId;

  TaxCodeComponentBuilder() {
    TaxCodeComponent._defaults(this);
  }

  TaxCodeComponentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _taxCodeId = $v.taxCodeId;
      _name = $v.name;
      _ratePercent = $v.ratePercent;
      _outputAccountId = $v.outputAccountId;
      _inputAccountId = $v.inputAccountId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxCodeComponent other) {
    _$v = other as _$TaxCodeComponent;
  }

  @override
  void update(void Function(TaxCodeComponentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxCodeComponent build() => _build();

  _$TaxCodeComponent _build() {
    final _$result = _$v ??
        _$TaxCodeComponent._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'TaxCodeComponent', 'id'),
          taxCodeId: BuiltValueNullFieldError.checkNotNull(
              taxCodeId, r'TaxCodeComponent', 'taxCodeId'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TaxCodeComponent', 'name'),
          ratePercent: BuiltValueNullFieldError.checkNotNull(
              ratePercent, r'TaxCodeComponent', 'ratePercent'),
          outputAccountId: BuiltValueNullFieldError.checkNotNull(
              outputAccountId, r'TaxCodeComponent', 'outputAccountId'),
          inputAccountId: BuiltValueNullFieldError.checkNotNull(
              inputAccountId, r'TaxCodeComponent', 'inputAccountId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
