import 'package:test/test.dart';
import 'package:api_client/api_client.dart';

void main() {
  group(RolePage, () {
    test('deserializes roles with permissions containing custom actions', () {
      final jsonMap = {
        'data': [
          {
            'id': 1,
            'name': 'Super Admin',
            'is_system_role': true,
            'permissions': [
              {
                'id': 1,
                'module': 'AUTH',
                'action': 'login',
                'slug': 'auth.login',
              },
              {
                'id': 6,
                'module': 'RBAC',
                'action': 'roles_read',
                'slug': 'rbac.roles_read',
              },
            ],
          },
        ],
        'meta': {
          'limit': 100,
          'offset': 0,
          'has_more': false,
        },
      };

      final rolePage = standardSerializers.deserializeWith(
        RolePage.serializer,
        jsonMap,
      );

      expect(rolePage, isNotNull);
      expect(rolePage!.data.length, 1);
      expect(rolePage.data.first.permissions!.length, 2);
      expect(rolePage.data.first.permissions!.first.action, 'login');
      expect(rolePage.data.first.permissions!.last.action, 'roles_read');
    });
  });
}
