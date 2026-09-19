# api_client.api.SYSApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPublicSettings**](SYSApi.md#getpublicsettings) | **GET** /settings/public | Timezone, currency, hours, page size
[**getSettings**](SYSApi.md#getsettings) | **GET** /settings | All settings or one category
[**listAuditLogs**](SYSApi.md#listauditlogs) | **GET** /audit-logs | Append-only admin audit (no update/delete)
[**putSettings**](SYSApi.md#putsettings) | **PUT** /settings | Upsert known setting keys


# **getPublicSettings**
> PublicSettings getPublicSettings()

Timezone, currency, hours, page size

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSYSApi();

try {
    final response = api.getPublicSettings();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SYSApi->getPublicSettings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PublicSettings**](PublicSettings.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSettings**
> SettingsList getSettings(category)

All settings or one category

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSYSApi();
final SettingCategory category = ; // SettingCategory | 

try {
    final response = api.getSettings(category);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SYSApi->getSettings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **category** | [**SettingCategory**](.md)|  | [optional] 

### Return type

[**SettingsList**](SettingsList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAuditLogs**
> AuditLogPage listAuditLogs(limit, cursor, actorUserId, entityName, entityId, action, from, to)

Append-only admin audit (no update/delete)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSYSApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.
final int actorUserId = 789; // int | 
final String entityName = entityName_example; // String | 
final int entityId = 789; // int | 
final String action = action_example; // String | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listAuditLogs(limit, cursor, actorUserId, entityName, entityId, action, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SYSApi->listAuditLogs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 
 **actorUserId** | **int**|  | [optional] 
 **entityName** | **String**|  | [optional] 
 **entityId** | **int**|  | [optional] 
 **action** | **String**|  | [optional] 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**AuditLogPage**](AuditLogPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **putSettings**
> SettingsList putSettings(settingsWrite)

Upsert known setting keys

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSYSApi();
final SettingsWrite settingsWrite = ; // SettingsWrite | 

try {
    final response = api.putSettings(settingsWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SYSApi->putSettings: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **settingsWrite** | [**SettingsWrite**](SettingsWrite.md)|  | 

### Return type

[**SettingsList**](SettingsList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

