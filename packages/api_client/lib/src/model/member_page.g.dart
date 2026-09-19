// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberPage extends MemberPage {
  @override
  final BuiltList<Member> data;
  @override
  final PageMeta meta;

  factory _$MemberPage([void Function(MemberPageBuilder)? updates]) =>
      (MemberPageBuilder()..update(updates))._build();

  _$MemberPage._({required this.data, required this.meta}) : super._();
  @override
  MemberPage rebuild(void Function(MemberPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberPageBuilder toBuilder() => MemberPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'MemberPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MemberPageBuilder implements Builder<MemberPage, MemberPageBuilder> {
  _$MemberPage? _$v;

  ListBuilder<Member>? _data;
  ListBuilder<Member> get data => _$this._data ??= ListBuilder<Member>();
  set data(ListBuilder<Member>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MemberPageBuilder() {
    MemberPage._defaults(this);
  }

  MemberPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberPage other) {
    _$v = other as _$MemberPage;
  }

  @override
  void update(void Function(MemberPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberPage build() => _build();

  _$MemberPage _build() {
    _$MemberPage _$result;
    try {
      _$result = _$v ??
          _$MemberPage._(
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
            r'MemberPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
