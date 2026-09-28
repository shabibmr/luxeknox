# api_client.api.GOALApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**checkInGoal**](GOALApi.md#checkingoal) | **POST** /goals/{id}/check-ins | Record a goal check-in
[**compareProgressPhotos**](GOALApi.md#compareprogressphotos) | **GET** /members/{id}/progress-photos/comparison | Compare progress photos across two dates and poses
[**createGoalMetric**](GOALApi.md#creategoalmetric) | **POST** /goal-metrics | Create a metric
[**createMeasurement**](GOALApi.md#createmeasurement) | **POST** /members/{id}/measurements | Record a measurement session
[**createMemberGoal**](GOALApi.md#createmembergoal) | **POST** /members/{id}/goals | Create a goal
[**createProgressNote**](GOALApi.md#createprogressnote) | **POST** /members/{id}/progress-notes | Add a progress note
[**createProgressPhoto**](GOALApi.md#createprogressphoto) | **POST** /members/{id}/progress-photos | Add a progress photo (deferred)
[**deleteProgressPhoto**](GOALApi.md#deleteprogressphoto) | **DELETE** /progress-photos/{id} | Delete a progress photo (deferred)
[**getGoal**](GOALApi.md#getgoal) | **GET** /goals/{id} | Goal detail
[**getMeasurement**](GOALApi.md#getmeasurement) | **GET** /measurements/{id} | Measurement session with values
[**getMeasurementChart**](GOALApi.md#getmeasurementchart) | **GET** /members/{id}/measurements/chart | Longitudinal metric chart series
[**listGoalMetrics**](GOALApi.md#listgoalmetrics) | **GET** /goal-metrics | Measurement type catalog
[**listMeasurements**](GOALApi.md#listmeasurements) | **GET** /members/{id}/measurements | Measurement sessions
[**listMemberGoals**](GOALApi.md#listmembergoals) | **GET** /members/{id}/goals | Member goals
[**listProgressNotes**](GOALApi.md#listprogressnotes) | **GET** /members/{id}/progress-notes | Coach / member notes
[**listProgressPhotos**](GOALApi.md#listprogressphotos) | **GET** /members/{id}/progress-photos | Progress photos (deferred)
[**updateGoal**](GOALApi.md#updategoal) | **PATCH** /goals/{id} | Update a goal
[**updateGoalMetric**](GOALApi.md#updategoalmetric) | **PATCH** /goal-metrics/{id} | Update a metric


# **checkInGoal**
> GoalHistory checkInGoal(id, goalCheckInWrite)

Record a goal check-in

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final GoalCheckInWrite goalCheckInWrite = ; // GoalCheckInWrite | 

try {
    final response = api.checkInGoal(id, goalCheckInWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->checkInGoal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **goalCheckInWrite** | [**GoalCheckInWrite**](GoalCheckInWrite.md)|  | 

### Return type

[**GoalHistory**](GoalHistory.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **compareProgressPhotos**
> ProgressPhotoComparison compareProgressPhotos(id, date1, date2)

Compare progress photos across two dates and poses

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final Date date1 = 2013-10-20; // Date | 
final Date date2 = 2013-10-20; // Date | 

try {
    final response = api.compareProgressPhotos(id, date1, date2);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->compareProgressPhotos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **date1** | **Date**|  | 
 **date2** | **Date**|  | 

### Return type

[**ProgressPhotoComparison**](ProgressPhotoComparison.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createGoalMetric**
> GoalMetric createGoalMetric(goalMetricWrite)

Create a metric

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final GoalMetricWrite goalMetricWrite = ; // GoalMetricWrite | 

try {
    final response = api.createGoalMetric(goalMetricWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->createGoalMetric: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **goalMetricWrite** | [**GoalMetricWrite**](GoalMetricWrite.md)|  | 

### Return type

[**GoalMetric**](GoalMetric.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createMeasurement**
> Measurement createMeasurement(id, measurementWrite)

Record a measurement session

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final MeasurementWrite measurementWrite = ; // MeasurementWrite | 

try {
    final response = api.createMeasurement(id, measurementWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->createMeasurement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **measurementWrite** | [**MeasurementWrite**](MeasurementWrite.md)|  | 

### Return type

[**Measurement**](Measurement.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createMemberGoal**
> Goal createMemberGoal(id, goalWrite)

Create a goal

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final GoalWrite goalWrite = ; // GoalWrite | 

try {
    final response = api.createMemberGoal(id, goalWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->createMemberGoal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **goalWrite** | [**GoalWrite**](GoalWrite.md)|  | 

### Return type

[**Goal**](Goal.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createProgressNote**
> ProgressNote createProgressNote(id, progressNoteWrite)

Add a progress note

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final ProgressNoteWrite progressNoteWrite = ; // ProgressNoteWrite | 

try {
    final response = api.createProgressNote(id, progressNoteWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->createProgressNote: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **progressNoteWrite** | [**ProgressNoteWrite**](ProgressNoteWrite.md)|  | 

### Return type

[**ProgressNote**](ProgressNote.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createProgressPhoto**
> ProgressPhoto createProgressPhoto(id, progressPhotoWrite)

Add a progress photo (deferred)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final ProgressPhotoWrite progressPhotoWrite = ; // ProgressPhotoWrite | 

try {
    final response = api.createProgressPhoto(id, progressPhotoWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->createProgressPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **progressPhotoWrite** | [**ProgressPhotoWrite**](ProgressPhotoWrite.md)|  | 

### Return type

[**ProgressPhoto**](ProgressPhoto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteProgressPhoto**
> deleteProgressPhoto(id)

Delete a progress photo (deferred)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 

try {
    api.deleteProgressPhoto(id);
} on DioException catch (e) {
    print('Exception when calling GOALApi->deleteProgressPhoto: $e\n');
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

# **getGoal**
> Goal getGoal(id)

Goal detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 

try {
    final response = api.getGoal(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->getGoal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Goal**](Goal.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMeasurement**
> Measurement getMeasurement(id)

Measurement session with values

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 

try {
    final response = api.getMeasurement(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->getMeasurement: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Measurement**](Measurement.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMeasurementChart**
> BuiltList<LongitudinalDataPoint> getMeasurementChart(id, metricId, from, to)

Longitudinal metric chart series

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final int metricId = 789; // int | 
final DateTime from = 2013-10-20T19:20:30+01:00; // DateTime | 
final DateTime to = 2013-10-20T19:20:30+01:00; // DateTime | 

try {
    final response = api.getMeasurementChart(id, metricId, from, to);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->getMeasurementChart: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **metricId** | **int**|  | 
 **from** | **DateTime**|  | [optional] 
 **to** | **DateTime**|  | [optional] 

### Return type

[**BuiltList&lt;LongitudinalDataPoint&gt;**](LongitudinalDataPoint.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listGoalMetrics**
> GoalMetricPage listGoalMetrics()

Measurement type catalog

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();

try {
    final response = api.listGoalMetrics();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->listGoalMetrics: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GoalMetricPage**](GoalMetricPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMeasurements**
> MeasurementPage listMeasurements(id, limit, cursor)

Measurement sessions

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.

try {
    final response = api.listMeasurements(id, limit, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->listMeasurements: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 

### Return type

[**MeasurementPage**](MeasurementPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMemberGoals**
> GoalPage listMemberGoals(id)

Member goals

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 

try {
    final response = api.listMemberGoals(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->listMemberGoals: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**GoalPage**](GoalPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProgressNotes**
> ProgressNotePage listProgressNotes(id, cursor)

Coach / member notes

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.

try {
    final response = api.listProgressNotes(id, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->listProgressNotes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 

### Return type

[**ProgressNotePage**](ProgressNotePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listProgressPhotos**
> ProgressPhotoPage listProgressPhotos(id)

Progress photos (deferred)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 

try {
    final response = api.listProgressPhotos(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->listProgressPhotos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**ProgressPhotoPage**](ProgressPhotoPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateGoal**
> Goal updateGoal(id, goalWrite)

Update a goal

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final GoalWrite goalWrite = ; // GoalWrite | 

try {
    final response = api.updateGoal(id, goalWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->updateGoal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **goalWrite** | [**GoalWrite**](GoalWrite.md)|  | 

### Return type

[**Goal**](Goal.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateGoalMetric**
> GoalMetric updateGoalMetric(id, goalMetricWrite)

Update a metric

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getGOALApi();
final int id = 789; // int | 
final GoalMetricWrite goalMetricWrite = ; // GoalMetricWrite | 

try {
    final response = api.updateGoalMetric(id, goalMetricWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GOALApi->updateGoalMetric: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **goalMetricWrite** | [**GoalMetricWrite**](GoalMetricWrite.md)|  | 

### Return type

[**GoalMetric**](GoalMetric.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

