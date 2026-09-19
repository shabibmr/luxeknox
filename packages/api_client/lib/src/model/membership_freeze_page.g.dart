// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_freeze_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipFreezePage extends MembershipFreezePage {
  @override
  final BuiltList<MembershipFreeze> data;
  @override
  final PageMeta meta;

  factory _$MembershipFreezePage(
          [void Function(MembershipFreezePageBuilder)? updates]) =>
      (MembershipFreezePageBuilder()..update(updates))._build();

  _$MembershipFreezePage._({required this.data, required this.meta})
      : super._();
  @override
  MembershipFreezePage rebuild(
          void Function(MembershipFreezePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipFreezePageBuilder toBuilder() =>
      MembershipFreezePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipFreezePage &&
        data == other.data &&
        meta == other.meta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MembershipFreezePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MembershipFreezePageBuilder
    implements Builder<MembershipFreezePage, MembershipFreezePageBuilder> {
  _$MembershipFreezePage? _$v;

  ListBuilder<MembershipFreeze>? _data;
  ListBuilder<MembershipFreeze> get data =>
      _$this._data ??= ListBuilder<MembershipFreeze>();
  set data(ListBuilder<MembershipFreeze>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MembershipFreezePageBuilder() {
    MembershipFreezePage._defaults(this);
  }

  MembershipFreezePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipFreezePage other) {
    _$v = other as _$MembershipFreezePage;
  }

  @override
  void update(void Function(MembershipFreezePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipFreezePage build() => _build();

  _$MembershipFreezePage _build() {
    _$MembershipFreezePage _$result;
    try {
      _$result = _$v ??
          _$MembershipFreezePage._(
            data: data.build(),
            meta: meta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MembershipFreezePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
