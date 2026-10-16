# api_client.model.PurchaseBillCreate

## Load the model package
```dart
import 'package:api_client/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**vendorId** | **int** |  | 
**billDate** | [**Date**](Date.md) |  | 
**supplierInvoiceNo** | **String** |  | [optional] 
**dueDate** | [**Date**](Date.md) |  | [optional] 
**draft** | **bool** | When true the bill is saved as a draft and posted later via POST /accounting/purchase-bills/{id}/post. | [optional] 
**lines** | [**BuiltList&lt;PurchaseBillLineWrite&gt;**](PurchaseBillLineWrite.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


