import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for SYSApi
void main() {
  final instance = ApiClient().getSYSApi();

  group(SYSApi, () {
    // Timezone, currency, hours, page size
    //
    //Future<PublicSettings> getPublicSettings() async
    test('test getPublicSettings', () async {
      // TODO
    });

    // All settings or one category
    //
    //Future<SettingsList> getSettings({ SettingCategory category }) async
    test('test getSettings', () async {
      // TODO
    });

    // Append-only admin audit (no update/delete)
    //
    //Future<AuditLogPage> listAuditLogs({ int limit, String cursor, int actorUserId, String entityName, int entityId, String action, DateTime from, DateTime to }) async
    test('test listAuditLogs', () async {
      // TODO
    });

    // Upsert known setting keys
    //
    //Future<SettingsList> putSettings(SettingsWrite settingsWrite) async
    test('test putSettings', () async {
      // TODO
    });

  });
}
