// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_type_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ScheduleTypeWrite extends ScheduleTypeWrite {
  @override
  final String name;
  @override
  final String? colorCode;
  @override
  final int? defaultDurationMinutes;
  @override
  final bool? requiresTrainer;

  factory _$ScheduleTypeWrite(
          [void Function(ScheduleTypeWriteBuilder)? updates]) =>
      (ScheduleTypeWriteBuilder()..update(updates))._build();

  _$ScheduleTypeWrite._(
      {required this.name,
      this.colorCode,
      this.defaultDurationMinutes,
      this.requiresTrainer})
      : super._();
  @override
  ScheduleTypeWrite rebuild(void Function(ScheduleTypeWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ScheduleTypeWriteBuilder toBuilder() =>
      ScheduleTypeWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ScheduleTypeWrite &&
        name == other.name &&
        colorCode == other.colorCode &&
        defaultDurationMinutes == other.defaultDurationMinutes &&
        requiresTrainer == other.requiresTrainer;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, colorCode.hashCode);
    _$hash = $jc(_$hash, defaultDurationMinutes.hashCode);
    _$hash = $jc(_$hash, requiresTrainer.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ScheduleTypeWrite')
          ..add('name', name)
          ..add('colorCode', colorCode)
          ..add('defaultDurationMinutes', defaultDurationMinutes)
          ..add('requiresTrainer', requiresTrainer))
        .toString();
  }
}

class ScheduleTypeWriteBuilder
    implements Builder<ScheduleTypeWrite, ScheduleTypeWriteBuilder> {
  _$ScheduleTypeWrite? _$v;

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

  ScheduleTypeWriteBuilder() {
    ScheduleTypeWrite._defaults(this);
  }

  ScheduleTypeWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _colorCode = $v.colorCode;
      _defaultDurationMinutes = $v.defaultDurationMinutes;
      _requiresTrainer = $v.requiresTrainer;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ScheduleTypeWrite other) {
    _$v = other as _$ScheduleTypeWrite;
  }

  @override
  void update(void Function(ScheduleTypeWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ScheduleTypeWrite build() => _build();

  _$ScheduleTypeWrite _build() {
    final _$result = _$v ??
        _$ScheduleTypeWrite._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'ScheduleTypeWrite', 'name'),
          colorCode: colorCode,
          defaultDurationMinutes: defaultDurationMinutes,
          requiresTrainer: requiresTrainer,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
