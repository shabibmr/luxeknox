import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/membership_replacement_preview.dart';
import '../../domain/entities/membership_status.dart';
import 'membership_date.dart';

extension MembershipReplacementPreviewModelMapper
    on api.MembershipReplacementPreview {
  MembershipReplacementPreview toDomain() {
    return MembershipReplacementPreview(
      membershipId: membershipId.toString(),
      productName: productName,
      status: MembershipStatus.values.firstWhere(
        (s) => s.name == status.name,
        orElse: () => MembershipStatus.expired,
      ),
      endDate: apiDateToDateTime(endDate),
      remainingDays: remainingDays,
      isCouple: isCouple,
      suggestedCredit: suggestedCredit,
    );
  }
}
