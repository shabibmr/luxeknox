# api_client.model.FundTransfer

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**transferNumber** | **String** |  | 
**transferDate** | [**Date**](Date.md) |  | 
**fromAccountId** | **int** |  | 
**toAccountId** | **int** |  | 
**amount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**feeAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**feeAccountId** | **int** |  | [optional] 
**memo** | **String** |  | [optional] 
**status** | **String** |  | 
**journalEntryId** | **int** |  | [optional] 
**rowVersion** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**updatedAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


