// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_enable_posting_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLiveEnablePostingResponse extends GoLiveEnablePostingResponse {
  @override
  final bool success;
  @override
  final bool postingEnabled;

  factory _$GoLiveEnablePostingResponse(
          [void Function(GoLiveEnablePostingResponseBuilder)? updates]) =>
      (GoLiveEnablePostingResponseBuilder()..update(updates))._build();

  _$GoLiveEnablePostingResponse._(
      {required this.success, required this.postingEnabled})
      : super._();
  @override
  GoLiveEnablePostingResponse rebuild(
          void Function(GoLiveEnablePostingResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLiveEnablePostingResponseBuilder toBuilder() =>
      GoLiveEnablePostingResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLiveEnablePostingResponse &&
        success == other.success &&
        postingEnabled == other.postingEnabled;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, success.hashCode);
    _$hash = $jc(_$hash, postingEnabled.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoLiveEnablePostingResponse')
          ..add('success', success)
          ..add('postingEnabled', postingEnabled))
        .toString();
  }
}

class GoLiveEnablePostingResponseBuilder
    implements
        Builder<GoLiveEnablePostingResponse,
            GoLiveEnablePostingResponseBuilder> {
  _$GoLiveEnablePostingResponse? _$v;

  bool? _success;
  bool? get success => _$this._success;
  set success(bool? success) => _$this._success = success;

  bool? _postingEnabled;
  bool? get postingEnabled => _$this._postingEnabled;
  set postingEnabled(bool? postingEnabled) =>
      _$this._postingEnabled = postingEnabled;

  GoLiveEnablePostingResponseBuilder() {
    GoLiveEnablePostingResponse._defaults(this);
  }

  GoLiveEnablePostingResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _success = $v.success;
      _postingEnabled = $v.postingEnabled;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLiveEnablePostingResponse other) {
    _$v = other as _$GoLiveEnablePostingResponse;
  }

  @override
  void update(void Function(GoLiveEnablePostingResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLiveEnablePostingResponse build() => _build();

  _$GoLiveEnablePostingResponse _build() {
    final _$result = _$v ??
        _$GoLiveEnablePostingResponse._(
          success: BuiltValueNullFieldError.checkNotNull(
              success, r'GoLiveEnablePostingResponse', 'success'),
          postingEnabled: BuiltValueNullFieldError.checkNotNull(
              postingEnabled, r'GoLiveEnablePostingResponse', 'postingEnabled'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
