// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JournalPage extends JournalPage {
  @override
  final BuiltList<Journal> data;
  @override
  final PageMeta meta;

  factory _$JournalPage([void Function(JournalPageBuilder)? updates]) =>
      (JournalPageBuilder()..update(updates))._build();

  _$JournalPage._({required this.data, required this.meta}) : super._();
  @override
  JournalPage rebuild(void Function(JournalPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JournalPageBuilder toBuilder() => JournalPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JournalPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'JournalPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class JournalPageBuilder implements Builder<JournalPage, JournalPageBuilder> {
  _$JournalPage? _$v;

  ListBuilder<Journal>? _data;
  ListBuilder<Journal> get data => _$this._data ??= ListBuilder<Journal>();
  set data(ListBuilder<Journal>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  JournalPageBuilder() {
    JournalPage._defaults(this);
  }

  JournalPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JournalPage other) {
    _$v = other as _$JournalPage;
  }

  @override
  void update(void Function(JournalPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JournalPage build() => _build();

  _$JournalPage _build() {
    _$JournalPage _$result;
    try {
      _$result = _$v ??
          _$JournalPage._(
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
            r'JournalPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
