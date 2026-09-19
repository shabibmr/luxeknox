# api_client.api.DIETApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignDietPlan**](DIETApi.md#assigndietplan) | **POST** /diet-plans/{id}/assign | Copy a template onto a member
[**createDietPlan**](DIETApi.md#createdietplan) | **POST** /diet-plans | Create a diet plan (also creates version 1)
[**createFood**](DIETApi.md#createfood) | **POST** /foods | Create a food
[**getDietPlan**](DIETApi.md#getdietplan) | **GET** /diet-plans/{id} | Plan with current version meals
[**getFood**](DIETApi.md#getfood) | **GET** /foods/{id} | Food detail
[**listDietLogs**](DIETApi.md#listdietlogs) | **GET** /members/{id}/diet-logs | Diet adherence history
[**listDietPlanVersions**](DIETApi.md#listdietplanversions) | **GET** /diet-plans/{id}/versions | Diet plan versions
[**listDietPlans**](DIETApi.md#listdietplans) | **GET** /diet-plans | Diet plans and templates
[**listFoods**](DIETApi.md#listfoods) | **GET** /foods | Food library
[**publishDietPlan**](DIETApi.md#publishdietplan) | **POST** /diet-plans/{id}/publish | Publish a draft diet plan
[**putDietLog**](DIETApi.md#putdietlog) | **PUT** /members/{id}/diet-logs/{date} | Upsert a day&#39;s intake log
[**replaceDietPlanMeals**](DIETApi.md#replacedietplanmeals) | **PUT** /diet-plans/{id}/meals | Replace current-version meals (inserts a new version)
[**updateDietPlan**](DIETApi.md#updatedietplan) | **PATCH** /diet-plans/{id} | Update diet plan metadata (requires row_version)
[**updateFood**](DIETApi.md#updatefood) | **PATCH** /foods/{id} | Update a food


# **assignDietPlan**
> DietPlan assignDietPlan(id, assignPlanRequest)

Copy a template onto a member

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 
final AssignPlanRequest assignPlanRequest = ; // AssignPlanRequest | 

try {
    final response = api.assignDietPlan(id, assignPlanRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->assignDietPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **assignPlanRequest** | [**AssignPlanRequest**](AssignPlanRequest.md)|  | 

### Return type

[**DietPlan**](DietPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createDietPlan**
> DietPlan createDietPlan(dietPlanWrite)

Create a diet plan (also creates version 1)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final DietPlanWrite dietPlanWrite = ; // DietPlanWrite | 

try {
    final response = api.createDietPlan(dietPlanWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->createDietPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **dietPlanWrite** | [**DietPlanWrite**](DietPlanWrite.md)|  | 

### Return type

[**DietPlan**](DietPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createFood**
> Food createFood(foodWrite)

Create a food

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final FoodWrite foodWrite = ; // FoodWrite | 

try {
    final response = api.createFood(foodWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->createFood: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **foodWrite** | [**FoodWrite**](FoodWrite.md)|  | 

### Return type

[**Food**](Food.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDietPlan**
> DietPlan getDietPlan(id)

Plan with current version meals

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 

try {
    final response = api.getDietPlan(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->getDietPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**DietPlan**](DietPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFood**
> Food getFood(id)

Food detail

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 

try {
    final response = api.getFood(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->getFood: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Food**](Food.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDietLogs**
> DietLogPage listDietLogs(id, limit, cursor)

Diet adherence history

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.

try {
    final response = api.listDietLogs(id, limit, cursor);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->listDietLogs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 

### Return type

[**DietLogPage**](DietLogPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDietPlanVersions**
> DietPlanVersionPage listDietPlanVersions(id)

Diet plan versions

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 

try {
    final response = api.listDietPlanVersions(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->listDietPlanVersions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**DietPlanVersionPage**](DietPlanVersionPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listDietPlans**
> DietPlanPage listDietPlans(limit, offset, memberId, isTemplate)

Diet plans and templates

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final int memberId = 789; // int | 
final bool isTemplate = true; // bool | 

try {
    final response = api.listDietPlans(limit, offset, memberId, isTemplate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->listDietPlans: $e\n');
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

[**DietPlanPage**](DietPlanPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listFoods**
> FoodPage listFoods(limit, offset, q)

Food library

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String q = q_example; // String | Case-insensitive search (FR-API-014).

try {
    final response = api.listFoods(limit, offset, q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->listFoods: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **q** | **String**| Case-insensitive search (FR-API-014). | [optional] 

### Return type

[**FoodPage**](FoodPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **publishDietPlan**
> DietPlan publishDietPlan(id)

Publish a draft diet plan

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 

try {
    final response = api.publishDietPlan(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->publishDietPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**DietPlan**](DietPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **putDietLog**
> DietLog putDietLog(id, date, dietLogWrite)

Upsert a day's intake log

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 
final Date date = 2013-10-20; // Date | 
final DietLogWrite dietLogWrite = ; // DietLogWrite | 

try {
    final response = api.putDietLog(id, date, dietLogWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->putDietLog: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **date** | **Date**|  | 
 **dietLogWrite** | [**DietLogWrite**](DietLogWrite.md)|  | 

### Return type

[**DietLog**](DietLog.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **replaceDietPlanMeals**
> DietPlan replaceDietPlanMeals(id, dietPlanMealsWrite)

Replace current-version meals (inserts a new version)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 
final DietPlanMealsWrite dietPlanMealsWrite = ; // DietPlanMealsWrite | 

try {
    final response = api.replaceDietPlanMeals(id, dietPlanMealsWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->replaceDietPlanMeals: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **dietPlanMealsWrite** | [**DietPlanMealsWrite**](DietPlanMealsWrite.md)|  | 

### Return type

[**DietPlan**](DietPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateDietPlan**
> DietPlan updateDietPlan(id, dietPlanWrite)

Update diet plan metadata (requires row_version)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 
final DietPlanWrite dietPlanWrite = ; // DietPlanWrite | 

try {
    final response = api.updateDietPlan(id, dietPlanWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->updateDietPlan: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **dietPlanWrite** | [**DietPlanWrite**](DietPlanWrite.md)|  | 

### Return type

[**DietPlan**](DietPlan.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateFood**
> Food updateFood(id, foodWrite)

Update a food

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDIETApi();
final int id = 789; // int | 
final FoodWrite foodWrite = ; // FoodWrite | 

try {
    final response = api.updateFood(id, foodWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DIETApi->updateFood: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **foodWrite** | [**FoodWrite**](FoodWrite.md)|  | 

### Return type

[**Food**](Food.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

