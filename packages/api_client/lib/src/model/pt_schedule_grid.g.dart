// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_schedule_grid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtScheduleGrid extends PtScheduleGrid {
  @override
  final int memberId;
  @override
  final Date startDate;
  @override
  final Date endDate;
  @override
  final BuiltList<int> weekdays;
  @override
  final BuiltList<String> hours;
  @override
  final BuiltList<PtGridTrainer> trainers;
  @override
  final BuiltList<PtGridCell> cells;

  factory _$PtScheduleGrid([void Function(PtScheduleGridBuilder)? updates]) =>
      (PtScheduleGridBuilder()..update(updates))._build();

  _$PtScheduleGrid._(
      {required this.memberId,
      required this.startDate,
      required this.endDate,
      required this.weekdays,
      required this.hours,
      required this.trainers,
      required this.cells})
      : super._();
  @override
  PtScheduleGrid rebuild(void Function(PtScheduleGridBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtScheduleGridBuilder toBuilder() => PtScheduleGridBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtScheduleGrid &&
        memberId == other.memberId &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        weekdays == other.weekdays &&
        hours == other.hours &&
        trainers == other.trainers &&
        cells == other.cells;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, endDate.hashCode);
    _$hash = $jc(_$hash, weekdays.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jc(_$hash, trainers.hashCode);
    _$hash = $jc(_$hash, cells.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtScheduleGrid')
          ..add('memberId', memberId)
          ..add('startDate', startDate)
          ..add('endDate', endDate)
          ..add('weekdays', weekdays)
          ..add('hours', hours)
          ..add('trainers', trainers)
          ..add('cells', cells))
        .toString();
  }
}

class PtScheduleGridBuilder
    implements Builder<PtScheduleGrid, PtScheduleGridBuilder> {
  _$PtScheduleGrid? _$v;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  Date? _startDate;
  Date? get startDate => _$this._startDate;
  set startDate(Date? startDate) => _$this._startDate = startDate;

  Date? _endDate;
  Date? get endDate => _$this._endDate;
  set endDate(Date? endDate) => _$this._endDate = endDate;

  ListBuilder<int>? _weekdays;
  ListBuilder<int> get weekdays => _$this._weekdays ??= ListBuilder<int>();
  set weekdays(ListBuilder<int>? weekdays) => _$this._weekdays = weekdays;

  ListBuilder<String>? _hours;
  ListBuilder<String> get hours => _$this._hours ??= ListBuilder<String>();
  set hours(ListBuilder<String>? hours) => _$this._hours = hours;

  ListBuilder<PtGridTrainer>? _trainers;
  ListBuilder<PtGridTrainer> get trainers =>
      _$this._trainers ??= ListBuilder<PtGridTrainer>();
  set trainers(ListBuilder<PtGridTrainer>? trainers) =>
      _$this._trainers = trainers;

  ListBuilder<PtGridCell>? _cells;
  ListBuilder<PtGridCell> get cells =>
      _$this._cells ??= ListBuilder<PtGridCell>();
  set cells(ListBuilder<PtGridCell>? cells) => _$this._cells = cells;

  PtScheduleGridBuilder() {
    PtScheduleGrid._defaults(this);
  }

  PtScheduleGridBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _startDate = $v.startDate;
      _endDate = $v.endDate;
      _weekdays = $v.weekdays.toBuilder();
      _hours = $v.hours.toBuilder();
      _trainers = $v.trainers.toBuilder();
      _cells = $v.cells.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtScheduleGrid other) {
    _$v = other as _$PtScheduleGrid;
  }

  @override
  void update(void Function(PtScheduleGridBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtScheduleGrid build() => _build();

  _$PtScheduleGrid _build() {
    _$PtScheduleGrid _$result;
    try {
      _$result = _$v ??
          _$PtScheduleGrid._(
            memberId: BuiltValueNullFieldError.checkNotNull(
                memberId, r'PtScheduleGrid', 'memberId'),
            startDate: BuiltValueNullFieldError.checkNotNull(
                startDate, r'PtScheduleGrid', 'startDate'),
            endDate: BuiltValueNullFieldError.checkNotNull(
                endDate, r'PtScheduleGrid', 'endDate'),
            weekdays: weekdays.build(),
            hours: hours.build(),
            trainers: trainers.build(),
            cells: cells.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'weekdays';
        weekdays.build();
        _$failedField = 'hours';
        hours.build();
        _$failedField = 'trainers';
        trainers.build();
        _$failedField = 'cells';
        cells.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PtScheduleGrid', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
