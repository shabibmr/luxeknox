# api_client.model.MembershipCreate

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**memberId** | **int** |  | 
**productId** | **int** |  | 
**startDate** | [**Date**](Date.md) |  | 
**paymentMethodId** | **int** |  | 
**lockerNumber** | **String** |  | [optional] 
**autoRenew** | **bool** |  | [optional] 
**partnerMemberId** | **int** | Required for a couple product; rejected for a single product. | [optional] 
**replacePartnerMembership** | **bool** | Must be true when the partner has an active or frozen single membership; it is cancelled. | [optional] 
**discountAmount** | **String** | Optional unsigned discount. Payment totals still reject amounts over the subtotal. | [optional] 
**paymentDate** | [**Date**](Date.md) | Gym-local day the money was received; not in the future. Defaults to now. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


