# api_client.api.NOTIFApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**broadcastNotification**](NOTIFApi.md#broadcastnotification) | **POST** /notifications/broadcast | Broadcast to a role-scoped audience
[**deleteDevice**](NOTIFApi.md#deletedevice) | **DELETE** /devices/{id} | Unregister a device
[**getNotification**](NOTIFApi.md#getnotification) | **GET** /notifications/{id} | Notification detail
[**listBroadcasts**](NOTIFApi.md#listbroadcasts) | **GET** /notifications/broadcasts | Sent broadcasts
[**listDevices**](NOTIFApi.md#listdevices) | **GET** /devices | Registered push devices for the current user
[**listNotifications**](NOTIFApi.md#listnotifications) | **GET** /notifications | Inbox
[**markAllNotificationsRead**](NOTIFApi.md#markallnotificationsread) | **POST** /notifications/read-all | Mark all read
[**markNotificationRead**](NOTIFApi.md#marknotificationread) | **POST** /notifications/{id}/read | Mark one notification read
[**registerDevice**](NOTIFApi.md#registerdevice) | **POST** /devices | Register a push token


# **broadcastNotification**
> Notification broadcastNotification(broadcastRequest)

Broadcast to a role-scoped audience

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();
final BroadcastRequest broadcastRequest = ; // BroadcastRequest | 

try {
    final response = api.broadcastNotification(broadcastRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->broadcastNotification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **broadcastRequest** | [**BroadcastRequest**](BroadcastRequest.md)|  | 

### Return type

[**Notification**](Notification.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteDevice**
> deleteDevice(id)

Unregister a device

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();
final int id = 789; // int | 

try {
    api.deleteDevice(id);
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->deleteDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getNotification**
> Notification getNotification(id)

Notification detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();
final int id = 789; // int | 

try {
    final response = api.getNotification(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->getNotification: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Notification**](Notification.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listBroadcasts**
> NotificationPage listBroadcasts(limit, offset)

Sent broadcasts

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.

try {
    final response = api.listBroadcasts(limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->listBroadcasts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 

### Return type

[**NotificationPage**](NotificationPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDevices**
> DevicePage listDevices()

Registered push devices for the current user

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();

try {
    final response = api.listDevices();
    print(response);
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->listDevices: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**DevicePage**](DevicePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listNotifications**
> NotificationPage listNotifications(limit, cursor)

Inbox

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.

try {
    final response = api.listNotifications(limit, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->listNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 

### Return type

[**NotificationPage**](NotificationPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markAllNotificationsRead**
> markAllNotificationsRead()

Mark all read

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();

try {
    api.markAllNotificationsRead();
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->markAllNotificationsRead: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markNotificationRead**
> Notification markNotificationRead(id)

Mark one notification read

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();
final int id = 789; // int | 

try {
    final response = api.markNotificationRead(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->markNotificationRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Notification**](Notification.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **registerDevice**
> Device registerDevice(deviceWrite)

Register a push token

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getNOTIFApi();
final DeviceWrite deviceWrite = ; // DeviceWrite | 

try {
    final response = api.registerDevice(deviceWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling NOTIFApi->registerDevice: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deviceWrite** | [**DeviceWrite**](DeviceWrite.md)|  | 

### Return type

[**Device**](Device.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

