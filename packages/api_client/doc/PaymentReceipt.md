# api_client.model.PaymentReceipt

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**paymentId** | **int** |  | 
**receiptNumber** | **String** |  | 
**receiptPdfUrl** | **String** | Null in MVP; receipt is re-rendered from ledger rows (ADR-0005). | [optional] 
**generatedAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | [optional] 
**payment** | [**Payment**](Payment.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


