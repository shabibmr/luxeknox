# api_client.model.Membership

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**memberId** | **int** |  | 
**productId** | **int** |  | 
**startDate** | [**Date**](Date.md) |  | 
**endDate** | [**Date**](Date.md) |  | 
**remainingPtSessions** | **int** |  | [optional] 
**status** | [**MembershipStatus**](MembershipStatus.md) |  | 
**lockerNumber** | **String** |  | [optional] 
**autoRenew** | **bool** |  | [optional] 
**rowVersion** | **int** |  | 
**partnerMembershipId** | **int** | Set on both rows of a couple membership. | [optional] 
**partnerMemberId** | **int** |  | [optional] 
**partnerMemberName** | **String** |  | [optional] 
**product** | [**MembershipProduct**](MembershipProduct.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


