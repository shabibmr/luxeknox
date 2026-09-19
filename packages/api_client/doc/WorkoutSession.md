# api_client.model.WorkoutSession

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**memberId** | **int** |  | 
**workoutPlanId** | **int** |  | [optional] 
**workoutPlanVersionId** | **int** |  | [optional] 
**trainerId** | **int** |  | [optional] 
**startedAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**completedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**totalVolumeKg** | **num** |  | [optional] 
**durationMinutes** | **int** |  | [optional] 
**clientFeedbackRating** | **int** |  | [optional] 
**notes** | **String** |  | [optional] 
**sets** | [**BuiltList&lt;WorkoutSessionExercise&gt;**](WorkoutSessionExercise.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


