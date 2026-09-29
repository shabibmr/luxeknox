// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_subscription.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtSubscription extends PtSubscription {
  @override
  final int id;
  @override
  final int memberId;
  @override
  final int ptProductId;
  @override
  final int trainerId;
  @override
  final int? membershipId;
  @override
  final int? renewedFromId;
  @override
  final Date startDate;
  @override
  final Date endDate;
  @override
  final BuiltList<int> weekdays;
  @override
  final String slotStart;
  @override
  final PtSubscriptionStatus status;
  @override
  final int rowVersion;
  @override
  final String productName;
  @override
  final int sessionsPerWeek;
  @override
  final String trainerName;
  @override
  final String slotLabel;

  factory _$PtSubscription([void Function(PtSubscriptionBuilder)? updates]) =>
      (PtSubscriptionBuilder()..update(updates))._build();

  _$PtSubscription._(
      {required this.id,
      required this.memberId,
      required this.ptProductId,
      required this.trainerId,
      this.membershipId,
      this.renewedFromId,
      required this.startDate,
      required this.endDate,
      required this.weekdays,
      required this.slotStart,
      required this.status,
      required this.rowVersion,
      required this.productName,
      required this.sessionsPerWeek,
      required this.trainerName,
      required this.slotLabel})
      : super._();
  @override
  PtSubscription rebuild(void Function(PtSubscriptionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtSubscriptionBuilder toBuilder() => PtSubscriptionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtSubscription &&
        id == other.id &&
        memberId == other.memberId &&
        ptProductId == other.ptProductId &&
        trainerId == other.trainerId &&
        membershipId == other.membershipId &&
        renewedFromId == other.renewedFromId &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        weekdays == other.weekdays &&
        slotStart == other.slotStart &&
        status == other.status &&
        rowVersion == other.rowVersion &&
        productName == other.productName &&
        sessionsPerWeek == other.sessionsPerWeek &&
        trainerName == other.trainerName &&
        slotLabel == other.slotLabel;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, ptProductId.hashCode);
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, membershipId.hashCode);
    _$hash = $jc(_$hash, renewedFromId.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, weekdays.hashCode);
    _$hash = $jc(_$hash, slotStart.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, rowVersion.hashCode);
    _$hash = $jc(_$hash, productName.hashCode);
    _$hash = $jc(_$hash, sessionsPerWeek.hashCode);
    _$hash = $jc(_$hash, trainerName.hashCode);
    _$hash = $jc(_$hash, slotLabel.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtSubscription')
          ..add('id', id)
          ..add('memberId', memberId)
          ..add('ptProductId', ptProductId)
          ..add('trainerId', trainerId)
          ..add('membershipId', membershipId)
          ..add('renewedFromId', renewedFromId)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('weekdays', weekdays)
          ..add('slotStart', slotStart)
          ..add('status', status)
          ..add('rowVersion', rowVersion)
          ..add('productName', productName)
          ..add('sessionsPerWeek', sessionsPerWeek)
          ..add('trainerName', trainerName)
          ..add('slotLabel', slotLabel))
        .toString();
  }
}

class PtSubscriptionBuilder
    implements Builder<PtSubscription, PtSubscriptionBuilder> {
  _$PtSubscription? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _ptProductId;
  int? get ptProductId => _$this._ptProductId;
  set ptProductId(int? ptProductId) => _$this._ptProductId = ptProductId;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  int? _membershipId;
  int? get membershipId => _$this._membershipId;
  set membershipId(int? membershipId) => _$this._membershipId = membershipId;

  int? _renewedFromId;
  int? get renewedFromId => _$this._renewedFromId;
  set renewedFromId(int? renewedFromId) =>
      _$this._renewedFromId = renewedFromId;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  ListBuilder<int>? _weekdays;
  ListBuilder<int> get weekdays => _$this._weekdays ??= ListBuilder<int>();
  set weekdays(ListBuilder<int>? weekdays) => _$this._weekdays = weekdays;

  String? _slotStart;
  String? get slotStart => _$this._slotStart;
  set slotStart(String? slotStart) => _$this._slotStart = slotStart;

  PtSubscriptionStatus? _status;
  PtSubscriptionStatus? get status => _$this._status;
  set status(PtSubscriptionStatus? status) => _$this._status = status;

  int? _rowVersion;
  int? get rowVersion => _$this._rowVersion;
  set rowVersion(int? rowVersion) => _$this._rowVersion = rowVersion;

  String? _productName;
  String? get productName => _$this._productName;
  set productName(String? productName) => _$this._productName = productName;

  int? _sessionsPerWeek;
  int? get sessionsPerWeek => _$this._sessionsPerWeek;
  set sessionsPerWeek(int? sessionsPerWeek) =>
      _$this._sessionsPerWeek = sessionsPerWeek;

  String? _trainerName;
  String? get trainerName => _$this._trainerName;
  set trainerName(String? trainerName) => _$this._trainerName = trainerName;

  String? _slotLabel;
  String? get slotLabel => _$this._slotLabel;
  set slotLabel(String? slotLabel) => _$this._slotLabel = slotLabel;

  PtSubscriptionBuilder() {
    PtSubscription._defaults(this);
  }

  PtSubscriptionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _memberId = $v.memberId;
      _ptProductId = $v.ptProductId;
      _trainerId = $v.trainerId;
      _membershipId = $v.membershipId;
      _renewedFromId = $v.renewedFromId;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _weekdays = $v.weekdays.toBuilder();
      _slotStart = $v.slotStart;
      _status = $v.status;
      _rowVersion = $v.rowVersion;
      _productName = $v.productName;
      _sessionsPerWeek = $v.sessionsPerWeek;
      _trainerName = $v.trainerName;
      _slotLabel = $v.slotLabel;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtSubscription other) {
    _$v = other as _$PtSubscription;
  }

  @override
  void update(void Function(PtSubscriptionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtSubscription build() => _build();

  _$PtSubscription _build() {
    _$PtSubscription _$result;
    try {
      _$result = _$v ??
          _$PtSubscription._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'PtSubscription', 'id'),
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'PtSubscription', 'memberId'),
            ptProductId: BuiltValueNullFieldError.checkNotNull(
                ptProductId, r'PtSubscription', 'ptProductId'),
            trainerId: BuiltValueNullFieldError.checkNotNull(
                trainerId, r'PtSubscription', 'trainerId'),
            membershipId: membershipId,
            renewedFromId: renewedFromId,
            startDate: BuiltValueNullFieldError.checkNotNull(
                startDate, r'PtSubscription', 'startDate'),
            endDate: BuiltValueNullFieldError.checkNotNull(
                endDate, r'PtSubscription', 'endDate'),
            weekdays: weekdays.build(),
            slotStart: BuiltValueNullFieldError.checkNotNull(
                slotStart, r'PtSubscription', 'slotStart'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PtSubscription', 'status'),
            rowVersion: BuiltValueNullFieldError.checkNotNull(
                rowVersion, r'PtSubscription', 'rowVersion'),
            productName: BuiltValueNullFieldError.checkNotNull(
                productName, r'PtSubscription', 'productName'),
            sessionsPerWeek: BuiltValueNullFieldError.checkNotNull(
                sessionsPerWeek, r'PtSubscription', 'sessionsPerWeek'),
            trainerName: BuiltValueNullFieldError.checkNotNull(
                trainerName, r'PtSubscription', 'trainerName'),
            slotLabel: BuiltValueNullFieldError.checkNotNull(
                slotLabel, r'PtSubscription', 'slotLabel'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weekdays';
        weekdays.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtSubscription', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
