# api_client.api.PTApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**changePtSlot**](PTApi.md#changeptslot) | **POST** /pt-subscriptions/{id}/change-slot | Move remaining PT sessions to other weekdays/hour
[**clientSignPtProgressReview**](PTApi.md#clientsignptprogressreview) | **POST** /reviews/{id}/client-sign | Client signs a review
[**createPtProduct**](PTApi.md#createptproduct) | **POST** /pt-products | Create a PT package
[**createPtProgressReviewDraft**](PTApi.md#createptprogressreviewdraft) | **POST** /members/{id}/pt-reviews | Draft a PT progress review
[**exportPtProgressReviewPdf**](PTApi.md#exportptprogressreviewpdf) | **GET** /reviews/{id}/export-pdf | Export the review presentation card as PDF
[**getMemberPtSummary**](PTApi.md#getmemberptsummary) | **GET** /members/{id}/pt-subscriptions | Member&#39;s current PT, PT history, and the calling trainer&#39;s access level
[**getPtPaymentPreview**](PTApi.md#getptpaymentpreview) | **GET** /pt/payment-preview | Subtotal, discount, tax and total a PT sale would charge
[**getPtProduct**](PTApi.md#getptproduct) | **GET** /pt-products/{id} | PT package detail
[**getPtProgressReview**](PTApi.md#getptprogressreview) | **GET** /reviews/{id} | Get a PT progress review
[**getPtScheduleGrid**](PTApi.md#getptschedulegrid) | **GET** /pt/schedule-grid | Hours × active trainers occupancy for a PT package, start date and weekdays
[**getPtSubscription**](PTApi.md#getptsubscription) | **GET** /pt-subscriptions/{id} | PT subscription detail
[**listPtProducts**](PTApi.md#listptproducts) | **GET** /pt-products | Personal Training package catalog
[**managerApprovePtProgressReview**](PTApi.md#managerapproveptprogressreview) | **POST** /reviews/{id}/manager-approve | Manager approves a review
[**purchasePtSubscription**](PTApi.md#purchaseptsubscription) | **POST** /pt-subscriptions | Sell PT — assign trainer + fixed weekly slot, take payment, generate sessions
[**reassignPtTrainer**](PTApi.md#reassignpttrainer) | **POST** /pt-subscriptions/{id}/reassign-trainer | Move remaining PT sessions to another active trainer
[**renewPtSubscription**](PTApi.md#renewptsubscription) | **POST** /pt-subscriptions/{id}/renew | Renew PT with the same trainer and slot
[**trainerSignPtProgressReview**](PTApi.md#trainersignptprogressreview) | **POST** /reviews/{id}/trainer-sign | Trainer signs a draft review
[**updatePtProduct**](PTApi.md#updateptproduct) | **PATCH** /pt-products/{id} | Update or archive a PT package
[**updatePtProgressReviewDraft**](PTApi.md#updateptprogressreviewdraft) | **PATCH** /reviews/{id} | Save the presentation card of a draft review


# **changePtSlot**
> PtSubscription changePtSlot(id, ptChangeSlotRequest)

Move remaining PT sessions to other weekdays/hour

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 
final PtChangeSlotRequest ptChangeSlotRequest = ; // PtChangeSlotRequest | 

try {
    final response = api.changePtSlot(id, ptChangeSlotRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->changePtSlot: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **ptChangeSlotRequest** | [**PtChangeSlotRequest**](PtChangeSlotRequest.md)|  | 

### Return type

[**PtSubscription**](PtSubscription.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **clientSignPtProgressReview**
> PtProgressReview clientSignPtProgressReview(id)

Client signs a review

`pending_client_sign` → `pending_manager_approval`. 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 

try {
    final response = api.clientSignPtProgressReview(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->clientSignPtProgressReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PtProgressReview**](PtProgressReview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPtProduct**
> PtProduct createPtProduct(ptProductWrite)

Create a PT package

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final PtProductWrite ptProductWrite = ; // PtProductWrite | 

try {
    final response = api.createPtProduct(ptProductWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->createPtProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ptProductWrite** | [**PtProductWrite**](PtProductWrite.md)|  | 

### Return type

[**PtProduct**](PtProduct.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPtProgressReviewDraft**
> PtProgressReview createPtProgressReviewDraft(id, ptProgressReviewDraft)

Draft a PT progress review

Snapshots the member's measurements into `body_metrics_snapshot` as the five presentation-card rows (weight, waist, strength, cardio, other), in that order. Start is the latest value on or before the period start and current is the latest on or before the period end (calendar dates, end day included). Change is current − start, rounded half away from zero to two decimals, and is null unless both exist. Targets come from in-progress or achieved goals, not from goal baseline or current values. A row with no matching metric is still present with null values. New drafts leave `performance_markers_snapshot` null. `highlights_other_text` is accepted only when `progress_highlights` includes `other`. 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 
final PtProgressReviewDraft ptProgressReviewDraft = ; // PtProgressReviewDraft | 

try {
    final response = api.createPtProgressReviewDraft(id, ptProgressReviewDraft);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->createPtProgressReviewDraft: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **ptProgressReviewDraft** | [**PtProgressReviewDraft**](PtProgressReviewDraft.md)|  | 

### Return type

[**PtProgressReview**](PtProgressReview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exportPtProgressReviewPdf**
> Uint8List exportPtProgressReviewPdf(id)

Export the review presentation card as PDF

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 

try {
    final response = api.exportPtProgressReviewPdf(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->exportPtProgressReviewPdf: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/pdf, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMemberPtSummary**
> MemberPtSummary getMemberPtSummary(id)

Member's current PT, PT history, and the calling trainer's access level

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 

try {
    final response = api.getMemberPtSummary(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->getMemberPtSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MemberPtSummary**](MemberPtSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPtPaymentPreview**
> PtPaymentPreview getPtPaymentPreview(ptProductId, discountAmount)

Subtotal, discount, tax and total a PT sale would charge

Same server-side computation as the payment taken by `purchasePtSubscription` (taxable = subtotal − discount, plus the configured tax rate). 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int ptProductId = 789; // int | 
final String discountAmount = discountAmount_example; // String | 

try {
    final response = api.getPtPaymentPreview(ptProductId, discountAmount);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->getPtPaymentPreview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ptProductId** | **int**|  | 
 **discountAmount** | **String**|  | [optional] 

### Return type

[**PtPaymentPreview**](PtPaymentPreview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPtProduct**
> PtProduct getPtProduct(id)

PT package detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 

try {
    final response = api.getPtProduct(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->getPtProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PtProduct**](PtProduct.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPtProgressReview**
> PtProgressReview getPtProgressReview(id)

Get a PT progress review

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 

try {
    final response = api.getPtProgressReview(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->getPtProgressReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PtProgressReview**](PtProgressReview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPtScheduleGrid**
> PtScheduleGrid getPtScheduleGrid(memberId, ptProductId, startDate, weekdays, partnerMemberId, excludeSubscriptionId)

Hours × active trainers occupancy for a PT package, start date and weekdays

A cell is `free` only when the hour is inside the trainer's availability and clash-free on every occurrence date of the PT period. All active trainers are listed. 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int memberId = 789; // int | 
final int ptProductId = 789; // int | 
final Date startDate = 2013-10-20; // Date | 
final String weekdays = weekdays_example; // String | Comma-separated 0=Sunday … 6=Saturday, e.g. \"1,3,5\"
final int partnerMemberId = 789; // int | Second member when selling a couple PT. Cells busy for either member show as occupied. On re-plan (`exclude_subscription_id`), the partner is resolved from the subscription when omitted. 
final int excludeSubscriptionId = 789; // int | 

try {
    final response = api.getPtScheduleGrid(memberId, ptProductId, startDate, weekdays, partnerMemberId, excludeSubscriptionId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->getPtScheduleGrid: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberId** | **int**|  | 
 **ptProductId** | **int**|  | 
 **startDate** | **Date**|  | 
 **weekdays** | **String**| Comma-separated 0=Sunday … 6=Saturday, e.g. \"1,3,5\" | 
 **partnerMemberId** | **int**| Second member when selling a couple PT. Cells busy for either member show as occupied. On re-plan (`exclude_subscription_id`), the partner is resolved from the subscription when omitted.  | [optional] 
 **excludeSubscriptionId** | **int**|  | [optional] 

### Return type

[**PtScheduleGrid**](PtScheduleGrid.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPtSubscription**
> PtSubscription getPtSubscription(id)

PT subscription detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 

try {
    final response = api.getPtSubscription(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->getPtSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PtSubscription**](PtSubscription.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPtProducts**
> PtProductPage listPtProducts(limit, offset, q, packageType)

Personal Training package catalog

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String q = q_example; // String | Case-insensitive search (FR-API-014).
final PtPackageType packageType = ; // PtPackageType | Filter by single or couple packages.

try {
    final response = api.listPtProducts(limit, offset, q, packageType);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->listPtProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **q** | **String**| Case-insensitive search (FR-API-014). | [optional] 
 **packageType** | [**PtPackageType**](.md)| Filter by single or couple packages. | [optional] 

### Return type

[**PtProductPage**](PtProductPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **managerApprovePtProgressReview**
> PtProgressReview managerApprovePtProgressReview(id)

Manager approves a review

`pending_manager_approval` → `approved`. 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 

try {
    final response = api.managerApprovePtProgressReview(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->managerApprovePtProgressReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PtProgressReview**](PtProgressReview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **purchasePtSubscription**
> PtPurchaseResult purchasePtSubscription(ptPurchaseRequest, idempotencyKey)

Sell PT — assign trainer + fixed weekly slot, take payment, generate sessions

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final PtPurchaseRequest ptPurchaseRequest = ; // PtPurchaseRequest | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.purchasePtSubscription(ptPurchaseRequest, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->purchasePtSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ptPurchaseRequest** | [**PtPurchaseRequest**](PtPurchaseRequest.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**PtPurchaseResult**](PtPurchaseResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **reassignPtTrainer**
> PtSubscription reassignPtTrainer(id, ptReassignTrainerRequest)

Move remaining PT sessions to another active trainer

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 
final PtReassignTrainerRequest ptReassignTrainerRequest = ; // PtReassignTrainerRequest | 

try {
    final response = api.reassignPtTrainer(id, ptReassignTrainerRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->reassignPtTrainer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **ptReassignTrainerRequest** | [**PtReassignTrainerRequest**](PtReassignTrainerRequest.md)|  | 

### Return type

[**PtSubscription**](PtSubscription.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **renewPtSubscription**
> PtPurchaseResult renewPtSubscription(id, ptRenewRequest)

Renew PT with the same trainer and slot

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 
final PtRenewRequest ptRenewRequest = ; // PtRenewRequest | 

try {
    final response = api.renewPtSubscription(id, ptRenewRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->renewPtSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **ptRenewRequest** | [**PtRenewRequest**](PtRenewRequest.md)|  | 

### Return type

[**PtPurchaseResult**](PtPurchaseResult.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **trainerSignPtProgressReview**
> PtProgressReview trainerSignPtProgressReview(id)

Trainer signs a draft review

`draft` → `pending_client_sign`. 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 

try {
    final response = api.trainerSignPtProgressReview(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->trainerSignPtProgressReview: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PtProgressReview**](PtProgressReview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePtProduct**
> PtProduct updatePtProduct(id, ptProductWrite)

Update or archive a PT package

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 
final PtProductWrite ptProductWrite = ; // PtProductWrite | 

try {
    final response = api.updatePtProduct(id, ptProductWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->updatePtProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **ptProductWrite** | [**PtProductWrite**](PtProductWrite.md)|  | 

### Return type

[**PtProduct**](PtProduct.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updatePtProgressReviewDraft**
> PtProgressReview updatePtProgressReviewDraft(id, ptProgressReviewDraftEdit)

Save the presentation card of a draft review

Partial update of a review that is still a `draft`: the highlight checkboxes, the other-text line, the summary, the member's feedback, the next phase, and the six discussed checks. Omitted fields are left alone, an explicit null clears one, and `progress_highlights` replaces the whole set. Only the review's trainer may edit. `highlights_other_text` is accepted only when `other` is selected, and deselecting `other` clears the stored text. `next_review_date` must be after `review_period_end`. The period and the measure rows cannot be changed here. Once the review is no longer a draft the edit is refused with 409. 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPTApi();
final int id = 789; // int | 
final PtProgressReviewDraftEdit ptProgressReviewDraftEdit = ; // PtProgressReviewDraftEdit | 

try {
    final response = api.updatePtProgressReviewDraft(id, ptProgressReviewDraftEdit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PTApi->updatePtProgressReviewDraft: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **ptProgressReviewDraftEdit** | [**PtProgressReviewDraftEdit**](PtProgressReviewDraftEdit.md)|  | 

### Return type

[**PtProgressReview**](PtProgressReview.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

