// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_bill_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PurchaseBillPage extends PurchaseBillPage {
  @override
  final BuiltList<PurchaseBill> data;
  @override
  final PageMeta meta;

  factory _$PurchaseBillPage(
          [void Function(PurchaseBillPageBuilder)? updates]) =>
      (PurchaseBillPageBuilder()..update(updates))._build();

  _$PurchaseBillPage._({required this.data, required this.meta}) : super._();
  @override
  PurchaseBillPage rebuild(void Function(PurchaseBillPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PurchaseBillPageBuilder toBuilder() =>
      PurchaseBillPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PurchaseBillPage &&
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
    return (newBuiltValueToStringHelper(r'PurchaseBillPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class PurchaseBillPageBuilder
    implements Builder<PurchaseBillPage, PurchaseBillPageBuilder> {
  _$PurchaseBillPage? _$v;

  ListBuilder<PurchaseBill>? _data;
  ListBuilder<PurchaseBill> get data =>
      _$this._data ??= ListBuilder<PurchaseBill>();
  set data(ListBuilder<PurchaseBill>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  PurchaseBillPageBuilder() {
    PurchaseBillPage._defaults(this);
  }

  PurchaseBillPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PurchaseBillPage other) {
    _$v = other as _$PurchaseBillPage;
  }

  @override
  void update(void Function(PurchaseBillPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PurchaseBillPage build() => _build();

  _$PurchaseBillPage _build() {
    _$PurchaseBillPage _$result;
    try {
      _$result = _$v ??
          _$PurchaseBillPage._(
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
            r'PurchaseBillPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
