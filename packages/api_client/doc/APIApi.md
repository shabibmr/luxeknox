# api_client.api.APIApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getHealth**](APIApi.md#gethealth) | **GET** /health | Process liveness
[**getReady**](APIApi.md#getready) | **GET** /ready | Database readiness


# **getHealth**
> Health getHealth()

Process liveness

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAPIApi();

try {
    final response = api.getHealth();
    print(response);
} on DioException catch (e) {
    print('Exception when calling APIApi->getHealth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Health**](Health.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getReady**
> Ready getReady()

Database readiness

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getAPIApi();

try {
    final response = api.getReady();
    print(response);
} on DioException catch (e) {
    print('Exception when calling APIApi->getReady: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Ready**](Ready.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

