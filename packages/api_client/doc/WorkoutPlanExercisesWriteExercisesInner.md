# api_client.model.WorkoutPlanExercisesWriteExercisesInner

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**exerciseId** | **int** |  | 
**dayNumber** | **int** |  | 
**orderIndex** | **int** |  | 
**targetSets** | **int** |  | [optional] 
**targetReps** | **String** |  | [optional] 
**targetWeightKg** | **num** |  | [optional] 
**restSeconds** | **int** |  | [optional] 
**restBetweenExercisesSeconds** | **int** |  | [optional] 
**targetRir** | **num** | Reps in reserve. At most one decimal place. On update, an omitted field is left unchanged. Null or blank stores empty. | [optional] 
**targetDurationSeconds** | **int** | Timed-set duration in seconds. On update, an omitted field is left unchanged. Null or blank stores empty. | [optional] 
**notes** | **String** | On update, an omitted field is left unchanged. Null or blank stores empty. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


