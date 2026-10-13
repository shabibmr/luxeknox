# api_client.model.BalanceSheetReport

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**asOf** | [**Date**](Date.md) |  | 
**fiscalYearStart** | [**Date**](Date.md) |  | 
**assetAccounts** | [**BuiltList&lt;BalanceSheetAccount&gt;**](BalanceSheetAccount.md) |  | 
**totalAssets** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**liabilityAccounts** | [**BuiltList&lt;BalanceSheetAccount&gt;**](BalanceSheetAccount.md) |  | 
**totalLiabilities** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**equityAccounts** | [**BuiltList&lt;BalanceSheetAccount&gt;**](BalanceSheetAccount.md) |  | 
**currentYearEarnings** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**totalEquity** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**totalLiabilitiesAndEquity** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


