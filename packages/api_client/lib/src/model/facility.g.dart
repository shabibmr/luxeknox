// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Facility extends Facility {
  @override
  final int id;
  @override
  final String name;
  @override
  final int? capacity;
  @override
  final String? locationDetails;
  @override
  final bool isActive;

  factory _$Facility([void Function(FacilityBuilder)? updates]) =>
      (FacilityBuilder()..update(updates))._build();

  _$Facility._(
      {required this.id,
      required this.name,
      this.capacity,
      this.locationDetails,
      required this.isActive})
      : super._();
  @override
  Facility rebuild(void Function(FacilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FacilityBuilder toBuilder() => FacilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Facility &&
        id == other.id &&
        name == other.name &&
        capacity == other.capacity &&
        locationDetails == other.locationDetails &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, capacity.hashCode);
    _$hash = $jc(_$hash, locationDetails.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Facility')
          ..add('id', id)
          ..add('name', name)
          ..add('capacity', capacity)
          ..add('locationDetails', locationDetails)
          ..add('isActive', isActive))
        .toString();
  }
}

class FacilityBuilder implements Builder<Facility, FacilityBuilder> {
  _$Facility? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

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

  FacilityBuilder() {
    Facility._defaults(this);
  }

  FacilityBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _capacity = $v.capacity;
      _locationDetails = $v.locationDetails;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Facility other) {
    _$v = other as _$Facility;
  }

  @override
  void update(void Function(FacilityBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Facility build() => _build();

  _$Facility _build() {
    final _$result = _$v ??
        _$Facility._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'Facility', 'id'),
          name:
              BuiltValueNullFieldError.checkNotNull(name, r'Facility', 'name'),
          capacity: capacity,
          locationDetails: locationDetails,
          isActive: BuiltValueNullFieldError.checkNotNull(
              isActive, r'Facility', 'isActive'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
