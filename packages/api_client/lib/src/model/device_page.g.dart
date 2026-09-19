// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DevicePage extends DevicePage {
  @override
  final BuiltList<Device> data;
  @override
  final PageMeta meta;

  factory _$DevicePage([void Function(DevicePageBuilder)? updates]) =>
      (DevicePageBuilder()..update(updates))._build();

  _$DevicePage._({required this.data, required this.meta}) : super._();
  @override
  DevicePage rebuild(void Function(DevicePageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DevicePageBuilder toBuilder() => DevicePageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DevicePage && data == other.data && meta == other.meta;
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
    return (newBuiltValueToStringHelper(r'DevicePage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class DevicePageBuilder implements Builder<DevicePage, DevicePageBuilder> {
  _$DevicePage? _$v;

  ListBuilder<Device>? _data;
  ListBuilder<Device> get data => _$this._data ??= ListBuilder<Device>();
  set data(ListBuilder<Device>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  DevicePageBuilder() {
    DevicePage._defaults(this);
  }

  DevicePageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DevicePage other) {
    _$v = other as _$DevicePage;
  }

  @override
  void update(void Function(DevicePageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DevicePage build() => _build();

  _$DevicePage _build() {
    _$DevicePage _$result;
    try {
      _$result = _$v ??
          _$DevicePage._(
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
            r'DevicePage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
