// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeasurementPage extends MeasurementPage {
  @override
  final BuiltList<Measurement> data;
  @override
  final PageMeta meta;

  factory _$MeasurementPage([void Function(MeasurementPageBuilder)? updates]) =>
      (MeasurementPageBuilder()..update(updates))._build();

  _$MeasurementPage._({required this.data, required this.meta}) : super._();
  @override
  MeasurementPage rebuild(void Function(MeasurementPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeasurementPageBuilder toBuilder() => MeasurementPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeasurementPage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'MeasurementPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class MeasurementPageBuilder
    implements Builder<MeasurementPage, MeasurementPageBuilder> {
  _$MeasurementPage? _$v;

  ListBuilder<Measurement>? _data;
  ListBuilder<Measurement> get data =>
      _$this._data ??= ListBuilder<Measurement>();
  set data(ListBuilder<Measurement>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  MeasurementPageBuilder() {
    MeasurementPage._defaults(this);
  }

  MeasurementPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeasurementPage other) {
    _$v = other as _$MeasurementPage;
  }

  @override
  void update(void Function(MeasurementPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeasurementPage build() => _build();

  _$MeasurementPage _build() {
    _$MeasurementPage _$result;
    try {
      _$result = _$v ??
          _$MeasurementPage._(
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
            r'MeasurementPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
