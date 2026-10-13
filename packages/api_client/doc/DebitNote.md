# api_client.model.DebitNote

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**debitNoteNumber** | **String** |  | 
**purchaseBillId** | **int** |  | 
**debitNoteDate** | [**Date**](Date.md) |  | 
**reason** | **String** |  | [optional] 
**subtotal** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**taxAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**totalAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**status** | [**DebitNoteStatus**](DebitNoteStatus.md) |  | 
**journalEntryId** | **int** |  | [optional] 
**rowVersion** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**updatedAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


