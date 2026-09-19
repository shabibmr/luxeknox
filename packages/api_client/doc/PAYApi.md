# api_client.api.PAYApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**adjustPayment**](PAYApi.md#adjustpayment) | **POST** /payments/{id}/adjust | Adjust an invoice
[**createPayment**](PAYApi.md#createpayment) | **POST** /payments | Record POS / issue invoice
[**createPaymentMethod**](PAYApi.md#createpaymentmethod) | **POST** /payment-methods | Create a payment method
[**getPayment**](PAYApi.md#getpayment) | **GET** /payments/{id} | Invoice detail with history
[**getPaymentReceipt**](PAYApi.md#getpaymentreceipt) | **GET** /payments/{id}/receipt | Receipt (re-rendered in MVP; no stored PDF)
[**listOutstandingPayments**](PAYApi.md#listoutstandingpayments) | **GET** /payments/outstanding | Pending and partial invoices
[**listPaymentMethods**](PAYApi.md#listpaymentmethods) | **GET** /payment-methods | Payment methods
[**listPayments**](PAYApi.md#listpayments) | **GET** /payments | Invoice ledger
[**refundPayment**](PAYApi.md#refundpayment) | **POST** /payments/{id}/refund | Refund against an invoice


# **adjustPayment**
> Payment adjustPayment(id, paymentAdjustRequest)

Adjust an invoice

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();
final int id = 789; // int | 
final PaymentAdjustRequest paymentAdjustRequest = ; // PaymentAdjustRequest | 

try {
    final response = api.adjustPayment(id, paymentAdjustRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->adjustPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **paymentAdjustRequest** | [**PaymentAdjustRequest**](PaymentAdjustRequest.md)|  | 

### Return type

[**Payment**](Payment.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPayment**
> Payment createPayment(paymentCreate, idempotencyKey)

Record POS / issue invoice

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();
final PaymentCreate paymentCreate = ; // PaymentCreate | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.createPayment(paymentCreate, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->createPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentCreate** | [**PaymentCreate**](PaymentCreate.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**Payment**](Payment.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createPaymentMethod**
> PaymentMethod createPaymentMethod(paymentMethodWrite)

Create a payment method

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();
final PaymentMethodWrite paymentMethodWrite = ; // PaymentMethodWrite | 

try {
    final response = api.createPaymentMethod(paymentMethodWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->createPaymentMethod: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **paymentMethodWrite** | [**PaymentMethodWrite**](PaymentMethodWrite.md)|  | 

### Return type

[**PaymentMethod**](PaymentMethod.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPayment**
> Payment getPayment(id)

Invoice detail with history

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();
final int id = 789; // int | 

try {
    final response = api.getPayment(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->getPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Payment**](Payment.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPaymentReceipt**
> PaymentReceipt getPaymentReceipt(id)

Receipt (re-rendered in MVP; no stored PDF)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();
final int id = 789; // int | 

try {
    final response = api.getPaymentReceipt(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->getPaymentReceipt: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**PaymentReceipt**](PaymentReceipt.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listOutstandingPayments**
> PaymentPage listOutstandingPayments(limit, offset)

Pending and partial invoices

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.

try {
    final response = api.listOutstandingPayments(limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->listOutstandingPayments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 

### Return type

[**PaymentPage**](PaymentPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPaymentMethods**
> PaymentMethodPage listPaymentMethods()

Payment methods

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();

try {
    final response = api.listPaymentMethods();
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->listPaymentMethods: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PaymentMethodPage**](PaymentMethodPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPayments**
> PaymentPage listPayments(limit, offset, memberId, status)

Invoice ledger

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final int memberId = 789; // int | 
final String status = status_example; // String | 

try {
    final response = api.listPayments(limit, offset, memberId, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->listPayments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **memberId** | **int**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**PaymentPage**](PaymentPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refundPayment**
> Payment refundPayment(id, paymentAdjustRequest, idempotencyKey)

Refund against an invoice

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPAYApi();
final int id = 789; // int | 
final PaymentAdjustRequest paymentAdjustRequest = ; // PaymentAdjustRequest | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.refundPayment(id, paymentAdjustRequest, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PAYApi->refundPayment: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **paymentAdjustRequest** | [**PaymentAdjustRequest**](PaymentAdjustRequest.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**Payment**](Payment.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

