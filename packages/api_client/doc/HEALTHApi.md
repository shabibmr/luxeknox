# api_client.api.HEALTHApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createEmergencyContact**](HEALTHApi.md#createemergencycontact) | **POST** /users/{id}/emergency-contacts | Add an emergency contact
[**createHealthCondition**](HEALTHApi.md#createhealthcondition) | **POST** /health-conditions | Create a condition
[**createMedicalHistory**](HEALTHApi.md#createmedicalhistory) | **POST** /members/{id}/medical-histories | Add a medical history row
[**createMemberDocument**](HEALTHApi.md#creatememberdocument) | **POST** /members/{id}/documents | Attach a document metadata row
[**createMemberPhoto**](HEALTHApi.md#creatememberphoto) | **POST** /members/{id}/photos | Add a gallery photo
[**deleteEmergencyContact**](HEALTHApi.md#deleteemergencycontact) | **DELETE** /users/{id}/emergency-contacts/{contactId} | Remove an emergency contact
[**deleteMedicalHistory**](HEALTHApi.md#deletemedicalhistory) | **DELETE** /members/{id}/medical-histories/{historyId} | Soft-remove a medical history row
[**deleteMemberDocument**](HEALTHApi.md#deletememberdocument) | **DELETE** /members/{id}/documents/{documentId} | Delete a document row
[**getMemberHealth**](HEALTHApi.md#getmemberhealth) | **GET** /members/{id}/health | Current health row
[**listEmergencyContacts**](HEALTHApi.md#listemergencycontacts) | **GET** /users/{id}/emergency-contacts | Emergency contacts for a user
[**listHealthConditions**](HEALTHApi.md#listhealthconditions) | **GET** /health-conditions | Condition catalog
[**listMedicalHistories**](HEALTHApi.md#listmedicalhistories) | **GET** /members/{id}/medical-histories | Medical history list
[**listMemberDocuments**](HEALTHApi.md#listmemberdocuments) | **GET** /members/{id}/documents | Member documents
[**listMemberPhotos**](HEALTHApi.md#listmemberphotos) | **GET** /members/{id}/photos | Member gallery
[**putMemberHealth**](HEALTHApi.md#putmemberhealth) | **PUT** /members/{id}/health | Replace current health row
[**setMemberAvatar**](HEALTHApi.md#setmemberavatar) | **POST** /members/{id}/photos/{photoId}/avatar | Set current avatar from a gallery shot
[**updateEmergencyContact**](HEALTHApi.md#updateemergencycontact) | **PATCH** /users/{id}/emergency-contacts/{contactId} | Update an emergency contact
[**updateHealthCondition**](HEALTHApi.md#updatehealthcondition) | **PATCH** /health-conditions/{id} | Update a condition
[**updateMedicalHistory**](HEALTHApi.md#updatemedicalhistory) | **PATCH** /members/{id}/medical-histories/{historyId} | Update a medical history row
[**verifyMemberDocument**](HEALTHApi.md#verifymemberdocument) | **POST** /members/{id}/documents/{documentId}/verify | Verify a document


# **createEmergencyContact**
> EmergencyContact createEmergencyContact(id, emergencyContactWrite)

Add an emergency contact

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final EmergencyContactWrite emergencyContactWrite = ; // EmergencyContactWrite | 

try {
    final response = api.createEmergencyContact(id, emergencyContactWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->createEmergencyContact: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **emergencyContactWrite** | [**EmergencyContactWrite**](EmergencyContactWrite.md)|  | 

### Return type

[**EmergencyContact**](EmergencyContact.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createHealthCondition**
> HealthCondition createHealthCondition(healthConditionWrite)

Create a condition

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final HealthConditionWrite healthConditionWrite = ; // HealthConditionWrite | 

try {
    final response = api.createHealthCondition(healthConditionWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->createHealthCondition: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **healthConditionWrite** | [**HealthConditionWrite**](HealthConditionWrite.md)|  | 

### Return type

[**HealthCondition**](HealthCondition.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createMedicalHistory**
> MedicalHistory createMedicalHistory(id, medicalHistoryWrite)

Add a medical history row

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final MedicalHistoryWrite medicalHistoryWrite = ; // MedicalHistoryWrite | 

try {
    final response = api.createMedicalHistory(id, medicalHistoryWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->createMedicalHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **medicalHistoryWrite** | [**MedicalHistoryWrite**](MedicalHistoryWrite.md)|  | 

### Return type

[**MedicalHistory**](MedicalHistory.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createMemberDocument**
> MemberDocument createMemberDocument(id, memberDocumentWrite)

Attach a document metadata row

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final MemberDocumentWrite memberDocumentWrite = ; // MemberDocumentWrite | 

try {
    final response = api.createMemberDocument(id, memberDocumentWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->createMemberDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **memberDocumentWrite** | [**MemberDocumentWrite**](MemberDocumentWrite.md)|  | 

### Return type

[**MemberDocument**](MemberDocument.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createMemberPhoto**
> MemberPhoto createMemberPhoto(id, memberPhotoWrite)

Add a gallery photo

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final MemberPhotoWrite memberPhotoWrite = ; // MemberPhotoWrite | 

try {
    final response = api.createMemberPhoto(id, memberPhotoWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->createMemberPhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **memberPhotoWrite** | [**MemberPhotoWrite**](MemberPhotoWrite.md)|  | 

### Return type

[**MemberPhoto**](MemberPhoto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteEmergencyContact**
> deleteEmergencyContact(id, contactId)

Remove an emergency contact

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final int contactId = 789; // int | 

try {
    api.deleteEmergencyContact(id, contactId);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->deleteEmergencyContact: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **contactId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteMedicalHistory**
> deleteMedicalHistory(id, historyId)

Soft-remove a medical history row

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final int historyId = 789; // int | 

try {
    api.deleteMedicalHistory(id, historyId);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->deleteMedicalHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **historyId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteMemberDocument**
> deleteMemberDocument(id, documentId)

Delete a document row

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final int documentId = 789; // int | 

try {
    api.deleteMemberDocument(id, documentId);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->deleteMemberDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **documentId** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMemberHealth**
> MemberHealth getMemberHealth(id)

Current health row

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 

try {
    final response = api.getMemberHealth(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->getMemberHealth: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MemberHealth**](MemberHealth.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listEmergencyContacts**
> EmergencyContactPage listEmergencyContacts(id)

Emergency contacts for a user

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 

try {
    final response = api.listEmergencyContacts(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->listEmergencyContacts: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**EmergencyContactPage**](EmergencyContactPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listHealthConditions**
> HealthConditionPage listHealthConditions(limit, offset)

Condition catalog

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.

try {
    final response = api.listHealthConditions(limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->listHealthConditions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 

### Return type

[**HealthConditionPage**](HealthConditionPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMedicalHistories**
> MedicalHistoryPage listMedicalHistories(id, limit, offset)

Medical history list

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final int limit = 56; // int | Default from gym_settings pagination.default_page_size.
final int offset = 56; // int | Admin tables that need page numbers.

try {
    final response = api.listMedicalHistories(id, limit, offset);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->listMedicalHistories: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **limit** | **int**| Default from gym_settings pagination.default_page_size. | [optional] 
 **offset** | **int**| Admin tables that need page numbers. | [optional] 

### Return type

[**MedicalHistoryPage**](MedicalHistoryPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMemberDocuments**
> MemberDocumentPage listMemberDocuments(id)

Member documents

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 

try {
    final response = api.listMemberDocuments(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->listMemberDocuments: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MemberDocumentPage**](MemberDocumentPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **listMemberPhotos**
> MemberPhotoPage listMemberPhotos(id)

Member gallery

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 

try {
    final response = api.listMemberPhotos(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->listMemberPhotos: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**MemberPhotoPage**](MemberPhotoPage.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **putMemberHealth**
> MemberHealth putMemberHealth(id, memberHealthWrite)

Replace current health row

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final MemberHealthWrite memberHealthWrite = ; // MemberHealthWrite | 

try {
    final response = api.putMemberHealth(id, memberHealthWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->putMemberHealth: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **memberHealthWrite** | [**MemberHealthWrite**](MemberHealthWrite.md)|  | 

### Return type

[**MemberHealth**](MemberHealth.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setMemberAvatar**
> MemberPhoto setMemberAvatar(id, photoId)

Set current avatar from a gallery shot

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final int photoId = 789; // int | 

try {
    final response = api.setMemberAvatar(id, photoId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->setMemberAvatar: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **photoId** | **int**|  | 

### Return type

[**MemberPhoto**](MemberPhoto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateEmergencyContact**
> EmergencyContact updateEmergencyContact(id, contactId, emergencyContactWrite)

Update an emergency contact

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final int contactId = 789; // int | 
final EmergencyContactWrite emergencyContactWrite = ; // EmergencyContactWrite | 

try {
    final response = api.updateEmergencyContact(id, contactId, emergencyContactWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->updateEmergencyContact: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **contactId** | **int**|  | 
 **emergencyContactWrite** | [**EmergencyContactWrite**](EmergencyContactWrite.md)|  | 

### Return type

[**EmergencyContact**](EmergencyContact.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateHealthCondition**
> HealthCondition updateHealthCondition(id, healthConditionWrite)

Update a condition

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final HealthConditionWrite healthConditionWrite = ; // HealthConditionWrite | 

try {
    final response = api.updateHealthCondition(id, healthConditionWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->updateHealthCondition: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **healthConditionWrite** | [**HealthConditionWrite**](HealthConditionWrite.md)|  | 

### Return type

[**HealthCondition**](HealthCondition.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateMedicalHistory**
> MedicalHistory updateMedicalHistory(id, historyId, medicalHistoryWrite)

Update a medical history row

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final int historyId = 789; // int | 
final MedicalHistoryWrite medicalHistoryWrite = ; // MedicalHistoryWrite | 

try {
    final response = api.updateMedicalHistory(id, historyId, medicalHistoryWrite);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->updateMedicalHistory: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **historyId** | **int**|  | 
 **medicalHistoryWrite** | [**MedicalHistoryWrite**](MedicalHistoryWrite.md)|  | 

### Return type

[**MedicalHistory**](MedicalHistory.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyMemberDocument**
> MemberDocument verifyMemberDocument(id, documentId)

Verify a document

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getHEALTHApi();
final int id = 789; // int | 
final int documentId = 789; // int | 

try {
    final response = api.verifyMemberDocument(id, documentId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling HEALTHApi->verifyMemberDocument: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **documentId** | **int**|  | 

### Return type

[**MemberDocument**](MemberDocument.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

