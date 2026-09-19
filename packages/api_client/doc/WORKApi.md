# api_client.api.WORKApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignWorkoutPlan**](WORKApi.md#assignworkoutplan) | **POST** /workout-plans/{id}/assign | Copy a template onto a member (new plan + version 1)
[**completeWorkoutSession**](WORKApi.md#completeworkoutsession) | **POST** /workout-sessions/{id}/complete | Complete a session
[**createExercise**](WORKApi.md#createexercise) | **POST** /exercises | Create an exercise
[**createWorkoutPlan**](WORKApi.md#createworkoutplan) | **POST** /workout-plans | Create a plan (also creates version 1)
[**getExercise**](WORKApi.md#getexercise) | **GET** /exercises/{id} | Exercise detail
[**getWorkoutPlan**](WORKApi.md#getworkoutplan) | **GET** /workout-plans/{id} | Plan with current version line items
[**listExercises**](WORKApi.md#listexercises) | **GET** /exercises | Exercise library
[**listWorkoutPlanVersions**](WORKApi.md#listworkoutplanversions) | **GET** /workout-plans/{id}/versions | Plan version snapshots
[**listWorkoutPlans**](WORKApi.md#listworkoutplans) | **GET** /workout-plans | Workout plans and templates
[**listWorkoutSessions**](WORKApi.md#listworkoutsessions) | **GET** /workout-sessions | Workout history
[**logWorkoutSet**](WORKApi.md#logworkoutset) | **POST** /workout-sessions/{id}/sets | Log a set
[**publishWorkoutPlan**](WORKApi.md#publishworkoutplan) | **POST** /workout-plans/{id}/publish | Publish a draft plan
[**replaceWorkoutPlanExercises**](WORKApi.md#replaceworkoutplanexercises) | **PUT** /workout-plans/{id}/exercises | Replace current-version line items (inserts a new version)
[**startWorkoutSession**](WORKApi.md#startworkoutsession) | **POST** /workout-sessions | Start a live session
[**updateExercise**](WORKApi.md#updateexercise) | **PATCH** /exercises/{id} | Update or deactivate an exercise
[**updateWorkoutPlan**](WORKApi.md#updateworkoutplan) | **PATCH** /workout-plans/{id} | Update plan metadata (requires row_version)


# **assignWorkoutPlan**
> WorkoutPlan assignWorkoutPlan(id, assignPlanRequest)

Copy a template onto a member (new plan + version 1)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 
final AssignPlanRequest assignPlanRequest = ; // AssignPlanRequest | 

try {
    final response = api.assignWorkoutPlan(id, assignPlanRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->assignWorkoutPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **assignPlanRequest** | [**AssignPlanRequest**](AssignPlanRequest.md)|  | 

### Return type

[**WorkoutPlan**](WorkoutPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **completeWorkoutSession**
> WorkoutSession completeWorkoutSession(id)

Complete a session

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 

try {
    final response = api.completeWorkoutSession(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->completeWorkoutSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**WorkoutSession**](WorkoutSession.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createExercise**
> Exercise createExercise(exerciseWrite)

Create an exercise

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final ExerciseWrite exerciseWrite = ; // ExerciseWrite | 

try {
    final response = api.createExercise(exerciseWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->createExercise: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **exerciseWrite** | [**ExerciseWrite**](ExerciseWrite.md)|  | 

### Return type

[**Exercise**](Exercise.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createWorkoutPlan**
> WorkoutPlan createWorkoutPlan(workoutPlanWrite)

Create a plan (also creates version 1)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final WorkoutPlanWrite workoutPlanWrite = ; // WorkoutPlanWrite | 

try {
    final response = api.createWorkoutPlan(workoutPlanWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->createWorkoutPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workoutPlanWrite** | [**WorkoutPlanWrite**](WorkoutPlanWrite.md)|  | 

### Return type

[**WorkoutPlan**](WorkoutPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getExercise**
> Exercise getExercise(id)

Exercise detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 

try {
    final response = api.getExercise(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->getExercise: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Exercise**](Exercise.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWorkoutPlan**
> WorkoutPlan getWorkoutPlan(id)

Plan with current version line items

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 

try {
    final response = api.getWorkoutPlan(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->getWorkoutPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**WorkoutPlan**](WorkoutPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listExercises**
> ExercisePage listExercises(limit, offset, q, primaryMuscleGroup, equipmentNeeded, difficultyLevel)

Exercise library

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String q = q_example; // String | Case-insensitive search (FR-API-014).
final String primaryMuscleGroup = primaryMuscleGroup_example; // String | 
final String equipmentNeeded = equipmentNeeded_example; // String | 
final String difficultyLevel = difficultyLevel_example; // String | 

try {
    final response = api.listExercises(limit, offset, q, primaryMuscleGroup, equipmentNeeded, difficultyLevel);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->listExercises: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **q** | **String**| Case-insensitive search (FR-API-014). | [optional] 
 **primaryMuscleGroup** | **String**|  | [optional] 
 **equipmentNeeded** | **String**|  | [optional] 
 **difficultyLevel** | **String**|  | [optional] 

### Return type

[**ExercisePage**](ExercisePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listWorkoutPlanVersions**
> WorkoutPlanVersionPage listWorkoutPlanVersions(id)

Plan version snapshots

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 

try {
    final response = api.listWorkoutPlanVersions(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->listWorkoutPlanVersions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**WorkoutPlanVersionPage**](WorkoutPlanVersionPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listWorkoutPlans**
> WorkoutPlanPage listWorkoutPlans(limit, offset, memberId, isTemplate)

Workout plans and templates

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final int memberId = 789; // int | 
final bool isTemplate = true; // bool | 

try {
    final response = api.listWorkoutPlans(limit, offset, memberId, isTemplate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->listWorkoutPlans: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **memberId** | **int**|  | [optional] 
 **isTemplate** | **bool**|  | [optional] 

### Return type

[**WorkoutPlanPage**](WorkoutPlanPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listWorkoutSessions**
> WorkoutSessionPage listWorkoutSessions(limit, cursor, memberId)

Workout history

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.
final int memberId = 789; // int | 

try {
    final response = api.listWorkoutSessions(limit, cursor, memberId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->listWorkoutSessions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 
 **memberId** | **int**|  | [optional] 

### Return type

[**WorkoutSessionPage**](WorkoutSessionPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logWorkoutSet**
> WorkoutSessionExercise logWorkoutSet(id, workoutSetWrite)

Log a set

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 
final WorkoutSetWrite workoutSetWrite = ; // WorkoutSetWrite | 

try {
    final response = api.logWorkoutSet(id, workoutSetWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->logWorkoutSet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **workoutSetWrite** | [**WorkoutSetWrite**](WorkoutSetWrite.md)|  | 

### Return type

[**WorkoutSessionExercise**](WorkoutSessionExercise.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publishWorkoutPlan**
> WorkoutPlan publishWorkoutPlan(id)

Publish a draft plan

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 

try {
    final response = api.publishWorkoutPlan(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->publishWorkoutPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**WorkoutPlan**](WorkoutPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **replaceWorkoutPlanExercises**
> WorkoutPlan replaceWorkoutPlanExercises(id, workoutPlanExercisesWrite)

Replace current-version line items (inserts a new version)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 
final WorkoutPlanExercisesWrite workoutPlanExercisesWrite = ; // WorkoutPlanExercisesWrite | 

try {
    final response = api.replaceWorkoutPlanExercises(id, workoutPlanExercisesWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->replaceWorkoutPlanExercises: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **workoutPlanExercisesWrite** | [**WorkoutPlanExercisesWrite**](WorkoutPlanExercisesWrite.md)|  | 

### Return type

[**WorkoutPlan**](WorkoutPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **startWorkoutSession**
> WorkoutSession startWorkoutSession(workoutSessionCreate)

Start a live session

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final WorkoutSessionCreate workoutSessionCreate = ; // WorkoutSessionCreate | 

try {
    final response = api.startWorkoutSession(workoutSessionCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->startWorkoutSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **workoutSessionCreate** | [**WorkoutSessionCreate**](WorkoutSessionCreate.md)|  | 

### Return type

[**WorkoutSession**](WorkoutSession.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateExercise**
> Exercise updateExercise(id, exerciseWrite)

Update or deactivate an exercise

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 
final ExerciseWrite exerciseWrite = ; // ExerciseWrite | 

try {
    final response = api.updateExercise(id, exerciseWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->updateExercise: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **exerciseWrite** | [**ExerciseWrite**](ExerciseWrite.md)|  | 

### Return type

[**Exercise**](Exercise.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateWorkoutPlan**
> WorkoutPlan updateWorkoutPlan(id, workoutPlanWrite)

Update plan metadata (requires row_version)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getWORKApi();
final int id = 789; // int | 
final WorkoutPlanWrite workoutPlanWrite = ; // WorkoutPlanWrite | 

try {
    final response = api.updateWorkoutPlan(id, workoutPlanWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WORKApi->updateWorkoutPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **workoutPlanWrite** | [**WorkoutPlanWrite**](WorkoutPlanWrite.md)|  | 

### Return type

[**WorkoutPlan**](WorkoutPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

