# api_client.model.PaymentVoucherCreate

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**paymentDate** | [**Date**](Date.md) |  | 
**bankAccountId** | **int** |  | 
**totalAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**memo** | **String** |  | [optional] 
**allocations** | [**BuiltList&lt;PaymentAllocationWrite&gt;**](PaymentAllocationWrite.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


