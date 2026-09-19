// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_type.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScheduleType extends ScheduleType {
  @override
  final int id;
  @override
  final String name;
  @override
  final String? colorCode;
  @override
  final int? defaultDurationMinutes;
  @override
  final bool? requiresTrainer;

  factory _$ScheduleType([void Function(ScheduleTypeBuilder)? updates]) =>
      (ScheduleTypeBuilder()..update(updates))._build();

  _$ScheduleType._(
      {required this.id,
      required this.name,
      this.colorCode,
      this.defaultDurationMinutes,
      this.requiresTrainer})
      : super._();
  @override
  ScheduleType rebuild(void Function(ScheduleTypeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleTypeBuilder toBuilder() => ScheduleTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleType &&
        id == other.id &&
        name == other.name &&
        colorCode == other.colorCode &&
        defaultDurationMinutes == other.defaultDurationMinutes &&
        requiresTrainer == other.requiresTrainer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, colorCode.hashCode);
    _$hash = $jc(_$hash, defaultDurationMinutes.hashCode);
    _$hash = $jc(_$hash, requiresTrainer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduleType')
          ..add('id', id)
          ..add('name', name)
          ..add('colorCode', colorCode)
          ..add('defaultDurationMinutes', defaultDurationMinutes)
          ..add('requiresTrainer', requiresTrainer))
        .toString();
  }
}

class ScheduleTypeBuilder
    implements Builder<ScheduleType, ScheduleTypeBuilder> {
  _$ScheduleType? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _colorCode;
  String? get colorCode => _$this._colorCode;
  set colorCode(String? colorCode) => _$this._colorCode = colorCode;

  int? _defaultDurationMinutes;
  int? get defaultDurationMinutes => _$this._defaultDurationMinutes;
  set defaultDurationMinutes(int? defaultDurationMinutes) =>
      _$this._defaultDurationMinutes = defaultDurationMinutes;

  bool? _requiresTrainer;
  bool? get requiresTrainer => _$this._requiresTrainer;
  set requiresTrainer(bool? requiresTrainer) =>
      _$this._requiresTrainer = requiresTrainer;

  ScheduleTypeBuilder() {
    ScheduleType._defaults(this);
  }

  ScheduleTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _colorCode = $v.colorCode;
      _defaultDurationMinutes = $v.defaultDurationMinutes;
      _requiresTrainer = $v.requiresTrainer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleType other) {
    _$v = other as _$ScheduleType;
  }

  @override
  void update(void Function(ScheduleTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleType build() => _build();

  _$ScheduleType _build() {
    final _$result = _$v ??
        _$ScheduleType._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'ScheduleType', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ScheduleType', 'name'),
          colorCode: colorCode,
          defaultDurationMinutes: defaultDurationMinutes,
          requiresTrainer: requiresTrainer,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
