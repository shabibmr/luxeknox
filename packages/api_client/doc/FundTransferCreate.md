# api_client.model.FundTransferCreate

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**transferDate** | [**Date**](Date.md) |  | 
**fromAccountId** | **int** |  | 
**toAccountId** | **int** |  | 
**amount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | 
**feeAmount** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | [optional] 
**feeAccountId** | **int** |  | [optional] 
**memo** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


