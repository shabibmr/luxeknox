# api_client.model.PtSubscription

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**memberId** | **int** |  | 
**ptProductId** | **int** |  | 
**trainerId** | **int** |  | 
**membershipId** | **int** |  | [optional] 
**renewedFromId** | **int** |  | [optional] 
**startDate** | [**Date**](Date.md) |  | 
**endDate** | [**Date**](Date.md) |  | 
**weekdays** | **BuiltList&lt;int&gt;** | 0=Sunday … 6=Saturday | 
**slotStart** | **String** | Gym wall-clock \"HH:00:00\"; the slot is one hour. | 
**status** | [**PtSubscriptionStatus**](PtSubscriptionStatus.md) |  | 
**rowVersion** | **int** |  | 
**productName** | **String** |  | 
**sessionsPerWeek** | **int** |  | 
**trainerName** | **String** |  | 
**slotLabel** | **String** | e.g. \"17:00-18:00\" | 
**packageType** | [**PtPackageType**](PtPackageType.md) |  | 
**isPrimary** | **bool** | True for a single subscription and for the primary row of a couple pair. | 
**partnerSubscriptionId** | **int** | Set on both rows of a couple PT (see ADR-0011). | [optional] 
**partnerMemberId** | **int** |  | [optional] 
**partnerMemberName** | **String** | Partner display name; member-scoped reads expose only this partner field. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


