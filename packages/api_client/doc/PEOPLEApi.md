# api_client.api.PEOPLEApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**assignTrainer**](PEOPLEApi.md#assigntrainer) | **POST** /members/{id}/assign-trainer | Assign or reassign a trainer
[**createEmployee**](PEOPLEApi.md#createemployee) | **POST** /employees | Create an employee
[**createMember**](PEOPLEApi.md#createmember) | **POST** /members | Onboard a member (user + profile, one transaction)
[**createTrainer**](PEOPLEApi.md#createtrainer) | **POST** /trainers | Create a trainer
[**getEmployee**](PEOPLEApi.md#getemployee) | **GET** /employees/{id} | Employee profile
[**getMember**](PEOPLEApi.md#getmember) | **GET** /members/{id} | Member dossier (role-scoped)
[**getTrainer**](PEOPLEApi.md#gettrainer) | **GET** /trainers/{id} | Trainer profile (rate hidden from members)
[**listEmployees**](PEOPLEApi.md#listemployees) | **GET** /employees | Staff directory
[**listMembers**](PEOPLEApi.md#listmembers) | **GET** /members | Member directory (scoped by role)
[**listTrainerMembers**](PEOPLEApi.md#listtrainermembers) | **GET** /trainers/{id}/members | Members assigned to a trainer
[**listTrainers**](PEOPLEApi.md#listtrainers) | **GET** /trainers | Trainer directory
[**setEmployeeStatus**](PEOPLEApi.md#setemployeestatus) | **POST** /employees/{id}/status | Change employment status; suspend revokes sessions
[**updateEmployee**](PEOPLEApi.md#updateemployee) | **PATCH** /employees/{id} | Update employee
[**updateMember**](PEOPLEApi.md#updatemember) | **PATCH** /members/{id} | Update member profile
[**updateTrainer**](PEOPLEApi.md#updatetrainer) | **PATCH** /trainers/{id} | Update trainer


# **assignTrainer**
> Member assignTrainer(id, assignTrainerRequest)

Assign or reassign a trainer

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 
final AssignTrainerRequest assignTrainerRequest = ; // AssignTrainerRequest | 

try {
    final response = api.assignTrainer(id, assignTrainerRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->assignTrainer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **assignTrainerRequest** | [**AssignTrainerRequest**](AssignTrainerRequest.md)|  | 

### Return type

[**Member**](Member.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createEmployee**
> Employee createEmployee(employeeCreate)

Create an employee

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final EmployeeCreate employeeCreate = ; // EmployeeCreate | 

try {
    final response = api.createEmployee(employeeCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->createEmployee: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **employeeCreate** | [**EmployeeCreate**](EmployeeCreate.md)|  | 

### Return type

[**Employee**](Employee.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createMember**
> Member createMember(memberCreate)

Onboard a member (user + profile, one transaction)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final MemberCreate memberCreate = ; // MemberCreate | 

try {
    final response = api.createMember(memberCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->createMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **memberCreate** | [**MemberCreate**](MemberCreate.md)|  | 

### Return type

[**Member**](Member.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createTrainer**
> Trainer createTrainer(trainerCreate)

Create a trainer

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final TrainerCreate trainerCreate = ; // TrainerCreate | 

try {
    final response = api.createTrainer(trainerCreate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->createTrainer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **trainerCreate** | [**TrainerCreate**](TrainerCreate.md)|  | 

### Return type

[**Trainer**](Trainer.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getEmployee**
> Employee getEmployee(id)

Employee profile

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 

try {
    final response = api.getEmployee(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->getEmployee: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Employee**](Employee.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMember**
> MemberDossier getMember(id)

Member dossier (role-scoped)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 

try {
    final response = api.getMember(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->getMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MemberDossier**](MemberDossier.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getTrainer**
> Trainer getTrainer(id)

Trainer profile (rate hidden from members)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 

try {
    final response = api.getTrainer(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->getTrainer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Trainer**](Trainer.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listEmployees**
> EmployeePage listEmployees(limit, offset, q)

Staff directory

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String q = q_example; // String | Case-insensitive search (FR-API-014).

try {
    final response = api.listEmployees(limit, offset, q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->listEmployees: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **q** | **String**| Case-insensitive search (FR-API-014). | [optional] 

### Return type

[**EmployeePage**](EmployeePage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMembers**
> MemberPage listMembers(limit, offset, cursor, q, sort, status, membershipStatus, assignedTrainerId)

Member directory (scoped by role)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String cursor = cursor_example; // String | Opaque cursor on (created_at, id) for feeds.
final String q = q_example; // String | Case-insensitive search (FR-API-014).
final String sort = created_at:desc; // String | 
final UserStatus status = ; // UserStatus | 
final String membershipStatus = membershipStatus_example; // String | 
final int assignedTrainerId = 789; // int | 

try {
    final response = api.listMembers(limit, offset, cursor, q, sort, status, membershipStatus, assignedTrainerId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->listMembers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **cursor** | **String**| Opaque cursor on (created_at, id) for feeds. | [optional] 
 **q** | **String**| Case-insensitive search (FR-API-014). | [optional] 
 **sort** | **String**|  | [optional] 
 **status** | [**UserStatus**](.md)|  | [optional] 
 **membershipStatus** | **String**|  | [optional] 
 **assignedTrainerId** | **int**|  | [optional] 

### Return type

[**MemberPage**](MemberPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTrainerMembers**
> MemberPage listTrainerMembers(id, limit, offset)

Members assigned to a trainer

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.

try {
    final response = api.listTrainerMembers(id, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->listTrainerMembers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 

### Return type

[**MemberPage**](MemberPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listTrainers**
> TrainerPage listTrainers(limit, offset, q)

Trainer directory

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.
final String q = q_example; // String | Case-insensitive search (FR-API-014).

try {
    final response = api.listTrainers(limit, offset, q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->listTrainers: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 
 **q** | **String**| Case-insensitive search (FR-API-014). | [optional] 

### Return type

[**TrainerPage**](TrainerPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setEmployeeStatus**
> Employee setEmployeeStatus(id, employeeStatusRequest)

Change employment status; suspend revokes sessions

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 
final EmployeeStatusRequest employeeStatusRequest = ; // EmployeeStatusRequest | 

try {
    final response = api.setEmployeeStatus(id, employeeStatusRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->setEmployeeStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **employeeStatusRequest** | [**EmployeeStatusRequest**](EmployeeStatusRequest.md)|  | 

### Return type

[**Employee**](Employee.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateEmployee**
> Employee updateEmployee(id, employeeUpdate)

Update employee

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 
final EmployeeUpdate employeeUpdate = ; // EmployeeUpdate | 

try {
    final response = api.updateEmployee(id, employeeUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->updateEmployee: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **employeeUpdate** | [**EmployeeUpdate**](EmployeeUpdate.md)|  | 

### Return type

[**Employee**](Employee.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateMember**
> Member updateMember(id, memberUpdate)

Update member profile

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 
final MemberUpdate memberUpdate = ; // MemberUpdate | 

try {
    final response = api.updateMember(id, memberUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->updateMember: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **memberUpdate** | [**MemberUpdate**](MemberUpdate.md)|  | 

### Return type

[**Member**](Member.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateTrainer**
> Trainer updateTrainer(id, trainerUpdate)

Update trainer

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getPEOPLEApi();
final int id = 789; // int | 
final TrainerUpdate trainerUpdate = ; // TrainerUpdate | 

try {
    final response = api.updateTrainer(id, trainerUpdate);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PEOPLEApi->updateTrainer: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **trainerUpdate** | [**TrainerUpdate**](TrainerUpdate.md)|  | 

### Return type

[**Trainer**](Trainer.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

