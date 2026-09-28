// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_photo_comparison_comparison_by_pose.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ProgressPhotoComparisonComparisonByPose
    extends ProgressPhotoComparisonComparisonByPose {
  @override
  final ProgressPhotoComparisonPosePair? front;
  @override
  final ProgressPhotoComparisonPosePair? side;
  @override
  final ProgressPhotoComparisonPosePair? back;

  factory _$ProgressPhotoComparisonComparisonByPose(
          [void Function(ProgressPhotoComparisonComparisonByPoseBuilder)?
              updates]) =>
      (ProgressPhotoComparisonComparisonByPoseBuilder()..update(updates))
          ._build();

  _$ProgressPhotoComparisonComparisonByPose._(
      {this.front, this.side, this.back})
      : super._();
  @override
  ProgressPhotoComparisonComparisonByPose rebuild(
          void Function(ProgressPhotoComparisonComparisonByPoseBuilder)
              updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ProgressPhotoComparisonComparisonByPoseBuilder toBuilder() =>
      ProgressPhotoComparisonComparisonByPoseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ProgressPhotoComparisonComparisonByPose &&
        front == other.front &&
        side == other.side &&
        back == other.back;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, front.hashCode);
    _$hash = $jc(_$hash, side.hashCode);
    _$hash = $jc(_$hash, back.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'ProgressPhotoComparisonComparisonByPose')
          ..add('front', front)
          ..add('side', side)
          ..add('back', back))
        .toString();
  }
}

class ProgressPhotoComparisonComparisonByPoseBuilder
    implements
        Builder<ProgressPhotoComparisonComparisonByPose,
            ProgressPhotoComparisonComparisonByPoseBuilder> {
  _$ProgressPhotoComparisonComparisonByPose? _$v;

  ProgressPhotoComparisonPosePairBuilder? _front;
  ProgressPhotoComparisonPosePairBuilder get front =>
      _$this._front ??= ProgressPhotoComparisonPosePairBuilder();
  set front(ProgressPhotoComparisonPosePairBuilder? front) =>
      _$this._front = front;

  ProgressPhotoComparisonPosePairBuilder? _side;
  ProgressPhotoComparisonPosePairBuilder get side =>
      _$this._side ??= ProgressPhotoComparisonPosePairBuilder();
  set side(ProgressPhotoComparisonPosePairBuilder? side) => _$this._side = side;

  ProgressPhotoComparisonPosePairBuilder? _back;
  ProgressPhotoComparisonPosePairBuilder get back =>
      _$this._back ??= ProgressPhotoComparisonPosePairBuilder();
  set back(ProgressPhotoComparisonPosePairBuilder? back) => _$this._back = back;

  ProgressPhotoComparisonComparisonByPoseBuilder() {
    ProgressPhotoComparisonComparisonByPose._defaults(this);
  }

  ProgressPhotoComparisonComparisonByPoseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _front = $v.front?.toBuilder();
      _side = $v.side?.toBuilder();
      _back = $v.back?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ProgressPhotoComparisonComparisonByPose other) {
    _$v = other as _$ProgressPhotoComparisonComparisonByPose;
  }

  @override
  void update(
      void Function(ProgressPhotoComparisonComparisonByPoseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ProgressPhotoComparisonComparisonByPose build() => _build();

  _$ProgressPhotoComparisonComparisonByPose _build() {
    _$ProgressPhotoComparisonComparisonByPose _$result;
    try {
      _$result = _$v ??
          _$ProgressPhotoComparisonComparisonByPose._(
            front: _front?.build(),
            side: _side?.build(),
            back: _back?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'front';
        _front?.build();
        _$failedField = 'side';
        _side?.build();
        _$failedField = 'back';
        _back?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ProgressPhotoComparisonComparisonByPose',
            _$failedField,
            e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
