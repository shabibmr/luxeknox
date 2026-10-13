// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_reverse.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JournalReverse extends JournalReverse {
  @override
  final Date? entryDate;
  @override
  final String? memo;

  factory _$JournalReverse([void Function(JournalReverseBuilder)? updates]) =>
      (JournalReverseBuilder()..update(updates))._build();

  _$JournalReverse._({this.entryDate, this.memo}) : super._();
  @override
  JournalReverse rebuild(void Function(JournalReverseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JournalReverseBuilder toBuilder() => JournalReverseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JournalReverse &&
        entryDate == other.entryDate &&
        memo == other.memo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entryDate.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JournalReverse')
          ..add('entryDate', entryDate)
          ..add('memo', memo))
        .toString();
  }
}

class JournalReverseBuilder
    implements Builder<JournalReverse, JournalReverseBuilder> {
  _$JournalReverse? _$v;

  Date? _entryDate;
  Date? get entryDate => _$this._entryDate;
  set entryDate(Date? entryDate) => _$this._entryDate = entryDate;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  JournalReverseBuilder() {
    JournalReverse._defaults(this);
  }

  JournalReverseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entryDate = $v.entryDate;
      _memo = $v.memo;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JournalReverse other) {
    _$v = other as _$JournalReverse;
  }

  @override
  void update(void Function(JournalReverseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JournalReverse build() => _build();

  _$JournalReverse _build() {
    final _$result = _$v ??
        _$JournalReverse._(
          entryDate: entryDate,
          memo: memo,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
