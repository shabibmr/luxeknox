// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FacilityWrite extends FacilityWrite {
  @override
  final String name;
  @override
  final int? capacity;
  @override
  final String? locationDetails;
  @override
  final bool? isActive;

  factory _$FacilityWrite([void Function(FacilityWriteBuilder)? updates]) =>
      (FacilityWriteBuilder()..update(updates))._build();

  _$FacilityWrite._(
      {required this.name, this.capacity, this.locationDetails, this.isActive})
      : super._();
  @override
  FacilityWrite rebuild(void Function(FacilityWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FacilityWriteBuilder toBuilder() => FacilityWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FacilityWrite &&
        name == other.name &&
        capacity == other.capacity &&
        locationDetails == other.locationDetails &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, capacity.hashCode);
    _$hash = $jc(_$hash, locationDetails.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FacilityWrite')
          ..add('name', name)
          ..add('capacity', capacity)
          ..add('locationDetails', locationDetails)
          ..add('isActive', isActive))
        .toString();
  }
}

class FacilityWriteBuilder
    implements Builder<FacilityWrite, FacilityWriteBuilder> {
  _$FacilityWrite? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _capacity;
  int? get capacity => _$this._capacity;
  set capacity(int? capacity) => _$this._capacity = capacity;

  String? _locationDetails;
  String? get locationDetails => _$this._locationDetails;
  set locationDetails(String? locationDetails) =>
      _$this._locationDetails = locationDetails;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  FacilityWriteBuilder() {
    FacilityWrite._defaults(this);
  }

  FacilityWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _capacity = $v.capacity;
      _locationDetails = $v.locationDetails;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FacilityWrite other) {
    _$v = other as _$FacilityWrite;
  }

  @override
  void update(void Function(FacilityWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FacilityWrite build() => _build();

  _$FacilityWrite _build() {
    final _$result = _$v ??
        _$FacilityWrite._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'FacilityWrite', 'name'),
          capacity: capacity,
          locationDetails: locationDetails,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
