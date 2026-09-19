// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_history_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MedicalHistoryWrite extends MedicalHistoryWrite {
  @override
  final int? conditionId;
  @override
  final String title;
  @override
  final String? description;
  @override
  final Date? diagnosedDate;
  @override
  final String? clearanceStatus;

  factory _$MedicalHistoryWrite(
          [void Function(MedicalHistoryWriteBuilder)? updates]) =>
      (MedicalHistoryWriteBuilder()..update(updates))._build();

  _$MedicalHistoryWrite._(
      {this.conditionId,
      required this.title,
      this.description,
      this.diagnosedDate,
      this.clearanceStatus})
      : super._();
  @override
  MedicalHistoryWrite rebuild(
          void Function(MedicalHistoryWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MedicalHistoryWriteBuilder toBuilder() =>
      MedicalHistoryWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MedicalHistoryWrite &&
        conditionId == other.conditionId &&
        title == other.title &&
        description == other.description &&
        diagnosedDate == other.diagnosedDate &&
        clearanceStatus == other.clearanceStatus;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, conditionId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, diagnosedDate.hashCode);
    _$hash = $jc(_$hash, clearanceStatus.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MedicalHistoryWrite')
          ..add('conditionId', conditionId)
          ..add('title', title)
          ..add('description', description)
          ..add('diagnosedDate', diagnosedDate)
          ..add('clearanceStatus', clearanceStatus))
        .toString();
  }
}

class MedicalHistoryWriteBuilder
    implements Builder<MedicalHistoryWrite, MedicalHistoryWriteBuilder> {
  _$MedicalHistoryWrite? _$v;

  int? _conditionId;
  int? get conditionId => _$this._conditionId;
  set conditionId(int? conditionId) => _$this._conditionId = conditionId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  Date? _diagnosedDate;
  Date? get diagnosedDate => _$this._diagnosedDate;
  set diagnosedDate(Date? diagnosedDate) =>
      _$this._diagnosedDate = diagnosedDate;

  String? _clearanceStatus;
  String? get clearanceStatus => _$this._clearanceStatus;
  set clearanceStatus(String? clearanceStatus) =>
      _$this._clearanceStatus = clearanceStatus;

  MedicalHistoryWriteBuilder() {
    MedicalHistoryWrite._defaults(this);
  }

  MedicalHistoryWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _conditionId = $v.conditionId;
      _title = $v.title;
      _description = $v.description;
      _diagnosedDate = $v.diagnosedDate;
      _clearanceStatus = $v.clearanceStatus;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MedicalHistoryWrite other) {
    _$v = other as _$MedicalHistoryWrite;
  }

  @override
  void update(void Function(MedicalHistoryWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MedicalHistoryWrite build() => _build();

  _$MedicalHistoryWrite _build() {
    final _$result = _$v ??
        _$MedicalHistoryWrite._(
          conditionId: conditionId,
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'MedicalHistoryWrite', 'title'),
          description: description,
          diagnosedDate: diagnosedDate,
          clearanceStatus: clearanceStatus,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
