import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for MEDIAApi
void main() {
  final instance = ApiClient().getMEDIAApi();

  group(MEDIAApi, () {
    // Signed PUT slot (deferred — ADR-0005)
    //
    //Future<MediaUpload> createMediaUpload(MediaUploadRequest mediaUploadRequest) async
    test('test createMediaUpload', () async {
      // TODO
    });

    // Short-lived signed GET (deferred — ADR-0005)
    //
    //Future<MediaDownload> getMediaUrl(String key) async
    test('test getMediaUrl', () async {
      // TODO
    });

  });
}
