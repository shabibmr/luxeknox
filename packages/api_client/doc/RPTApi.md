# api_client.api.RPTApi

## Load the API package
```dart
import 'package:api_client/api.dart';
```

All URIs are relative to *http://localhost:3000/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getReport**](RPTApi.md#getreport) | **GET** /reports/{type} | Analytics report


# **getReport**
> Report getReport(type, from, to, productId, trainerId, format)

Analytics report

### Example
```dart
import 'package:api_client/api.dart';

final api = ApiClient().getRPTApi();
final ReportType type = ; // ReportType | 
final Date from = 2013-10-20; // Date | 
final Date to = 2013-10-20; // Date | 
final int productId = 789; // int | 
final int trainerId = 789; // int | 
final String format = format_example; // String | PDF export is a later addition

try {
    final response = api.getReport(type, from, to, productId, trainerId, format);
    print(response);
} on DioException catch (e) {
    print('Exception when calling RPTApi->getReport: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **type** | [**ReportType**](.md)|  | 
 **from** | **Date**|  | [optional] 
 **to** | **Date**|  | [optional] 
 **productId** | **int**|  | [optional] 
 **trainerId** | **int**|  | [optional] 
 **format** | **String**| PDF export is a later addition | [optional] 

### Return type

[**Report**](Report.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

