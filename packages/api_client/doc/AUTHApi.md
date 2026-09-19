# api_client.api.AUTHApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**changePassword**](AUTHApi.md#changepassword) | **POST** /auth/password/change | Change password; invalidates other sessions
[**forgotPassword**](AUTHApi.md#forgotpassword) | **POST** /auth/password/forgot | Request a password-reset token
[**getMe**](AUTHApi.md#getme) | **GET** /me | Current user, role, permission slugs, profile summary
[**login**](AUTHApi.md#login) | **POST** /auth/login | Login with email or phone + password
[**logout**](AUTHApi.md#logout) | **POST** /auth/logout | Revoke current session
[**refreshSession**](AUTHApi.md#refreshsession) | **POST** /auth/refresh | Rotate refresh token; reuse revokes the family
[**resetPassword**](AUTHApi.md#resetpassword) | **POST** /auth/password/reset | Consume a one-time reset token


# **changePassword**
> changePassword(changePasswordRequest)

Change password; invalidates other sessions

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAUTHApi();
final ChangePasswordRequest changePasswordRequest = ; // ChangePasswordRequest | 

try {
    api.changePassword(changePasswordRequest);
} on DioException catch (e) {
    print('Exception when calling AUTHApi->changePassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **changePasswordRequest** | [**ChangePasswordRequest**](ChangePasswordRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **forgotPassword**
> forgotPassword(forgotPasswordRequest)

Request a password-reset token

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAUTHApi();
final ForgotPasswordRequest forgotPasswordRequest = ; // ForgotPasswordRequest | 

try {
    api.forgotPassword(forgotPasswordRequest);
} on DioException catch (e) {
    print('Exception when calling AUTHApi->forgotPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **forgotPasswordRequest** | [**ForgotPasswordRequest**](ForgotPasswordRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMe**
> MeResponse getMe()

Current user, role, permission slugs, profile summary

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAUTHApi();

try {
    final response = api.getMe();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AUTHApi->getMe: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MeResponse**](MeResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> SessionResponse login(loginRequest)

Login with email or phone + password

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAUTHApi();
final LoginRequest loginRequest = ; // LoginRequest | 

try {
    final response = api.login(loginRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AUTHApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginRequest** | [**LoginRequest**](LoginRequest.md)|  | 

### Return type

[**SessionResponse**](SessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> logout(logoutRequest)

Revoke current session

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAUTHApi();
final LogoutRequest logoutRequest = ; // LogoutRequest | 

try {
    api.logout(logoutRequest);
} on DioException catch (e) {
    print('Exception when calling AUTHApi->logout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **logoutRequest** | [**LogoutRequest**](LogoutRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshSession**
> SessionResponse refreshSession(refreshRequest)

Rotate refresh token; reuse revokes the family

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAUTHApi();
final RefreshRequest refreshRequest = ; // RefreshRequest | 

try {
    final response = api.refreshSession(refreshRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling AUTHApi->refreshSession: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshRequest** | [**RefreshRequest**](RefreshRequest.md)|  | 

### Return type

[**SessionResponse**](SessionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPassword**
> resetPassword(resetPasswordRequest)

Consume a one-time reset token

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAUTHApi();
final ResetPasswordRequest resetPasswordRequest = ; // ResetPasswordRequest | 

try {
    api.resetPassword(resetPasswordRequest);
} on DioException catch (e) {
    print('Exception when calling AUTHApi->resetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resetPasswordRequest** | [**ResetPasswordRequest**](ResetPasswordRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

