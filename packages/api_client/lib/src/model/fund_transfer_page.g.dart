// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_transfer_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FundTransferPage extends FundTransferPage {
  @override
  final BuiltList<FundTransfer> data;
  @override
  final PageMeta meta;

  factory _$FundTransferPage(
          [void Function(FundTransferPageBuilder)? updates]) =>
      (FundTransferPageBuilder()..update(updates))._build();

  _$FundTransferPage._({required this.data, required this.meta}) : super._();
  @override
  FundTransferPage rebuild(void Function(FundTransferPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FundTransferPageBuilder toBuilder() =>
      FundTransferPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FundTransferPage &&
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
    return (newBuiltValueToStringHelper(r'FundTransferPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class FundTransferPageBuilder
    implements Builder<FundTransferPage, FundTransferPageBuilder> {
  _$FundTransferPage? _$v;

  ListBuilder<FundTransfer>? _data;
  ListBuilder<FundTransfer> get data =>
      _$this._data ??= ListBuilder<FundTransfer>();
  set data(ListBuilder<FundTransfer>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  FundTransferPageBuilder() {
    FundTransferPage._defaults(this);
  }

  FundTransferPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FundTransferPage other) {
    _$v = other as _$FundTransferPage;
  }

  @override
  void update(void Function(FundTransferPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FundTransferPage build() => _build();

  _$FundTransferPage _build() {
    _$FundTransferPage _$result;
    try {
      _$result = _$v ??
          _$FundTransferPage._(
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
            r'FundTransferPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
