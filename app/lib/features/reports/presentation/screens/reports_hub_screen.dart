import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../domain/entities/app_report_type.dart';
import '../report_strings.dart';

/// Admin report navigation hub — one tile per report type.
class ReportsHubScreen extends StatelessWidget {
  const ReportsHubScreen({super.key});

  static const _adminTypes = <AppReportType>[
    AppReportType.members,
    AppReportType.memberships,
    AppReportType.attendance,
    AppReportType.payments,
    AppReportType.trainers,
    AppReportType.workouts,
    AppReportType.diets,
    AppReportType.progress,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(ReportStrings.hubTitle)),
      body: ListView.separated(
        itemCount: _adminTypes.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final type = _adminTypes[index];
          return ListTile(
            title: Text(ReportStrings.titleFor(type)),
            subtitle: Text(ReportStrings.subtitleFor(type)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(
              Routes.adminReportsCategory(type.category),
            ),
          );
        },
      ),
    );
  }
}
