// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_bill_update.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PurchaseBillUpdate extends PurchaseBillUpdate {
  @override
  final int? vendorId;
  @override
  final Date? billDate;
  @override
  final Date? dueDate;
  @override
  final BuiltList<PurchaseBillLineWrite>? lines;

  factory _$PurchaseBillUpdate(
          [void Function(PurchaseBillUpdateBuilder)? updates]) =>
      (PurchaseBillUpdateBuilder()..update(updates))._build();

  _$PurchaseBillUpdate._(
      {this.vendorId, this.billDate, this.dueDate, this.lines})
      : super._();
  @override
  PurchaseBillUpdate rebuild(
          void Function(PurchaseBillUpdateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PurchaseBillUpdateBuilder toBuilder() =>
      PurchaseBillUpdateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PurchaseBillUpdate &&
        vendorId == other.vendorId &&
        billDate == other.billDate &&
        dueDate == other.dueDate &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, billDate.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PurchaseBillUpdate')
          ..add('vendorId', vendorId)
          ..add('billDate', billDate)
          ..add('dueDate', dueDate)
          ..add('lines', lines))
        .toString();
  }
}

class PurchaseBillUpdateBuilder
    implements Builder<PurchaseBillUpdate, PurchaseBillUpdateBuilder> {
  _$PurchaseBillUpdate? _$v;

  int? _vendorId;
  int? get vendorId => _$this._vendorId;
  set vendorId(int? vendorId) => _$this._vendorId = vendorId;

  Date? _billDate;
  Date? get billDate => _$this._billDate;
  set billDate(Date? billDate) => _$this._billDate = billDate;

  Date? _dueDate;
  Date? get dueDate => _$this._dueDate;
  set dueDate(Date? dueDate) => _$this._dueDate = dueDate;

  ListBuilder<PurchaseBillLineWrite>? _lines;
  ListBuilder<PurchaseBillLineWrite> get lines =>
      _$this._lines ??= ListBuilder<PurchaseBillLineWrite>();
  set lines(ListBuilder<PurchaseBillLineWrite>? lines) => _$this._lines = lines;

  PurchaseBillUpdateBuilder() {
    PurchaseBillUpdate._defaults(this);
  }

  PurchaseBillUpdateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _vendorId = $v.vendorId;
      _billDate = $v.billDate;
      _dueDate = $v.dueDate;
      _lines = $v.lines?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PurchaseBillUpdate other) {
    _$v = other as _$PurchaseBillUpdate;
  }

  @override
  void update(void Function(PurchaseBillUpdateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PurchaseBillUpdate build() => _build();

  _$PurchaseBillUpdate _build() {
    _$PurchaseBillUpdate _$result;
    try {
      _$result = _$v ??
          _$PurchaseBillUpdate._(
            vendorId: vendorId,
            billDate: billDate,
            dueDate: dueDate,
            lines: _lines?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        _lines?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PurchaseBillUpdate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
