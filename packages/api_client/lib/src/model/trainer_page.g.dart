// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainerPage extends TrainerPage {
  @override
  final BuiltList<Trainer> data;
  @override
  final PageMeta meta;

  factory _$TrainerPage([void Function(TrainerPageBuilder)? updates]) =>
      (TrainerPageBuilder()..update(updates))._build();

  _$TrainerPage._({required this.data, required this.meta}) : super._();
  @override
  TrainerPage rebuild(void Function(TrainerPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainerPageBuilder toBuilder() => TrainerPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainerPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'TrainerPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class TrainerPageBuilder implements Builder<TrainerPage, TrainerPageBuilder> {
  _$TrainerPage? _$v;

  ListBuilder<Trainer>? _data;
  ListBuilder<Trainer> get data => _$this._data ??= ListBuilder<Trainer>();
  set data(ListBuilder<Trainer>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  TrainerPageBuilder() {
    TrainerPage._defaults(this);
  }

  TrainerPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainerPage other) {
    _$v = other as _$TrainerPage;
  }

  @override
  void update(void Function(TrainerPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainerPage build() => _build();

  _$TrainerPage _build() {
    _$TrainerPage _$result;
    try {
      _$result = _$v ??
          _$TrainerPage._(
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
            r'TrainerPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
