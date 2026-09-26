// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_photo_comparison.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressPhotoComparison extends ProgressPhotoComparison {
  @override
  final Date date1;
  @override
  final Date date2;
  @override
  final BuiltList<ProgressPhoto> date1Photos;
  @override
  final BuiltList<ProgressPhoto> date2Photos;
  @override
  final ProgressPhotoComparisonComparisonByPose comparisonByPose;

  factory _$ProgressPhotoComparison(
          [void Function(ProgressPhotoComparisonBuilder)? updates]) =>
      (ProgressPhotoComparisonBuilder()..update(updates))._build();

  _$ProgressPhotoComparison._(
      {required this.date1,
      required this.date2,
      required this.date1Photos,
      required this.date2Photos,
      required this.comparisonByPose})
      : super._();
  @override
  ProgressPhotoComparison rebuild(
          void Function(ProgressPhotoComparisonBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressPhotoComparisonBuilder toBuilder() =>
      ProgressPhotoComparisonBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressPhotoComparison &&
        date1 == other.date1 &&
        date2 == other.date2 &&
        date1Photos == other.date1Photos &&
        date2Photos == other.date2Photos &&
        comparisonByPose == other.comparisonByPose;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, date1.hashCode);
    _$hash = $jc(_$hash, date2.hashCode);
    _$hash = $jc(_$hash, date1Photos.hashCode);
    _$hash = $jc(_$hash, date2Photos.hashCode);
    _$hash = $jc(_$hash, comparisonByPose.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ProgressPhotoComparison')
          ..add('date1', date1)
          ..add('date2', date2)
          ..add('date1Photos', date1Photos)
          ..add('date2Photos', date2Photos)
          ..add('comparisonByPose', comparisonByPose))
        .toString();
  }
}

class ProgressPhotoComparisonBuilder
    implements
        Builder<ProgressPhotoComparison, ProgressPhotoComparisonBuilder> {
  _$ProgressPhotoComparison? _$v;

  Date? _date1;
  Date? get date1 => _$this._date1;
  set date1(Date? date1) => _$this._date1 = date1;

  Date? _date2;
  Date? get date2 => _$this._date2;
  set date2(Date? date2) => _$this._date2 = date2;

  ListBuilder<ProgressPhoto>? _date1Photos;
  ListBuilder<ProgressPhoto> get date1Photos =>
      _$this._date1Photos ??= ListBuilder<ProgressPhoto>();
  set date1Photos(ListBuilder<ProgressPhoto>? date1Photos) =>
      _$this._date1Photos = date1Photos;

  ListBuilder<ProgressPhoto>? _date2Photos;
  ListBuilder<ProgressPhoto> get date2Photos =>
      _$this._date2Photos ??= ListBuilder<ProgressPhoto>();
  set date2Photos(ListBuilder<ProgressPhoto>? date2Photos) =>
      _$this._date2Photos = date2Photos;

  ProgressPhotoComparisonComparisonByPoseBuilder? _comparisonByPose;
  ProgressPhotoComparisonComparisonByPoseBuilder get comparisonByPose =>
      _$this._comparisonByPose ??=
          ProgressPhotoComparisonComparisonByPoseBuilder();
  set comparisonByPose(
          ProgressPhotoComparisonComparisonByPoseBuilder? comparisonByPose) =>
      _$this._comparisonByPose = comparisonByPose;

  ProgressPhotoComparisonBuilder() {
    ProgressPhotoComparison._defaults(this);
  }

  ProgressPhotoComparisonBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _date1 = $v.date1;
      _date2 = $v.date2;
      _date1Photos = $v.date1Photos.toBuilder();
      _date2Photos = $v.date2Photos.toBuilder();
      _comparisonByPose = $v.comparisonByPose.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressPhotoComparison other) {
    _$v = other as _$ProgressPhotoComparison;
  }

  @override
  void update(void Function(ProgressPhotoComparisonBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressPhotoComparison build() => _build();

  _$ProgressPhotoComparison _build() {
    _$ProgressPhotoComparison _$result;
    try {
      _$result = _$v ??
          _$ProgressPhotoComparison._(
            date1: BuiltValueNullFieldError.checkNotNull(
                date1, r'ProgressPhotoComparison', 'date1'),
            date2: BuiltValueNullFieldError.checkNotNull(
                date2, r'ProgressPhotoComparison', 'date2'),
            date1Photos: date1Photos.build(),
            date2Photos: date2Photos.build(),
            comparisonByPose: comparisonByPose.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'date1Photos';
        date1Photos.build();
        _$failedField = 'date2Photos';
        date2Photos.build();
        _$failedField = 'comparisonByPose';
        comparisonByPose.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProgressPhotoComparison', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
