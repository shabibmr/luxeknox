# api_client.api.MEDIAApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createMediaUpload**](MEDIAApi.md#createmediaupload) | **POST** /media/uploads | Signed PUT slot (deferred — ADR-0005)
[**getMediaUrl**](MEDIAApi.md#getmediaurl) | **GET** /media/{key} | Short-lived signed GET (deferred — ADR-0005)


# **createMediaUpload**
> MediaUpload createMediaUpload(mediaUploadRequest)

Signed PUT slot (deferred — ADR-0005)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEDIAApi();
final MediaUploadRequest mediaUploadRequest = ; // MediaUploadRequest | 

try {
    final response = api.createMediaUpload(mediaUploadRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEDIAApi->createMediaUpload: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **mediaUploadRequest** | [**MediaUploadRequest**](MediaUploadRequest.md)|  | 

### Return type

[**MediaUpload**](MediaUpload.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMediaUrl**
> MediaDownload getMediaUrl(key)

Short-lived signed GET (deferred — ADR-0005)

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEDIAApi();
final String key = key_example; // String | 

try {
    final response = api.getMediaUrl(key);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEDIAApi->getMediaUrl: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  | 

### Return type

[**MediaDownload**](MediaDownload.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

