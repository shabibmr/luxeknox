// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_health_history_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MemberHealthHistoryPage extends MemberHealthHistoryPage {
  @override
  final BuiltList<MemberHealthRecord> data;
  @override
  final PageMeta meta;

  factory _$MemberHealthHistoryPage(
          [void Function(MemberHealthHistoryPageBuilder)? updates]) =>
      (MemberHealthHistoryPageBuilder()..update(updates))._build();

  _$MemberHealthHistoryPage._({required this.data, required this.meta})
      : super._();
  @override
  MemberHealthHistoryPage rebuild(
          void Function(MemberHealthHistoryPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MemberHealthHistoryPageBuilder toBuilder() =>
      MemberHealthHistoryPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MemberHealthHistoryPage &&
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
    return (newBuiltValueToStringHelper(r'MemberHealthHistoryPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MemberHealthHistoryPageBuilder
    implements
        Builder<MemberHealthHistoryPage, MemberHealthHistoryPageBuilder> {
  _$MemberHealthHistoryPage? _$v;

  ListBuilder<MemberHealthRecord>? _data;
  ListBuilder<MemberHealthRecord> get data =>
      _$this._data ??= ListBuilder<MemberHealthRecord>();
  set data(ListBuilder<MemberHealthRecord>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MemberHealthHistoryPageBuilder() {
    MemberHealthHistoryPage._defaults(this);
  }

  MemberHealthHistoryPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MemberHealthHistoryPage other) {
    _$v = other as _$MemberHealthHistoryPage;
  }

  @override
  void update(void Function(MemberHealthHistoryPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MemberHealthHistoryPage build() => _build();

  _$MemberHealthHistoryPage _build() {
    _$MemberHealthHistoryPage _$result;
    try {
      _$result = _$v ??
          _$MemberHealthHistoryPage._(
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
            r'MemberHealthHistoryPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
