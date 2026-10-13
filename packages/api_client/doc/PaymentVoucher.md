# api_client.model.PaymentVoucher

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**voucherNumber** | **String** |  | 
**paymentDate** | [**Date**](Date.md) |  | 
**bankAccountId** | **int** |  | 
**totalAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**memo** | **String** |  | [optional] 
**status** | **String** |  | 
**journalEntryId** | **int** |  | [optional] 
**rowVersion** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**updatedAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | [optional] 
**allocations** | [**BuiltList&lt;PaymentAllocation&gt;**](PaymentAllocation.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


