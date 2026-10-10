// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_product.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtProduct extends PtProduct {
  @override
  final int id;
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
  final bool isActive;

  factory _$PtProduct([void Function(PtProductBuilder)? updates]) =>
      (PtProductBuilder()..update(updates))._build();

  _$PtProduct._(
      {required this.id,
      required this.name,
      required this.code,
      this.description,
      required this.durationDays,
      required this.basePrice,
      this.taxPercentage,
      required this.isActive})
      : super._();
  @override
  PtProduct rebuild(void Function(PtProductBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtProductBuilder toBuilder() => PtProductBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtProduct &&
        id == other.id &&
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
    _$hash = $jc(_$hash, id.hashCode);
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
    return (newBuiltValueToStringHelper(r'PtProduct')
          ..add('id', id)
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

class PtProductBuilder implements Builder<PtProduct, PtProductBuilder> {
  _$PtProduct? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

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

  PtProductBuilder() {
    PtProduct._defaults(this);
  }

  PtProductBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
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
  void replace(PtProduct other) {
    _$v = other as _$PtProduct;
  }

  @override
  void update(void Function(PtProductBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtProduct build() => _build();

  _$PtProduct _build() {
    final _$result = _$v ??
        _$PtProduct._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'PtProduct', 'id'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'PtProduct', 'name'),
          code:
              BuiltValueNullFieldError.checkNotNull(code, r'PtProduct', 'code'),
          description: description,
          durationDays: BuiltValueNullFieldError.checkNotNull(
              durationDays, r'PtProduct', 'durationDays'),
          basePrice: BuiltValueNullFieldError.checkNotNull(
              basePrice, r'PtProduct', 'basePrice'),
          taxPercentage: taxPercentage,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'PtProduct', 'isActive'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
