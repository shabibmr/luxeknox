// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmergencyContactWrite extends EmergencyContactWrite {
  @override
  final String contactName;
  @override
  final String? relationship;
  @override
  final String phonePrimary;
  @override
  final String? phoneSecondary;
  @override
  final bool? isPrimary;

  factory _$EmergencyContactWrite(
          [void Function(EmergencyContactWriteBuilder)? updates]) =>
      (EmergencyContactWriteBuilder()..update(updates))._build();

  _$EmergencyContactWrite._(
      {required this.contactName,
      this.relationship,
      required this.phonePrimary,
      this.phoneSecondary,
      this.isPrimary})
      : super._();
  @override
  EmergencyContactWrite rebuild(
          void Function(EmergencyContactWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmergencyContactWriteBuilder toBuilder() =>
      EmergencyContactWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmergencyContactWrite &&
        contactName == other.contactName &&
        relationship == other.relationship &&
        phonePrimary == other.phonePrimary &&
        phoneSecondary == other.phoneSecondary &&
        isPrimary == other.isPrimary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, contactName.hashCode);
    _$hash = $jc(_$hash, relationship.hashCode);
    _$hash = $jc(_$hash, phonePrimary.hashCode);
    _$hash = $jc(_$hash, phoneSecondary.hashCode);
    _$hash = $jc(_$hash, isPrimary.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmergencyContactWrite')
          ..add('contactName', contactName)
          ..add('relationship', relationship)
          ..add('phonePrimary', phonePrimary)
          ..add('phoneSecondary', phoneSecondary)
          ..add('isPrimary', isPrimary))
        .toString();
  }
}

class EmergencyContactWriteBuilder
    implements Builder<EmergencyContactWrite, EmergencyContactWriteBuilder> {
  _$EmergencyContactWrite? _$v;

  String? _contactName;
  String? get contactName => _$this._contactName;
  set contactName(String? contactName) => _$this._contactName = contactName;

  String? _relationship;
  String? get relationship => _$this._relationship;
  set relationship(String? relationship) => _$this._relationship = relationship;

  String? _phonePrimary;
  String? get phonePrimary => _$this._phonePrimary;
  set phonePrimary(String? phonePrimary) => _$this._phonePrimary = phonePrimary;

  String? _phoneSecondary;
  String? get phoneSecondary => _$this._phoneSecondary;
  set phoneSecondary(String? phoneSecondary) =>
      _$this._phoneSecondary = phoneSecondary;

  bool? _isPrimary;
  bool? get isPrimary => _$this._isPrimary;
  set isPrimary(bool? isPrimary) => _$this._isPrimary = isPrimary;

  EmergencyContactWriteBuilder() {
    EmergencyContactWrite._defaults(this);
  }

  EmergencyContactWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _contactName = $v.contactName;
      _relationship = $v.relationship;
      _phonePrimary = $v.phonePrimary;
      _phoneSecondary = $v.phoneSecondary;
      _isPrimary = $v.isPrimary;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmergencyContactWrite other) {
    _$v = other as _$EmergencyContactWrite;
  }

  @override
  void update(void Function(EmergencyContactWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmergencyContactWrite build() => _build();

  _$EmergencyContactWrite _build() {
    final _$result = _$v ??
        _$EmergencyContactWrite._(
          contactName: BuiltValueNullFieldError.checkNotNull(
              contactName, r'EmergencyContactWrite', 'contactName'),
          relationship: relationship,
          phonePrimary: BuiltValueNullFieldError.checkNotNull(
              phonePrimary, r'EmergencyContactWrite', 'phonePrimary'),
          phoneSecondary: phoneSecondary,
          isPrimary: isPrimary,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
