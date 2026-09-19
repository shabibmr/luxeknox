// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_download.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MediaDownload extends MediaDownload {
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$MediaDownload([void Function(MediaDownloadBuilder)? updates]) =>
      (MediaDownloadBuilder()..update(updates))._build();

  _$MediaDownload._({required this.url, required this.expiresAt}) : super._();
  @override
  MediaDownload rebuild(void Function(MediaDownloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MediaDownloadBuilder toBuilder() => MediaDownloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MediaDownload &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MediaDownload')
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MediaDownloadBuilder
    implements Builder<MediaDownload, MediaDownloadBuilder> {
  _$MediaDownload? _$v;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MediaDownloadBuilder() {
    MediaDownload._defaults(this);
  }

  MediaDownloadBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MediaDownload other) {
    _$v = other as _$MediaDownload;
  }

  @override
  void update(void Function(MediaDownloadBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MediaDownload build() => _build();

  _$MediaDownload _build() {
    final _$result = _$v ??
        _$MediaDownload._(
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'MediaDownload', 'url'),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt, r'MediaDownload', 'expiresAt'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
