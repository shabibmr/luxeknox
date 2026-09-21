import 'package:api_client/api_client.dart' as api;
import 'package:app/features/dashboard/data/models/dashboard_model.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardModelMapper (client mirror of backend DSH-005 omission)', () {
    test('maps a full member section', () {
      final dashboard = api.Dashboard(
        (b) => b
          ..role = api.UserType.member
          ..member = BuiltMap<String, JsonObject?>({
            'membership': JsonObject({
              'status': 'active',
              'end_date': '2026-10-05',
              'days_remaining': 14,
            }),
            'assigned_trainer': JsonObject({'id': 7, 'name': 'Jamie Fox'}),
          }).toBuilder(),
      );

      final snapshot = dashboard.toDomain();

      expect(snapshot.role, UserType.member);
      expect(snapshot.member?.membership?.status, 'active');
      expect(snapshot.member?.membership?.daysRemaining, 14);
      expect(snapshot.member?.assignedTrainer?.name, 'Jamie Fox');
      expect(snapshot.trainer, isNull);
      expect(snapshot.admin, isNull);
    });

    test('an absent section maps to null, never an error', () {
      final dashboard = api.Dashboard((b) => b..role = api.UserType.admin);

      final snapshot = dashboard.toDomain();

      expect(snapshot.member, isNull);
      expect(snapshot.trainer, isNull);
      expect(snapshot.admin, isNull);
      expect(snapshot.isEmpty, isTrue);
    });

    test('maps the trainer section with an assigned-members preview', () {
      final dashboard = api.Dashboard(
        (b) => b
          ..role = api.UserType.trainer
          ..trainer = BuiltMap<String, JsonObject?>({
            'assigned_members_count': JsonObject(12),
            'assigned_members': JsonObject([
              {'id': 1, 'name': 'Ana Lee', 'membership_number': 'M00000001'},
            ]),
          }).toBuilder(),
      );

      final snapshot = dashboard.toDomain();

      expect(snapshot.trainer?.assignedMembersCount, 12);
      expect(snapshot.trainer?.assignedMembers, hasLength(1));
      expect(snapshot.trainer?.assignedMembers.first.name, 'Ana Lee');
    });

    test('maps the admin section aggregates', () {
      final dashboard = api.Dashboard(
        (b) => b
          ..role = api.UserType.admin
          ..admin = BuiltMap<String, JsonObject?>({
            'members_total': JsonObject(100),
            'trainers_total': JsonObject(10),
            'trainers_active': JsonObject(8),
            'employees_total': JsonObject(5),
            'employees_active': JsonObject(5),
            'memberships_by_status': JsonObject({'active': 90, 'frozen': 5}),
            'memberships_expiring_soon': JsonObject({'days': 7, 'count': 3}),
          }).toBuilder(),
      );

      final snapshot = dashboard.toDomain();

      expect(snapshot.admin?.membersTotal, 100);
      expect(snapshot.admin?.membershipsByStatus, {'active': 90, 'frozen': 5});
      expect(snapshot.admin?.expiringSoon.count, 3);
    });

    test(
      'a malformed member section (missing fields) yields a null widget, not a crash',
      () {
        final dashboard = api.Dashboard(
          (b) => b
            ..role = api.UserType.member
            ..member = BuiltMap<String, JsonObject?>({
              'membership': JsonObject({
                'status': 'active',
              }), // missing end_date/days_remaining
            }).toBuilder(),
        );

        expect(() => dashboard.toDomain(), returnsNormally);
        final snapshot = dashboard.toDomain();
        expect(snapshot.member?.membership, isNull);
      },
    );
  });
}
