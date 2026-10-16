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
  static const String itemsTitle = 'Items';
  static const String itemDetailTitle = 'Item Details';
  static const String createItemTitle = 'New Item';
  static const String editItemTitle = 'Edit Item';
  static const String itemSectionBasics = 'Basics';
  static const String itemSectionPricing = 'Pricing & tax';
  static const String itemSectionAccounting = 'Accounting';
  static const String itemSectionInventory = 'Inventory';
  static const String itemNameLabel = 'Name';
  static const String itemSkuLabel = 'SKU';
  static const String itemHsnSacLabel = 'HSN/SAC';
  static const String itemKindLabel = 'Kind';
  static const String itemCategoryLabel = 'Category';
  static const String itemUomLabel = 'Unit of measure';
  static const String itemSaleRateLabel = 'Sale rate';
  static const String itemPurchaseRateLabel = 'Purchase rate';
  static const String itemTaxCodeLabel = 'Tax code';
  static const String itemIncomeAccountLabel = 'Income account';
  static const String itemExpenseAccountLabel = 'Expense account';
  static const String itemInventoryAccountLabel = 'Inventory account';
  static const String itemCogsAccountLabel = 'COGS account';
  static const String itemTrackedLabel = 'Tracks inventory';
  static const String itemReorderLevelLabel = 'Reorder level';
  static const String itemHasMovementsLabel = 'Has stock movements';
  static const String itemActive = 'Active';
  static const String itemInactive = 'Inactive';
  static const String itemYes = 'Yes';
  static const String itemNo = 'No';
  static const String itemEditAction = 'Edit';
  static const String itemRefreshFailed = 'Could not refresh this item.';
  static const String itemEmDash = '—';
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
  static const String confirm = 'Confirm';
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
  static const String reportTotalsTitle = 'Totals';
  static const String noReportData = 'No data for this report and date range.';
  static const String incomeSectionTitle = 'Income';
  static const String expenseSectionTitle = 'Expenses';
  static const String assetsSectionTitle = 'Assets';
  static const String liabilitiesSectionTitle = 'Liabilities';
  static const String equitySectionTitle = 'Equity';
  static const String totalDebit = 'Total Debit';
  static const String totalCredit = 'Total Credit';
  static const String totalIncome = 'Total Income';
  static const String totalExpense = 'Total Expense';
  static const String netProfit = 'Net Profit';
  static const String totalAssets = 'Total Assets';
  static const String totalLiabilities = 'Total Liabilities';
  static const String totalEquity = 'Total Equity';
  static const String totalLiabilitiesAndEquity = 'Total Liabilities & Equity';
  static const String currentYearEarnings = 'Current Year Earnings';
  static const String fiscalYearStartLabel = 'Fiscal Year Start';
  static const String outputTax = 'Output Tax';
  static const String outputCgst = 'Output CGST';
  static const String outputSgst = 'Output SGST';
  static const String outputIgst = 'Output IGST';
  static const String inputTax = 'Input Tax';
  static const String netGstPayable = 'Net GST Payable';
  static const String taxableValue = 'Taxable Value';
  static const String cgstLabel = 'CGST';
  static const String sgstLabel = 'SGST';
  static const String igstLabel = 'IGST';
  static const String ratePercentLabel = 'Rate %';
  static const String totalTaxLabel = 'Total Tax';
  static const String unearnedMembership = 'Unearned Membership';
  static const String unearnedPt = 'Unearned PT';
  static const String totalUnearned = 'Total Unearned';

  // Field Labels
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

  // Accounts Form & Picker
  static const String searchAccounts = 'Search accounts...';
  static const String searchItems = 'Search by name or SKU...';
  static const String selectItem = 'Select an item';
  static const String allTypes = 'All Types';
  static const String allKinds = 'All kinds';
  static const String allStatuses = 'All Statuses';
  static const String activeOnly = 'Active Only';
  static const String inactiveOnly = 'Inactive Only';
  static const String itemKindGoods = 'Goods';
  static const String itemKindService = 'Service';
  static const String trackedBadge = 'Tracked';
  static const String trackedOnly = 'Tracked';
  static const String untrackedOnly = 'Untracked';
  static const String parentAccountLabel = 'Parent Account';
  static const String none = 'None';
  static const String selectAccount = 'Select Account';
  static const String cannotPickDeactivated =
      'Deactivated accounts cannot be picked on a new document.';
  static const String deactivateAccount = 'Deactivate Account';
  static const String deactivateAccountConfirm =
      'Are you sure you want to deactivate this account? Deactivated accounts stay visible on reports and lists, but cannot be picked on new documents.';
  static const String cannotDeactivateControl =
      'Control accounts cannot be deactivated.';
  static const String accountTypeAsset = 'Asset';
  static const String accountTypeLiability = 'Liability';
  static const String accountTypeEquity = 'Equity';
  static const String accountTypeIncome = 'Income';
  static const String accountTypeExpense = 'Expense';
  static const String nameRequired = 'Account name is required.';
  static const String typeRequired = 'Account type is required.';
  static const String accountSavedSuccess = 'Account saved successfully.';
  static const String accountDeactivatedSuccess =
      'Account deactivated successfully.';
  static const String noPermission =
      'You do not have permission to perform this action.';
  static const String selectType = 'Select Account Type';
  static const String accountCreatedSuccess = 'Account created successfully.';
  static const String accountUpdatedSuccess = 'Account updated successfully.';

  // Journals & Entry Form
  static const String journalNumberLabel = 'Journal #';
  static const String sourceTypeLabel = 'Source Type';
  static const String sourceIdLabel = 'Source ID';
  static const String reversesJournalLabel = 'Reverses';
  static const String reversedByJournalLabel = 'Reversed By';
  static const String reversalDateLabel = 'Reversal Date';
  static const String reversalMemoLabel = 'Reversal Memo';
  static const String reverseJournalConfirm =
      'Are you sure you want to reverse this journal entry? This will create an offsetting journal with swapped debits and credits.';
  static const String journalReversedSuccess =
      'Journal entry reversed successfully.';
  static const String journalCreatedSuccess =
      'Journal entry created successfully.';
  static const String unbalancedEntryError =
      'An unbalanced entry cannot be submitted. Debits must equal credits.';
  static const String minLinesRequired =
      'At least two journal lines are required.';
  static const String accountRequiredOnLines =
      'Every line must have an account selected.';
  static const String lineBothDebitCreditError =
      'A line cannot have both debit and credit amounts.';
  static const String lineZeroAmountError =
      'Every line must have either a debit or a credit amount.';
  static const String addLine = 'Add Line';
  static const String removeLine = 'Remove Line';
  static const String balancedStatus = 'Balanced';
  static const String unbalancedStatus = 'Unbalanced';
  static const String differenceLabel = 'Difference';
  static const String filterByDateRange = 'Filter by Date';
  static const String filterBySourceType = 'Source Type';
  static const String filterByPaymentId = 'Payment ID';
  static const String openingBadge = 'Opening';
  static const String closingBadge = 'Closing';

  // Periods Management
  static const String fiscalYearLabel = 'Fiscal Year';
  static const String periodNumberLabel = 'Period #';
  static const String periodRangeLabel = 'Date Range';
  static const String selectFiscalYear = 'Select Fiscal Year';
  static const String lockPeriodConfirmation =
      'Are you sure you want to lock this accounting period? No further transactions can be posted to it.';
  static const String unlockPeriodConfirmation =
      'Are you sure you want to unlock this accounting period?';

  // Vendors, Bills, Expenses, Vouchers, Transfers (ACC-095)
  static const String transfersTitle = 'Fund Transfers';
  static const String transferDetailTitle = 'Fund Transfer';
  static const String createTransferTitle = 'New Fund Transfer';
  static const String fromAccountLabel = 'From Account';
  static const String toAccountLabel = 'To Account';
  static const String feeAmountLabel = 'Fee Amount';
  static const String feeAccountLabel = 'Fee Account';
  static const String transferDateLabel = 'Transfer Date';
  static const String transferCreatedSuccess =
      'Fund transfer created successfully.';
  static const String transferPostedSuccess =
      'Fund transfer posted successfully.';
  static const String postTransferConfirm =
      'Are you sure you want to post this fund transfer to the general ledger? Once posted, it cannot be modified.';
  static const String cannotTransferSameAccount =
      'Source and destination accounts must be different.';
  static const String feeLineLabel = 'Processor Fee';
  static const String postTransfer = 'Post Transfer';
  static const String searchTransfers = 'Search transfers...';
  static const String grossAmountLabel = 'Gross Amount';
  static const String netTransferAmountLabel = 'Net Deposited';

  static const String phoneLabel = 'Phone';
  static const String emailLabel = 'Email';
  static const String gstinLabel = 'GSTIN';
  static const String vendorSavedSuccess = 'Vendor saved successfully.';
  static const String vendorCreatedSuccess = 'Vendor created successfully.';
  static const String vendorUpdatedSuccess = 'Vendor updated successfully.';
  static const String vendorNameRequired = 'Vendor name is required.';
  static const String searchVendors = 'Search vendors...';

  static const String billNumberLabel = 'Bill #';
  static const String subtotalLabel = 'Subtotal';
  static const String taxAmountLabel = 'Tax Amount';
  static const String billCreatedSuccess =
      'Purchase bill created successfully.';
  static const String billPostedSuccess =
      'Purchase bill posted successfully.';
  static const String postBillConfirm =
      'Are you sure you want to post this purchase bill? Once posted, it creates journal entries and cannot be modified.';
  static const String postBill = 'Post Bill';
  static const String searchBills = 'Search bills...';
  static const String lineItemRequired =
      'At least one bill line item is required.';
  static const String rateLabel = 'Rate';
  static const String quantityLabel = 'Quantity';
  static const String taxCodeLabel = 'Tax Code';
  static const String itemLabel = 'Item';
  static const String supplierInvoiceNoLabel = 'Supplier Invoice #';
  static const String saveDraft = 'Save draft';
  static const String saveAndPost = 'Save & post';
  static const String billDraftSavedSuccess =
      'Purchase bill saved as draft.';
  static const String rateExcludesTaxHint = 'Rate excludes tax';

  static const String expenseNumberLabel = 'Expense #';
  static const String payeeLabel = 'Payee';
  static const String paidFromAccountLabel = 'Paid From Account';
  static const String expenseCreatedSuccess =
      'Expense created successfully.';
  static const String expensePostedSuccess =
      'Expense posted successfully.';
  static const String postExpenseConfirm =
      'Are you sure you want to post this expense voucher? Once posted, it creates journal entries and cannot be modified.';
  static const String postExpense = 'Post Expense';
  static const String searchExpenses = 'Search expenses...';
  static const String vendorOrPayeeRequired =
      'Vendor or Payee Name is required for credit expense.';

  static const String voucherNumberLabel = 'Voucher #';
  static const String bankAccountLabel = 'Bank Account';
  static const String allocationAmountLabel = 'Allocated Amount';
  static const String addAllocation = 'Add Allocation';
  static const String removeAllocation = 'Remove Allocation';
  static const String voucherCreatedSuccess =
      'Payment voucher created successfully.';
  static const String voucherPostedSuccess =
      'Payment voucher posted successfully.';
  static const String postVoucherConfirm =
      'Are you sure you want to post this payment voucher? Once posted, it creates journal entries and cannot be modified.';
  static const String postVoucher = 'Post Voucher';
  static const String allocationsSumMismatch =
      'Total amount must equal the sum of allocated amounts.';
  static const String searchVouchers = 'Search payment vouchers...';
  static const String allocationTypeBill = 'Purchase Bill';
  static const String allocationTypeExpense = 'Expense Voucher';
  static const String selectAllocationTarget = 'Select Bill or Expense';
  static const String allocatedLabel = 'Allocated';
  static const String allocationsLabel = 'Allocations';

  // Go-Live (ACC-099)
  static const String goLiveSetup = 'Go-Live Setup';
  static const String goLiveDateLabel = 'Go-Live Date';
  static const String changeDateLabel = 'Change Date';
  static const String runCutover = 'Execute Cutover';
  static const String cutoverWarning =
      'Executing Go-Live locks all historical periods and initializes opening balances.';
  static const String goLiveChecklistTitle = 'Go-Live Checklist';

  // Payment Method Mappings
  static const String paymentMethodMappingsTitle = 'Payment Method Mappings';
  static const String paymentMethodMappingsSubtitle =
      'Active payment methods mapped to ledger accounts';
  static const String mappedAccountLabel = 'Mapped Account';
  static const String unmappedAccount = 'Unmapped';
  static const String mapAccount = 'Map Account';
  static const String changeAccount = 'Change Account';
  static const String paymentMethodMappedSuccess =
      'Payment method mapped successfully.';

  // Unearned Revenue & Opening Balance Match
  static const String unearnedComparisonTitle =
      'Opening Balance & Unearned Revenue Comparison';
  static const String expectedPreviewLabel = 'Expected (Calculated Preview)';
  static const String actualOpeningLabel = 'Actual (Opening Journal)';
  static const String openingJournalMissing = 'Opening Journal Missing';
  static const String matchedBadge = 'Matched';
  static const String mismatchBadge = 'Mismatch';
  static const String unearnedMembershipAccountLabel =
      'Unearned Membership (2200)';
  static const String unearnedPtAccountLabel = 'Unearned PT (2210)';

  // Readiness & Failing Checks
  static const String readinessTitle = 'Go-Live Readiness';
  static const String allPrerequisitesMet =
      'All prerequisites met. Ready for Go-Live.';
  static const String prerequisitesNotMet =
      'Prerequisites not met. Resolve the issues below before enabling posting.';
  static const String failingChecksTitle = 'Failing Checks';

  // Enable Posting
  static const String enableAutomaticPosting = 'Enable Automatic Posting';
  static const String postingAlreadyEnabled = 'Posting is currently ENABLED';
  static const String confirmGoLiveTitle = 'Confirm Go-Live';
  static const String enablePostingConfirm =
      'Executing Go-Live locks all historical periods and initializes opening balances. This action enables automatic journal creation from member sales and cannot be undone easily. Are you sure you want to proceed?';
  static const String postingEnabledSuccess =
      'Automatic journal posting enabled successfully.';
  static const String missingPostingTogglePermission =
      'Requires accounting.posting_toggle capability to enable automatic posting.';

  // Formatters
  static String formatMoney(String amount) => '\$$amount';
  static String formatAmount(num amount) => '\$${amount.toStringAsFixed(2)}';

  static String periodSummary(AccountingPeriod period) =>
      '${period.name} (${period.startDate.toIso8601String().substring(0, 10)} to ${period.endDate.toIso8601String().substring(0, 10)})';

  static String openItemsCount(int count) => '$count open item${count == 1 ? '' : 's'}';

  static const String searchUoms = 'Search units';
  static const String itemCategoryNone = 'No category';
}
