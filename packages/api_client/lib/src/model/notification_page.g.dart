// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NotificationPage extends NotificationPage {
  @override
  final BuiltList<Notification> data;
  @override
  final PageMeta meta;

  factory _$NotificationPage(
          [void Function(NotificationPageBuilder)? updates]) =>
      (NotificationPageBuilder()..update(updates))._build();

  _$NotificationPage._({required this.data, required this.meta}) : super._();
  @override
  NotificationPage rebuild(void Function(NotificationPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationPageBuilder toBuilder() =>
      NotificationPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationPage &&
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
    return (newBuiltValueToStringHelper(r'NotificationPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class NotificationPageBuilder
    implements Builder<NotificationPage, NotificationPageBuilder> {
  _$NotificationPage? _$v;

  ListBuilder<Notification>? _data;
  ListBuilder<Notification> get data =>
      _$this._data ??= ListBuilder<Notification>();
  set data(ListBuilder<Notification>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  NotificationPageBuilder() {
    NotificationPage._defaults(this);
  }

  NotificationPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationPage other) {
    _$v = other as _$NotificationPage;
  }

  @override
  void update(void Function(NotificationPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationPage build() => _build();

  _$NotificationPage _build() {
    _$NotificationPage _$result;
    try {
      _$result = _$v ??
          _$NotificationPage._(
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
            r'NotificationPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
