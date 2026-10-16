# api_client.model.InventoryItem

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**name** | **String** |  | 
**sku** | **String** |  | [optional] 
**hsnSac** | **String** |  | [optional] 
**itemKind** | [**ItemKind**](ItemKind.md) |  | 
**categoryId** | **int** |  | [optional] 
**categoryName** | **String** |  | [optional] 
**uomId** | **int** |  | 
**uomCode** | **String** |  | 
**uomDecimalPlaces** | **int** |  | 
**saleRate** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | [optional] 
**purchaseRate** | **String** | DECIMAL(12,2) as a two-decimal string. Never a JSON number. | [optional] 
**reorderLevel** | **String** | DECIMAL(14,3) quantity as a three-decimal string. Never a JSON number. | [optional] 
**taxCodeId** | **int** |  | [optional] 
**incomeAccountId** | **int** |  | 
**expenseAccountId** | **int** |  | 
**inventoryAccountId** | **int** |  | [optional] 
**cogsAccountId** | **int** |  | [optional] 
**inventoryTracked** | **bool** |  | 
**hasMovements** | **bool** |  | 
**isActive** | **bool** |  | 
**rowVersion** | **int** |  | 
**createdAt** | [**DateTime**](DateTime.md) | UTC ISO-8601 | 
**updatedAt** | [**DateTime**](DateTime.md) |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


