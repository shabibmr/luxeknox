# api_client.model.PaymentCreate

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**memberId** | **int** |  | 
**membershipId** | **int** |  | [optional] 
**productId** | **int** | If set, assign/renew membership in the same transaction when paid. | [optional] 
**subtotal** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**discountAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | [optional] 
**paymentMethodId** | **int** |  | [optional] 
**tenders** | [**BuiltList&lt;TenderLine&gt;**](TenderLine.md) | Split tender. Sum becomes amount_paid. payment_method_id on header is null when present. | [optional] 
**transactionReference** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


