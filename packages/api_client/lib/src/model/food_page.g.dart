// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FoodPage extends FoodPage {
  @override
  final BuiltList<Food> data;
  @override
  final PageMeta meta;

  factory _$FoodPage([void Function(FoodPageBuilder)? updates]) =>
      (FoodPageBuilder()..update(updates))._build();

  _$FoodPage._({required this.data, required this.meta}) : super._();
  @override
  FoodPage rebuild(void Function(FoodPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FoodPageBuilder toBuilder() => FoodPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FoodPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'FoodPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class FoodPageBuilder implements Builder<FoodPage, FoodPageBuilder> {
  _$FoodPage? _$v;

  ListBuilder<Food>? _data;
  ListBuilder<Food> get data => _$this._data ??= ListBuilder<Food>();
  set data(ListBuilder<Food>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  FoodPageBuilder() {
    FoodPage._defaults(this);
  }

  FoodPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FoodPage other) {
    _$v = other as _$FoodPage;
  }

  @override
  void update(void Function(FoodPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FoodPage build() => _build();

  _$FoodPage _build() {
    _$FoodPage _$result;
    try {
      _$result = _$v ??
          _$FoodPage._(
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
            r'FoodPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
