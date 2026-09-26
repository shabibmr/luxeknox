// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_photo_comparison_pose_pair.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressPhotoComparisonPosePair
    extends ProgressPhotoComparisonPosePair {
  @override
  final ProgressPhoto? date1;
  @override
  final ProgressPhoto? date2;

  factory _$ProgressPhotoComparisonPosePair(
          [void Function(ProgressPhotoComparisonPosePairBuilder)? updates]) =>
      (ProgressPhotoComparisonPosePairBuilder()..update(updates))._build();

  _$ProgressPhotoComparisonPosePair._({this.date1, this.date2}) : super._();
  @override
  ProgressPhotoComparisonPosePair rebuild(
          void Function(ProgressPhotoComparisonPosePairBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressPhotoComparisonPosePairBuilder toBuilder() =>
      ProgressPhotoComparisonPosePairBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressPhotoComparisonPosePair &&
        date1 == other.date1 &&
        date2 == other.date2;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date1.hashCode);
    _$hash = $jc(_$hash, date2.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProgressPhotoComparisonPosePair')
          ..add('date1', date1)
          ..add('date2', date2))
        .toString();
  }
}

class ProgressPhotoComparisonPosePairBuilder
    implements
        Builder<ProgressPhotoComparisonPosePair,
            ProgressPhotoComparisonPosePairBuilder> {
  _$ProgressPhotoComparisonPosePair? _$v;

  ProgressPhotoBuilder? _date1;
  ProgressPhotoBuilder get date1 => _$this._date1 ??= ProgressPhotoBuilder();
  set date1(ProgressPhotoBuilder? date1) => _$this._date1 = date1;

  ProgressPhotoBuilder? _date2;
  ProgressPhotoBuilder get date2 => _$this._date2 ??= ProgressPhotoBuilder();
  set date2(ProgressPhotoBuilder? date2) => _$this._date2 = date2;

  ProgressPhotoComparisonPosePairBuilder() {
    ProgressPhotoComparisonPosePair._defaults(this);
  }

  ProgressPhotoComparisonPosePairBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date1 = $v.date1?.toBuilder();
      _date2 = $v.date2?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressPhotoComparisonPosePair other) {
    _$v = other as _$ProgressPhotoComparisonPosePair;
  }

  @override
  void update(void Function(ProgressPhotoComparisonPosePairBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressPhotoComparisonPosePair build() => _build();

  _$ProgressPhotoComparisonPosePair _build() {
    _$ProgressPhotoComparisonPosePair _$result;
    try {
      _$result = _$v ??
          _$ProgressPhotoComparisonPosePair._(
            date1: _date1?.build(),
            date2: _date2?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'date1';
        _date1?.build();
        _$failedField = 'date2';
        _date2?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProgressPhotoComparisonPosePair', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
