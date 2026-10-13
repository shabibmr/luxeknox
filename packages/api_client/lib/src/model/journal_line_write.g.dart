// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_line_write.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$JournalLineWrite extends JournalLineWrite {
  @override
  final int accountId;
  @override
  final String? debit;
  @override
  final String? credit;
  @override
  final String? memo;
  @override
  final int? memberId;
  @override
  final int? vendorId;

  factory _$JournalLineWrite(
          [void Function(JournalLineWriteBuilder)? updates]) =>
      (JournalLineWriteBuilder()..update(updates))._build();

  _$JournalLineWrite._(
      {required this.accountId,
      this.debit,
      this.credit,
      this.memo,
      this.memberId,
      this.vendorId})
      : super._();
  @override
  JournalLineWrite rebuild(void Function(JournalLineWriteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  JournalLineWriteBuilder toBuilder() =>
      JournalLineWriteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is JournalLineWrite &&
        accountId == other.accountId &&
        debit == other.debit &&
        credit == other.credit &&
        memo == other.memo &&
        memberId == other.memberId &&
        vendorId == other.vendorId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accountId.hashCode);
    _$hash = $jc(_$hash, debit.hashCode);
    _$hash = $jc(_$hash, credit.hashCode);
    _$hash = $jc(_$hash, memo.hashCode);
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'JournalLineWrite')
          ..add('accountId', accountId)
          ..add('debit', debit)
          ..add('credit', credit)
          ..add('memo', memo)
          ..add('memberId', memberId)
          ..add('vendorId', vendorId))
        .toString();
  }
}

class JournalLineWriteBuilder
    implements Builder<JournalLineWrite, JournalLineWriteBuilder> {
  _$JournalLineWrite? _$v;

  int? _accountId;
  int? get accountId => _$this._accountId;
  set accountId(int? accountId) => _$this._accountId = accountId;

  String? _debit;
  String? get debit => _$this._debit;
  set debit(String? debit) => _$this._debit = debit;

  String? _credit;
  String? get credit => _$this._credit;
  set credit(String? credit) => _$this._credit = credit;

  String? _memo;
  String? get memo => _$this._memo;
  set memo(String? memo) => _$this._memo = memo;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  int? _vendorId;
  int? get vendorId => _$this._vendorId;
  set vendorId(int? vendorId) => _$this._vendorId = vendorId;

  JournalLineWriteBuilder() {
    JournalLineWrite._defaults(this);
  }

  JournalLineWriteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accountId = $v.accountId;
      _debit = $v.debit;
      _credit = $v.credit;
      _memo = $v.memo;
      _memberId = $v.memberId;
      _vendorId = $v.vendorId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(JournalLineWrite other) {
    _$v = other as _$JournalLineWrite;
  }

  @override
  void update(void Function(JournalLineWriteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  JournalLineWrite build() => _build();

  _$JournalLineWrite _build() {
    final _$result = _$v ??
        _$JournalLineWrite._(
          accountId: BuiltValueNullFieldError.checkNotNull(
              accountId, r'JournalLineWrite', 'accountId'),
          debit: debit,
          credit: credit,
          memo: memo,
          memberId: memberId,
          vendorId: vendorId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
