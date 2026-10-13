# api_client.model.Journal

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**journalNumber** | **String** |  | 
**entryDate** | [**Date**](Date.md) |  | 
**accountingPeriodId** | **int** |  | 
**sourceType** | **String** |  | 
**sourceId** | **int** |  | 
**memo** | **String** |  | [optional] 
**postedAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**postedByUserId** | **int** |  | [optional] 
**reversesJournalId** | **int** |  | [optional] 
**rowVersion** | **int** |  | 
**lines** | [**BuiltList&lt;JournalLine&gt;**](JournalLine.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


