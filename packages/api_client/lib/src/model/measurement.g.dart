// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Measurement extends Measurement {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final int? recordedByUserId;
  @override
  final DateTime recordedAt;
  @override
  final String? notes;
  @override
  final BuiltList<MeasurementValue>? values;

  factory _$Measurement([void Function(MeasurementBuilder)? updates]) =>
      (MeasurementBuilder()..update(updates))._build();

  _$Measurement._(
      {required this.id,
      required this.memberId,
      this.recordedByUserId,
      required this.recordedAt,
      this.notes,
      this.values})
      : super._();
  @override
  Measurement rebuild(void Function(MeasurementBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeasurementBuilder toBuilder() => MeasurementBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Measurement &&
        id == other.id &&
        memberId == other.memberId &&
        recordedByUserId == other.recordedByUserId &&
        recordedAt == other.recordedAt &&
        notes == other.notes &&
        values == other.values;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, recordedByUserId.hashCode);
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, values.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Measurement')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('recordedByUserId', recordedByUserId)
          ..add('recordedAt', recordedAt)
          ..add('notes', notes)
          ..add('values', values))
        .toString();
  }
}

class MeasurementBuilder implements Builder<Measurement, MeasurementBuilder> {
  _$Measurement? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _recordedByUserId;
  int? get recordedByUserId => _$this._recordedByUserId;
  set recordedByUserId(int? recordedByUserId) =>
      _$this._recordedByUserId = recordedByUserId;

  DateTime? _recordedAt;
  DateTime? get recordedAt => _$this._recordedAt;
  set recordedAt(DateTime? recordedAt) => _$this._recordedAt = recordedAt;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  ListBuilder<MeasurementValue>? _values;
  ListBuilder<MeasurementValue> get values =>
      _$this._values ??= ListBuilder<MeasurementValue>();
  set values(ListBuilder<MeasurementValue>? values) => _$this._values = values;

  MeasurementBuilder() {
    Measurement._defaults(this);
  }

  MeasurementBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _recordedByUserId = $v.recordedByUserId;
      _recordedAt = $v.recordedAt;
      _notes = $v.notes;
      _values = $v.values?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Measurement other) {
    _$v = other as _$Measurement;
  }

  @override
  void update(void Function(MeasurementBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Measurement build() => _build();

  _$Measurement _build() {
    _$Measurement _$result;
    try {
      _$result = _$v ??
          _$Measurement._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Measurement', 'id'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'Measurement', 'memberId'),
            recordedByUserId: recordedByUserId,
            recordedAt: BuiltValueNullFieldError.checkNotNull(
                recordedAt, r'Measurement', 'recordedAt'),
            notes: notes,
            values: _values?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'values';
        _values?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Measurement', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
