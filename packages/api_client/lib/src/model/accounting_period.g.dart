// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_period.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AccountingPeriodStatusEnum _$accountingPeriodStatusEnum_open =
    const AccountingPeriodStatusEnum._('open');
const AccountingPeriodStatusEnum _$accountingPeriodStatusEnum_locked =
    const AccountingPeriodStatusEnum._('locked');

AccountingPeriodStatusEnum _$accountingPeriodStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$accountingPeriodStatusEnum_open;
    case 'locked':
      return _$accountingPeriodStatusEnum_locked;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AccountingPeriodStatusEnum> _$accountingPeriodStatusEnumValues =
    BuiltSet<AccountingPeriodStatusEnum>(const <AccountingPeriodStatusEnum>[
  _$accountingPeriodStatusEnum_open,
  _$accountingPeriodStatusEnum_locked,
]);

Serializer<AccountingPeriodStatusEnum> _$accountingPeriodStatusEnumSerializer =
    _$AccountingPeriodStatusEnumSerializer();

class _$AccountingPeriodStatusEnumSerializer
    implements PrimitiveSerializer<AccountingPeriodStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'locked': 'locked',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'locked': 'locked',
  };

  @override
  final Iterable<Type> types = const <Type>[AccountingPeriodStatusEnum];
  @override
  final String wireName = 'AccountingPeriodStatusEnum';

  @override
  Object serialize(Serializers serializers, AccountingPeriodStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  AccountingPeriodStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AccountingPeriodStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$AccountingPeriod extends AccountingPeriod {
  @override
  final int id;
  @override
  final int fiscalYearId;
  @override
  final Date startsOn;
  @override
  final Date endsOn;
  @override
  final AccountingPeriodStatusEnum status;
  @override
  final DateTime? closedAt;
  @override
  final int? closedByUserId;
  @override
  final DraftDocumentCounts? draftDocumentCounts;

  factory _$AccountingPeriod(
          [void Function(AccountingPeriodBuilder)? updates]) =>
      (AccountingPeriodBuilder()..update(updates))._build();

  _$AccountingPeriod._(
      {required this.id,
      required this.fiscalYearId,
      required this.startsOn,
      required this.endsOn,
      required this.status,
      this.closedAt,
      this.closedByUserId,
      this.draftDocumentCounts})
      : super._();
  @override
  AccountingPeriod rebuild(void Function(AccountingPeriodBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AccountingPeriodBuilder toBuilder() =>
      AccountingPeriodBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AccountingPeriod &&
        id == other.id &&
        fiscalYearId == other.fiscalYearId &&
        startsOn == other.startsOn &&
        endsOn == other.endsOn &&
        status == other.status &&
        closedAt == other.closedAt &&
        closedByUserId == other.closedByUserId &&
        draftDocumentCounts == other.draftDocumentCounts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fiscalYearId.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, closedByUserId.hashCode);
    _$hash = $jc(_$hash, draftDocumentCounts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AccountingPeriod')
          ..add('id', id)
          ..add('fiscalYearId', fiscalYearId)
          ..add('startsOn', startsOn)
          ..add('endsOn', endsOn)
          ..add('status', status)
          ..add('closedAt', closedAt)
          ..add('closedByUserId', closedByUserId)
          ..add('draftDocumentCounts', draftDocumentCounts))
        .toString();
  }
}

class AccountingPeriodBuilder
    implements Builder<AccountingPeriod, AccountingPeriodBuilder> {
  _$AccountingPeriod? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  int? _fiscalYearId;
  int? get fiscalYearId => _$this._fiscalYearId;
  set fiscalYearId(int? fiscalYearId) => _$this._fiscalYearId = fiscalYearId;

  Date? _startsOn;
  Date? get startsOn => _$this._startsOn;
  set startsOn(Date? startsOn) => _$this._startsOn = startsOn;

  Date? _endsOn;
  Date? get endsOn => _$this._endsOn;
  set endsOn(Date? endsOn) => _$this._endsOn = endsOn;

  AccountingPeriodStatusEnum? _status;
  AccountingPeriodStatusEnum? get status => _$this._status;
  set status(AccountingPeriodStatusEnum? status) => _$this._status = status;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  int? _closedByUserId;
  int? get closedByUserId => _$this._closedByUserId;
  set closedByUserId(int? closedByUserId) =>
      _$this._closedByUserId = closedByUserId;

  DraftDocumentCountsBuilder? _draftDocumentCounts;
  DraftDocumentCountsBuilder get draftDocumentCounts =>
      _$this._draftDocumentCounts ??= DraftDocumentCountsBuilder();
  set draftDocumentCounts(DraftDocumentCountsBuilder? draftDocumentCounts) =>
      _$this._draftDocumentCounts = draftDocumentCounts;

  AccountingPeriodBuilder() {
    AccountingPeriod._defaults(this);
  }

  AccountingPeriodBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fiscalYearId = $v.fiscalYearId;
      _startsOn = $v.startsOn;
      _endsOn = $v.endsOn;
      _status = $v.status;
      _closedAt = $v.closedAt;
      _closedByUserId = $v.closedByUserId;
      _draftDocumentCounts = $v.draftDocumentCounts?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AccountingPeriod other) {
    _$v = other as _$AccountingPeriod;
  }

  @override
  void update(void Function(AccountingPeriodBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AccountingPeriod build() => _build();

  _$AccountingPeriod _build() {
    _$AccountingPeriod _$result;
    try {
      _$result = _$v ??
          _$AccountingPeriod._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'AccountingPeriod', 'id'),
            fiscalYearId: BuiltValueNullFieldError.checkNotNull(
                fiscalYearId, r'AccountingPeriod', 'fiscalYearId'),
            startsOn: BuiltValueNullFieldError.checkNotNull(
                startsOn, r'AccountingPeriod', 'startsOn'),
            endsOn: BuiltValueNullFieldError.checkNotNull(
                endsOn, r'AccountingPeriod', 'endsOn'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'AccountingPeriod', 'status'),
            closedAt: closedAt,
            closedByUserId: closedByUserId,
            draftDocumentCounts: _draftDocumentCounts?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'draftDocumentCounts';
        _draftDocumentCounts?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'AccountingPeriod', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
