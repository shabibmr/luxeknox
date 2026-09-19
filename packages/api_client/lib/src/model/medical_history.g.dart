// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_history.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MedicalHistory extends MedicalHistory {
  @override
  final int id;
  @override
  final int memberId;
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
  @override
  final String? documentUrl;

  factory _$MedicalHistory([void Function(MedicalHistoryBuilder)? updates]) =>
      (MedicalHistoryBuilder()..update(updates))._build();

  _$MedicalHistory._(
      {required this.id,
      required this.memberId,
      this.conditionId,
      required this.title,
      this.description,
      this.diagnosedDate,
      this.clearanceStatus,
      this.documentUrl})
      : super._();
  @override
  MedicalHistory rebuild(void Function(MedicalHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MedicalHistoryBuilder toBuilder() => MedicalHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MedicalHistory &&
        id == other.id &&
        memberId == other.memberId &&
        conditionId == other.conditionId &&
        title == other.title &&
        description == other.description &&
        diagnosedDate == other.diagnosedDate &&
        clearanceStatus == other.clearanceStatus &&
        documentUrl == other.documentUrl;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, conditionId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, diagnosedDate.hashCode);
    _$hash = $jc(_$hash, clearanceStatus.hashCode);
    _$hash = $jc(_$hash, documentUrl.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MedicalHistory')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('conditionId', conditionId)
          ..add('title', title)
          ..add('description', description)
          ..add('diagnosedDate', diagnosedDate)
          ..add('clearanceStatus', clearanceStatus)
          ..add('documentUrl', documentUrl))
        .toString();
  }
}

class MedicalHistoryBuilder
    implements Builder<MedicalHistory, MedicalHistoryBuilder> {
  _$MedicalHistory? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

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

  String? _documentUrl;
  String? get documentUrl => _$this._documentUrl;
  set documentUrl(String? documentUrl) => _$this._documentUrl = documentUrl;

  MedicalHistoryBuilder() {
    MedicalHistory._defaults(this);
  }

  MedicalHistoryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _conditionId = $v.conditionId;
      _title = $v.title;
      _description = $v.description;
      _diagnosedDate = $v.diagnosedDate;
      _clearanceStatus = $v.clearanceStatus;
      _documentUrl = $v.documentUrl;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MedicalHistory other) {
    _$v = other as _$MedicalHistory;
  }

  @override
  void update(void Function(MedicalHistoryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MedicalHistory build() => _build();

  _$MedicalHistory _build() {
    final _$result = _$v ??
        _$MedicalHistory._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'MedicalHistory', 'id'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'MedicalHistory', 'memberId'),
          conditionId: conditionId,
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'MedicalHistory', 'title'),
          description: description,
          diagnosedDate: diagnosedDate,
          clearanceStatus: clearanceStatus,
          documentUrl: documentUrl,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
