// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_code_component_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TaxCodeComponentWrite extends TaxCodeComponentWrite {
  @override
  final String name;
  @override
  final String ratePercent;
  @override
  final int outputAccountId;
  @override
  final int inputAccountId;

  factory _$TaxCodeComponentWrite(
          [void Function(TaxCodeComponentWriteBuilder)? updates]) =>
      (TaxCodeComponentWriteBuilder()..update(updates))._build();

  _$TaxCodeComponentWrite._(
      {required this.name,
      required this.ratePercent,
      required this.outputAccountId,
      required this.inputAccountId})
      : super._();
  @override
  TaxCodeComponentWrite rebuild(
          void Function(TaxCodeComponentWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaxCodeComponentWriteBuilder toBuilder() =>
      TaxCodeComponentWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TaxCodeComponentWrite &&
        name == other.name &&
        ratePercent == other.ratePercent &&
        outputAccountId == other.outputAccountId &&
        inputAccountId == other.inputAccountId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ratePercent.hashCode);
    _$hash = $jc(_$hash, outputAccountId.hashCode);
    _$hash = $jc(_$hash, inputAccountId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TaxCodeComponentWrite')
          ..add('name', name)
          ..add('ratePercent', ratePercent)
          ..add('outputAccountId', outputAccountId)
          ..add('inputAccountId', inputAccountId))
        .toString();
  }
}

class TaxCodeComponentWriteBuilder
    implements Builder<TaxCodeComponentWrite, TaxCodeComponentWriteBuilder> {
  _$TaxCodeComponentWrite? _$v;

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

  TaxCodeComponentWriteBuilder() {
    TaxCodeComponentWrite._defaults(this);
  }

  TaxCodeComponentWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _ratePercent = $v.ratePercent;
      _outputAccountId = $v.outputAccountId;
      _inputAccountId = $v.inputAccountId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TaxCodeComponentWrite other) {
    _$v = other as _$TaxCodeComponentWrite;
  }

  @override
  void update(void Function(TaxCodeComponentWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TaxCodeComponentWrite build() => _build();

  _$TaxCodeComponentWrite _build() {
    final _$result = _$v ??
        _$TaxCodeComponentWrite._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'TaxCodeComponentWrite', 'name'),
          ratePercent: BuiltValueNullFieldError.checkNotNull(
              ratePercent, r'TaxCodeComponentWrite', 'ratePercent'),
          outputAccountId: BuiltValueNullFieldError.checkNotNull(
              outputAccountId, r'TaxCodeComponentWrite', 'outputAccountId'),
          inputAccountId: BuiltValueNullFieldError.checkNotNull(
              inputAccountId, r'TaxCodeComponentWrite', 'inputAccountId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
