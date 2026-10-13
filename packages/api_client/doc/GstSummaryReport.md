# api_client.model.GstSummaryReport

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**from** | [**Date**](Date.md) |  | 
**to** | [**Date**](Date.md) |  | 
**taxCodes** | [**BuiltList&lt;GstTaxCodeSummary&gt;**](GstTaxCodeSummary.md) |  | 
**totalTaxableValue** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**outputCgst** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**outputSgst** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**outputIgst** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**totalOutputTax** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**inputTaxCredit** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**netPayable** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


