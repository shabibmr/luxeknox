// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_product_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtProductWrite extends PtProductWrite {
  @override
  final String name;
  @override
  final String code;
  @override
  final String? description;
  @override
  final int durationDays;
  @override
  final String basePrice;
  @override
  final String? taxPercentage;
  @override
  final bool? isActive;

  factory _$PtProductWrite([void Function(PtProductWriteBuilder)? updates]) =>
      (PtProductWriteBuilder()..update(updates))._build();

  _$PtProductWrite._(
      {required this.name,
      required this.code,
      this.description,
      required this.durationDays,
      required this.basePrice,
      this.taxPercentage,
      this.isActive})
      : super._();
  @override
  PtProductWrite rebuild(void Function(PtProductWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtProductWriteBuilder toBuilder() => PtProductWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtProductWrite &&
        name == other.name &&
        code == other.code &&
        description == other.description &&
        durationDays == other.durationDays &&
        basePrice == other.basePrice &&
        taxPercentage == other.taxPercentage &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, durationDays.hashCode);
    _$hash = $jc(_$hash, basePrice.hashCode);
    _$hash = $jc(_$hash, taxPercentage.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtProductWrite')
          ..add('name', name)
          ..add('code', code)
          ..add('description', description)
          ..add('durationDays', durationDays)
          ..add('basePrice', basePrice)
          ..add('taxPercentage', taxPercentage)
          ..add('isActive', isActive))
        .toString();
  }
}

class PtProductWriteBuilder
    implements Builder<PtProductWrite, PtProductWriteBuilder> {
  _$PtProductWrite? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  int? _durationDays;
  int? get durationDays => _$this._durationDays;
  set durationDays(int? durationDays) => _$this._durationDays = durationDays;

  String? _basePrice;
  String? get basePrice => _$this._basePrice;
  set basePrice(String? basePrice) => _$this._basePrice = basePrice;

  String? _taxPercentage;
  String? get taxPercentage => _$this._taxPercentage;
  set taxPercentage(String? taxPercentage) =>
      _$this._taxPercentage = taxPercentage;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  PtProductWriteBuilder() {
    PtProductWrite._defaults(this);
  }

  PtProductWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _code = $v.code;
      _description = $v.description;
      _durationDays = $v.durationDays;
      _basePrice = $v.basePrice;
      _taxPercentage = $v.taxPercentage;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtProductWrite other) {
    _$v = other as _$PtProductWrite;
  }

  @override
  void update(void Function(PtProductWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtProductWrite build() => _build();

  _$PtProductWrite _build() {
    final _$result = _$v ??
        _$PtProductWrite._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PtProductWrite', 'name'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'PtProductWrite', 'code'),
          description: description,
          durationDays: BuiltValueNullFieldError.checkNotNull(
              durationDays, r'PtProductWrite', 'durationDays'),
          basePrice: BuiltValueNullFieldError.checkNotNull(
              basePrice, r'PtProductWrite', 'basePrice'),
          taxPercentage: taxPercentage,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
