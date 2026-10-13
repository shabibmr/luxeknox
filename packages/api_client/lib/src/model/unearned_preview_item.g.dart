// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unearned_preview_item.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const UnearnedPreviewItemKindEnum _$unearnedPreviewItemKindEnum_membership =
    const UnearnedPreviewItemKindEnum._('membership');
const UnearnedPreviewItemKindEnum _$unearnedPreviewItemKindEnum_pt =
    const UnearnedPreviewItemKindEnum._('pt');

UnearnedPreviewItemKindEnum _$unearnedPreviewItemKindEnumValueOf(String name) {
  switch (name) {
    case 'membership':
      return _$unearnedPreviewItemKindEnum_membership;
    case 'pt':
      return _$unearnedPreviewItemKindEnum_pt;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<UnearnedPreviewItemKindEnum>
    _$unearnedPreviewItemKindEnumValues =
    BuiltSet<UnearnedPreviewItemKindEnum>(const <UnearnedPreviewItemKindEnum>[
  _$unearnedPreviewItemKindEnum_membership,
  _$unearnedPreviewItemKindEnum_pt,
]);

Serializer<UnearnedPreviewItemKindEnum>
    _$unearnedPreviewItemKindEnumSerializer =
    _$UnearnedPreviewItemKindEnumSerializer();

class _$UnearnedPreviewItemKindEnumSerializer
    implements PrimitiveSerializer<UnearnedPreviewItemKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'membership': 'membership',
    'pt': 'pt',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'membership': 'membership',
    'pt': 'pt',
  };

  @override
  final Iterable<Type> types = const <Type>[UnearnedPreviewItemKindEnum];
  @override
  final String wireName = 'UnearnedPreviewItemKindEnum';

  @override
  Object serialize(Serializers serializers, UnearnedPreviewItemKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  UnearnedPreviewItemKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      UnearnedPreviewItemKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$UnearnedPreviewItem extends UnearnedPreviewItem {
  @override
  final UnearnedPreviewItemKindEnum kind;
  @override
  final int sourceId;
  @override
  final int paymentId;
  @override
  final int memberId;
  @override
  final Date startsOn;
  @override
  final Date endsOn;
  @override
  final int unearnedAccountId;
  @override
  final int incomeAccountId;
  @override
  final String accountCode;
  @override
  final String totalNet;
  @override
  final String unexpiredAmount;

  factory _$UnearnedPreviewItem(
          [void Function(UnearnedPreviewItemBuilder)? updates]) =>
      (UnearnedPreviewItemBuilder()..update(updates))._build();

  _$UnearnedPreviewItem._(
      {required this.kind,
      required this.sourceId,
      required this.paymentId,
      required this.memberId,
      required this.startsOn,
      required this.endsOn,
      required this.unearnedAccountId,
      required this.incomeAccountId,
      required this.accountCode,
      required this.totalNet,
      required this.unexpiredAmount})
      : super._();
  @override
  UnearnedPreviewItem rebuild(
          void Function(UnearnedPreviewItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UnearnedPreviewItemBuilder toBuilder() =>
      UnearnedPreviewItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UnearnedPreviewItem &&
        kind == other.kind &&
        sourceId == other.sourceId &&
        paymentId == other.paymentId &&
        memberId == other.memberId &&
        startsOn == other.startsOn &&
        endsOn == other.endsOn &&
        unearnedAccountId == other.unearnedAccountId &&
        incomeAccountId == other.incomeAccountId &&
        accountCode == other.accountCode &&
        totalNet == other.totalNet &&
        unexpiredAmount == other.unexpiredAmount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, sourceId.hashCode);
    _$hash = $jc(_$hash, paymentId.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, startsOn.hashCode);
    _$hash = $jc(_$hash, endsOn.hashCode);
    _$hash = $jc(_$hash, unearnedAccountId.hashCode);
    _$hash = $jc(_$hash, incomeAccountId.hashCode);
    _$hash = $jc(_$hash, accountCode.hashCode);
    _$hash = $jc(_$hash, totalNet.hashCode);
    _$hash = $jc(_$hash, unexpiredAmount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UnearnedPreviewItem')
          ..add('kind', kind)
          ..add('sourceId', sourceId)
          ..add('paymentId', paymentId)
          ..add('memberId', memberId)
          ..add('startsOn', startsOn)
          ..add('endsOn', endsOn)
          ..add('unearnedAccountId', unearnedAccountId)
          ..add('incomeAccountId', incomeAccountId)
          ..add('accountCode', accountCode)
          ..add('totalNet', totalNet)
          ..add('unexpiredAmount', unexpiredAmount))
        .toString();
  }
}

class UnearnedPreviewItemBuilder
    implements Builder<UnearnedPreviewItem, UnearnedPreviewItemBuilder> {
  _$UnearnedPreviewItem? _$v;

  UnearnedPreviewItemKindEnum? _kind;
  UnearnedPreviewItemKindEnum? get kind => _$this._kind;
  set kind(UnearnedPreviewItemKindEnum? kind) => _$this._kind = kind;

  int? _sourceId;
  int? get sourceId => _$this._sourceId;
  set sourceId(int? sourceId) => _$this._sourceId = sourceId;

  int? _paymentId;
  int? get paymentId => _$this._paymentId;
  set paymentId(int? paymentId) => _$this._paymentId = paymentId;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  Date? _startsOn;
  Date? get startsOn => _$this._startsOn;
  set startsOn(Date? startsOn) => _$this._startsOn = startsOn;

  Date? _endsOn;
  Date? get endsOn => _$this._endsOn;
  set endsOn(Date? endsOn) => _$this._endsOn = endsOn;

  int? _unearnedAccountId;
  int? get unearnedAccountId => _$this._unearnedAccountId;
  set unearnedAccountId(int? unearnedAccountId) =>
      _$this._unearnedAccountId = unearnedAccountId;

  int? _incomeAccountId;
  int? get incomeAccountId => _$this._incomeAccountId;
  set incomeAccountId(int? incomeAccountId) =>
      _$this._incomeAccountId = incomeAccountId;

  String? _accountCode;
  String? get accountCode => _$this._accountCode;
  set accountCode(String? accountCode) => _$this._accountCode = accountCode;

  String? _totalNet;
  String? get totalNet => _$this._totalNet;
  set totalNet(String? totalNet) => _$this._totalNet = totalNet;

  String? _unexpiredAmount;
  String? get unexpiredAmount => _$this._unexpiredAmount;
  set unexpiredAmount(String? unexpiredAmount) =>
      _$this._unexpiredAmount = unexpiredAmount;

  UnearnedPreviewItemBuilder() {
    UnearnedPreviewItem._defaults(this);
  }

  UnearnedPreviewItemBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _sourceId = $v.sourceId;
      _paymentId = $v.paymentId;
      _memberId = $v.memberId;
      _startsOn = $v.startsOn;
      _endsOn = $v.endsOn;
      _unearnedAccountId = $v.unearnedAccountId;
      _incomeAccountId = $v.incomeAccountId;
      _accountCode = $v.accountCode;
      _totalNet = $v.totalNet;
      _unexpiredAmount = $v.unexpiredAmount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UnearnedPreviewItem other) {
    _$v = other as _$UnearnedPreviewItem;
  }

  @override
  void update(void Function(UnearnedPreviewItemBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UnearnedPreviewItem build() => _build();

  _$UnearnedPreviewItem _build() {
    final _$result = _$v ??
        _$UnearnedPreviewItem._(
          kind: BuiltValueNullFieldError.checkNotNull(
              kind, r'UnearnedPreviewItem', 'kind'),
          sourceId: BuiltValueNullFieldError.checkNotNull(
              sourceId, r'UnearnedPreviewItem', 'sourceId'),
          paymentId: BuiltValueNullFieldError.checkNotNull(
              paymentId, r'UnearnedPreviewItem', 'paymentId'),
          memberId: BuiltValueNullFieldError.checkNotNull(
              memberId, r'UnearnedPreviewItem', 'memberId'),
          startsOn: BuiltValueNullFieldError.checkNotNull(
              startsOn, r'UnearnedPreviewItem', 'startsOn'),
          endsOn: BuiltValueNullFieldError.checkNotNull(
              endsOn, r'UnearnedPreviewItem', 'endsOn'),
          unearnedAccountId: BuiltValueNullFieldError.checkNotNull(
              unearnedAccountId, r'UnearnedPreviewItem', 'unearnedAccountId'),
          incomeAccountId: BuiltValueNullFieldError.checkNotNull(
              incomeAccountId, r'UnearnedPreviewItem', 'incomeAccountId'),
          accountCode: BuiltValueNullFieldError.checkNotNull(
              accountCode, r'UnearnedPreviewItem', 'accountCode'),
          totalNet: BuiltValueNullFieldError.checkNotNull(
              totalNet, r'UnearnedPreviewItem', 'totalNet'),
          unexpiredAmount: BuiltValueNullFieldError.checkNotNull(
              unexpiredAmount, r'UnearnedPreviewItem', 'unexpiredAmount'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
