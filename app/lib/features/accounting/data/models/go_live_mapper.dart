import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/go_live.dart';

GoLiveUnearnedComparison goLiveUnearnedComparisonFromJson(
  Map<String, dynamic> json,
) {
  return GoLiveUnearnedComparison(
    preview: (json['preview'] ?? '0.00').toString(),
    actual: (json['actual'] ?? '0.00').toString(),
    isMatched:
        (json['matched'] ?? json['is_matched'] ?? json['isMatched'] ?? false)
            as bool,
  );
}

GoLiveTaxComparison goLiveTaxComparisonFromJson(
  Map<String, dynamic> json,
) {
  return GoLiveTaxComparison(
    gymRate: (json['gym_tax_rate'] ??
            json['gymTaxRate'] ??
            json['gym_rate'] ??
            json['gymRate'] ??
            '0.00')
        .toString(),
    defaultCode: (json['default_tax_code'] ??
            json['defaultTaxCode'] ??
            json['default_code'] ??
            json['defaultCode'] ??
            '')
        .toString(),
    defaultRate: (json['default_tax_rate'] ??
            json['defaultTaxRate'] ??
            json['default_rate'] ??
            json['defaultRate'] ??
            '0.00')
        .toString(),
    isMatched:
        (json['matched'] ?? json['is_matched'] ?? json['isMatched'] ?? false)
            as bool,
  );
}

GoLivePaymentMethodMapping goLivePaymentMethodMappingFromJson(
  Map<String, dynamic> json,
) {
  final rawAccountId = json['account_id'] ?? json['accountId'];
  return GoLivePaymentMethodMapping(
    id: (json['id'] as num).toInt(),
    methodName: (json['method_name'] ?? json['methodName'] ?? '').toString(),
    isActive: (json['is_active'] ?? json['isActive'] ?? true) as bool,
    isDigital: (json['is_digital'] ?? json['isDigital'] ?? false) as bool,
    accountId: rawAccountId != null ? (rawAccountId as num).toInt() : null,
    accountName: (json['account_name'] ?? json['accountName'])?.toString(),
  );
}

GoLiveChecklist goLiveChecklistFromJson(
  Map<String, dynamic> json,
) {
  final dateStr = json['go_live_date'] ?? json['goLiveDate'];
  final goLiveDate = dateStr != null
      ? DateTime.tryParse(dateStr.toString()) ?? DateTime.now()
      : DateTime.now();

  final isPostingEnabled = (json['is_posting_enabled'] ??
      json['isPostingEnabled'] ??
      json['posting_enabled'] ??
      json['postingEnabled'] ??
      false) as bool;

  final canEnable = (json['can_enable'] ?? json['canEnable'] ?? false) as bool;

  final rawFailingReasons = json['failing_reasons'] ??
      json['failingReasons'] ??
      json['failing_checks'] ??
      <dynamic>[];
  final failingReasons =
      (rawFailingReasons as List).map((e) => e.toString()).toList();

  final openingJournalFound = (json['opening_journal_found'] ??
      json['openingJournalFound'] ??
      false) as bool;

  final openingJournalMatches = (json['opening_journal_matches'] ??
      json['openingJournalMatches'] ??
      false) as bool;

  final rawMembership = (json['membership_unearned'] ??
      json['membershipUnearned'] ??
      json['unearned_membership'] ??
      json['unearnedMembership'] ??
      <String, dynamic>{}) as Map;
  final membershipUnearned = goLiveUnearnedComparisonFromJson(
    Map<String, dynamic>.from(rawMembership),
  );

  final rawPt = (json['pt_unearned'] ??
      json['ptUnearned'] ??
      json['unearned_pt'] ??
      json['unearnedPt'] ??
      <String, dynamic>{}) as Map;
  final ptUnearned = goLiveUnearnedComparisonFromJson(
    Map<String, dynamic>.from(rawPt),
  );

  final rawTax = (json['tax_match'] ??
      json['taxMatch'] ??
      <String, dynamic>{}) as Map;
  final taxMatch = goLiveTaxComparisonFromJson(
    Map<String, dynamic>.from(rawTax),
  );

  final rawPaymentMethods = (json['payment_methods'] ??
      json['paymentMethods'] ??
      <dynamic>[]) as List;
  final paymentMethods = rawPaymentMethods
      .map((item) => goLivePaymentMethodMappingFromJson(
            Map<String, dynamic>.from(item as Map),
          ))
      .toList();

  return GoLiveChecklist(
    goLiveDate: goLiveDate,
    isPostingEnabled: isPostingEnabled,
    canEnable: canEnable,
    failingReasons: failingReasons,
    openingJournalFound: openingJournalFound,
    openingJournalMatches: openingJournalMatches,
    membershipUnearned: membershipUnearned,
    ptUnearned: ptUnearned,
    taxMatch: taxMatch,
    paymentMethods: paymentMethods,
  );
}

extension GoLivePaymentMethodModelMapper on api.GoLivePaymentMethod {
  GoLivePaymentMethodMapping toDomain() {
    return GoLivePaymentMethodMapping(
      id: id,
      methodName: methodName,
      isActive: isActive,
      isDigital: isDigital,
      accountId: accountId,
      accountName: accountName,
    );
  }
}

extension GoLiveUnearnedMatchModelMapper on api.GoLiveUnearnedMatch {
  GoLiveUnearnedComparison toDomain() {
    return GoLiveUnearnedComparison(
      preview: preview,
      actual: actual,
      isMatched: matched,
    );
  }
}

extension GoLiveTaxMatchModelMapper on api.GoLiveTaxMatch {
  GoLiveTaxComparison toDomain() {
    return GoLiveTaxComparison(
      gymRate: gymTaxRate,
      defaultCode: defaultTaxCode,
      defaultRate: defaultTaxRate,
      isMatched: matched,
    );
  }
}

extension GoLiveChecklistResponseModelMapper on api.GoLiveChecklistResponse {
  GoLiveChecklist toDomain() {
    return GoLiveChecklist(
      goLiveDate: goLiveDate.toDateTime(),
      isPostingEnabled: postingEnabled,
      canEnable: canEnable,
      failingReasons: failingReasons.toList(),
      openingJournalFound: openingJournalFound,
      openingJournalMatches: openingJournalMatches,
      membershipUnearned: unearnedMembership.toDomain(),
      ptUnearned: unearnedPt.toDomain(),
      taxMatch: taxMatch.toDomain(),
      paymentMethods: paymentMethods.map((m) => m.toDomain()).toList(),
    );
  }
}
