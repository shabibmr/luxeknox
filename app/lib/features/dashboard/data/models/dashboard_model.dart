import 'package:api_client/api_client.dart' as api;
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';

import '../../../../session/domain/entities/user_type.dart';
import '../../domain/entities/dashboard_snapshot.dart';

/// The `Dashboard` schema is intentionally loosely typed server-side
/// (`additionalProperties: true`, `member`/`trainer`/`admin` are generic
/// maps — see `docs/openapi/v1.yaml` `Dashboard`), so every read here treats
/// a missing or malformed field as "section unavailable" rather than throwing.
extension DashboardModelMapper on api.Dashboard {
  DashboardSnapshot toDomain() {
    return DashboardSnapshot(
      role: _mapRole(role),
      member: _mapMember(member),
      trainer: _mapTrainer(trainer),
      admin: _mapAdmin(admin),
    );
  }
}

UserType? _mapRole(api.UserType? role) {
  if (role == null) return null;
  return switch (role.name) {
    'member' => UserType.member,
    'trainer' => UserType.trainer,
    'employee' => UserType.employee,
    'admin' => UserType.admin,
    _ => null,
  };
}

Map<String, Object?>? _asMap(JsonObject? object) {
  if (object == null || !object.isMap) return null;
  return object.asMap.cast<String, Object?>();
}

List<Object?>? _asList(JsonObject? object) {
  if (object == null || !object.isList) return null;
  return object.asList;
}

String? _asString(Object? value) => value is String ? value : null;

int? _asInt(Object? value) {
  if (value is num) return value.round();
  return null;
}

DashboardMemberWidget? _mapMember(BuiltMap<String, JsonObject?>? section) {
  if (section == null) return null;

  DashboardMembershipSummary? membership;
  final membershipMap = _asMap(section['membership']);
  if (membershipMap != null) {
    final status = _asString(membershipMap['status']);
    final endDate = _asString(membershipMap['end_date']);
    final daysRemaining = _asInt(membershipMap['days_remaining']);
    if (status != null && endDate != null && daysRemaining != null) {
      membership = DashboardMembershipSummary(
        status: status,
        endDate: endDate,
        daysRemaining: daysRemaining,
      );
    }
  }

  DashboardAssignedTrainer? assignedTrainer;
  final trainerMap = _asMap(section['assigned_trainer']);
  if (trainerMap != null) {
    final id = _asInt(trainerMap['id']);
    final name = _asString(trainerMap['name']);
    if (id != null && name != null) {
      assignedTrainer = DashboardAssignedTrainer(id: id.toString(), name: name);
    }
  }

  if (membership == null && assignedTrainer == null) return null;
  return DashboardMemberWidget(
    membership: membership,
    assignedTrainer: assignedTrainer,
  );
}

DashboardTrainerWidget? _mapTrainer(BuiltMap<String, JsonObject?>? section) {
  if (section == null) return null;

  final count = _asInt(section['assigned_members_count']?.value) ?? 0;
  final previewList = _asList(section['assigned_members']) ?? const [];
  final previews = <DashboardAssignedMemberPreview>[];
  for (final entry in previewList) {
    if (entry is! Map) continue;
    final id = _asInt(entry['id']);
    final name = _asString(entry['name']);
    final membershipNumber = _asString(entry['membership_number']);
    if (id == null || name == null) continue;
    previews.add(
      DashboardAssignedMemberPreview(
        id: id.toString(),
        name: name,
        membershipNumber: membershipNumber ?? '',
      ),
    );
  }

  return DashboardTrainerWidget(
    assignedMembersCount: count,
    assignedMembers: previews,
  );
}

DashboardAdminWidget? _mapAdmin(BuiltMap<String, JsonObject?>? section) {
  if (section == null) return null;

  final membershipsByStatusMap =
      _asMap(section['memberships_by_status']) ?? const {};
  final membershipsByStatus = <String, int>{
    for (final entry in membershipsByStatusMap.entries)
      if (_asInt(entry.value) != null) entry.key: _asInt(entry.value)!,
  };

  final expiringSoonMap = _asMap(section['memberships_expiring_soon']);
  final expiringSoon = DashboardExpiringSoon(
    days: _asInt(expiringSoonMap?['days']) ?? 0,
    count: _asInt(expiringSoonMap?['count']) ?? 0,
  );

  return DashboardAdminWidget(
    membersTotal: _asInt(section['members_total']?.value) ?? 0,
    trainersTotal: _asInt(section['trainers_total']?.value) ?? 0,
    trainersActive: _asInt(section['trainers_active']?.value) ?? 0,
    employeesTotal: _asInt(section['employees_total']?.value) ?? 0,
    employeesActive: _asInt(section['employees_active']?.value) ?? 0,
    membershipsByStatus: membershipsByStatus,
    expiringSoon: expiringSoon,
  );
}
