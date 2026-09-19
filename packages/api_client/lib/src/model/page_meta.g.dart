// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_meta.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PageMeta extends PageMeta {
  @override
  final int limit;
  @override
  final int? offset;
  @override
  final String? cursor;
  @override
  final String? nextCursor;
  @override
  final bool hasMore;
  @override
  final int? total;

  factory _$PageMeta([void Function(PageMetaBuilder)? updates]) =>
      (PageMetaBuilder()..update(updates))._build();

  _$PageMeta._(
      {required this.limit,
      this.offset,
      this.cursor,
      this.nextCursor,
      required this.hasMore,
      this.total})
      : super._();
  @override
  PageMeta rebuild(void Function(PageMetaBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PageMetaBuilder toBuilder() => PageMetaBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PageMeta &&
        limit == other.limit &&
        offset == other.offset &&
        cursor == other.cursor &&
        nextCursor == other.nextCursor &&
        hasMore == other.hasMore &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, offset.hashCode);
    _$hash = $jc(_$hash, cursor.hashCode);
    _$hash = $jc(_$hash, nextCursor.hashCode);
    _$hash = $jc(_$hash, hasMore.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PageMeta')
          ..add('limit', limit)
          ..add('offset', offset)
          ..add('cursor', cursor)
          ..add('nextCursor', nextCursor)
          ..add('hasMore', hasMore)
          ..add('total', total))
        .toString();
  }
}

class PageMetaBuilder implements Builder<PageMeta, PageMetaBuilder> {
  _$PageMeta? _$v;

  int? _limit;
  int? get limit => _$this._limit;
  set limit(int? limit) => _$this._limit = limit;

  int? _offset;
  int? get offset => _$this._offset;
  set offset(int? offset) => _$this._offset = offset;

  String? _cursor;
  String? get cursor => _$this._cursor;
  set cursor(String? cursor) => _$this._cursor = cursor;

  String? _nextCursor;
  String? get nextCursor => _$this._nextCursor;
  set nextCursor(String? nextCursor) => _$this._nextCursor = nextCursor;

  bool? _hasMore;
  bool? get hasMore => _$this._hasMore;
  set hasMore(bool? hasMore) => _$this._hasMore = hasMore;

  int? _total;
  int? get total => _$this._total;
  set total(int? total) => _$this._total = total;

  PageMetaBuilder() {
    PageMeta._defaults(this);
  }

  PageMetaBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _limit = $v.limit;
      _offset = $v.offset;
      _cursor = $v.cursor;
      _nextCursor = $v.nextCursor;
      _hasMore = $v.hasMore;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PageMeta other) {
    _$v = other as _$PageMeta;
  }

  @override
  void update(void Function(PageMetaBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PageMeta build() => _build();

  _$PageMeta _build() {
    final _$result = _$v ??
        _$PageMeta._(
          limit: BuiltValueNullFieldError.checkNotNull(
              limit, r'PageMeta', 'limit'),
          offset: offset,
          cursor: cursor,
          nextCursor: nextCursor,
          hasMore: BuiltValueNullFieldError.checkNotNull(
              hasMore, r'PageMeta', 'hasMore'),
          total: total,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
