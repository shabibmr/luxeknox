import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/membership_history_entry.dart';
import '../../domain/entities/membership_status.dart';
import 'membership_date.dart';

MembershipHistoryAction _actionToDomain(api.MembershipHistoryActionEnum action) {
  return switch (action.name) {
    'created' => MembershipHistoryAction.created,
    'renewed' => MembershipHistoryAction.renewed,
    'upgraded' => MembershipHistoryAction.upgraded,
    'frozen' => MembershipHistoryAction.frozen,
    'expired' => MembershipHistoryAction.expired,
    'cancelled' => MembershipHistoryAction.cancelled,
    'extended' => MembershipHistoryAction.extended,
    _ => MembershipHistoryAction.created,
  };
}

extension MembershipHistoryModelMapper on api.MembershipHistory {
  MembershipHistoryEntry toDomain() {
    return MembershipHistoryEntry(
      id: id.toString(),
      membershipId: membershipId.toString(),
      action: _actionToDomain(action),
      oldEndDate: oldEndDate == null ? null : apiDateToDateTime(oldEndDate!),
      newEndDate: newEndDate == null ? null : apiDateToDateTime(newEndDate!),
      performedByUserId: (performedByUserId ?? 0).toString(),
      timestamp: timestamp,
    );
  }
}
