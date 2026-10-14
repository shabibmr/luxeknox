// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'go_live_checklist_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoLiveChecklistResponse extends GoLiveChecklistResponse {
  @override
  final Date goLiveDate;
  @override
  final bool postingEnabled;
  @override
  final bool canEnable;
  @override
  final BuiltList<String> failingReasons;
  @override
  final bool openingJournalFound;
  @override
  final bool openingJournalMatches;
  @override
  final GoLiveUnearnedMatch unearnedMembership;
  @override
  final GoLiveUnearnedMatch unearnedPt;
  @override
  final GoLiveTaxMatch taxMatch;
  @override
  final BuiltList<GoLivePaymentMethod> paymentMethods;

  factory _$GoLiveChecklistResponse(
          [void Function(GoLiveChecklistResponseBuilder)? updates]) =>
      (GoLiveChecklistResponseBuilder()..update(updates))._build();

  _$GoLiveChecklistResponse._(
      {required this.goLiveDate,
      required this.postingEnabled,
      required this.canEnable,
      required this.failingReasons,
      required this.openingJournalFound,
      required this.openingJournalMatches,
      required this.unearnedMembership,
      required this.unearnedPt,
      required this.taxMatch,
      required this.paymentMethods})
      : super._();
  @override
  GoLiveChecklistResponse rebuild(
          void Function(GoLiveChecklistResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoLiveChecklistResponseBuilder toBuilder() =>
      GoLiveChecklistResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoLiveChecklistResponse &&
        goLiveDate == other.goLiveDate &&
        postingEnabled == other.postingEnabled &&
        canEnable == other.canEnable &&
        failingReasons == other.failingReasons &&
        openingJournalFound == other.openingJournalFound &&
        openingJournalMatches == other.openingJournalMatches &&
        unearnedMembership == other.unearnedMembership &&
        unearnedPt == other.unearnedPt &&
        taxMatch == other.taxMatch &&
        paymentMethods == other.paymentMethods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, goLiveDate.hashCode);
    _$hash = $jc(_$hash, postingEnabled.hashCode);
    _$hash = $jc(_$hash, canEnable.hashCode);
    _$hash = $jc(_$hash, failingReasons.hashCode);
    _$hash = $jc(_$hash, openingJournalFound.hashCode);
    _$hash = $jc(_$hash, openingJournalMatches.hashCode);
    _$hash = $jc(_$hash, unearnedMembership.hashCode);
    _$hash = $jc(_$hash, unearnedPt.hashCode);
    _$hash = $jc(_$hash, taxMatch.hashCode);
    _$hash = $jc(_$hash, paymentMethods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoLiveChecklistResponse')
          ..add('goLiveDate', goLiveDate)
          ..add('postingEnabled', postingEnabled)
          ..add('canEnable', canEnable)
          ..add('failingReasons', failingReasons)
          ..add('openingJournalFound', openingJournalFound)
          ..add('openingJournalMatches', openingJournalMatches)
          ..add('unearnedMembership', unearnedMembership)
          ..add('unearnedPt', unearnedPt)
          ..add('taxMatch', taxMatch)
          ..add('paymentMethods', paymentMethods))
        .toString();
  }
}

class GoLiveChecklistResponseBuilder
    implements
        Builder<GoLiveChecklistResponse, GoLiveChecklistResponseBuilder> {
  _$GoLiveChecklistResponse? _$v;

  Date? _goLiveDate;
  Date? get goLiveDate => _$this._goLiveDate;
  set goLiveDate(Date? goLiveDate) => _$this._goLiveDate = goLiveDate;

  bool? _postingEnabled;
  bool? get postingEnabled => _$this._postingEnabled;
  set postingEnabled(bool? postingEnabled) =>
      _$this._postingEnabled = postingEnabled;

  bool? _canEnable;
  bool? get canEnable => _$this._canEnable;
  set canEnable(bool? canEnable) => _$this._canEnable = canEnable;

  ListBuilder<String>? _failingReasons;
  ListBuilder<String> get failingReasons =>
      _$this._failingReasons ??= ListBuilder<String>();
  set failingReasons(ListBuilder<String>? failingReasons) =>
      _$this._failingReasons = failingReasons;

  bool? _openingJournalFound;
  bool? get openingJournalFound => _$this._openingJournalFound;
  set openingJournalFound(bool? openingJournalFound) =>
      _$this._openingJournalFound = openingJournalFound;

  bool? _openingJournalMatches;
  bool? get openingJournalMatches => _$this._openingJournalMatches;
  set openingJournalMatches(bool? openingJournalMatches) =>
      _$this._openingJournalMatches = openingJournalMatches;

  GoLiveUnearnedMatchBuilder? _unearnedMembership;
  GoLiveUnearnedMatchBuilder get unearnedMembership =>
      _$this._unearnedMembership ??= GoLiveUnearnedMatchBuilder();
  set unearnedMembership(GoLiveUnearnedMatchBuilder? unearnedMembership) =>
      _$this._unearnedMembership = unearnedMembership;

  GoLiveUnearnedMatchBuilder? _unearnedPt;
  GoLiveUnearnedMatchBuilder get unearnedPt =>
      _$this._unearnedPt ??= GoLiveUnearnedMatchBuilder();
  set unearnedPt(GoLiveUnearnedMatchBuilder? unearnedPt) =>
      _$this._unearnedPt = unearnedPt;

  GoLiveTaxMatchBuilder? _taxMatch;
  GoLiveTaxMatchBuilder get taxMatch =>
      _$this._taxMatch ??= GoLiveTaxMatchBuilder();
  set taxMatch(GoLiveTaxMatchBuilder? taxMatch) => _$this._taxMatch = taxMatch;

  ListBuilder<GoLivePaymentMethod>? _paymentMethods;
  ListBuilder<GoLivePaymentMethod> get paymentMethods =>
      _$this._paymentMethods ??= ListBuilder<GoLivePaymentMethod>();
  set paymentMethods(ListBuilder<GoLivePaymentMethod>? paymentMethods) =>
      _$this._paymentMethods = paymentMethods;

  GoLiveChecklistResponseBuilder() {
    GoLiveChecklistResponse._defaults(this);
  }

  GoLiveChecklistResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _goLiveDate = $v.goLiveDate;
      _postingEnabled = $v.postingEnabled;
      _canEnable = $v.canEnable;
      _failingReasons = $v.failingReasons.toBuilder();
      _openingJournalFound = $v.openingJournalFound;
      _openingJournalMatches = $v.openingJournalMatches;
      _unearnedMembership = $v.unearnedMembership.toBuilder();
      _unearnedPt = $v.unearnedPt.toBuilder();
      _taxMatch = $v.taxMatch.toBuilder();
      _paymentMethods = $v.paymentMethods.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoLiveChecklistResponse other) {
    _$v = other as _$GoLiveChecklistResponse;
  }

  @override
  void update(void Function(GoLiveChecklistResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoLiveChecklistResponse build() => _build();

  _$GoLiveChecklistResponse _build() {
    _$GoLiveChecklistResponse _$result;
    try {
      _$result = _$v ??
          _$GoLiveChecklistResponse._(
            goLiveDate: BuiltValueNullFieldError.checkNotNull(
                goLiveDate, r'GoLiveChecklistResponse', 'goLiveDate'),
            postingEnabled: BuiltValueNullFieldError.checkNotNull(
                postingEnabled, r'GoLiveChecklistResponse', 'postingEnabled'),
            canEnable: BuiltValueNullFieldError.checkNotNull(
                canEnable, r'GoLiveChecklistResponse', 'canEnable'),
            failingReasons: failingReasons.build(),
            openingJournalFound: BuiltValueNullFieldError.checkNotNull(
                openingJournalFound,
                r'GoLiveChecklistResponse',
                'openingJournalFound'),
            openingJournalMatches: BuiltValueNullFieldError.checkNotNull(
                openingJournalMatches,
                r'GoLiveChecklistResponse',
                'openingJournalMatches'),
            unearnedMembership: unearnedMembership.build(),
            unearnedPt: unearnedPt.build(),
            taxMatch: taxMatch.build(),
            paymentMethods: paymentMethods.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'failingReasons';
        failingReasons.build();

        _$failedField = 'unearnedMembership';
        unearnedMembership.build();
        _$failedField = 'unearnedPt';
        unearnedPt.build();
        _$failedField = 'taxMatch';
        taxMatch.build();
        _$failedField = 'paymentMethods';
        paymentMethods.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GoLiveChecklistResponse', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
