# api_client.api.ATTNApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**checkIn**](ATTNApi.md#checkin) | **POST** /attendances/check-in | Gate check-in (user session or device key)
[**checkOut**](ATTNApi.md#checkout) | **POST** /attendances/{id}/check-out | Gate check-out
[**getAttendancePass**](ATTNApi.md#getattendancepass) | **GET** /attendance/pass | Member digital pass (QR payload)
[**getAttendanceSummary**](ATTNApi.md#getattendancesummary) | **GET** /attendances/summary | Scoped attendance summary
[**listAttendanceHistories**](ATTNApi.md#listattendancehistories) | **GET** /attendance-histories | Daily footfall aggregates
[**listAttendances**](ATTNApi.md#listattendances) | **GET** /attendances | Gate attendance log
[**markSessionAttendance**](ATTNApi.md#marksessionattendance) | **POST** /schedules/{id}/participants/{participantId}/mark | Mark session attended / no-show


# **checkIn**
> Attendance checkIn(checkInRequest, idempotencyKey)

Gate check-in (user session or device key)

### Example
```dart
import 'package:api_client/api.dart';
// TODO Configure API key authorization: deviceKey
//defaultApiClient.getAuthentication<ApiKeyAuth>('deviceKey').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('deviceKey').apiKeyPrefix = 'Bearer';

final api = ApiClient().getATTNApi();
final CheckInRequest checkInRequest = ; // CheckInRequest | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.checkIn(checkInRequest, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ATTNApi->checkIn: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **checkInRequest** | [**CheckInRequest**](CheckInRequest.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**Attendance**](Attendance.md)

### Authorization

[deviceKey](../README.md#deviceKey), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **checkOut**
> Attendance checkOut(id)

Gate check-out

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getATTNApi();
final int id = 789; // int | 

try {
    final response = api.checkOut(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ATTNApi->checkOut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Attendance**](Attendance.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAttendancePass**
> AttendancePass getAttendancePass()

Member digital pass (QR payload)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getATTNApi();

try {
    final response = api.getAttendancePass();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ATTNApi->getAttendancePass: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AttendancePass**](AttendancePass.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAttendanceSummary**
> AttendanceSummary getAttendanceSummary(memberId)

Scoped attendance summary

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getATTNApi();
final int memberId = 789; // int | 

try {
    final response = api.getAttendanceSummary(memberId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ATTNApi->getAttendanceSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberId** | **int**|  | [optional] 

### Return type

[**AttendanceSummary**](AttendanceSummary.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAttendanceHistories**
> AttendanceHistoryPage listAttendanceHistories(from, to)

Daily footfall aggregates

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getATTNApi();
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 

try {
    final response = api.listAttendanceHistories(from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ATTNApi->listAttendanceHistories: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 

### Return type

[**AttendanceHistoryPage**](AttendanceHistoryPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listAttendances**
> AttendancePage listAttendances(limit, cursor, userId, from, to)

Gate attendance log

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getATTNApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.
final int userId = 789; // int | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.listAttendances(limit, cursor, userId, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ATTNApi->listAttendances: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 
 **userId** | **int**|  | [optional] 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**AttendancePage**](AttendancePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markSessionAttendance**
> ScheduleParticipant markSessionAttendance(id, participantId, markAttendanceRequest)

Mark session attended / no-show

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getATTNApi();
final int id = 789; // int | 
final int participantId = 789; // int | 
final MarkAttendanceRequest markAttendanceRequest = ; // MarkAttendanceRequest | 

try {
    final response = api.markSessionAttendance(id, participantId, markAttendanceRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ATTNApi->markSessionAttendance: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **participantId** | **int**|  | 
 **markAttendanceRequest** | [**MarkAttendanceRequest**](MarkAttendanceRequest.md)|  | 

### Return type

[**ScheduleParticipant**](ScheduleParticipant.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

