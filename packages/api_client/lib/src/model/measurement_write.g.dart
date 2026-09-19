// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measurement_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MeasurementWrite extends MeasurementWrite {
  @override
  final DateTime? recordedAt;
  @override
  final String? notes;
  @override
  final BuiltList<MeasurementValue> values;

  factory _$MeasurementWrite(
          [void Function(MeasurementWriteBuilder)? updates]) =>
      (MeasurementWriteBuilder()..update(updates))._build();

  _$MeasurementWrite._({this.recordedAt, this.notes, required this.values})
      : super._();
  @override
  MeasurementWrite rebuild(void Function(MeasurementWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MeasurementWriteBuilder toBuilder() =>
      MeasurementWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MeasurementWrite &&
        recordedAt == other.recordedAt &&
        notes == other.notes &&
        values == other.values;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recordedAt.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, values.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MeasurementWrite')
          ..add('recordedAt', recordedAt)
          ..add('notes', notes)
          ..add('values', values))
        .toString();
  }
}

class MeasurementWriteBuilder
    implements Builder<MeasurementWrite, MeasurementWriteBuilder> {
  _$MeasurementWrite? _$v;

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

  MeasurementWriteBuilder() {
    MeasurementWrite._defaults(this);
  }

  MeasurementWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recordedAt = $v.recordedAt;
      _notes = $v.notes;
      _values = $v.values.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MeasurementWrite other) {
    _$v = other as _$MeasurementWrite;
  }

  @override
  void update(void Function(MeasurementWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MeasurementWrite build() => _build();

  _$MeasurementWrite _build() {
    _$MeasurementWrite _$result;
    try {
      _$result = _$v ??
          _$MeasurementWrite._(
            recordedAt: recordedAt,
            notes: notes,
            values: values.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'values';
        values.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'MeasurementWrite', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
