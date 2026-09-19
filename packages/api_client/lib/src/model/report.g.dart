// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Report extends Report {
  @override
  final ReportType type;
  @override
  final Date from;
  @override
  final Date to;
  @override
  final BuiltList<BuiltMap<String, JsonObject?>> rows;

  factory _$Report([void Function(ReportBuilder)? updates]) =>
      (ReportBuilder()..update(updates))._build();

  _$Report._(
      {required this.type,
      required this.from,
      required this.to,
      required this.rows})
      : super._();
  @override
  Report rebuild(void Function(ReportBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReportBuilder toBuilder() => ReportBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Report &&
        type == other.type &&
        from == other.from &&
        to == other.to &&
        rows == other.rows;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, rows.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Report')
          ..add('type', type)
          ..add('from', from)
          ..add('to', to)
          ..add('rows', rows))
        .toString();
  }
}

class ReportBuilder implements Builder<Report, ReportBuilder> {
  _$Report? _$v;

  ReportType? _type;
  ReportType? get type => _$this._type;
  set type(ReportType? type) => _$this._type = type;

  Date? _from;
  Date? get from => _$this._from;
  set from(Date? from) => _$this._from = from;

  Date? _to;
  Date? get to => _$this._to;
  set to(Date? to) => _$this._to = to;

  ListBuilder<BuiltMap<String, JsonObject?>>? _rows;
  ListBuilder<BuiltMap<String, JsonObject?>> get rows =>
      _$this._rows ??= ListBuilder<BuiltMap<String, JsonObject?>>();
  set rows(ListBuilder<BuiltMap<String, JsonObject?>>? rows) =>
      _$this._rows = rows;

  ReportBuilder() {
    Report._defaults(this);
  }

  ReportBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _from = $v.from;
      _to = $v.to;
      _rows = $v.rows.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Report other) {
    _$v = other as _$Report;
  }

  @override
  void update(void Function(ReportBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Report build() => _build();

  _$Report _build() {
    _$Report _$result;
    try {
      _$result = _$v ??
          _$Report._(
            type:
                BuiltValueNullFieldError.checkNotNull(type, r'Report', 'type'),
            from:
                BuiltValueNullFieldError.checkNotNull(from, r'Report', 'from'),
            to: BuiltValueNullFieldError.checkNotNull(to, r'Report', 'to'),
            rows: rows.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rows';
        rows.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Report', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
