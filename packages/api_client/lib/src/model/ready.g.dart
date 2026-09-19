// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReadyStatusEnum _$readyStatusEnum_ok = const ReadyStatusEnum._('ok');
const ReadyStatusEnum _$readyStatusEnum_degraded =
    const ReadyStatusEnum._('degraded');

ReadyStatusEnum _$readyStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$readyStatusEnum_ok;
    case 'degraded':
      return _$readyStatusEnum_degraded;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReadyStatusEnum> _$readyStatusEnumValues =
    BuiltSet<ReadyStatusEnum>(const <ReadyStatusEnum>[
  _$readyStatusEnum_ok,
  _$readyStatusEnum_degraded,
]);

const ReadyDatabaseEnum _$readyDatabaseEnum_up =
    const ReadyDatabaseEnum._('up');
const ReadyDatabaseEnum _$readyDatabaseEnum_down =
    const ReadyDatabaseEnum._('down');

ReadyDatabaseEnum _$readyDatabaseEnumValueOf(String name) {
  switch (name) {
    case 'up':
      return _$readyDatabaseEnum_up;
    case 'down':
      return _$readyDatabaseEnum_down;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReadyDatabaseEnum> _$readyDatabaseEnumValues =
    BuiltSet<ReadyDatabaseEnum>(const <ReadyDatabaseEnum>[
  _$readyDatabaseEnum_up,
  _$readyDatabaseEnum_down,
]);

Serializer<ReadyStatusEnum> _$readyStatusEnumSerializer =
    _$ReadyStatusEnumSerializer();
Serializer<ReadyDatabaseEnum> _$readyDatabaseEnumSerializer =
    _$ReadyDatabaseEnumSerializer();

class _$ReadyStatusEnumSerializer
    implements PrimitiveSerializer<ReadyStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
    'degraded': 'degraded',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
    'degraded': 'degraded',
  };

  @override
  final Iterable<Type> types = const <Type>[ReadyStatusEnum];
  @override
  final String wireName = 'ReadyStatusEnum';

  @override
  Object serialize(Serializers serializers, ReadyStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadyStatusEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadyStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$ReadyDatabaseEnumSerializer
    implements PrimitiveSerializer<ReadyDatabaseEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'up': 'up',
    'down': 'down',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'up': 'up',
    'down': 'down',
  };

  @override
  final Iterable<Type> types = const <Type>[ReadyDatabaseEnum];
  @override
  final String wireName = 'ReadyDatabaseEnum';

  @override
  Object serialize(Serializers serializers, ReadyDatabaseEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  ReadyDatabaseEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ReadyDatabaseEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$Ready extends Ready {
  @override
  final ReadyStatusEnum status;
  @override
  final ReadyDatabaseEnum database;

  factory _$Ready([void Function(ReadyBuilder)? updates]) =>
      (ReadyBuilder()..update(updates))._build();

  _$Ready._({required this.status, required this.database}) : super._();
  @override
  Ready rebuild(void Function(ReadyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReadyBuilder toBuilder() => ReadyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Ready &&
        status == other.status &&
        database == other.database;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, database.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Ready')
          ..add('status', status)
          ..add('database', database))
        .toString();
  }
}

class ReadyBuilder implements Builder<Ready, ReadyBuilder> {
  _$Ready? _$v;

  ReadyStatusEnum? _status;
  ReadyStatusEnum? get status => _$this._status;
  set status(ReadyStatusEnum? status) => _$this._status = status;

  ReadyDatabaseEnum? _database;
  ReadyDatabaseEnum? get database => _$this._database;
  set database(ReadyDatabaseEnum? database) => _$this._database = database;

  ReadyBuilder() {
    Ready._defaults(this);
  }

  ReadyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _database = $v.database;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Ready other) {
    _$v = other as _$Ready;
  }

  @override
  void update(void Function(ReadyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Ready build() => _build();

  _$Ready _build() {
    final _$result = _$v ??
        _$Ready._(
          status:
              BuiltValueNullFieldError.checkNotNull(status, r'Ready', 'status'),
          database: BuiltValueNullFieldError.checkNotNull(
              database, r'Ready', 'database'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
