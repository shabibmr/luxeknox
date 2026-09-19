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
**membership** | [**Membership**](Membership.md) |  | [optional] 
**outstandingBalance** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | [optional] 
**lastCheckIn** | [**DateTime**](DateTime.md) | UTC ISO-8601 | [optional] 
**nextSchedule** | [**Schedule**](Schedule.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


