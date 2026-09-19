// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipPage extends MembershipPage {
  @override
  final BuiltList<Membership> data;
  @override
  final PageMeta meta;

  factory _$MembershipPage([void Function(MembershipPageBuilder)? updates]) =>
      (MembershipPageBuilder()..update(updates))._build();

  _$MembershipPage._({required this.data, required this.meta}) : super._();
  @override
  MembershipPage rebuild(void Function(MembershipPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipPageBuilder toBuilder() => MembershipPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'MembershipPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MembershipPageBuilder
    implements Builder<MembershipPage, MembershipPageBuilder> {
  _$MembershipPage? _$v;

  ListBuilder<Membership>? _data;
  ListBuilder<Membership> get data =>
      _$this._data ??= ListBuilder<Membership>();
  set data(ListBuilder<Membership>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MembershipPageBuilder() {
    MembershipPage._defaults(this);
  }

  MembershipPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipPage other) {
    _$v = other as _$MembershipPage;
  }

  @override
  void update(void Function(MembershipPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipPage build() => _build();

  _$MembershipPage _build() {
    _$MembershipPage _$result;
    try {
      _$result = _$v ??
          _$MembershipPage._(
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
            r'MembershipPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
