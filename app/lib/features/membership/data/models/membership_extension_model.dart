import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/membership_extension.dart';

extension MembershipExtensionModelMapper on api.MembershipExtension {
  MembershipExtension toDomain() {
    return MembershipExtension(
      id: id.toString(),
      membershipId: membershipId.toString(),
      daysExtended: daysExtended,
      reason: reason,
      grantedByUserId: grantedByUserId.toString(),
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
