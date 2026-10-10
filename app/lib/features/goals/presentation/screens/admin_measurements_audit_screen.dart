import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/admin_measurements_audit_cubit.dart';
import '../goals_strings.dart';

/// Gym-wide measurements audit / history archive.
/// Cubit is provided on the GoRoute (ADR-0006 §8).
class AdminMeasurementsAuditScreen extends StatelessWidget {
  const AdminMeasurementsAuditScreen({
    super.key,
    this.title = GoalsStrings.adminMeasurementsAuditTitle,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: BlocBuilder<AdminMeasurementsAuditCubit, AdminMeasurementsAuditState>(
        builder: (context, state) {
          final showData =
              state.status == LoadStatus.success || state.items.isNotEmpty;
          if (state.status == LoadStatus.loading && !showData) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !showData) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () =>
                  context.read<AdminMeasurementsAuditCubit>().load(),
            );
          }
          if (state.items.isEmpty) {
            return const AppEmptyView(
              message: GoalsStrings.adminMeasurementsEmpty,
            );
          }
          return ListView.separated(
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final session = state.items[index];
              return ListTile(
                title: Text('Member #${session.memberId}'),
                subtitle: Text(
                  '${GoalsStrings.calendarDate(session.recordedAt)} · '
                  '${session.values.length} values',
                ),
                trailing: session.notes != null && session.notes!.isNotEmpty
                    ? const Icon(Icons.notes_outlined)
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
