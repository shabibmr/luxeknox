// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_settings.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PublicSettings extends PublicSettings {
  @override
  final String timezone;
  @override
  final String currency;
  @override
  final String? dateFormat;
  @override
  final int? defaultPageSize;
  @override
  final String? operatingHours;
  @override
  final int? cancellationCutoffMinutes;

  factory _$PublicSettings([void Function(PublicSettingsBuilder)? updates]) =>
      (PublicSettingsBuilder()..update(updates))._build();

  _$PublicSettings._(
      {required this.timezone,
      required this.currency,
      this.dateFormat,
      this.defaultPageSize,
      this.operatingHours,
      this.cancellationCutoffMinutes})
      : super._();
  @override
  PublicSettings rebuild(void Function(PublicSettingsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PublicSettingsBuilder toBuilder() => PublicSettingsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PublicSettings &&
        timezone == other.timezone &&
        currency == other.currency &&
        dateFormat == other.dateFormat &&
        defaultPageSize == other.defaultPageSize &&
        operatingHours == other.operatingHours &&
        cancellationCutoffMinutes == other.cancellationCutoffMinutes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, timezone.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, dateFormat.hashCode);
    _$hash = $jc(_$hash, defaultPageSize.hashCode);
    _$hash = $jc(_$hash, operatingHours.hashCode);
    _$hash = $jc(_$hash, cancellationCutoffMinutes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PublicSettings')
          ..add('timezone', timezone)
          ..add('currency', currency)
          ..add('dateFormat', dateFormat)
          ..add('defaultPageSize', defaultPageSize)
          ..add('operatingHours', operatingHours)
          ..add('cancellationCutoffMinutes', cancellationCutoffMinutes))
        .toString();
  }
}

class PublicSettingsBuilder
    implements Builder<PublicSettings, PublicSettingsBuilder> {
  _$PublicSettings? _$v;

  String? _timezone;
  String? get timezone => _$this._timezone;
  set timezone(String? timezone) => _$this._timezone = timezone;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _dateFormat;
  String? get dateFormat => _$this._dateFormat;
  set dateFormat(String? dateFormat) => _$this._dateFormat = dateFormat;

  int? _defaultPageSize;
  int? get defaultPageSize => _$this._defaultPageSize;
  set defaultPageSize(int? defaultPageSize) =>
      _$this._defaultPageSize = defaultPageSize;

  String? _operatingHours;
  String? get operatingHours => _$this._operatingHours;
  set operatingHours(String? operatingHours) =>
      _$this._operatingHours = operatingHours;

  int? _cancellationCutoffMinutes;
  int? get cancellationCutoffMinutes => _$this._cancellationCutoffMinutes;
  set cancellationCutoffMinutes(int? cancellationCutoffMinutes) =>
      _$this._cancellationCutoffMinutes = cancellationCutoffMinutes;

  PublicSettingsBuilder() {
    PublicSettings._defaults(this);
  }

  PublicSettingsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _timezone = $v.timezone;
      _currency = $v.currency;
      _dateFormat = $v.dateFormat;
      _defaultPageSize = $v.defaultPageSize;
      _operatingHours = $v.operatingHours;
      _cancellationCutoffMinutes = $v.cancellationCutoffMinutes;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PublicSettings other) {
    _$v = other as _$PublicSettings;
  }

  @override
  void update(void Function(PublicSettingsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PublicSettings build() => _build();

  _$PublicSettings _build() {
    final _$result = _$v ??
        _$PublicSettings._(
          timezone: BuiltValueNullFieldError.checkNotNull(
              timezone, r'PublicSettings', 'timezone'),
          currency: BuiltValueNullFieldError.checkNotNull(
              currency, r'PublicSettings', 'currency'),
          dateFormat: dateFormat,
          defaultPageSize: defaultPageSize,
          operatingHours: operatingHours,
          cancellationCutoffMinutes: cancellationCutoffMinutes,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
