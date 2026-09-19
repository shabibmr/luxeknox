// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Exercise extends Exercise {
  @override
  final int id;
  @override
  final String name;
  @override
  final String? primaryMuscleGroup;
  @override
  final BuiltList<String>? secondaryMuscles;
  @override
  final String? equipmentNeeded;
  @override
  final String? instructions;
  @override
  final String? videoUrl;
  @override
  final String? gifUrl;
  @override
  final String? difficultyLevel;
  @override
  final bool isActive;

  factory _$Exercise([void Function(ExerciseBuilder)? updates]) =>
      (ExerciseBuilder()..update(updates))._build();

  _$Exercise._(
      {required this.id,
      required this.name,
      this.primaryMuscleGroup,
      this.secondaryMuscles,
      this.equipmentNeeded,
      this.instructions,
      this.videoUrl,
      this.gifUrl,
      this.difficultyLevel,
      required this.isActive})
      : super._();
  @override
  Exercise rebuild(void Function(ExerciseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExerciseBuilder toBuilder() => ExerciseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Exercise &&
        id == other.id &&
        name == other.name &&
        primaryMuscleGroup == other.primaryMuscleGroup &&
        secondaryMuscles == other.secondaryMuscles &&
        equipmentNeeded == other.equipmentNeeded &&
        instructions == other.instructions &&
        videoUrl == other.videoUrl &&
        gifUrl == other.gifUrl &&
        difficultyLevel == other.difficultyLevel &&
        isActive == other.isActive;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, primaryMuscleGroup.hashCode);
    _$hash = $jc(_$hash, secondaryMuscles.hashCode);
    _$hash = $jc(_$hash, equipmentNeeded.hashCode);
    _$hash = $jc(_$hash, instructions.hashCode);
    _$hash = $jc(_$hash, videoUrl.hashCode);
    _$hash = $jc(_$hash, gifUrl.hashCode);
    _$hash = $jc(_$hash, difficultyLevel.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Exercise')
          ..add('id', id)
          ..add('name', name)
          ..add('primaryMuscleGroup', primaryMuscleGroup)
          ..add('secondaryMuscles', secondaryMuscles)
          ..add('equipmentNeeded', equipmentNeeded)
          ..add('instructions', instructions)
          ..add('videoUrl', videoUrl)
          ..add('gifUrl', gifUrl)
          ..add('difficultyLevel', difficultyLevel)
          ..add('isActive', isActive))
        .toString();
  }
}

class ExerciseBuilder implements Builder<Exercise, ExerciseBuilder> {
  _$Exercise? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _primaryMuscleGroup;
  String? get primaryMuscleGroup => _$this._primaryMuscleGroup;
  set primaryMuscleGroup(String? primaryMuscleGroup) =>
      _$this._primaryMuscleGroup = primaryMuscleGroup;

  ListBuilder<String>? _secondaryMuscles;
  ListBuilder<String> get secondaryMuscles =>
      _$this._secondaryMuscles ??= ListBuilder<String>();
  set secondaryMuscles(ListBuilder<String>? secondaryMuscles) =>
      _$this._secondaryMuscles = secondaryMuscles;

  String? _equipmentNeeded;
  String? get equipmentNeeded => _$this._equipmentNeeded;
  set equipmentNeeded(String? equipmentNeeded) =>
      _$this._equipmentNeeded = equipmentNeeded;

  String? _instructions;
  String? get instructions => _$this._instructions;
  set instructions(String? instructions) => _$this._instructions = instructions;

  String? _videoUrl;
  String? get videoUrl => _$this._videoUrl;
  set videoUrl(String? videoUrl) => _$this._videoUrl = videoUrl;

  String? _gifUrl;
  String? get gifUrl => _$this._gifUrl;
  set gifUrl(String? gifUrl) => _$this._gifUrl = gifUrl;

  String? _difficultyLevel;
  String? get difficultyLevel => _$this._difficultyLevel;
  set difficultyLevel(String? difficultyLevel) =>
      _$this._difficultyLevel = difficultyLevel;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  ExerciseBuilder() {
    Exercise._defaults(this);
  }

  ExerciseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _primaryMuscleGroup = $v.primaryMuscleGroup;
      _secondaryMuscles = $v.secondaryMuscles?.toBuilder();
      _equipmentNeeded = $v.equipmentNeeded;
      _instructions = $v.instructions;
      _videoUrl = $v.videoUrl;
      _gifUrl = $v.gifUrl;
      _difficultyLevel = $v.difficultyLevel;
      _isActive = $v.isActive;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Exercise other) {
    _$v = other as _$Exercise;
  }

  @override
  void update(void Function(ExerciseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Exercise build() => _build();

  _$Exercise _build() {
    _$Exercise _$result;
    try {
      _$result = _$v ??
          _$Exercise._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'Exercise', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'Exercise', 'name'),
            primaryMuscleGroup: primaryMuscleGroup,
            secondaryMuscles: _secondaryMuscles?.build(),
            equipmentNeeded: equipmentNeeded,
            instructions: instructions,
            videoUrl: videoUrl,
            gifUrl: gifUrl,
            difficultyLevel: difficultyLevel,
            isActive: BuiltValueNullFieldError.checkNotNull(
                isActive, r'Exercise', 'isActive'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'secondaryMuscles';
        _secondaryMuscles?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Exercise', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
