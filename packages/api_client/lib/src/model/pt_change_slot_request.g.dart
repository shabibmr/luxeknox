// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_change_slot_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtChangeSlotRequest extends PtChangeSlotRequest {
  @override
  final BuiltList<int> weekdays;
  @override
  final String slotStart;
  @override
  final int? trainerId;
  @override
  final Date effectiveDate;
  @override
  final String? reason;

  factory _$PtChangeSlotRequest(
          [void Function(PtChangeSlotRequestBuilder)? updates]) =>
      (PtChangeSlotRequestBuilder()..update(updates))._build();

  _$PtChangeSlotRequest._(
      {required this.weekdays,
      required this.slotStart,
      this.trainerId,
      required this.effectiveDate,
      this.reason})
      : super._();
  @override
  PtChangeSlotRequest rebuild(
          void Function(PtChangeSlotRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtChangeSlotRequestBuilder toBuilder() =>
      PtChangeSlotRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtChangeSlotRequest &&
        weekdays == other.weekdays &&
        slotStart == other.slotStart &&
        trainerId == other.trainerId &&
        effectiveDate == other.effectiveDate &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weekdays.hashCode);
    _$hash = $jc(_$hash, slotStart.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, effectiveDate.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtChangeSlotRequest')
          ..add('weekdays', weekdays)
          ..add('slotStart', slotStart)
          ..add('trainerId', trainerId)
          ..add('effectiveDate', effectiveDate)
          ..add('reason', reason))
        .toString();
  }
}

class PtChangeSlotRequestBuilder
    implements Builder<PtChangeSlotRequest, PtChangeSlotRequestBuilder> {
  _$PtChangeSlotRequest? _$v;

  ListBuilder<int>? _weekdays;
  ListBuilder<int> get weekdays => _$this._weekdays ??= ListBuilder<int>();
  set weekdays(ListBuilder<int>? weekdays) => _$this._weekdays = weekdays;

  String? _slotStart;
  String? get slotStart => _$this._slotStart;
  set slotStart(String? slotStart) => _$this._slotStart = slotStart;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  Date? _effectiveDate;
  Date? get effectiveDate => _$this._effectiveDate;
  set effectiveDate(Date? effectiveDate) =>
      _$this._effectiveDate = effectiveDate;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  PtChangeSlotRequestBuilder() {
    PtChangeSlotRequest._defaults(this);
  }

  PtChangeSlotRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weekdays = $v.weekdays.toBuilder();
      _slotStart = $v.slotStart;
      _trainerId = $v.trainerId;
      _effectiveDate = $v.effectiveDate;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtChangeSlotRequest other) {
    _$v = other as _$PtChangeSlotRequest;
  }

  @override
  void update(void Function(PtChangeSlotRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtChangeSlotRequest build() => _build();

  _$PtChangeSlotRequest _build() {
    _$PtChangeSlotRequest _$result;
    try {
      _$result = _$v ??
          _$PtChangeSlotRequest._(
            weekdays: weekdays.build(),
            slotStart: BuiltValueNullFieldError.checkNotNull(
                slotStart, r'PtChangeSlotRequest', 'slotStart'),
            trainerId: trainerId,
            effectiveDate: BuiltValueNullFieldError.checkNotNull(
                effectiveDate, r'PtChangeSlotRequest', 'effectiveDate'),
            reason: reason,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weekdays';
        weekdays.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtChangeSlotRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
