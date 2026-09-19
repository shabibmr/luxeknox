// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_response_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeResponseProfile extends MeResponseProfile {
  @override
  final OneOf oneOf;

  factory _$MeResponseProfile(
          [void Function(MeResponseProfileBuilder)? updates]) =>
      (MeResponseProfileBuilder()..update(updates))._build();

  _$MeResponseProfile._({required this.oneOf}) : super._();
  @override
  MeResponseProfile rebuild(void Function(MeResponseProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeResponseProfileBuilder toBuilder() =>
      MeResponseProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeResponseProfile && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeResponseProfile')
          ..add('oneOf', oneOf))
        .toString();
  }
}

class MeResponseProfileBuilder
    implements Builder<MeResponseProfile, MeResponseProfileBuilder> {
  _$MeResponseProfile? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  MeResponseProfileBuilder() {
    MeResponseProfile._defaults(this);
  }

  MeResponseProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeResponseProfile other) {
    _$v = other as _$MeResponseProfile;
  }

  @override
  void update(void Function(MeResponseProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeResponseProfile build() => _build();

  _$MeResponseProfile _build() {
    final _$result = _$v ??
        _$MeResponseProfile._(
          oneOf: BuiltValueNullFieldError.checkNotNull(
              oneOf, r'MeResponseProfile', 'oneOf'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
