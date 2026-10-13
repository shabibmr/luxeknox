// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'open_items_report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const OpenItemsReportKindEnum _$openItemsReportKindEnum_ar =
    const OpenItemsReportKindEnum._('ar');
const OpenItemsReportKindEnum _$openItemsReportKindEnum_ap =
    const OpenItemsReportKindEnum._('ap');

OpenItemsReportKindEnum _$openItemsReportKindEnumValueOf(String name) {
  switch (name) {
    case 'ar':
      return _$openItemsReportKindEnum_ar;
    case 'ap':
      return _$openItemsReportKindEnum_ap;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<OpenItemsReportKindEnum> _$openItemsReportKindEnumValues =
    BuiltSet<OpenItemsReportKindEnum>(const <OpenItemsReportKindEnum>[
  _$openItemsReportKindEnum_ar,
  _$openItemsReportKindEnum_ap,
]);

Serializer<OpenItemsReportKindEnum> _$openItemsReportKindEnumSerializer =
    _$OpenItemsReportKindEnumSerializer();

class _$OpenItemsReportKindEnumSerializer
    implements PrimitiveSerializer<OpenItemsReportKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ar': 'ar',
    'ap': 'ap',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ar': 'ar',
    'ap': 'ap',
  };

  @override
  final Iterable<Type> types = const <Type>[OpenItemsReportKindEnum];
  @override
  final String wireName = 'OpenItemsReportKindEnum';

  @override
  Object serialize(Serializers serializers, OpenItemsReportKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  OpenItemsReportKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      OpenItemsReportKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$OpenItemsReport extends OpenItemsReport {
  @override
  final OpenItemsReportKindEnum kind;
  @override
  final BuiltList<OpenArItem>? arItems;
  @override
  final BuiltList<OpenApItem>? apItems;
  @override
  final String totalOpenAmount;

  factory _$OpenItemsReport([void Function(OpenItemsReportBuilder)? updates]) =>
      (OpenItemsReportBuilder()..update(updates))._build();

  _$OpenItemsReport._(
      {required this.kind,
      this.arItems,
      this.apItems,
      required this.totalOpenAmount})
      : super._();
  @override
  OpenItemsReport rebuild(void Function(OpenItemsReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OpenItemsReportBuilder toBuilder() => OpenItemsReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OpenItemsReport &&
        kind == other.kind &&
        arItems == other.arItems &&
        apItems == other.apItems &&
        totalOpenAmount == other.totalOpenAmount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, arItems.hashCode);
    _$hash = $jc(_$hash, apItems.hashCode);
    _$hash = $jc(_$hash, totalOpenAmount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OpenItemsReport')
          ..add('kind', kind)
          ..add('arItems', arItems)
          ..add('apItems', apItems)
          ..add('totalOpenAmount', totalOpenAmount))
        .toString();
  }
}

class OpenItemsReportBuilder
    implements Builder<OpenItemsReport, OpenItemsReportBuilder> {
  _$OpenItemsReport? _$v;

  OpenItemsReportKindEnum? _kind;
  OpenItemsReportKindEnum? get kind => _$this._kind;
  set kind(OpenItemsReportKindEnum? kind) => _$this._kind = kind;

  ListBuilder<OpenArItem>? _arItems;
  ListBuilder<OpenArItem> get arItems =>
      _$this._arItems ??= ListBuilder<OpenArItem>();
  set arItems(ListBuilder<OpenArItem>? arItems) => _$this._arItems = arItems;

  ListBuilder<OpenApItem>? _apItems;
  ListBuilder<OpenApItem> get apItems =>
      _$this._apItems ??= ListBuilder<OpenApItem>();
  set apItems(ListBuilder<OpenApItem>? apItems) => _$this._apItems = apItems;

  String? _totalOpenAmount;
  String? get totalOpenAmount => _$this._totalOpenAmount;
  set totalOpenAmount(String? totalOpenAmount) =>
      _$this._totalOpenAmount = totalOpenAmount;

  OpenItemsReportBuilder() {
    OpenItemsReport._defaults(this);
  }

  OpenItemsReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _arItems = $v.arItems?.toBuilder();
      _apItems = $v.apItems?.toBuilder();
      _totalOpenAmount = $v.totalOpenAmount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OpenItemsReport other) {
    _$v = other as _$OpenItemsReport;
  }

  @override
  void update(void Function(OpenItemsReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OpenItemsReport build() => _build();

  _$OpenItemsReport _build() {
    _$OpenItemsReport _$result;
    try {
      _$result = _$v ??
          _$OpenItemsReport._(
            kind: BuiltValueNullFieldError.checkNotNull(
                kind, r'OpenItemsReport', 'kind'),
            arItems: _arItems?.build(),
            apItems: _apItems?.build(),
            totalOpenAmount: BuiltValueNullFieldError.checkNotNull(
                totalOpenAmount, r'OpenItemsReport', 'totalOpenAmount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'arItems';
        _arItems?.build();
        _$failedField = 'apItems';
        _apItems?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OpenItemsReport', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
