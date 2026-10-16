import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for INVApi
void main() {
  final instance = ApiClient().getINVApi();

  group(INVApi, () {
    // Get inventory item by ID
    //
    //Future<InventoryItem> getInventoryItem(int id) async
    test('test getInventoryItem', () async {
      // TODO
    });

    // List inventory items
    //
    //Future<InventoryItemPage> listInventoryItems({ int limit, int offset, String cursor, String search, ItemKind itemKind, int categoryId, bool isActive, bool inventoryTracked }) async
    test('test listInventoryItems', () async {
      // TODO
    });

  });
}
