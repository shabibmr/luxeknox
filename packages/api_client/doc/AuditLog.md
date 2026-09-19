# api_client.model.AuditLog

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**actorUserId** | **int** |  | 
**action** | **String** |  | 
**entityName** | **String** |  | 
**entityId** | **int** |  | [optional] 
**beforeState** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional] 
**afterState** | [**BuiltMap&lt;String, JsonObject&gt;**](JsonObject.md) |  | [optional] 
**ipAddress** | **String** |  | [optional] 
**timestamp** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


