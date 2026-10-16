# api_client.api.INVApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getInventoryItem**](INVApi.md#getinventoryitem) | **GET** /inventory/items/{id} | Get inventory item by ID
[**listInventoryItems**](INVApi.md#listinventoryitems) | **GET** /inventory/items | List inventory items


# **getInventoryItem**
> InventoryItem getInventoryItem(id)

Get inventory item by ID

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getINVApi();
final int id = 789; // int | 

try {
    final response = api.getInventoryItem(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling INVApi->getInventoryItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**InventoryItem**](InventoryItem.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listInventoryItems**
> InventoryItemPage listInventoryItems(limit, offset, cursor, search, itemKind, categoryId, isActive, inventoryTracked)

List inventory items

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getINVApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.
final String search = search_example; // String | Name or SKU
final ItemKind itemKind = ; // ItemKind | 
final int categoryId = 789; // int | 
final bool isActive = true; // bool | 
final bool inventoryTracked = true; // bool | 

try {
    final response = api.listInventoryItems(limit, offset, cursor, search, itemKind, categoryId, isActive, inventoryTracked);
    print(response);
} on DioException catch (e) {
    print('Exception when calling INVApi->listInventoryItems: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 
 **search** | **String**| Name or SKU | [optional] 
 **itemKind** | [**ItemKind**](.md)|  | [optional] 
 **categoryId** | **int**|  | [optional] 
 **isActive** | **bool**|  | [optional] 
 **inventoryTracked** | **bool**|  | [optional] 

### Return type

[**InventoryItemPage**](InventoryItemPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

