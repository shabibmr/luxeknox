# api_client.model.Schedule

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**seriesId** | **int** |  | [optional] 
**scheduleTypeId** | **int** |  | 
**facilityId** | **int** |  | [optional] 
**trainerId** | **int** |  | [optional] 
**title** | **String** |  | 
**startTime** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**endTime** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**maxCapacity** | **int** |  | [optional] 
**status** | [**ScheduleStatus**](ScheduleStatus.md) |  | 
**notes** | **String** |  | [optional] 
**rowVersion** | **int** |  | 
**participants** | [**BuiltList&lt;ScheduleParticipant&gt;**](ScheduleParticipant.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


