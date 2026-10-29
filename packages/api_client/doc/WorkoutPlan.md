# api_client.model.WorkoutPlan

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**title** | **String** |  | 
**description** | **String** |  | [optional] 
**memberId** | **int** |  | [optional] 
**trainerId** | **int** |  | [optional] 
**targetGoal** | **String** |  | [optional] 
**difficulty** | **String** |  | [optional] 
**durationWeeks** | **int** |  | [optional] 
**isTemplate** | **bool** |  | 
**status** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | [optional] 
**rowVersion** | **int** |  | 
**primaryObjective12w** | **String** |  | [optional] 
**milestone4w** | **String** |  | [optional] 
**sessionsPerWeek** | **int** |  | [optional] 
**targetSessionDurationMinutes** | **int** |  | [optional] 
**splitType** | **String** |  | [optional] 
**cardioProtocol** | **String** |  | [optional] 
**mobilityProtocol** | **String** |  | [optional] 
**progressionMethods** | **BuiltList&lt;String&gt;** | Unique values only. | [optional] 
**mainSuccessMeasure** | **String** |  | [optional] 
**trainerProgrammingNotes** | **String** |  | [optional] 
**currentVersion** | [**WorkoutPlanVersion**](WorkoutPlanVersion.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


