// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorWrite extends VendorWrite {
  @override
  final String name;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String? gstin;
  @override
  final bool? isActive;

  factory _$VendorWrite([void Function(VendorWriteBuilder)? updates]) =>
      (VendorWriteBuilder()..update(updates))._build();

  _$VendorWrite._(
      {required this.name, this.phone, this.email, this.gstin, this.isActive})
      : super._();
  @override
  VendorWrite rebuild(void Function(VendorWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorWriteBuilder toBuilder() => VendorWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorWrite &&
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
    return (newBuiltValueToStringHelper(r'VendorWrite')
          ..add('name', name)
          ..add('phone', phone)
          ..add('email', email)
          ..add('gstin', gstin)
          ..add('isActive', isActive))
        .toString();
  }
}

class VendorWriteBuilder implements Builder<VendorWrite, VendorWriteBuilder> {
  _$VendorWrite? _$v;

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

  VendorWriteBuilder() {
    VendorWrite._defaults(this);
  }

  VendorWriteBuilder get _$this {
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
  void replace(VendorWrite other) {
    _$v = other as _$VendorWrite;
  }

  @override
  void update(void Function(VendorWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorWrite build() => _build();

  _$VendorWrite _build() {
    final _$result = _$v ??
        _$VendorWrite._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'VendorWrite', 'name'),
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
