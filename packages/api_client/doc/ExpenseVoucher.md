# api_client.model.ExpenseVoucher

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**expenseNumber** | **String** |  | 
**vendorId** | **int** |  | [optional] 
**payeeName** | **String** |  | [optional] 
**expenseDate** | [**Date**](Date.md) |  | 
**paidFromAccountId** | **int** |  | [optional] 
**status** | [**ExpenseStatus**](ExpenseStatus.md) |  | 
**subtotal** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**taxAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**totalAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**journalEntryId** | **int** |  | [optional] 
**rowVersion** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**updatedAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | [optional] 
**lines** | [**BuiltList&lt;ExpenseVoucherLine&gt;**](ExpenseVoucherLine.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


