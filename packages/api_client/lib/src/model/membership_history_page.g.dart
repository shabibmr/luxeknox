// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_history_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MembershipHistoryPage extends MembershipHistoryPage {
  @override
  final BuiltList<MembershipHistory> data;
  @override
  final PageMeta meta;

  factory _$MembershipHistoryPage(
          [void Function(MembershipHistoryPageBuilder)? updates]) =>
      (MembershipHistoryPageBuilder()..update(updates))._build();

  _$MembershipHistoryPage._({required this.data, required this.meta})
      : super._();
  @override
  MembershipHistoryPage rebuild(
          void Function(MembershipHistoryPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MembershipHistoryPageBuilder toBuilder() =>
      MembershipHistoryPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MembershipHistoryPage &&
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
    return (newBuiltValueToStringHelper(r'MembershipHistoryPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MembershipHistoryPageBuilder
    implements Builder<MembershipHistoryPage, MembershipHistoryPageBuilder> {
  _$MembershipHistoryPage? _$v;

  ListBuilder<MembershipHistory>? _data;
  ListBuilder<MembershipHistory> get data =>
      _$this._data ??= ListBuilder<MembershipHistory>();
  set data(ListBuilder<MembershipHistory>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MembershipHistoryPageBuilder() {
    MembershipHistoryPage._defaults(this);
  }

  MembershipHistoryPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MembershipHistoryPage other) {
    _$v = other as _$MembershipHistoryPage;
  }

  @override
  void update(void Function(MembershipHistoryPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MembershipHistoryPage build() => _build();

  _$MembershipHistoryPage _build() {
    _$MembershipHistoryPage _$result;
    try {
      _$result = _$v ??
          _$MembershipHistoryPage._(
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
            r'MembershipHistoryPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
