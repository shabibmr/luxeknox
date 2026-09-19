# api_client.api.MEMBApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**approveFreeze**](MEMBApi.md#approvefreeze) | **POST** /freezes/{id}/approve | Approve a freeze
[**cancelMembership**](MEMBApi.md#cancelmembership) | **POST** /memberships/{id}/cancel | Cancel a membership
[**createMembership**](MEMBApi.md#createmembership) | **POST** /memberships | Assign a membership
[**createMembershipProduct**](MEMBApi.md#createmembershipproduct) | **POST** /membership-products | Create a package
[**extendMembership**](MEMBApi.md#extendmembership) | **POST** /memberships/{id}/extensions | Grant a compensatory extension
[**getMembership**](MEMBApi.md#getmembership) | **GET** /memberships/{id} | Membership detail
[**getMembershipProduct**](MEMBApi.md#getmembershipproduct) | **GET** /membership-products/{id} | Package detail
[**listMembershipFreezes**](MEMBApi.md#listmembershipfreezes) | **GET** /memberships/{id}/freezes | Freeze requests
[**listMembershipHistory**](MEMBApi.md#listmembershiphistory) | **GET** /memberships/{id}/history | Append-only membership history
[**listMembershipProducts**](MEMBApi.md#listmembershipproducts) | **GET** /membership-products | Package catalog
[**listMemberships**](MEMBApi.md#listmemberships) | **GET** /memberships | Membership contracts
[**rejectFreeze**](MEMBApi.md#rejectfreeze) | **POST** /freezes/{id}/reject | Reject a freeze
[**renewMembership**](MEMBApi.md#renewmembership) | **POST** /memberships/{id}/renew | Renew a membership
[**requestMembershipFreeze**](MEMBApi.md#requestmembershipfreeze) | **POST** /memberships/{id}/freezes | Request or create a freeze
[**updateMembershipProduct**](MEMBApi.md#updatemembershipproduct) | **PATCH** /membership-products/{id} | Update a package
[**upgradeMembership**](MEMBApi.md#upgrademembership) | **POST** /memberships/{id}/upgrade | Upgrade a membership


# **approveFreeze**
> MembershipFreeze approveFreeze(id)

Approve a freeze

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 

try {
    final response = api.approveFreeze(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->approveFreeze: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MembershipFreeze**](MembershipFreeze.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelMembership**
> Membership cancelMembership(id, membershipActionRequest)

Cancel a membership

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 
final MembershipActionRequest membershipActionRequest = ; // MembershipActionRequest | 

try {
    final response = api.cancelMembership(id, membershipActionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->cancelMembership: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **membershipActionRequest** | [**MembershipActionRequest**](MembershipActionRequest.md)|  | 

### Return type

[**Membership**](Membership.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createMembership**
> Membership createMembership(membershipCreate)

Assign a membership

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final MembershipCreate membershipCreate = ; // MembershipCreate | 

try {
    final response = api.createMembership(membershipCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->createMembership: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **membershipCreate** | [**MembershipCreate**](MembershipCreate.md)|  | 

### Return type

[**Membership**](Membership.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createMembershipProduct**
> MembershipProduct createMembershipProduct(membershipProductWrite)

Create a package

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final MembershipProductWrite membershipProductWrite = ; // MembershipProductWrite | 

try {
    final response = api.createMembershipProduct(membershipProductWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->createMembershipProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **membershipProductWrite** | [**MembershipProductWrite**](MembershipProductWrite.md)|  | 

### Return type

[**MembershipProduct**](MembershipProduct.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **extendMembership**
> MembershipExtension extendMembership(id, membershipExtensionWrite)

Grant a compensatory extension

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 
final MembershipExtensionWrite membershipExtensionWrite = ; // MembershipExtensionWrite | 

try {
    final response = api.extendMembership(id, membershipExtensionWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->extendMembership: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **membershipExtensionWrite** | [**MembershipExtensionWrite**](MembershipExtensionWrite.md)|  | 

### Return type

[**MembershipExtension**](MembershipExtension.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMembership**
> Membership getMembership(id)

Membership detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 

try {
    final response = api.getMembership(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->getMembership: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Membership**](Membership.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMembershipProduct**
> MembershipProduct getMembershipProduct(id)

Package detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 

try {
    final response = api.getMembershipProduct(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->getMembershipProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MembershipProduct**](MembershipProduct.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMembershipFreezes**
> MembershipFreezePage listMembershipFreezes(id)

Freeze requests

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 

try {
    final response = api.listMembershipFreezes(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->listMembershipFreezes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MembershipFreezePage**](MembershipFreezePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMembershipHistory**
> MembershipHistoryPage listMembershipHistory(id, limit, cursor)

Append-only membership history

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.

try {
    final response = api.listMembershipHistory(id, limit, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->listMembershipHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 

### Return type

[**MembershipHistoryPage**](MembershipHistoryPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMembershipProducts**
> MembershipProductPage listMembershipProducts(limit, offset, q)

Package catalog

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String q = q_example; // String | Case-insensitive search (FR-API-014).

try {
    final response = api.listMembershipProducts(limit, offset, q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->listMembershipProducts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **q** | **String**| Case-insensitive search (FR-API-014). | [optional] 

### Return type

[**MembershipProductPage**](MembershipProductPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMemberships**
> MembershipPage listMemberships(limit, offset, memberId, status)

Membership contracts

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final int memberId = 789; // int | 
final String status = status_example; // String | 

try {
    final response = api.listMemberships(limit, offset, memberId, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->listMemberships: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **memberId** | **int**|  | [optional] 
 **status** | **String**|  | [optional] 

### Return type

[**MembershipPage**](MembershipPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rejectFreeze**
> MembershipFreeze rejectFreeze(id, rejectRequest)

Reject a freeze

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 
final RejectRequest rejectRequest = ; // RejectRequest | 

try {
    final response = api.rejectFreeze(id, rejectRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->rejectFreeze: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **rejectRequest** | [**RejectRequest**](RejectRequest.md)|  | 

### Return type

[**MembershipFreeze**](MembershipFreeze.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **renewMembership**
> Membership renewMembership(id, membershipActionRequest)

Renew a membership

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 
final MembershipActionRequest membershipActionRequest = ; // MembershipActionRequest | 

try {
    final response = api.renewMembership(id, membershipActionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->renewMembership: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **membershipActionRequest** | [**MembershipActionRequest**](MembershipActionRequest.md)|  | 

### Return type

[**Membership**](Membership.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestMembershipFreeze**
> MembershipFreeze requestMembershipFreeze(id, membershipFreezeWrite, idempotencyKey)

Request or create a freeze

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 
final MembershipFreezeWrite membershipFreezeWrite = ; // MembershipFreezeWrite | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.requestMembershipFreeze(id, membershipFreezeWrite, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->requestMembershipFreeze: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **membershipFreezeWrite** | [**MembershipFreezeWrite**](MembershipFreezeWrite.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**MembershipFreeze**](MembershipFreeze.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateMembershipProduct**
> MembershipProduct updateMembershipProduct(id, membershipProductWrite)

Update a package

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 
final MembershipProductWrite membershipProductWrite = ; // MembershipProductWrite | 

try {
    final response = api.updateMembershipProduct(id, membershipProductWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->updateMembershipProduct: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **membershipProductWrite** | [**MembershipProductWrite**](MembershipProductWrite.md)|  | 

### Return type

[**MembershipProduct**](MembershipProduct.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **upgradeMembership**
> Membership upgradeMembership(id, membershipActionRequest)

Upgrade a membership

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEMBApi();
final int id = 789; // int | 
final MembershipActionRequest membershipActionRequest = ; // MembershipActionRequest | 

try {
    final response = api.upgradeMembership(id, membershipActionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEMBApi->upgradeMembership: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **membershipActionRequest** | [**MembershipActionRequest**](MembershipActionRequest.md)|  | 

### Return type

[**Membership**](Membership.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

