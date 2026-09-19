// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MediaUpload extends MediaUpload {
  @override
  final String url;
  @override
  final String objectKey;
  @override
  final DateTime expiresAt;

  factory _$MediaUpload([void Function(MediaUploadBuilder)? updates]) =>
      (MediaUploadBuilder()..update(updates))._build();

  _$MediaUpload._(
      {required this.url, required this.objectKey, required this.expiresAt})
      : super._();
  @override
  MediaUpload rebuild(void Function(MediaUploadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaUploadBuilder toBuilder() => MediaUploadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaUpload &&
        url == other.url &&
        objectKey == other.objectKey &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, objectKey.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaUpload')
          ..add('url', url)
          ..add('objectKey', objectKey)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MediaUploadBuilder implements Builder<MediaUpload, MediaUploadBuilder> {
  _$MediaUpload? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _objectKey;
  String? get objectKey => _$this._objectKey;
  set objectKey(String? objectKey) => _$this._objectKey = objectKey;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MediaUploadBuilder() {
    MediaUpload._defaults(this);
  }

  MediaUploadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _objectKey = $v.objectKey;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaUpload other) {
    _$v = other as _$MediaUpload;
  }

  @override
  void update(void Function(MediaUploadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaUpload build() => _build();

  _$MediaUpload _build() {
    final _$result = _$v ??
        _$MediaUpload._(
          url:
              BuiltValueNullFieldError.checkNotNull(url, r'MediaUpload', 'url'),
          objectKey: BuiltValueNullFieldError.checkNotNull(
              objectKey, r'MediaUpload', 'objectKey'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'MediaUpload', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
