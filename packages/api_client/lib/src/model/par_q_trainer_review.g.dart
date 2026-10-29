// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'par_q_trainer_review.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ParQTrainerReview extends ParQTrainerReview {
  @override
  final String trainerScreeningNotes;
  @override
  final bool referralRequired;
  @override
  final String? referralReason;

  factory _$ParQTrainerReview(
          [void Function(ParQTrainerReviewBuilder)? updates]) =>
      (ParQTrainerReviewBuilder()..update(updates))._build();

  _$ParQTrainerReview._(
      {required this.trainerScreeningNotes,
      required this.referralRequired,
      this.referralReason})
      : super._();
  @override
  ParQTrainerReview rebuild(void Function(ParQTrainerReviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParQTrainerReviewBuilder toBuilder() =>
      ParQTrainerReviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParQTrainerReview &&
        trainerScreeningNotes == other.trainerScreeningNotes &&
        referralRequired == other.referralRequired &&
        referralReason == other.referralReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trainerScreeningNotes.hashCode);
    _$hash = $jc(_$hash, referralRequired.hashCode);
    _$hash = $jc(_$hash, referralReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParQTrainerReview')
          ..add('trainerScreeningNotes', trainerScreeningNotes)
          ..add('referralRequired', referralRequired)
          ..add('referralReason', referralReason))
        .toString();
  }
}

class ParQTrainerReviewBuilder
    implements Builder<ParQTrainerReview, ParQTrainerReviewBuilder> {
  _$ParQTrainerReview? _$v;

  String? _trainerScreeningNotes;
  String? get trainerScreeningNotes => _$this._trainerScreeningNotes;
  set trainerScreeningNotes(String? trainerScreeningNotes) =>
      _$this._trainerScreeningNotes = trainerScreeningNotes;

  bool? _referralRequired;
  bool? get referralRequired => _$this._referralRequired;
  set referralRequired(bool? referralRequired) =>
      _$this._referralRequired = referralRequired;

  String? _referralReason;
  String? get referralReason => _$this._referralReason;
  set referralReason(String? referralReason) =>
      _$this._referralReason = referralReason;

  ParQTrainerReviewBuilder() {
    ParQTrainerReview._defaults(this);
  }

  ParQTrainerReviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trainerScreeningNotes = $v.trainerScreeningNotes;
      _referralRequired = $v.referralRequired;
      _referralReason = $v.referralReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParQTrainerReview other) {
    _$v = other as _$ParQTrainerReview;
  }

  @override
  void update(void Function(ParQTrainerReviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParQTrainerReview build() => _build();

  _$ParQTrainerReview _build() {
    final _$result = _$v ??
        _$ParQTrainerReview._(
          trainerScreeningNotes: BuiltValueNullFieldError.checkNotNull(
              trainerScreeningNotes,
              r'ParQTrainerReview',
              'trainerScreeningNotes'),
          referralRequired: BuiltValueNullFieldError.checkNotNull(
              referralRequired, r'ParQTrainerReview', 'referralRequired'),
          referralReason: referralReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
