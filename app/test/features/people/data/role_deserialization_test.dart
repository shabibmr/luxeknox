import 'package:api_client/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('deserializing Role from backend JSON', () {
    final json = {
      'id': 1,
      'name': 'Super Admin',
      'slug': 'super_admin',
      'description': 'System owner',
      'is_system': true,
      'created_at': '2026-10-10T14:00:00Z',
      'updated_at': '2026-10-10T14:00:00Z',
      'permissions': [],
    };

    expect(() {
      standardSerializers.deserializeWith(Role.serializer, json);
    }, returnsNormally);
  });

  test('deserializing Employee with null job_title from backend JSON', () {
    final json = {
      'id': 1,
      'user_id': 2,
      'first_name': 'John',
      'last_name': 'Doe',
      'gender': 'male',
      'job_title': null,
      'department': 'Ops',
      'hire_date': '2026-01-01',
      'status': 'active',
      'role_id': 1,
    };

    expect(() {
      standardSerializers.deserializeWith(Employee.serializer, json);
    }, returnsNormally);
  });
}
