# api_client.model.MemberDossier

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**userId** | **int** |  | 
**membershipNumber** | **String** |  | 
**firstName** | **String** |  | 
**lastName** | **String** |  | 
**gender** | **String** |  | [optional] 
**dateOfBirth** | [**Date**](Date.md) |  | [optional] 
**address** | **String** |  | [optional] 
**assignedTrainerId** | **int** |  | [optional] 
**joinedDate** | [**Date**](Date.md) |  | [optional] 
**notes** | **String** |  | [optional] 
**user** | [**User**](User.md) |  | [optional] 
**membership** | [**Membership**](Membership.md) | Null until MEMB vertical populates membership contracts. | [optional] 
**outstandingBalance** | **String** | Null until PAY vertical. | [optional] 
**lastCheckIn** | [**DateTime**](DateTime.md) | Null until ATTN vertical. | [optional] 
**nextSchedule** | [**Schedule**](Schedule.md) | Null until SCHED vertical. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


