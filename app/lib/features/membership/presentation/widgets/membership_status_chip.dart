import 'package:flutter/material.dart';

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
      MembershipStatus.expired => (MembershipStrings.statusExpired, scheme.error),
      MembershipStatus.frozen => (MembershipStrings.statusFrozen, Colors.blueGrey),
      MembershipStatus.cancelled => (MembershipStrings.statusCancelled, scheme.error),
    };
    return Chip(
      label: Text(label),
      backgroundColor: color.withValues(alpha: 0.15),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
      side: BorderSide.none,
    );
  }
}
