// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emergency_contact.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmergencyContact extends EmergencyContact {
  @override
  final int id;
  @override
  final int userId;
  @override
  final String contactName;
  @override
  final String? relationship;
  @override
  final String phonePrimary;
  @override
  final String? phoneSecondary;
  @override
  final bool isPrimary;

  factory _$EmergencyContact(
          [void Function(EmergencyContactBuilder)? updates]) =>
      (EmergencyContactBuilder()..update(updates))._build();

  _$EmergencyContact._(
      {required this.id,
      required this.userId,
      required this.contactName,
      this.relationship,
      required this.phonePrimary,
      this.phoneSecondary,
      required this.isPrimary})
      : super._();
  @override
  EmergencyContact rebuild(void Function(EmergencyContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmergencyContactBuilder toBuilder() =>
      EmergencyContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmergencyContact &&
        id == other.id &&
        userId == other.userId &&
        contactName == other.contactName &&
        relationship == other.relationship &&
        phonePrimary == other.phonePrimary &&
        phoneSecondary == other.phoneSecondary &&
        isPrimary == other.isPrimary;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
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
    return (newBuiltValueToStringHelper(r'EmergencyContact')
          ..add('id', id)
          ..add('userId', userId)
          ..add('contactName', contactName)
          ..add('relationship', relationship)
          ..add('phonePrimary', phonePrimary)
          ..add('phoneSecondary', phoneSecondary)
          ..add('isPrimary', isPrimary))
        .toString();
  }
}

class EmergencyContactBuilder
    implements Builder<EmergencyContact, EmergencyContactBuilder> {
  _$EmergencyContact? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _userId;
  int? get userId => _$this._userId;
  set userId(int? userId) => _$this._userId = userId;

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

  EmergencyContactBuilder() {
    EmergencyContact._defaults(this);
  }

  EmergencyContactBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _userId = $v.userId;
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
  void replace(EmergencyContact other) {
    _$v = other as _$EmergencyContact;
  }

  @override
  void update(void Function(EmergencyContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmergencyContact build() => _build();

  _$EmergencyContact _build() {
    final _$result = _$v ??
        _$EmergencyContact._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'EmergencyContact', 'id'),
          userId: BuiltValueNullFieldError.checkNotNull(
              userId, r'EmergencyContact', 'userId'),
          contactName: BuiltValueNullFieldError.checkNotNull(
              contactName, r'EmergencyContact', 'contactName'),
          relationship: relationship,
          phonePrimary: BuiltValueNullFieldError.checkNotNull(
              phonePrimary, r'EmergencyContact', 'phonePrimary'),
          phoneSecondary: phoneSecondary,
          isPrimary: BuiltValueNullFieldError.checkNotNull(
              isPrimary, r'EmergencyContact', 'isPrimary'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
