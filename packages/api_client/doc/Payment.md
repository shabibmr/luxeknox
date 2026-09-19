# api_client.model.Payment

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**invoiceNumber** | **String** |  | 
**memberId** | **int** |  | 
**membershipId** | **int** |  | [optional] 
**paymentMethodId** | **int** |  | [optional] 
**subtotal** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**taxAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**discountAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**totalAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**amountPaid** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**status** | [**PaymentStatus**](PaymentStatus.md) |  | 
**transactionReference** | **String** |  | [optional] 
**cashierUserId** | **int** |  | [optional] 
**paymentDate** | [**DateTime**](DateTime.md) | UTC ISO-8601 | [optional] 
**rowVersion** | **int** |  | 
**histories** | [**BuiltList&lt;PaymentHistory&gt;**](PaymentHistory.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


