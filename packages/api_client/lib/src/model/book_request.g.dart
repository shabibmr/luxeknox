// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BookRequest extends BookRequest {
  @override
  final int? memberId;

  factory _$BookRequest([void Function(BookRequestBuilder)? updates]) =>
      (BookRequestBuilder()..update(updates))._build();

  _$BookRequest._({this.memberId}) : super._();
  @override
  BookRequest rebuild(void Function(BookRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BookRequestBuilder toBuilder() => BookRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BookRequest && memberId == other.memberId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, memberId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BookRequest')
          ..add('memberId', memberId))
        .toString();
  }
}

class BookRequestBuilder implements Builder<BookRequest, BookRequestBuilder> {
  _$BookRequest? _$v;

  int? _memberId;
  int? get memberId => _$this._memberId;
  set memberId(int? memberId) => _$this._memberId = memberId;

  BookRequestBuilder() {
    BookRequest._defaults(this);
  }

  BookRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _memberId = $v.memberId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BookRequest other) {
    _$v = other as _$BookRequest;
  }

  @override
  void update(void Function(BookRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BookRequest build() => _build();

  _$BookRequest _build() {
    final _$result = _$v ??
        _$BookRequest._(
          memberId: memberId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
