// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorUpdate extends VendorUpdate {
  @override
  final String? name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? gstin;
  @override
  final bool? isActive;

  factory _$VendorUpdate([void Function(VendorUpdateBuilder)? updates]) =>
      (VendorUpdateBuilder()..update(updates))._build();

  _$VendorUpdate._(
      {this.name, this.phone, this.email, this.gstin, this.isActive})
      : super._();
  @override
  VendorUpdate rebuild(void Function(VendorUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorUpdateBuilder toBuilder() => VendorUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorUpdate &&
        name == other.name &&
        phone == other.phone &&
        email == other.email &&
        gstin == other.gstin &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, gstin.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorUpdate')
          ..add('name', name)
          ..add('phone', phone)
          ..add('email', email)
          ..add('gstin', gstin)
          ..add('isActive', isActive))
        .toString();
  }
}

class VendorUpdateBuilder
    implements Builder<VendorUpdate, VendorUpdateBuilder> {
  _$VendorUpdate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _gstin;
  String? get gstin => _$this._gstin;
  set gstin(String? gstin) => _$this._gstin = gstin;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  VendorUpdateBuilder() {
    VendorUpdate._defaults(this);
  }

  VendorUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _phone = $v.phone;
      _email = $v.email;
      _gstin = $v.gstin;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorUpdate other) {
    _$v = other as _$VendorUpdate;
  }

  @override
  void update(void Function(VendorUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorUpdate build() => _build();

  _$VendorUpdate _build() {
    final _$result = _$v ??
        _$VendorUpdate._(
          name: name,
          phone: phone,
          email: email,
          gstin: gstin,
          isActive: isActive,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
