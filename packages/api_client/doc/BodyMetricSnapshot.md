# api_client.model.BodyMetricSnapshot

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**row** | **String** | Absent on reviews drafted before the five-row card. | [optional] 
**metric** | **String** | Null when no metric matched the row. | 
**startVal** | **num** |  | [optional] 
**currentVal** | **num** |  | [optional] 
**changeVal** | **num** | Always `current_val − start_val`. | [optional] 
**targetVal** | **num** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


