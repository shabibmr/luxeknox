// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_grid_cell.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PtGridCellStatusEnum _$ptGridCellStatusEnum_free =
    const PtGridCellStatusEnum._('free');
const PtGridCellStatusEnum _$ptGridCellStatusEnum_occupied =
    const PtGridCellStatusEnum._('occupied');
const PtGridCellStatusEnum _$ptGridCellStatusEnum_unavailable =
    const PtGridCellStatusEnum._('unavailable');

PtGridCellStatusEnum _$ptGridCellStatusEnumValueOf(String name) {
  switch (name) {
    case 'free':
      return _$ptGridCellStatusEnum_free;
    case 'occupied':
      return _$ptGridCellStatusEnum_occupied;
    case 'unavailable':
      return _$ptGridCellStatusEnum_unavailable;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PtGridCellStatusEnum> _$ptGridCellStatusEnumValues =
    BuiltSet<PtGridCellStatusEnum>(const <PtGridCellStatusEnum>[
  _$ptGridCellStatusEnum_free,
  _$ptGridCellStatusEnum_occupied,
  _$ptGridCellStatusEnum_unavailable,
]);

Serializer<PtGridCellStatusEnum> _$ptGridCellStatusEnumSerializer =
    _$PtGridCellStatusEnumSerializer();

class _$PtGridCellStatusEnumSerializer
    implements PrimitiveSerializer<PtGridCellStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'free': 'free',
    'occupied': 'occupied',
    'unavailable': 'unavailable',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'free': 'free',
    'occupied': 'occupied',
    'unavailable': 'unavailable',
  };

  @override
  final Iterable<Type> types = const <Type>[PtGridCellStatusEnum];
  @override
  final String wireName = 'PtGridCellStatusEnum';

  @override
  Object serialize(Serializers serializers, PtGridCellStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PtGridCellStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PtGridCellStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PtGridCell extends PtGridCell {
  @override
  final int trainerId;
  @override
  final String slotStart;
  @override
  final PtGridCellStatusEnum status;
  @override
  final String? occupiedBy;
  @override
  final BuiltList<Date> conflictDates;

  factory _$PtGridCell([void Function(PtGridCellBuilder)? updates]) =>
      (PtGridCellBuilder()..update(updates))._build();

  _$PtGridCell._(
      {required this.trainerId,
      required this.slotStart,
      required this.status,
      this.occupiedBy,
      required this.conflictDates})
      : super._();
  @override
  PtGridCell rebuild(void Function(PtGridCellBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtGridCellBuilder toBuilder() => PtGridCellBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtGridCell &&
        trainerId == other.trainerId &&
        slotStart == other.slotStart &&
        status == other.status &&
        occupiedBy == other.occupiedBy &&
        conflictDates == other.conflictDates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, trainerId.hashCode);
    _$hash = $jc(_$hash, slotStart.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, occupiedBy.hashCode);
    _$hash = $jc(_$hash, conflictDates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtGridCell')
          ..add('trainerId', trainerId)
          ..add('slotStart', slotStart)
          ..add('status', status)
          ..add('occupiedBy', occupiedBy)
          ..add('conflictDates', conflictDates))
        .toString();
  }
}

class PtGridCellBuilder implements Builder<PtGridCell, PtGridCellBuilder> {
  _$PtGridCell? _$v;

  int? _trainerId;
  int? get trainerId => _$this._trainerId;
  set trainerId(int? trainerId) => _$this._trainerId = trainerId;

  String? _slotStart;
  String? get slotStart => _$this._slotStart;
  set slotStart(String? slotStart) => _$this._slotStart = slotStart;

  PtGridCellStatusEnum? _status;
  PtGridCellStatusEnum? get status => _$this._status;
  set status(PtGridCellStatusEnum? status) => _$this._status = status;

  String? _occupiedBy;
  String? get occupiedBy => _$this._occupiedBy;
  set occupiedBy(String? occupiedBy) => _$this._occupiedBy = occupiedBy;

  ListBuilder<Date>? _conflictDates;
  ListBuilder<Date> get conflictDates =>
      _$this._conflictDates ??= ListBuilder<Date>();
  set conflictDates(ListBuilder<Date>? conflictDates) =>
      _$this._conflictDates = conflictDates;

  PtGridCellBuilder() {
    PtGridCell._defaults(this);
  }

  PtGridCellBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _trainerId = $v.trainerId;
      _slotStart = $v.slotStart;
      _status = $v.status;
      _occupiedBy = $v.occupiedBy;
      _conflictDates = $v.conflictDates.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtGridCell other) {
    _$v = other as _$PtGridCell;
  }

  @override
  void update(void Function(PtGridCellBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtGridCell build() => _build();

  _$PtGridCell _build() {
    _$PtGridCell _$result;
    try {
      _$result = _$v ??
          _$PtGridCell._(
            trainerId: BuiltValueNullFieldError.checkNotNull(
                trainerId, r'PtGridCell', 'trainerId'),
            slotStart: BuiltValueNullFieldError.checkNotNull(
                slotStart, r'PtGridCell', 'slotStart'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'PtGridCell', 'status'),
            occupiedBy: occupiedBy,
            conflictDates: conflictDates.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'conflictDates';
        conflictDates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtGridCell', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
