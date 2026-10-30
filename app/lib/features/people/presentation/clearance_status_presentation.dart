import 'package:flutter/material.dart';

import '../domain/entities/par_q_screening.dart';
import 'people_strings.dart';

/// Colour, icon, and wording for a PAR-Q+ clearance status. Shared by the
/// screening form and the dossier banner so the two surfaces cannot disagree.
class ClearanceStatusPresentation {
  const ClearanceStatusPresentation({
    required this.color,
    required this.icon,
    required this.bannerLabel,
    this.bannerKey,
    this.formTitle,
    this.formBody,
  });

  final Color color;
  final IconData icon;
  final String bannerLabel;
  final Key? bannerKey;
  final String? formTitle;
  final String? formBody;

  static ClearanceStatusPresentation resolve({
    required ColorScheme scheme,
    ParQClearanceStatus? status,
    bool unavailable = false,
  }) {
    if (unavailable) {
      return ClearanceStatusPresentation(
        color: scheme.outline,
        icon: Icons.help_outline,
        bannerLabel: PeopleStrings.clearanceUnavailable,
        bannerKey: const ValueKey('clearance-neutral'),
      );
    }

    return switch (status) {
      ParQClearanceStatus.passed => const ClearanceStatusPresentation(
        color: Colors.green,
        icon: Icons.verified_outlined,
        bannerLabel: PeopleStrings.clearanceCleared,
        bannerKey: ValueKey('clearance-green'),
        formTitle: PeopleStrings.parQPassedTitle,
        formBody: PeopleStrings.parQPassedBody,
      ),
      ParQClearanceStatus.cleared => const ClearanceStatusPresentation(
        color: Colors.green,
        icon: Icons.verified_outlined,
        bannerLabel: PeopleStrings.clearanceCleared,
        bannerKey: ValueKey('clearance-green'),
        formTitle: PeopleStrings.parQClearedTitle,
        formBody: PeopleStrings.parQClearedBody,
      ),
      ParQClearanceStatus.pendingClearance => ClearanceStatusPresentation(
        color: scheme.error,
        icon: Icons.warning_amber_rounded,
        bannerLabel: PeopleStrings.clearancePending,
        bannerKey: const ValueKey('clearance-red'),
        formTitle: PeopleStrings.parQPendingTitle,
        formBody: PeopleStrings.parQPendingBody,
      ),
      ParQClearanceStatus.rejected => ClearanceStatusPresentation(
        color: scheme.error,
        icon: Icons.block,
        bannerLabel: PeopleStrings.clearanceRejected,
        bannerKey: const ValueKey('clearance-red'),
        formTitle: PeopleStrings.parQRejectedTitle,
        formBody: PeopleStrings.parQRejectedBody,
      ),
      null => ClearanceStatusPresentation(
        color: scheme.outline,
        icon: Icons.help_outline,
        bannerLabel: PeopleStrings.clearanceNone,
      ),
    };
  }
}
