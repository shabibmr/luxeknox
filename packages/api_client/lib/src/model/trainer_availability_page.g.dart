// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trainer_availability_page.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TrainerAvailabilityPage extends TrainerAvailabilityPage {
  @override
  final BuiltList<TrainerAvailability> data;
  @override
  final PageMeta meta;

  factory _$TrainerAvailabilityPage(
          [void Function(TrainerAvailabilityPageBuilder)? updates]) =>
      (TrainerAvailabilityPageBuilder()..update(updates))._build();

  _$TrainerAvailabilityPage._({required this.data, required this.meta})
      : super._();
  @override
  TrainerAvailabilityPage rebuild(
          void Function(TrainerAvailabilityPageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TrainerAvailabilityPageBuilder toBuilder() =>
      TrainerAvailabilityPageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TrainerAvailabilityPage &&
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
    return (newBuiltValueToStringHelper(r'TrainerAvailabilityPage')
          ..add('data', data)
          ..add('meta', meta))
        .toString();
  }
}

class TrainerAvailabilityPageBuilder
    implements
        Builder<TrainerAvailabilityPage, TrainerAvailabilityPageBuilder> {
  _$TrainerAvailabilityPage? _$v;

  ListBuilder<TrainerAvailability>? _data;
  ListBuilder<TrainerAvailability> get data =>
      _$this._data ??= ListBuilder<TrainerAvailability>();
  set data(ListBuilder<TrainerAvailability>? data) => _$this._data = data;

  PageMetaBuilder? _meta;
  PageMetaBuilder get meta => _$this._meta ??= PageMetaBuilder();
  set meta(PageMetaBuilder? meta) => _$this._meta = meta;

  TrainerAvailabilityPageBuilder() {
    TrainerAvailabilityPage._defaults(this);
  }

  TrainerAvailabilityPageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TrainerAvailabilityPage other) {
    _$v = other as _$TrainerAvailabilityPage;
  }

  @override
  void update(void Function(TrainerAvailabilityPageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TrainerAvailabilityPage build() => _build();

  _$TrainerAvailabilityPage _build() {
    _$TrainerAvailabilityPage _$result;
    try {
      _$result = _$v ??
          _$TrainerAvailabilityPage._(
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
            r'TrainerAvailabilityPage', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
