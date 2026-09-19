// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_product_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipProductWrite extends MembershipProductWrite {
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
  final int? maxFreezeDays;
  @override
  final int? ptSessionsIncluded;
  @override
  final BuiltList<String>? accessFacilities;
  @override
  final bool? isActive;

  factory _$MembershipProductWrite(
          [void Function(MembershipProductWriteBuilder)? updates]) =>
      (MembershipProductWriteBuilder()..update(updates))._build();

  _$MembershipProductWrite._(
      {required this.name,
      required this.code,
      this.description,
      required this.durationDays,
      required this.basePrice,
      this.taxPercentage,
      this.maxFreezeDays,
      this.ptSessionsIncluded,
      this.accessFacilities,
      this.isActive})
      : super._();
  @override
  MembershipProductWrite rebuild(
          void Function(MembershipProductWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipProductWriteBuilder toBuilder() =>
      MembershipProductWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipProductWrite &&
        name == other.name &&
        code == other.code &&
        description == other.description &&
        durationDays == other.durationDays &&
        basePrice == other.basePrice &&
        taxPercentage == other.taxPercentage &&
        maxFreezeDays == other.maxFreezeDays &&
        ptSessionsIncluded == other.ptSessionsIncluded &&
        accessFacilities == other.accessFacilities &&
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
    _$hash = $jc(_$hash, maxFreezeDays.hashCode);
    _$hash = $jc(_$hash, ptSessionsIncluded.hashCode);
    _$hash = $jc(_$hash, accessFacilities.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipProductWrite')
          ..add('name', name)
          ..add('code', code)
          ..add('description', description)
          ..add('durationDays', durationDays)
          ..add('basePrice', basePrice)
          ..add('taxPercentage', taxPercentage)
          ..add('maxFreezeDays', maxFreezeDays)
          ..add('ptSessionsIncluded', ptSessionsIncluded)
          ..add('accessFacilities', accessFacilities)
          ..add('isActive', isActive))
        .toString();
  }
}

class MembershipProductWriteBuilder
    implements Builder<MembershipProductWrite, MembershipProductWriteBuilder> {
  _$MembershipProductWrite? _$v;

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

  int? _maxFreezeDays;
  int? get maxFreezeDays => _$this._maxFreezeDays;
  set maxFreezeDays(int? maxFreezeDays) =>
      _$this._maxFreezeDays = maxFreezeDays;

  int? _ptSessionsIncluded;
  int? get ptSessionsIncluded => _$this._ptSessionsIncluded;
  set ptSessionsIncluded(int? ptSessionsIncluded) =>
      _$this._ptSessionsIncluded = ptSessionsIncluded;

  ListBuilder<String>? _accessFacilities;
  ListBuilder<String> get accessFacilities =>
      _$this._accessFacilities ??= ListBuilder<String>();
  set accessFacilities(ListBuilder<String>? accessFacilities) =>
      _$this._accessFacilities = accessFacilities;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  MembershipProductWriteBuilder() {
    MembershipProductWrite._defaults(this);
  }

  MembershipProductWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _code = $v.code;
      _description = $v.description;
      _durationDays = $v.durationDays;
      _basePrice = $v.basePrice;
      _taxPercentage = $v.taxPercentage;
      _maxFreezeDays = $v.maxFreezeDays;
      _ptSessionsIncluded = $v.ptSessionsIncluded;
      _accessFacilities = $v.accessFacilities?.toBuilder();
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipProductWrite other) {
    _$v = other as _$MembershipProductWrite;
  }

  @override
  void update(void Function(MembershipProductWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipProductWrite build() => _build();

  _$MembershipProductWrite _build() {
    _$MembershipProductWrite _$result;
    try {
      _$result = _$v ??
          _$MembershipProductWrite._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'MembershipProductWrite', 'name'),
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'MembershipProductWrite', 'code'),
            description: description,
            durationDays: BuiltValueNullFieldError.checkNotNull(
                durationDays, r'MembershipProductWrite', 'durationDays'),
            basePrice: BuiltValueNullFieldError.checkNotNull(
                basePrice, r'MembershipProductWrite', 'basePrice'),
            taxPercentage: taxPercentage,
            maxFreezeDays: maxFreezeDays,
            ptSessionsIncluded: ptSessionsIncluded,
            accessFacilities: _accessFacilities?.build(),
            isActive: isActive,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'accessFacilities';
        _accessFacilities?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MembershipProductWrite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
