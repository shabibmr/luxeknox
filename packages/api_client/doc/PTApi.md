# api_client.api.PTApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**changePtSlot**](PTApi.md#changeptslot) | **POST** /pt-subscriptions/{id}/change-slot | Move remaining PT sessions to other weekdays/hour
[**createPtProduct**](PTApi.md#createptproduct) | **POST** /pt-products | Create a PT package
[**getMemberPtSummary**](PTApi.md#getmemberptsummary) | **GET** /members/{id}/pt-subscriptions | Member&#39;s current PT, PT history, and the calling trainer&#39;s access level
[**getPtPaymentPreview**](PTApi.md#getptpaymentpreview) | **GET** /pt/payment-preview | Subtotal, discount, tax and total a PT sale would charge
[**getPtProduct**](PTApi.md#getptproduct) | **GET** /pt-products/{id} | PT package detail
[**getPtScheduleGrid**](PTApi.md#getptschedulegrid) | **GET** /pt/schedule-grid | Hours × active trainers occupancy for a PT package, start date and weekdays
[**getPtSubscription**](PTApi.md#getptsubscription) | **GET** /pt-subscriptions/{id} | PT subscription detail
[**listPtProducts**](PTApi.md#listptproducts) | **GET** /pt-products | Personal Training package catalog
[**purchasePtSubscription**](PTApi.md#purchaseptsubscription) | **POST** /pt-subscriptions | Sell PT — assign trainer + fixed weekly slot, take payment, generate sessions
[**reassignPtTrainer**](PTApi.md#reassignpttrainer) | **POST** /pt-subscriptions/{id}/reassign-trainer | Move remaining PT sessions to another active trainer
[**renewPtSubscription**](PTApi.md#renewptsubscription) | **POST** /pt-subscriptions/{id}/renew | Renew PT with the same trainer and slot
[**updatePtProduct**](PTApi.md#updateptproduct) | **PATCH** /pt-products/{id} | Update or archive a PT package


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

