# api_client.model.ProfitAndLossReport

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**from** | [**Date**](Date.md) |  | 
**to** | [**Date**](Date.md) |  | 
**incomeAccounts** | [**BuiltList&lt;ProfitAndLossAccount&gt;**](ProfitAndLossAccount.md) |  | 
**totalIncome** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**expenseAccounts** | [**BuiltList&lt;ProfitAndLossAccount&gt;**](ProfitAndLossAccount.md) |  | 
**totalExpense** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**netProfit** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


