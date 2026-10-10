# api_client.api.MEDIAApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createMediaUpload**](MEDIAApi.md#createmediaupload) | **POST** /media/uploads | Signed PUT slot (ADR-0008)
[**getMediaObject**](MEDIAApi.md#getmediaobject) | **GET** /media/objects | Local adapter signed GET (ADR-0008 HMAC query auth)
[**getMediaUrl**](MEDIAApi.md#getmediaurl) | **GET** /media/{key} | Short-lived signed GET (ADR-0008)
[**putMediaObject**](MEDIAApi.md#putmediaobject) | **PUT** /media/objects | Local adapter signed PUT (ADR-0008 HMAC query auth)


# **createMediaUpload**
> MediaUpload createMediaUpload(mediaUploadRequest)

Signed PUT slot (ADR-0008)

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

# **getMediaObject**
> Uint8List getMediaObject(key, expires, sig)

Local adapter signed GET (ADR-0008 HMAC query auth)

Local-disk signed download target. Auth is HMAC query signature (key, expires, sig), not Bearer. Returns raw object bytes. 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEDIAApi();
final String key = key_example; // String | 
final String expires = expires_example; // String | 
final String sig = sig_example; // String | 

try {
    final response = api.getMediaObject(key, expires, sig);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MEDIAApi->getMediaObject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  | 
 **expires** | **String**|  | 
 **sig** | **String**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/octet-stream, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMediaUrl**
> MediaDownload getMediaUrl(key)

Short-lived signed GET (ADR-0008)

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

# **putMediaObject**
> putMediaObject(key, expires, sig, contentType, body)

Local adapter signed PUT (ADR-0008 HMAC query auth)

Local-disk signed upload target. Auth is HMAC query signature (key, expires, sig, content_type), not Bearer. Returns 204. 

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getMEDIAApi();
final String key = key_example; // String | 
final String expires = expires_example; // String | 
final String sig = sig_example; // String | 
final String contentType = contentType_example; // String | 
final MultipartFile body = BINARY_DATA_HERE; // MultipartFile | 

try {
    api.putMediaObject(key, expires, sig, contentType, body);
} on DioException catch (e) {
    print('Exception when calling MEDIAApi->putMediaObject: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **key** | **String**|  | 
 **expires** | **String**|  | 
 **sig** | **String**|  | 
 **contentType** | **String**|  | 
 **body** | **MultipartFile**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/octet-stream
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

