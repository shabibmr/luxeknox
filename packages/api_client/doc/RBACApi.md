# api_client.api.RBACApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignEmployeeRole**](RBACApi.md#assignemployeerole) | **PUT** /employees/{id}/role | Assign exactly one role
[**createRole**](RBACApi.md#createrole) | **POST** /roles | Create a custom role
[**getRole**](RBACApi.md#getrole) | **GET** /roles/{id} | Get a role and its permissions
[**listPermissions**](RBACApi.md#listpermissions) | **GET** /permissions | List permission catalog
[**listRoles**](RBACApi.md#listroles) | **GET** /roles | List roles
[**replaceRolePermissions**](RBACApi.md#replacerolepermissions) | **PUT** /roles/{id}/permissions | Replace permission set on a non-system role
[**updateRole**](RBACApi.md#updaterole) | **PATCH** /roles/{id} | Update a non-system role


# **assignEmployeeRole**
> Employee assignEmployeeRole(id, assignRoleRequest)

Assign exactly one role

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getRBACApi();
final int id = 789; // int | 
final AssignRoleRequest assignRoleRequest = ; // AssignRoleRequest | 

try {
    final response = api.assignEmployeeRole(id, assignRoleRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RBACApi->assignEmployeeRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **assignRoleRequest** | [**AssignRoleRequest**](AssignRoleRequest.md)|  | 

### Return type

[**Employee**](Employee.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createRole**
> Role createRole(roleWrite)

Create a custom role

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getRBACApi();
final RoleWrite roleWrite = ; // RoleWrite | 

try {
    final response = api.createRole(roleWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RBACApi->createRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **roleWrite** | [**RoleWrite**](RoleWrite.md)|  | 

### Return type

[**Role**](Role.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRole**
> Role getRole(id)

Get a role and its permissions

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getRBACApi();
final int id = 789; // int | 

try {
    final response = api.getRole(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RBACApi->getRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Role**](Role.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listPermissions**
> PermissionPage listPermissions()

List permission catalog

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getRBACApi();

try {
    final response = api.listPermissions();
    print(response);
} on DioException catch (e) {
    print('Exception when calling RBACApi->listPermissions: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PermissionPage**](PermissionPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listRoles**
> RolePage listRoles(limit, offset)

List roles

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getRBACApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.

try {
    final response = api.listRoles(limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RBACApi->listRoles: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 

### Return type

[**RolePage**](RolePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **replaceRolePermissions**
> Role replaceRolePermissions(id, rolePermissionsWrite)

Replace permission set on a non-system role

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getRBACApi();
final int id = 789; // int | 
final RolePermissionsWrite rolePermissionsWrite = ; // RolePermissionsWrite | 

try {
    final response = api.replaceRolePermissions(id, rolePermissionsWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RBACApi->replaceRolePermissions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **rolePermissionsWrite** | [**RolePermissionsWrite**](RolePermissionsWrite.md)|  | 

### Return type

[**Role**](Role.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateRole**
> Role updateRole(id, roleWrite)

Update a non-system role

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getRBACApi();
final int id = 789; // int | 
final RoleWrite roleWrite = ; // RoleWrite | 

try {
    final response = api.updateRole(id, roleWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RBACApi->updateRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **roleWrite** | [**RoleWrite**](RoleWrite.md)|  | 

### Return type

[**Role**](Role.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

