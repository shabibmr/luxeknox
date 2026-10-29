# api_client.model.PtProgressReview

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**memberId** | **int** |  | 
**trainerId** | **int** |  | 
**reviewPeriodStart** | [**Date**](Date.md) |  | 
**reviewPeriodEnd** | [**Date**](Date.md) |  | 
**bodyMetricsSnapshot** | [**BuiltList&lt;BodyMetricSnapshot&gt;**](BodyMetricSnapshot.md) |  | [optional] 
**performanceMarkersSnapshot** | [**BuiltList&lt;PerformanceMarkerSnapshot&gt;**](PerformanceMarkerSnapshot.md) |  | [optional] 
**progressHighlights** | **BuiltList&lt;String&gt;** |  | [optional] 
**highlightsOtherText** | **String** |  | [optional] 
**trainerSummary** | **String** |  | [optional] 
**clientFeedback** | **String** |  | [optional] 
**nextPhaseGoal** | **String** |  | [optional] 
**nextPhaseTrainingFocus** | **String** |  | [optional] 
**nextReviewDate** | [**Date**](Date.md) |  | [optional] 
**reviewChecklist** | [**PtReviewChecklist**](PtReviewChecklist.md) |  | [optional] 
**finalReviewNotes** | **String** |  | [optional] 
**clientSignedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**trainerSignedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**managerUserId** | **int** |  | [optional] 
**managerSignedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**status** | **String** |  | 
**createdAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**updatedAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


