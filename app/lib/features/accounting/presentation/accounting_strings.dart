import '../domain/entities/accounting_period.dart';

/// UI string constants for the Accounting module.
class AccountingStrings {
  AccountingStrings._();

  // Navigation & Screen Titles
  static const String homeTitle = 'Accounting';
  static const String accountsTitle = 'Chart of Accounts';
  static const String accountDetailTitle = 'Account Details';
  static const String createAccountTitle = 'New Account';
  static const String editAccountTitle = 'Edit Account';
  static const String journalsTitle = 'Journal Entries';
  static const String journalDetailTitle = 'Journal Entry';
  static const String createJournalTitle = 'New Journal Entry';
  static const String reverseJournalTitle = 'Reverse Journal Entry';
  static const String billsTitle = 'Purchase Bills';
  static const String billDetailTitle = 'Purchase Bill';
  static const String createBillTitle = 'New Purchase Bill';
  static const String expensesTitle = 'Expenses';
  static const String expenseDetailTitle = 'Expense Voucher';
  static const String createExpenseTitle = 'New Expense';
  static const String paymentVouchersTitle = 'Payment Vouchers';
  static const String paymentVoucherDetailTitle = 'Payment Voucher';
  static const String createPaymentVoucherTitle = 'New Payment Voucher';
  static const String debitNotesTitle = 'Debit Notes';
  static const String debitNoteDetailTitle = 'Debit Note';
  static const String createDebitNoteTitle = 'New Debit Note';
  static const String vendorsTitle = 'Vendors';
  static const String vendorDetailTitle = 'Vendor Details';
  static const String createVendorTitle = 'New Vendor';
  static const String editVendorTitle = 'Edit Vendor';
  static const String reportsTitle = 'Accounting Reports';
  static const String periodsTitle = 'Fiscal Periods';
  static const String goLiveTitle = 'Accounting Go-Live';

  // Home Screen Sections & Cards
  static const String summarySectionTitle = 'Financial Summary';
  static const String openReceivables = 'Open Receivables (AR)';
  static const String openPayables = 'Open Payables (AP)';
  static const String cashAndBank = 'Cash & Bank Balances';
  static const String currentPeriod = 'Current Period';
  static const String quickActions = 'Quick Actions';
  static const String noBankAccounts = 'No cash or bank accounts found.';
  static const String noOpenItems = 'No open items outstanding.';
  static const String noPeriodActive = 'No active accounting period.';

  // Quick Action Buttons
  static const String viewAllAccounts = 'Chart of Accounts';
  static const String viewAllJournals = 'Journal Entries';
  static const String viewReports = 'Financial Reports';
  static const String managePeriods = 'Fiscal Periods';

  // Period Status Badges & Labels
  static const String periodLockedBadge = 'Locked';
  static const String periodOpenBadge = 'Open';
  static const String draftDocumentsWarning =
      'Draft documents exist in this period and must be posted or deleted before closing.';

  // Common Actions & Buttons
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String save = 'Save';
  static const String create = 'Create';
  static const String post = 'Post';
  static const String reverse = 'Reverse';
  static const String lockPeriod = 'Lock Period';
  static const String unlockPeriod = 'Unlock Period';
  static const String refresh = 'Refresh';
  static const String search = 'Search';
  static const String filter = 'Filter';
  static const String clearFilter = 'Clear Filters';
  static const String apply = 'Apply';
  static const String noneFound = 'No records found.';

  // Reports
  static const String trialBalanceTitle = 'Trial Balance';
  static const String profitAndLossTitle = 'Profit & Loss';
  static const String balanceSheetTitle = 'Balance Sheet';
  static const String dayBookTitle = 'Day Book';
  static const String gstSummaryTitle = 'GST Summary';
  static const String openItemsTitle = 'Open Items';
  static const String unearnedPreviewTitle = 'Unearned Revenue Preview';
  static const String fromDateLabel = 'From Date';
  static const String toDateLabel = 'To Date';
  static const String asOfDateLabel = 'As of Date';
  static const String generateReport = 'Generate Report';
  static const String totalDebit = 'Total Debit';
  static const String totalCredit = 'Total Credit';
  static const String totalIncome = 'Total Income';
  static const String totalExpense = 'Total Expense';
  static const String netProfit = 'Net Profit';
  static const String totalAssets = 'Total Assets';
  static const String totalLiabilities = 'Total Liabilities';
  static const String totalEquity = 'Total Equity';
  static const String currentYearEarnings = 'Current Year Earnings';
  static const String outputTax = 'Output Tax';
  static const String inputTax = 'Input Tax';
  static const String netGstPayable = 'Net GST Payable';
  static const String taxableValue = 'Taxable Value';
  static const String unearnedMembership = 'Unearned Membership';
  static const String unearnedPt = 'Unearned PT';
  static const String totalUnearned = 'Total Unearned';

  // Field Labels
  static const String codeLabel = 'Account Code';
  static const String nameLabel = 'Name';
  static const String typeLabel = 'Account Type';
  static const String descriptionLabel = 'Description';
  static const String debitLabel = 'Debit';
  static const String creditLabel = 'Credit';
  static const String balanceLabel = 'Balance';
  static const String memoLabel = 'Memo';
  static const String dateLabel = 'Date';
  static const String entryDateLabel = 'Entry Date';
  static const String billDateLabel = 'Bill Date';
  static const String dueDateLabel = 'Due Date';
  static const String expenseDateLabel = 'Expense Date';
  static const String paymentDateLabel = 'Payment Date';
  static const String debitNoteDateLabel = 'Debit Note Date';
  static const String vendorLabel = 'Vendor';
  static const String amountLabel = 'Amount';
  static const String totalAmountLabel = 'Total Amount';
  static const String statusLabel = 'Status';
  static const String isActiveLabel = 'Active';
  static const String isBankLabel = 'Bank / Cash Account';
  static const String isControlLabel = 'Control Account';
  static const String controlRoleLabel = 'Control Role';
  static const String reasonLabel = 'Reason';
  static const String partyLabel = 'Party';
  static const String documentNumberLabel = 'Document #';
  static const String openAmountLabel = 'Open Amount';

  // Status & Badges
  static const String statusDraft = 'Draft';
  static const String statusPosted = 'Posted';
  static const String statusVoid = 'Void';
  static const String statusReversed = 'Reversed';
  static const String statusPaid = 'Paid';
  static const String statusPartial = 'Partial';
  static const String statusOverdue = 'Overdue';
  static const String activeBadge = 'Active';
  static const String inactiveBadge = 'Inactive';

  // Periods Management
  static const String fiscalYearLabel = 'Fiscal Year';
  static const String periodNumberLabel = 'Period #';
  static const String periodRangeLabel = 'Date Range';
  static const String selectFiscalYear = 'Select Fiscal Year';
  static const String lockPeriodConfirmation =
      'Are you sure you want to lock this accounting period? No further transactions can be posted to it.';
  static const String unlockPeriodConfirmation =
      'Are you sure you want to unlock this accounting period?';

  // Go-Live
  static const String goLiveDateLabel = 'Go-Live Date';
  static const String runCutover = 'Execute Cutover';
  static const String cutoverWarning =
      'Executing Go-Live locks all historical periods and initializes opening balances.';

  // Formatters
  static String formatMoney(String amount) => '\$$amount';
  static String formatAmount(num amount) => '\$${amount.toStringAsFixed(2)}';

  static String periodSummary(AccountingPeriod period) =>
      '${period.name} (${period.startDate.toIso8601String().substring(0, 10)} to ${period.endDate.toIso8601String().substring(0, 10)})';

  static String openItemsCount(int count) => '$count open item${count == 1 ? '' : 's'}';
}
