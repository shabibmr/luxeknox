import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/membership_freeze.dart';
import '../../domain/entities/membership_status.dart';
import 'membership_date.dart';

FreezeStatus _freezeStatusToDomain(api.MembershipFreezeStatusEnum status) {
  return switch (status.name) {
    'pending' => FreezeStatus.pending,
    'approved' => FreezeStatus.approved,
    'rejected' => FreezeStatus.rejected,
    _ => FreezeStatus.pending,
  };
}

extension MembershipFreezeModelMapper on api.MembershipFreeze {
  MembershipFreeze toDomain() {
    return MembershipFreeze(
      id: id.toString(),
      membershipId: membershipId.toString(),
      startDate: apiDateToDateTime(startDate),
      endDate: apiDateToDateTime(endDate),
      totalFreezeDays: totalFreezeDays,
      reason: reason,
      status: _freezeStatusToDomain(status),
      reviewedByUserId: reviewedByUserId?.toString(),
      reviewedAt: reviewedAt,
    );
  }
}
