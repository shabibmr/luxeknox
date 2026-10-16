# api_client.api.ACCTApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createAccount**](ACCTApi.md#createaccount) | **POST** /accounting/accounts | Create an account
[**createDebitNote**](ACCTApi.md#createdebitnote) | **POST** /accounting/debit-notes | Create a draft debit note
[**createExpense**](ACCTApi.md#createexpense) | **POST** /accounting/expenses | Create an expense voucher
[**createFundTransfer**](ACCTApi.md#createfundtransfer) | **POST** /accounting/fund-transfers | Create fund transfer
[**createItem**](ACCTApi.md#createitem) | **POST** /accounting/items | Create item
[**createJournal**](ACCTApi.md#createjournal) | **POST** /accounting/journals | Create a manual or opening-balance journal
[**createPaymentVoucher**](ACCTApi.md#createpaymentvoucher) | **POST** /accounting/payment-vouchers | Create a draft payment voucher
[**createPurchaseBill**](ACCTApi.md#createpurchasebill) | **POST** /accounting/purchase-bills | Create a purchase bill (posted unless draft is true)
[**createTaxCode**](ACCTApi.md#createtaxcode) | **POST** /accounting/tax-codes | Create a tax code
[**createVendor**](ACCTApi.md#createvendor) | **POST** /accounting/vendors | Create vendor
[**enablePosting**](ACCTApi.md#enableposting) | **POST** /accounting/go-live/enable-posting | Enable accounting journal posting
[**getAccount**](ACCTApi.md#getaccount) | **GET** /accounting/accounts/{id} | Account detail
[**getBalanceSheet**](ACCTApi.md#getbalancesheet) | **GET** /accounting/reports/balance-sheet | Balance sheet as of a date
[**getDayBook**](ACCTApi.md#getdaybook) | **GET** /accounting/reports/day-book | Day book for one date
[**getDebitNote**](ACCTApi.md#getdebitnote) | **GET** /accounting/debit-notes/{id} | Get debit note by ID
[**getExpense**](ACCTApi.md#getexpense) | **GET** /accounting/expenses/{id} | Get expense voucher by ID
[**getFundTransfer**](ACCTApi.md#getfundtransfer) | **GET** /accounting/fund-transfers/{id} | Get fund transfer by ID
[**getGoLiveChecklist**](ACCTApi.md#getgolivechecklist) | **GET** /accounting/go-live/checklist | Get accounting go-live checklist and prerequisite checks
[**getGstSummary**](ACCTApi.md#getgstsummary) | **GET** /accounting/reports/gst-summary | GST summary for a date range
[**getItem**](ACCTApi.md#getitem) | **GET** /accounting/items/{id} | Get item by ID
[**getJournal**](ACCTApi.md#getjournal) | **GET** /accounting/journals/{id} | Journal entry detail
[**getOpenItems**](ACCTApi.md#getopenitems) | **GET** /accounting/reports/open-items | Open AR or AP items
[**getPaymentVoucher**](ACCTApi.md#getpaymentvoucher) | **GET** /accounting/payment-vouchers/{id} | Get payment voucher by ID
[**getProfitAndLoss**](ACCTApi.md#getprofitandloss) | **GET** /accounting/reports/profit-and-loss | Profit and loss for a date range
[**getPurchaseBill**](ACCTApi.md#getpurchasebill) | **GET** /accounting/purchase-bills/{id} | Get purchase bill by ID
[**getTaxCode**](ACCTApi.md#gettaxcode) | **GET** /accounting/tax-codes/{id} | Tax code detail
[**getTrialBalance**](ACCTApi.md#gettrialbalance) | **GET** /accounting/reports/trial-balance | Trial balance for a date range
[**getUnearnedPreview**](ACCTApi.md#getunearnedpreview) | **GET** /accounting/go-live/unearned-preview | Preview unearned membership and PT revenue for go-live
[**getVendor**](ACCTApi.md#getvendor) | **GET** /accounting/vendors/{id} | Get vendor by ID
[**listAccountingPeriods**](ACCTApi.md#listaccountingperiods) | **GET** /accounting/periods | List accounting periods
[**listAccounts**](ACCTApi.md#listaccounts) | **GET** /accounting/accounts | List accounts
[**listDebitNotes**](ACCTApi.md#listdebitnotes) | **GET** /accounting/debit-notes | List debit notes
[**listExpenses**](ACCTApi.md#listexpenses) | **GET** /accounting/expenses | List expense vouchers
[**listFiscalYears**](ACCTApi.md#listfiscalyears) | **GET** /accounting/fiscal-years | List all fiscal years
[**listFundTransfers**](ACCTApi.md#listfundtransfers) | **GET** /accounting/fund-transfers | List fund transfers
[**listItems**](ACCTApi.md#listitems) | **GET** /accounting/items | List items
[**listJournals**](ACCTApi.md#listjournals) | **GET** /accounting/journals | List journal entries
[**listPaymentVouchers**](ACCTApi.md#listpaymentvouchers) | **GET** /accounting/payment-vouchers | List payment vouchers
[**listPurchaseBills**](ACCTApi.md#listpurchasebills) | **GET** /accounting/purchase-bills | List purchase bills
[**listTaxCodes**](ACCTApi.md#listtaxcodes) | **GET** /accounting/tax-codes | List tax codes
[**listVendors**](ACCTApi.md#listvendors) | **GET** /accounting/vendors | List vendors
[**lockAccountingPeriod**](ACCTApi.md#lockaccountingperiod) | **POST** /accounting/periods/{id}/lock | Lock an accounting period
[**mapPaymentMethodAccount**](ACCTApi.md#mappaymentmethodaccount) | **PATCH** /accounting/go-live/payment-methods/{id} | Map payment method to accounting account
[**postDebitNote**](ACCTApi.md#postdebitnote) | **POST** /accounting/debit-notes/{id}/post | Post a debit note to the general ledger
[**postExpense**](ACCTApi.md#postexpense) | **POST** /accounting/expenses/{id}/post | Post an expense voucher to general ledger
[**postFundTransfer**](ACCTApi.md#postfundtransfer) | **POST** /accounting/fund-transfers/{id}/post | Post fund transfer to GL
[**postPaymentVoucher**](ACCTApi.md#postpaymentvoucher) | **POST** /accounting/payment-vouchers/{id}/post | Post a payment voucher to GL
[**postPurchaseBill**](ACCTApi.md#postpurchasebill) | **POST** /accounting/purchase-bills/{id}/post | Post a draft purchase bill
[**reverseJournal**](ACCTApi.md#reversejournal) | **POST** /accounting/journals/{id}/reverse | Reverse a posted journal
[**unlockAccountingPeriod**](ACCTApi.md#unlockaccountingperiod) | **POST** /accounting/periods/{id}/unlock | Unlock an accounting period
[**updateAccount**](ACCTApi.md#updateaccount) | **PATCH** /accounting/accounts/{id} | Update an account
[**updateExpense**](ACCTApi.md#updateexpense) | **PATCH** /accounting/expenses/{id} | Update a draft expense voucher
[**updateFundTransfer**](ACCTApi.md#updatefundtransfer) | **PATCH** /accounting/fund-transfers/{id} | Update fund transfer
[**updateItem**](ACCTApi.md#updateitem) | **PATCH** /accounting/items/{id} | Update item
[**updatePaymentVoucher**](ACCTApi.md#updatepaymentvoucher) | **PATCH** /accounting/payment-vouchers/{id} | Update a draft payment voucher
[**updateTaxCode**](ACCTApi.md#updatetaxcode) | **PATCH** /accounting/tax-codes/{id} | Update a tax code
[**updateVendor**](ACCTApi.md#updatevendor) | **PATCH** /accounting/vendors/{id} | Update vendor


# **createAccount**
> Account createAccount(accountCreate)

Create an account

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final AccountCreate accountCreate = ; // AccountCreate | 

try {
    final response = api.createAccount(accountCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **accountCreate** | [**AccountCreate**](AccountCreate.md)|  | 

### Return type

[**Account**](Account.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createDebitNote**
> DebitNote createDebitNote(debitNoteCreate, idempotencyKey)

Create a draft debit note

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final DebitNoteCreate debitNoteCreate = ; // DebitNoteCreate | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.createDebitNote(debitNoteCreate, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createDebitNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **debitNoteCreate** | [**DebitNoteCreate**](DebitNoteCreate.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**DebitNote**](DebitNote.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createExpense**
> ExpenseVoucher createExpense(expenseCreate, idempotencyKey)

Create an expense voucher

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final ExpenseCreate expenseCreate = ; // ExpenseCreate | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.createExpense(expenseCreate, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createExpense: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **expenseCreate** | [**ExpenseCreate**](ExpenseCreate.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**ExpenseVoucher**](ExpenseVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createFundTransfer**
> FundTransfer createFundTransfer(fundTransferCreate, idempotencyKey)

Create fund transfer

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final FundTransferCreate fundTransferCreate = ; // FundTransferCreate | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.createFundTransfer(fundTransferCreate, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createFundTransfer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fundTransferCreate** | [**FundTransferCreate**](FundTransferCreate.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**FundTransfer**](FundTransfer.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createItem**
> Item createItem(itemCreate)

Create item

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final ItemCreate itemCreate = ; // ItemCreate | 

try {
    final response = api.createItem(itemCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **itemCreate** | [**ItemCreate**](ItemCreate.md)|  | 

### Return type

[**Item**](Item.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createJournal**
> Journal createJournal(journalCreate, idempotencyKey)

Create a manual or opening-balance journal

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final JournalCreate journalCreate = ; // JournalCreate | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.createJournal(journalCreate, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createJournal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **journalCreate** | [**JournalCreate**](JournalCreate.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**Journal**](Journal.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPaymentVoucher**
> PaymentVoucher createPaymentVoucher(paymentVoucherCreate, idempotencyKey)

Create a draft payment voucher

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final PaymentVoucherCreate paymentVoucherCreate = ; // PaymentVoucherCreate | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.createPaymentVoucher(paymentVoucherCreate, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createPaymentVoucher: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentVoucherCreate** | [**PaymentVoucherCreate**](PaymentVoucherCreate.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**PaymentVoucher**](PaymentVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPurchaseBill**
> PurchaseBill createPurchaseBill(purchaseBillCreate, idempotencyKey)

Create a purchase bill (posted unless draft is true)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final PurchaseBillCreate purchaseBillCreate = ; // PurchaseBillCreate | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.createPurchaseBill(purchaseBillCreate, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createPurchaseBill: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **purchaseBillCreate** | [**PurchaseBillCreate**](PurchaseBillCreate.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**PurchaseBill**](PurchaseBill.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createTaxCode**
> TaxCode createTaxCode(taxCodeCreate)

Create a tax code

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final TaxCodeCreate taxCodeCreate = ; // TaxCodeCreate | 

try {
    final response = api.createTaxCode(taxCodeCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createTaxCode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **taxCodeCreate** | [**TaxCodeCreate**](TaxCodeCreate.md)|  | 

### Return type

[**TaxCode**](TaxCode.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createVendor**
> Vendor createVendor(vendorWrite)

Create vendor

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final VendorWrite vendorWrite = ; // VendorWrite | 

try {
    final response = api.createVendor(vendorWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->createVendor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **vendorWrite** | [**VendorWrite**](VendorWrite.md)|  | 

### Return type

[**Vendor**](Vendor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **enablePosting**
> GoLiveEnablePostingResponse enablePosting(goLiveEnablePosting)

Enable accounting journal posting

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final GoLiveEnablePosting goLiveEnablePosting = ; // GoLiveEnablePosting | 

try {
    final response = api.enablePosting(goLiveEnablePosting);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->enablePosting: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **goLiveEnablePosting** | [**GoLiveEnablePosting**](GoLiveEnablePosting.md)|  | [optional] 

### Return type

[**GoLiveEnablePostingResponse**](GoLiveEnablePostingResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAccount**
> Account getAccount(id)

Account detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getAccount(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Account**](Account.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getBalanceSheet**
> BalanceSheetReport getBalanceSheet(asOf)

Balance sheet as of a date

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final Date asOf = 2013-10-20; // Date | 

try {
    final response = api.getBalanceSheet(asOf);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getBalanceSheet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **asOf** | **Date**|  | 

### Return type

[**BalanceSheetReport**](BalanceSheetReport.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDayBook**
> DayBookReport getDayBook(date)

Day book for one date

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final Date date = 2013-10-20; // Date | 

try {
    final response = api.getDayBook(date);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getDayBook: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **Date**|  | 

### Return type

[**DayBookReport**](DayBookReport.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDebitNote**
> DebitNote getDebitNote(id)

Get debit note by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getDebitNote(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getDebitNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**DebitNote**](DebitNote.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getExpense**
> ExpenseVoucher getExpense(id)

Get expense voucher by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getExpense(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getExpense: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ExpenseVoucher**](ExpenseVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFundTransfer**
> FundTransfer getFundTransfer(id)

Get fund transfer by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getFundTransfer(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getFundTransfer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**FundTransfer**](FundTransfer.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGoLiveChecklist**
> GoLiveChecklistResponse getGoLiveChecklist(goLiveDate)

Get accounting go-live checklist and prerequisite checks

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final Date goLiveDate = 2013-10-20; // Date | 

try {
    final response = api.getGoLiveChecklist(goLiveDate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getGoLiveChecklist: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **goLiveDate** | **Date**|  | [optional] 

### Return type

[**GoLiveChecklistResponse**](GoLiveChecklistResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGstSummary**
> GstSummaryReport getGstSummary(from, to)

GST summary for a date range

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 

try {
    final response = api.getGstSummary(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getGstSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | 
 **to** | **Date**|  | 

### Return type

[**GstSummaryReport**](GstSummaryReport.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getItem**
> Item getItem(id)

Get item by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getItem(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Item**](Item.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getJournal**
> Journal getJournal(id)

Journal entry detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getJournal(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getJournal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Journal**](Journal.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getOpenItems**
> OpenItemsReport getOpenItems(kind)

Open AR or AP items

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final String kind = kind_example; // String | 

try {
    final response = api.getOpenItems(kind);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getOpenItems: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **kind** | **String**|  | 

### Return type

[**OpenItemsReport**](OpenItemsReport.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPaymentVoucher**
> PaymentVoucher getPaymentVoucher(id)

Get payment voucher by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getPaymentVoucher(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getPaymentVoucher: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PaymentVoucher**](PaymentVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProfitAndLoss**
> ProfitAndLossReport getProfitAndLoss(from, to)

Profit and loss for a date range

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 

try {
    final response = api.getProfitAndLoss(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getProfitAndLoss: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | 
 **to** | **Date**|  | 

### Return type

[**ProfitAndLossReport**](ProfitAndLossReport.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPurchaseBill**
> PurchaseBill getPurchaseBill(id)

Get purchase bill by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getPurchaseBill(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getPurchaseBill: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PurchaseBill**](PurchaseBill.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTaxCode**
> TaxCode getTaxCode(id)

Tax code detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getTaxCode(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getTaxCode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**TaxCode**](TaxCode.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTrialBalance**
> TrialBalanceReport getTrialBalance(to, from)

Trial balance for a date range

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final Date to = 2013-10-20; // Date | 
final Date from = 2013-10-20; // Date | 

try {
    final response = api.getTrialBalance(to, from);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getTrialBalance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **to** | **Date**|  | 
 **from** | **Date**|  | [optional] 

### Return type

[**TrialBalanceReport**](TrialBalanceReport.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUnearnedPreview**
> UnearnedPreviewResponse getUnearnedPreview(goLiveDate)

Preview unearned membership and PT revenue for go-live

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final Date goLiveDate = 2013-10-20; // Date | 

try {
    final response = api.getUnearnedPreview(goLiveDate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getUnearnedPreview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **goLiveDate** | **Date**|  | [optional] 

### Return type

[**UnearnedPreviewResponse**](UnearnedPreviewResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getVendor**
> Vendor getVendor(id)

Get vendor by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.getVendor(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->getVendor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Vendor**](Vendor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccountingPeriods**
> BuiltList<AccountingPeriod> listAccountingPeriods(fiscalYearId, status)

List accounting periods

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int fiscalYearId = 789; // int | 
final String status = status_example; // String | 

try {
    final response = api.listAccountingPeriods(fiscalYearId, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listAccountingPeriods: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **fiscalYearId** | **int**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;AccountingPeriod&gt;**](AccountingPeriod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAccounts**
> AccountPage listAccounts(limit, offset, accountType, isActive, search)

List accounts

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final AccountType accountType = ; // AccountType | 
final bool isActive = true; // bool | 
final String search = search_example; // String | 

try {
    final response = api.listAccounts(limit, offset, accountType, isActive, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listAccounts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **accountType** | [**AccountType**](.md)|  | [optional] 
 **isActive** | **bool**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**AccountPage**](AccountPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDebitNotes**
> DebitNotePage listDebitNotes(limit, offset, status, purchaseBillId, from, to, search)

List debit notes

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final DebitNoteStatus status = ; // DebitNoteStatus | 
final int purchaseBillId = 789; // int | 
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String search = search_example; // String | 

try {
    final response = api.listDebitNotes(limit, offset, status, purchaseBillId, from, to, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listDebitNotes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **status** | [**DebitNoteStatus**](.md)|  | [optional] 
 **purchaseBillId** | **int**|  | [optional] 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**DebitNotePage**](DebitNotePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listExpenses**
> ExpenseVoucherPage listExpenses(limit, offset, status, vendorId, from, to, search)

List expense vouchers

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final ExpenseStatus status = ; // ExpenseStatus | 
final int vendorId = 789; // int | 
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String search = search_example; // String | 

try {
    final response = api.listExpenses(limit, offset, status, vendorId, from, to, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listExpenses: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **status** | [**ExpenseStatus**](.md)|  | [optional] 
 **vendorId** | **int**|  | [optional] 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**ExpenseVoucherPage**](ExpenseVoucherPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFiscalYears**
> BuiltList<FiscalYear> listFiscalYears()

List all fiscal years

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();

try {
    final response = api.listFiscalYears();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listFiscalYears: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;FiscalYear&gt;**](FiscalYear.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFundTransfers**
> FundTransferPage listFundTransfers(limit, offset, status, from, to, accountId, search)

List fund transfers

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String status = status_example; // String | 
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final int accountId = 789; // int | 
final String search = search_example; // String | 

try {
    final response = api.listFundTransfers(limit, offset, status, from, to, accountId, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listFundTransfers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **status** | **String**|  | [optional] 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **accountId** | **int**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**FundTransferPage**](FundTransferPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listItems**
> ItemPage listItems(limit, offset, itemKind, isActive, search)

List items

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final ItemKind itemKind = ; // ItemKind | 
final bool isActive = true; // bool | 
final String search = search_example; // String | 

try {
    final response = api.listItems(limit, offset, itemKind, isActive, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listItems: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **itemKind** | [**ItemKind**](.md)|  | [optional] 
 **isActive** | **bool**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**ItemPage**](ItemPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listJournals**
> JournalPage listJournals(limit, offset, from, to, sourceType, paymentId)

List journal entries

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String sourceType = sourceType_example; // String | 
final int paymentId = 789; // int | 

try {
    final response = api.listJournals(limit, offset, from, to, sourceType, paymentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listJournals: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **sourceType** | **String**|  | [optional] 
 **paymentId** | **int**|  | [optional] 

### Return type

[**JournalPage**](JournalPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPaymentVouchers**
> PaymentVoucherPage listPaymentVouchers(limit, offset, status, from, to, bankAccountId, search)

List payment vouchers

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String status = status_example; // String | 
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final int bankAccountId = 789; // int | 
final String search = search_example; // String | 

try {
    final response = api.listPaymentVouchers(limit, offset, status, from, to, bankAccountId, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listPaymentVouchers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **status** | **String**|  | [optional] 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **bankAccountId** | **int**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**PaymentVoucherPage**](PaymentVoucherPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPurchaseBills**
> PurchaseBillPage listPurchaseBills(limit, offset, status, vendorId, from, to, search)

List purchase bills

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final PurchaseBillStatus status = ; // PurchaseBillStatus | 
final int vendorId = 789; // int | 
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final String search = search_example; // String | 

try {
    final response = api.listPurchaseBills(limit, offset, status, vendorId, from, to, search);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listPurchaseBills: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **status** | [**PurchaseBillStatus**](.md)|  | [optional] 
 **vendorId** | **int**|  | [optional] 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **search** | **String**|  | [optional] 

### Return type

[**PurchaseBillPage**](PurchaseBillPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTaxCodes**
> TaxCodePage listTaxCodes(limit, offset, isActive)

List tax codes

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final bool isActive = true; // bool | 

try {
    final response = api.listTaxCodes(limit, offset, isActive);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listTaxCodes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **isActive** | **bool**|  | [optional] 

### Return type

[**TaxCodePage**](TaxCodePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listVendors**
> VendorPage listVendors(limit, offset, search, isActive)

List vendors

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String search = search_example; // String | 
final bool isActive = true; // bool | 

try {
    final response = api.listVendors(limit, offset, search, isActive);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->listVendors: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **search** | **String**|  | [optional] 
 **isActive** | **bool**|  | [optional] 

### Return type

[**VendorPage**](VendorPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **lockAccountingPeriod**
> AccountingPeriod lockAccountingPeriod(id)

Lock an accounting period

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.lockAccountingPeriod(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->lockAccountingPeriod: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**AccountingPeriod**](AccountingPeriod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **mapPaymentMethodAccount**
> GoLivePaymentMethod mapPaymentMethodAccount(id, goLiveMapPaymentMethod)

Map payment method to accounting account

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final GoLiveMapPaymentMethod goLiveMapPaymentMethod = ; // GoLiveMapPaymentMethod | 

try {
    final response = api.mapPaymentMethodAccount(id, goLiveMapPaymentMethod);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->mapPaymentMethodAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **goLiveMapPaymentMethod** | [**GoLiveMapPaymentMethod**](GoLiveMapPaymentMethod.md)|  | 

### Return type

[**GoLivePaymentMethod**](GoLivePaymentMethod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postDebitNote**
> DebitNote postDebitNote(id)

Post a debit note to the general ledger

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.postDebitNote(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->postDebitNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**DebitNote**](DebitNote.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postExpense**
> ExpenseVoucher postExpense(id)

Post an expense voucher to general ledger

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.postExpense(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->postExpense: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ExpenseVoucher**](ExpenseVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postFundTransfer**
> FundTransfer postFundTransfer(id)

Post fund transfer to GL

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.postFundTransfer(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->postFundTransfer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**FundTransfer**](FundTransfer.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postPaymentVoucher**
> PaymentVoucher postPaymentVoucher(id)

Post a payment voucher to GL

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.postPaymentVoucher(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->postPaymentVoucher: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PaymentVoucher**](PaymentVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **postPurchaseBill**
> PurchaseBill postPurchaseBill(id, idempotencyKey)

Post a draft purchase bill

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.postPurchaseBill(id, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->postPurchaseBill: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**PurchaseBill**](PurchaseBill.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reverseJournal**
> Journal reverseJournal(id, journalReverse, idempotencyKey)

Reverse a posted journal

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final JournalReverse journalReverse = ; // JournalReverse | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.reverseJournal(id, journalReverse, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->reverseJournal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **journalReverse** | [**JournalReverse**](JournalReverse.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**Journal**](Journal.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unlockAccountingPeriod**
> AccountingPeriod unlockAccountingPeriod(id)

Unlock an accounting period

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 

try {
    final response = api.unlockAccountingPeriod(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->unlockAccountingPeriod: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**AccountingPeriod**](AccountingPeriod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAccount**
> Account updateAccount(id, accountUpdate)

Update an account

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final AccountUpdate accountUpdate = ; // AccountUpdate | 

try {
    final response = api.updateAccount(id, accountUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->updateAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **accountUpdate** | [**AccountUpdate**](AccountUpdate.md)|  | 

### Return type

[**Account**](Account.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateExpense**
> ExpenseVoucher updateExpense(id, expenseUpdate)

Update a draft expense voucher

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final ExpenseUpdate expenseUpdate = ; // ExpenseUpdate | 

try {
    final response = api.updateExpense(id, expenseUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->updateExpense: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **expenseUpdate** | [**ExpenseUpdate**](ExpenseUpdate.md)|  | 

### Return type

[**ExpenseVoucher**](ExpenseVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateFundTransfer**
> FundTransfer updateFundTransfer(id, fundTransferUpdate)

Update fund transfer

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final FundTransferUpdate fundTransferUpdate = ; // FundTransferUpdate | 

try {
    final response = api.updateFundTransfer(id, fundTransferUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->updateFundTransfer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **fundTransferUpdate** | [**FundTransferUpdate**](FundTransferUpdate.md)|  | 

### Return type

[**FundTransfer**](FundTransfer.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateItem**
> Item updateItem(id, itemUpdate)

Update item

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final ItemUpdate itemUpdate = ; // ItemUpdate | 

try {
    final response = api.updateItem(id, itemUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->updateItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **itemUpdate** | [**ItemUpdate**](ItemUpdate.md)|  | 

### Return type

[**Item**](Item.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePaymentVoucher**
> PaymentVoucher updatePaymentVoucher(id, paymentVoucherUpdate)

Update a draft payment voucher

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final PaymentVoucherUpdate paymentVoucherUpdate = ; // PaymentVoucherUpdate | 

try {
    final response = api.updatePaymentVoucher(id, paymentVoucherUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->updatePaymentVoucher: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **paymentVoucherUpdate** | [**PaymentVoucherUpdate**](PaymentVoucherUpdate.md)|  | 

### Return type

[**PaymentVoucher**](PaymentVoucher.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateTaxCode**
> TaxCode updateTaxCode(id, taxCodeUpdate)

Update a tax code

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final TaxCodeUpdate taxCodeUpdate = ; // TaxCodeUpdate | 

try {
    final response = api.updateTaxCode(id, taxCodeUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->updateTaxCode: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **taxCodeUpdate** | [**TaxCodeUpdate**](TaxCodeUpdate.md)|  | 

### Return type

[**TaxCode**](TaxCode.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateVendor**
> Vendor updateVendor(id, vendorUpdate)

Update vendor

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getACCTApi();
final int id = 789; // int | 
final VendorUpdate vendorUpdate = ; // VendorUpdate | 

try {
    final response = api.updateVendor(id, vendorUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ACCTApi->updateVendor: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **vendorUpdate** | [**VendorUpdate**](VendorUpdate.md)|  | 

### Return type

[**Vendor**](Vendor.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

