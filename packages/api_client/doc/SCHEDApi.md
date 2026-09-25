# api_client.api.SCHEDApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**bookSchedule**](SCHEDApi.md#bookschedule) | **POST** /schedules/{id}/book | Book or waitlist a member for a schedule
[**cancelBooking**](SCHEDApi.md#cancelbooking) | **POST** /schedules/{id}/bookings/{memberId}/cancel | Cancel a member booking
[**cancelSchedule**](SCHEDApi.md#cancelschedule) | **POST** /schedules/{id}/cancel | Cancel a schedule
[**completeSchedule**](SCHEDApi.md#completeschedule) | **POST** /schedules/{id}/complete | Mark schedule completed
[**createFacility**](SCHEDApi.md#createfacility) | **POST** /facilities | Create a facility
[**createSchedule**](SCHEDApi.md#createschedule) | **POST** /schedules | Create a booking or class occurrence
[**createScheduleType**](SCHEDApi.md#createscheduletype) | **POST** /schedule-types | Create a schedule type
[**getSchedule**](SCHEDApi.md#getschedule) | **GET** /schedules/{id} | Schedule detail
[**getTrainerAvailability**](SCHEDApi.md#gettraineravailability) | **GET** /trainers/{id}/availability | Trainer hours and block-outs
[**listFacilities**](SCHEDApi.md#listfacilities) | **GET** /facilities | Rooms and studios
[**listScheduleHistory**](SCHEDApi.md#listschedulehistory) | **GET** /schedules/{id}/history | Schedule history
[**listScheduleTypes**](SCHEDApi.md#listscheduletypes) | **GET** /schedule-types | Schedule types
[**listSchedules**](SCHEDApi.md#listschedules) | **GET** /schedules | Calendar list
[**putTrainerAvailability**](SCHEDApi.md#puttraineravailability) | **PUT** /trainers/{id}/availability | Replace trainer availability
[**startSchedule**](SCHEDApi.md#startschedule) | **POST** /schedules/{id}/start | Mark schedule ongoing
[**updateFacility**](SCHEDApi.md#updatefacility) | **PATCH** /facilities/{id} | Update a facility
[**updateSchedule**](SCHEDApi.md#updateschedule) | **PATCH** /schedules/{id} | Update a schedule (requires row_version)
[**updateScheduleType**](SCHEDApi.md#updatescheduletype) | **PATCH** /schedule-types/{id} | Update a schedule type


# **bookSchedule**
> ScheduleParticipant bookSchedule(id, bookRequest)

Book or waitlist a member for a schedule

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 
final BookRequest bookRequest = ; // BookRequest | 

try {
    final response = api.bookSchedule(id, bookRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->bookSchedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **bookRequest** | [**BookRequest**](BookRequest.md)|  | 

### Return type

[**ScheduleParticipant**](ScheduleParticipant.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelBooking**
> ScheduleParticipant cancelBooking(id, memberId, cancelBookingRequest)

Cancel a member booking

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 
final int memberId = 789; // int | 
final CancelBookingRequest cancelBookingRequest = ; // CancelBookingRequest | 

try {
    final response = api.cancelBooking(id, memberId, cancelBookingRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->cancelBooking: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **memberId** | **int**|  | 
 **cancelBookingRequest** | [**CancelBookingRequest**](CancelBookingRequest.md)|  | 

### Return type

[**ScheduleParticipant**](ScheduleParticipant.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelSchedule**
> Schedule cancelSchedule(id, cancelRequest)

Cancel a schedule

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 
final CancelRequest cancelRequest = ; // CancelRequest | 

try {
    final response = api.cancelSchedule(id, cancelRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->cancelSchedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **cancelRequest** | [**CancelRequest**](CancelRequest.md)|  | 

### Return type

[**Schedule**](Schedule.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeSchedule**
> Schedule completeSchedule(id)

Mark schedule completed

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 

try {
    final response = api.completeSchedule(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->completeSchedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Schedule**](Schedule.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createFacility**
> Facility createFacility(facilityWrite)

Create a facility

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final FacilityWrite facilityWrite = ; // FacilityWrite | 

try {
    final response = api.createFacility(facilityWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->createFacility: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **facilityWrite** | [**FacilityWrite**](FacilityWrite.md)|  | 

### Return type

[**Facility**](Facility.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createSchedule**
> Schedule createSchedule(scheduleWrite, idempotencyKey)

Create a booking or class occurrence

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final ScheduleWrite scheduleWrite = ; // ScheduleWrite | 
final String idempotencyKey = idempotencyKey_example; // String | Required in practice on payments, check-in, booking, freeze (FR-API-008).

try {
    final response = api.createSchedule(scheduleWrite, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->createSchedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **scheduleWrite** | [**ScheduleWrite**](ScheduleWrite.md)|  | 
 **idempotencyKey** | **String**| Required in practice on payments, check-in, booking, freeze (FR-API-008). | [optional] 

### Return type

[**Schedule**](Schedule.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createScheduleType**
> ScheduleType createScheduleType(scheduleTypeWrite)

Create a schedule type

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final ScheduleTypeWrite scheduleTypeWrite = ; // ScheduleTypeWrite | 

try {
    final response = api.createScheduleType(scheduleTypeWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->createScheduleType: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **scheduleTypeWrite** | [**ScheduleTypeWrite**](ScheduleTypeWrite.md)|  | 

### Return type

[**ScheduleType**](ScheduleType.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getSchedule**
> Schedule getSchedule(id)

Schedule detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 

try {
    final response = api.getSchedule(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->getSchedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Schedule**](Schedule.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTrainerAvailability**
> TrainerAvailabilityPage getTrainerAvailability(id)

Trainer hours and block-outs

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 

try {
    final response = api.getTrainerAvailability(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->getTrainerAvailability: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**TrainerAvailabilityPage**](TrainerAvailabilityPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFacilities**
> FacilityPage listFacilities()

Rooms and studios

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();

try {
    final response = api.listFacilities();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->listFacilities: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**FacilityPage**](FacilityPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listScheduleHistory**
> ScheduleHistoryPage listScheduleHistory(id, cursor)

Schedule history

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.

try {
    final response = api.listScheduleHistory(id, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->listScheduleHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 

### Return type

[**ScheduleHistoryPage**](ScheduleHistoryPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listScheduleTypes**
> ScheduleTypePage listScheduleTypes()

Schedule types

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();

try {
    final response = api.listScheduleTypes();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->listScheduleTypes: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ScheduleTypePage**](ScheduleTypePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listSchedules**
> SchedulePage listSchedules(limit, cursor, from, to, trainerId, memberId)

Calendar list

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 
final int trainerId = 789; // int | 
final int memberId = 789; // int | 

try {
    final response = api.listSchedules(limit, cursor, from, to, trainerId, memberId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->listSchedules: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 
 **trainerId** | **int**|  | [optional] 
 **memberId** | **int**|  | [optional] 

### Return type

[**SchedulePage**](SchedulePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **putTrainerAvailability**
> TrainerAvailabilityPage putTrainerAvailability(id, trainerAvailabilityWrite)

Replace trainer availability

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 
final TrainerAvailabilityWrite trainerAvailabilityWrite = ; // TrainerAvailabilityWrite | 

try {
    final response = api.putTrainerAvailability(id, trainerAvailabilityWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->putTrainerAvailability: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **trainerAvailabilityWrite** | [**TrainerAvailabilityWrite**](TrainerAvailabilityWrite.md)|  | 

### Return type

[**TrainerAvailabilityPage**](TrainerAvailabilityPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startSchedule**
> Schedule startSchedule(id)

Mark schedule ongoing

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 

try {
    final response = api.startSchedule(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->startSchedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Schedule**](Schedule.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateFacility**
> Facility updateFacility(id, facilityWrite)

Update a facility

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 
final FacilityWrite facilityWrite = ; // FacilityWrite | 

try {
    final response = api.updateFacility(id, facilityWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->updateFacility: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **facilityWrite** | [**FacilityWrite**](FacilityWrite.md)|  | 

### Return type

[**Facility**](Facility.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateSchedule**
> Schedule updateSchedule(id, scheduleWrite)

Update a schedule (requires row_version)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 
final ScheduleWrite scheduleWrite = ; // ScheduleWrite | 

try {
    final response = api.updateSchedule(id, scheduleWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->updateSchedule: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **scheduleWrite** | [**ScheduleWrite**](ScheduleWrite.md)|  | 

### Return type

[**Schedule**](Schedule.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateScheduleType**
> ScheduleType updateScheduleType(id, scheduleTypeWrite)

Update a schedule type

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getSCHEDApi();
final int id = 789; // int | 
final ScheduleTypeWrite scheduleTypeWrite = ; // ScheduleTypeWrite | 

try {
    final response = api.updateScheduleType(id, scheduleTypeWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SCHEDApi->updateScheduleType: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **scheduleTypeWrite** | [**ScheduleTypeWrite**](ScheduleTypeWrite.md)|  | 

### Return type

[**ScheduleType**](ScheduleType.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

