# api_client.model.PtRenewRequest

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**discountAmount** | **String** | Unsigned money with at most two decimals. Used for sale discount inputs. | [optional] 
**paymentDate** | [**Date**](Date.md) | Gym-local day the money was received; not in the future. Defaults to now. | [optional] 
**paymentMethodId** | **int** |  | [optional] 
**tenders** | [**BuiltList&lt;TenderLine&gt;**](TenderLine.md) |  | [optional] 
**transactionReference** | **String** |  | [optional] 
**ptProductId** | **int** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


