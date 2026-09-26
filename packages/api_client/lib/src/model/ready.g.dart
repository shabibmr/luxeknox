// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ready.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const ReadyStatusEnum _$readyStatusEnum_ok = const ReadyStatusEnum._('ok');
const ReadyStatusEnum _$readyStatusEnum_error =
    const ReadyStatusEnum._('error');

ReadyStatusEnum _$readyStatusEnumValueOf(String name) {
  switch (name) {
    case 'ok':
      return _$readyStatusEnum_ok;
    case 'error':
      return _$readyStatusEnum_error;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReadyStatusEnum> _$readyStatusEnumValues =
    BuiltSet<ReadyStatusEnum>(const <ReadyStatusEnum>[
  _$readyStatusEnum_ok,
  _$readyStatusEnum_error,
]);

const ReadyDatabaseEnum _$readyDatabaseEnum_connected =
    const ReadyDatabaseEnum._('connected');
const ReadyDatabaseEnum _$readyDatabaseEnum_disconnected =
    const ReadyDatabaseEnum._('disconnected');

ReadyDatabaseEnum _$readyDatabaseEnumValueOf(String name) {
  switch (name) {
    case 'connected':
      return _$readyDatabaseEnum_connected;
    case 'disconnected':
      return _$readyDatabaseEnum_disconnected;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ReadyDatabaseEnum> _$readyDatabaseEnumValues =
    BuiltSet<ReadyDatabaseEnum>(const <ReadyDatabaseEnum>[
  _$readyDatabaseEnum_connected,
  _$readyDatabaseEnum_disconnected,
]);

Serializer<ReadyStatusEnum> _$readyStatusEnumSerializer =
    _$ReadyStatusEnumSerializer();
Serializer<ReadyDatabaseEnum> _$readyDatabaseEnumSerializer =
    _$ReadyDatabaseEnumSerializer();

class _$ReadyStatusEnumSerializer
    implements PrimitiveSerializer<ReadyStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
    'error': 'error',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
    'error': 'error',
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
    'connected': 'connected',
    'disconnected': 'disconnected',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'connected': 'connected',
    'disconnected': 'disconnected',
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
  @override
  final DateTime timestamp;
  @override
  final ReadyJobs? jobs;

  factory _$Ready([void Function(ReadyBuilder)? updates]) =>
      (ReadyBuilder()..update(updates))._build();

  _$Ready._(
      {required this.status,
      required this.database,
      required this.timestamp,
      this.jobs})
      : super._();
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
        database == other.database &&
        timestamp == other.timestamp &&
        jobs == other.jobs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, database.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jc(_$hash, jobs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Ready')
          ..add('status', status)
          ..add('database', database)
          ..add('timestamp', timestamp)
          ..add('jobs', jobs))
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

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  ReadyJobsBuilder? _jobs;
  ReadyJobsBuilder get jobs => _$this._jobs ??= ReadyJobsBuilder();
  set jobs(ReadyJobsBuilder? jobs) => _$this._jobs = jobs;

  ReadyBuilder() {
    Ready._defaults(this);
  }

  ReadyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _database = $v.database;
      _timestamp = $v.timestamp;
      _jobs = $v.jobs?.toBuilder();
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
    _$Ready _$result;
    try {
      _$result = _$v ??
          _$Ready._(
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'Ready', 'status'),
            database: BuiltValueNullFieldError.checkNotNull(
                database, r'Ready', 'database'),
            timestamp: BuiltValueNullFieldError.checkNotNull(
                timestamp, r'Ready', 'timestamp'),
            jobs: _jobs?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'jobs';
        _jobs?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Ready', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
