// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unearned_preview_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UnearnedPreviewResponse extends UnearnedPreviewResponse {
  @override
  final Date goLiveDate;
  @override
  final UnearnedPreviewTotals totals;
  @override
  final BuiltList<UnearnedPreviewItem> items;

  factory _$UnearnedPreviewResponse(
          [void Function(UnearnedPreviewResponseBuilder)? updates]) =>
      (UnearnedPreviewResponseBuilder()..update(updates))._build();

  _$UnearnedPreviewResponse._(
      {required this.goLiveDate, required this.totals, required this.items})
      : super._();
  @override
  UnearnedPreviewResponse rebuild(
          void Function(UnearnedPreviewResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnearnedPreviewResponseBuilder toBuilder() =>
      UnearnedPreviewResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnearnedPreviewResponse &&
        goLiveDate == other.goLiveDate &&
        totals == other.totals &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, goLiveDate.hashCode);
    _$hash = $jc(_$hash, totals.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnearnedPreviewResponse')
          ..add('goLiveDate', goLiveDate)
          ..add('totals', totals)
          ..add('items', items))
        .toString();
  }
}

class UnearnedPreviewResponseBuilder
    implements
        Builder<UnearnedPreviewResponse, UnearnedPreviewResponseBuilder> {
  _$UnearnedPreviewResponse? _$v;

  Date? _goLiveDate;
  Date? get goLiveDate => _$this._goLiveDate;
  set goLiveDate(Date? goLiveDate) => _$this._goLiveDate = goLiveDate;

  UnearnedPreviewTotalsBuilder? _totals;
  UnearnedPreviewTotalsBuilder get totals =>
      _$this._totals ??= UnearnedPreviewTotalsBuilder();
  set totals(UnearnedPreviewTotalsBuilder? totals) => _$this._totals = totals;

  ListBuilder<UnearnedPreviewItem>? _items;
  ListBuilder<UnearnedPreviewItem> get items =>
      _$this._items ??= ListBuilder<UnearnedPreviewItem>();
  set items(ListBuilder<UnearnedPreviewItem>? items) => _$this._items = items;

  UnearnedPreviewResponseBuilder() {
    UnearnedPreviewResponse._defaults(this);
  }

  UnearnedPreviewResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _goLiveDate = $v.goLiveDate;
      _totals = $v.totals.toBuilder();
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnearnedPreviewResponse other) {
    _$v = other as _$UnearnedPreviewResponse;
  }

  @override
  void update(void Function(UnearnedPreviewResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnearnedPreviewResponse build() => _build();

  _$UnearnedPreviewResponse _build() {
    _$UnearnedPreviewResponse _$result;
    try {
      _$result = _$v ??
          _$UnearnedPreviewResponse._(
            goLiveDate: BuiltValueNullFieldError.checkNotNull(
                goLiveDate, r'UnearnedPreviewResponse', 'goLiveDate'),
            totals: totals.build(),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'totals';
        totals.build();
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'UnearnedPreviewResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
