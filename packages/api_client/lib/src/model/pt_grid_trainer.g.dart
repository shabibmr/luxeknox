// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_grid_trainer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PtGridTrainer extends PtGridTrainer {
  @override
  final int id;
  @override
  final String name;

  factory _$PtGridTrainer([void Function(PtGridTrainerBuilder)? updates]) =>
      (PtGridTrainerBuilder()..update(updates))._build();

  _$PtGridTrainer._({required this.id, required this.name}) : super._();
  @override
  PtGridTrainer rebuild(void Function(PtGridTrainerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PtGridTrainerBuilder toBuilder() => PtGridTrainerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PtGridTrainer && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PtGridTrainer')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class PtGridTrainerBuilder
    implements Builder<PtGridTrainer, PtGridTrainerBuilder> {
  _$PtGridTrainer? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  PtGridTrainerBuilder() {
    PtGridTrainer._defaults(this);
  }

  PtGridTrainerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PtGridTrainer other) {
    _$v = other as _$PtGridTrainer;
  }

  @override
  void update(void Function(PtGridTrainerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PtGridTrainer build() => _build();

  _$PtGridTrainer _build() {
    final _$result = _$v ??
        _$PtGridTrainer._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'PtGridTrainer', 'id'),
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'PtGridTrainer', 'name'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
