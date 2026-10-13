// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AccountPage extends AccountPage {
  @override
  final BuiltList<Account> data;
  @override
  final PageMeta meta;

  factory _$AccountPage([void Function(AccountPageBuilder)? updates]) =>
      (AccountPageBuilder()..update(updates))._build();

  _$AccountPage._({required this.data, required this.meta}) : super._();
  @override
  AccountPage rebuild(void Function(AccountPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountPageBuilder toBuilder() => AccountPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'AccountPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class AccountPageBuilder implements Builder<AccountPage, AccountPageBuilder> {
  _$AccountPage? _$v;

  ListBuilder<Account>? _data;
  ListBuilder<Account> get data => _$this._data ??= ListBuilder<Account>();
  set data(ListBuilder<Account>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  AccountPageBuilder() {
    AccountPage._defaults(this);
  }

  AccountPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountPage other) {
    _$v = other as _$AccountPage;
  }

  @override
  void update(void Function(AccountPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountPage build() => _build();

  _$AccountPage _build() {
    _$AccountPage _$result;
    try {
      _$result = _$v ??
          _$AccountPage._(
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
            r'AccountPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
