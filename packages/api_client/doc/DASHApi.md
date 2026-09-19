# api_client.api.DASHApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getDashboard**](DASHApi.md#getdashboard) | **GET** /dashboard | Role-specific home snapshot; unauthorized widgets omitted


# **getDashboard**
> Dashboard getDashboard()

Role-specific home snapshot; unauthorized widgets omitted

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getDASHApi();

try {
    final response = api.getDashboard();
    print(response);
} on DioException catch (e) {
    print('Exception when calling DASHApi->getDashboard: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Dashboard**](Dashboard.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

