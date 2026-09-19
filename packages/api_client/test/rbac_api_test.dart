import 'package:test/test.dart';
import 'package:api_client/api_client.dart';


/// tests for RBACApi
void main() {
  final instance = ApiClient().getRBACApi();

  group(RBACApi, () {
    // Assign exactly one role
    //
    //Future<Employee> assignEmployeeRole(int id, AssignRoleRequest assignRoleRequest) async
    test('test assignEmployeeRole', () async {
      // TODO
    });

    // Create a custom role
    //
    //Future<Role> createRole(RoleWrite roleWrite) async
    test('test createRole', () async {
      // TODO
    });

    // Get a role and its permissions
    //
    //Future<Role> getRole(int id) async
    test('test getRole', () async {
      // TODO
    });

    // List permission catalog
    //
    //Future<PermissionPage> listPermissions() async
    test('test listPermissions', () async {
      // TODO
    });

    // List roles
    //
    //Future<RolePage> listRoles({ int limit, int offset }) async
    test('test listRoles', () async {
      // TODO
    });

    // Replace permission set on a non-system role
    //
    //Future<Role> replaceRolePermissions(int id, RolePermissionsWrite rolePermissionsWrite) async
    test('test replaceRolePermissions', () async {
      // TODO
    });

    // Update a non-system role
    //
    //Future<Role> updateRole(int id, RoleWrite roleWrite) async
    test('test updateRole', () async {
      // TODO
    });

  });
}
