import 'package:equatable/equatable.dart';

class TrialBalanceAccountItem extends Equatable {
  const TrialBalanceAccountItem({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.debit,
    required this.credit,
  });

  final String accountId;
  final String accountCode;
  final String accountName;
  final String debit;
  final String credit;

  @override
  List<Object?> get props => [
    accountId,
    accountCode,
    accountName,
    debit,
    credit,
  ];
}

class TrialBalanceReport extends Equatable {
  const TrialBalanceReport({
    this.fromDate,
    required this.toDate,
    required this.totalDebit,
    required this.totalCredit,
    this.accounts = const [],
  });

  final DateTime? fromDate;
  final DateTime toDate;
  final String totalDebit;
  final String totalCredit;
  final List<TrialBalanceAccountItem> accounts;

  @override
  List<Object?> get props => [
    fromDate,
    toDate,
    totalDebit,
    totalCredit,
    accounts,
  ];
}

class ReportAccountItem extends Equatable {
  const ReportAccountItem({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.amount,
  });

  final String accountId;
  final String accountCode;
  final String accountName;
  final String amount;

  @override
  List<Object?> get props => [
    accountId,
    accountCode,
    accountName,
    amount,
  ];
}

class ProfitAndLossReport extends Equatable {
  const ProfitAndLossReport({
    required this.fromDate,
    required this.toDate,
    required this.totalIncome,
    required this.totalExpense,
    required this.netProfit,
    this.incomeAccounts = const [],
    this.expenseAccounts = const [],
  });

  final DateTime fromDate;
  final DateTime toDate;
  final String totalIncome;
  final String totalExpense;
  final String netProfit;
  final List<ReportAccountItem> incomeAccounts;
  final List<ReportAccountItem> expenseAccounts;

  @override
  List<Object?> get props => [
    fromDate,
    toDate,
    totalIncome,
    totalExpense,
    netProfit,
    incomeAccounts,
    expenseAccounts,
  ];
}

class BalanceSheetReport extends Equatable {
  const BalanceSheetReport({
    required this.asOfDate,
    required this.totalAssets,
    required this.totalLiabilities,
    required this.totalEquity,
    required this.currentYearEarnings,
    this.assetAccounts = const [],
    this.liabilityAccounts = const [],
    this.equityAccounts = const [],
  });

  final DateTime asOfDate;
  final String totalAssets;
  final String totalLiabilities;
  final String totalEquity;
  final String currentYearEarnings;
  final List<ReportAccountItem> assetAccounts;
  final List<ReportAccountItem> liabilityAccounts;
  final List<ReportAccountItem> equityAccounts;

  @override
  List<Object?> get props => [
    asOfDate,
    totalAssets,
    totalLiabilities,
    totalEquity,
    currentYearEarnings,
    assetAccounts,
    liabilityAccounts,
    equityAccounts,
  ];
}

class DayBookLineItem extends Equatable {
  const DayBookLineItem({
    required this.id,
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    required this.debit,
    required this.credit,
    this.memo,
  });

  final String id;
  final String accountId;
  final String accountCode;
  final String accountName;
  final String debit;
  final String credit;
  final String? memo;

  @override
  List<Object?> get props => [
    id,
    accountId,
    accountCode,
    accountName,
    debit,
    credit,
    memo,
  ];
}

class DayBookJournalItem extends Equatable {
  const DayBookJournalItem({
    required this.journalId,
    required this.journalNumber,
    required this.date,
    this.memo,
    this.lines = const [],
  });

  final String journalId;
  final String journalNumber;
  final DateTime date;
  final String? memo;
  final List<DayBookLineItem> lines;

  @override
  List<Object?> get props => [
    journalId,
    journalNumber,
    date,
    memo,
    lines,
  ];
}

class DayBookReport extends Equatable {
  const DayBookReport({
    required this.date,
    this.journals = const [],
  });

  final DateTime date;
  final List<DayBookJournalItem> journals;

  @override
  List<Object?> get props => [date, journals];
}

class OpenItemEntry extends Equatable {
  const OpenItemEntry({
    required this.documentId,
    required this.documentNumber,
    required this.partyName,
    required this.date,
    required this.totalAmount,
    required this.openAmount,
    required this.kind,
  });

  final String documentId;
  final String documentNumber;
  final String partyName;
  final DateTime date;
  final String totalAmount;
  final String openAmount;
  final String kind;

  @override
  List<Object?> get props => [
    documentId,
    documentNumber,
    partyName,
    date,
    totalAmount,
    openAmount,
    kind,
  ];
}

class OpenItemsReport extends Equatable {
  const OpenItemsReport({
    required this.kind,
    required this.totalOpenAmount,
    this.items = const [],
  });

  final String kind;
  final String totalOpenAmount;
  final List<OpenItemEntry> items;

  @override
  List<Object?> get props => [
    kind,
    totalOpenAmount,
    items,
  ];
}

class GstTaxCodeSummary extends Equatable {
  const GstTaxCodeSummary({
    required this.taxCodeId,
    required this.taxCodeName,
    required this.ratePercent,
    required this.taxableValue,
    required this.cgstAmount,
    required this.sgstAmount,
    required this.igstAmount,
    required this.totalTax,
  });

  final String taxCodeId;
  final String taxCodeName;
  final String ratePercent;
  final String taxableValue;
  final String cgstAmount;
  final String sgstAmount;
  final String igstAmount;
  final String totalTax;

  @override
  List<Object?> get props => [
    taxCodeId,
    taxCodeName,
    ratePercent,
    taxableValue,
    cgstAmount,
    sgstAmount,
    igstAmount,
    totalTax,
  ];
}

class GstSummaryReport extends Equatable {
  const GstSummaryReport({
    required this.fromDate,
    required this.toDate,
    required this.totalTaxableValue,
    required this.totalOutputTax,
    required this.totalInputTax,
    required this.netTaxPayable,
    this.codeSummaries = const [],
  });

  final DateTime fromDate;
  final DateTime toDate;
  final String totalTaxableValue;
  final String totalOutputTax;
  final String totalInputTax;
  final String netTaxPayable;
  final List<GstTaxCodeSummary> codeSummaries;

  @override
  List<Object?> get props => [
    fromDate,
    toDate,
    totalTaxableValue,
    totalOutputTax,
    totalInputTax,
    netTaxPayable,
    codeSummaries,
  ];
}

class UnearnedPreviewReportItem extends Equatable {
  const UnearnedPreviewReportItem({
    required this.kind,
    required this.sourceId,
    required this.paymentId,
    required this.memberId,
    required this.startsOn,
    required this.endsOn,
    required this.unearnedAccountId,
    required this.incomeAccountId,
    required this.accountCode,
    required this.totalNet,
    required this.unexpiredAmount,
  });

  final String kind;
  final String sourceId;
  final String paymentId;
  final String memberId;
  final DateTime startsOn;
  final DateTime endsOn;
  final String unearnedAccountId;
  final String incomeAccountId;
  final String accountCode;
  final String totalNet;
  final String unexpiredAmount;

  @override
  List<Object?> get props => [
    kind,
    sourceId,
    paymentId,
    memberId,
    startsOn,
    endsOn,
    unearnedAccountId,
    incomeAccountId,
    accountCode,
    totalNet,
    unexpiredAmount,
  ];
}

class UnearnedPreviewReport extends Equatable {
  const UnearnedPreviewReport({
    required this.asOfDate,
    required this.totalMembershipUnearned,
    required this.totalPtUnearned,
    required this.totalUnearned,
    this.items = const [],
  });

  final DateTime asOfDate;
  final String totalMembershipUnearned;
  final String totalPtUnearned;
  final String totalUnearned;
  final List<UnearnedPreviewReportItem> items;

  @override
  List<Object?> get props => [
    asOfDate,
    totalMembershipUnearned,
    totalPtUnearned,
    totalUnearned,
    items,
  ];
}
