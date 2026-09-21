import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/membership.dart';
import '../../domain/entities/membership_status.dart';
import 'membership_date.dart';
import 'membership_product_model.dart';

MembershipStatus _statusToDomain(api.MembershipStatus status) {
  return switch (status.name) {
    'active' => MembershipStatus.active,
    'expired' => MembershipStatus.expired,
    'frozen' => MembershipStatus.frozen,
    'cancelled' => MembershipStatus.cancelled,
    _ => MembershipStatus.expired,
  };
}

String statusToApi(MembershipStatus status) => status.name;

extension MembershipModelMapper on api.Membership {
  Membership toDomain() {
    return Membership(
      id: id.toString(),
      memberId: memberId.toString(),
      productId: productId.toString(),
      startDate: apiDateToDateTime(startDate),
      endDate: apiDateToDateTime(endDate),
      remainingPtSessions: remainingPtSessions,
      status: _statusToDomain(status),
      lockerNumber: lockerNumber,
      autoRenew: autoRenew,
      rowVersion: rowVersion,
      // Absent for trainer-scoped reads (FR-MEMB-007) — no pricing leak.
      product: product?.toDomain(),
    );
  }
}
