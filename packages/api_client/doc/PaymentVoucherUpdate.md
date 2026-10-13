# api_client.model.PaymentVoucherUpdate

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**paymentDate** | [**Date**](Date.md) |  | [optional] 
**bankAccountId** | **int** |  | [optional] 
**totalAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | [optional] 
**memo** | **String** |  | [optional] 
**allocations** | [**BuiltList&lt;PaymentAllocationWrite&gt;**](PaymentAllocationWrite.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


