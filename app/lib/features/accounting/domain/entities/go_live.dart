import 'package:equatable/equatable.dart';

class GoLiveUnearnedComparison extends Equatable {
  const GoLiveUnearnedComparison({
    required this.preview,
    required this.actual,
    required this.isMatched,
  });

  final String preview;
  final String actual;
  final bool isMatched;

  @override
  List<Object?> get props => [preview, actual, isMatched];
}

class GoLiveTaxComparison extends Equatable {
  const GoLiveTaxComparison({
    required this.gymRate,
    required this.defaultCode,
    required this.defaultRate,
    required this.isMatched,
  });

  final String gymRate;
  final String defaultCode;
  final String defaultRate;
  final bool isMatched;

  @override
  List<Object?> get props => [gymRate, defaultCode, defaultRate, isMatched];
}

class GoLivePaymentMethodMapping extends Equatable {
  const GoLivePaymentMethodMapping({
    required this.id,
    required this.methodName,
    required this.isActive,
    required this.isDigital,
    this.accountId,
    this.accountName,
  });

  final int id;
  final String methodName;
  final bool isActive;
  final bool isDigital;
  final int? accountId;
  final String? accountName;

  GoLivePaymentMethodMapping copyWith({
    int? id,
    String? methodName,
    bool? isActive,
    bool? isDigital,
    int? accountId,
    String? accountName,
    bool clearAccountId = false,
  }) {
    return GoLivePaymentMethodMapping(
      id: id ?? this.id,
      methodName: methodName ?? this.methodName,
      isActive: isActive ?? this.isActive,
      isDigital: isDigital ?? this.isDigital,
      accountId: clearAccountId ? null : (accountId ?? this.accountId),
      accountName: clearAccountId ? null : (accountName ?? this.accountName),
    );
  }

  @override
  List<Object?> get props => [
        id,
        methodName,
        isActive,
        isDigital,
        accountId,
        accountName,
      ];
}

class GoLiveChecklist extends Equatable {
  const GoLiveChecklist({
    required this.goLiveDate,
    required this.isPostingEnabled,
    required this.canEnable,
    required this.failingReasons,
    required this.openingJournalFound,
    required this.openingJournalMatches,
    required this.membershipUnearned,
    required this.ptUnearned,
    required this.taxMatch,
    required this.paymentMethods,
  });

  final DateTime goLiveDate;
  final bool isPostingEnabled;
  final bool canEnable;
  final List<String> failingReasons;
  final bool openingJournalFound;
  final bool openingJournalMatches;
  final GoLiveUnearnedComparison membershipUnearned;
  final GoLiveUnearnedComparison ptUnearned;
  final GoLiveTaxComparison taxMatch;
  final List<GoLivePaymentMethodMapping> paymentMethods;

  @override
  List<Object?> get props => [
        goLiveDate,
        isPostingEnabled,
        canEnable,
        failingReasons,
        openingJournalFound,
        openingJournalMatches,
        membershipUnearned,
        ptUnearned,
        taxMatch,
        paymentMethods,
      ];
}
