// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_voucher_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ExpenseVoucherPage extends ExpenseVoucherPage {
  @override
  final BuiltList<ExpenseVoucher> data;
  @override
  final PageMeta meta;

  factory _$ExpenseVoucherPage(
          [void Function(ExpenseVoucherPageBuilder)? updates]) =>
      (ExpenseVoucherPageBuilder()..update(updates))._build();

  _$ExpenseVoucherPage._({required this.data, required this.meta}) : super._();
  @override
  ExpenseVoucherPage rebuild(
          void Function(ExpenseVoucherPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExpenseVoucherPageBuilder toBuilder() =>
      ExpenseVoucherPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExpenseVoucherPage &&
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
    return (newBuiltValueToStringHelper(r'ExpenseVoucherPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class ExpenseVoucherPageBuilder
    implements Builder<ExpenseVoucherPage, ExpenseVoucherPageBuilder> {
  _$ExpenseVoucherPage? _$v;

  ListBuilder<ExpenseVoucher>? _data;
  ListBuilder<ExpenseVoucher> get data =>
      _$this._data ??= ListBuilder<ExpenseVoucher>();
  set data(ListBuilder<ExpenseVoucher>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  ExpenseVoucherPageBuilder() {
    ExpenseVoucherPage._defaults(this);
  }

  ExpenseVoucherPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExpenseVoucherPage other) {
    _$v = other as _$ExpenseVoucherPage;
  }

  @override
  void update(void Function(ExpenseVoucherPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExpenseVoucherPage build() => _build();

  _$ExpenseVoucherPage _build() {
    _$ExpenseVoucherPage _$result;
    try {
      _$result = _$v ??
          _$ExpenseVoucherPage._(
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
            r'ExpenseVoucherPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
