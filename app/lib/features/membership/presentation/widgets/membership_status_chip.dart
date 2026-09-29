import 'package:flutter/material.dart';

import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/membership_status.dart';
import '../membership_strings.dart';

class MembershipStatusChip extends StatelessWidget {
  const MembershipStatusChip({super.key, required this.status});

  final MembershipStatus status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (label, color) = switch (status) {
      MembershipStatus.active => (MembershipStrings.statusActive, Colors.green),
      MembershipStatus.expired => (
        MembershipStrings.statusExpired,
        scheme.error,
      ),
      MembershipStatus.frozen => (
        MembershipStrings.statusFrozen,
        Colors.blueGrey,
      ),
      MembershipStatus.cancelled => (
        MembershipStrings.statusCancelled,
        scheme.error,
      ),
    };
    return AppStatusChip(label: label, color: color);
  }
}
