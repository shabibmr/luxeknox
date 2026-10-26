import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../cubit/sell_pt_cubit.dart';
import '../pt_strings.dart';
import 'pt_schedule_grid_view.dart';

/// Trainer × hour grid shared by the sale and replan forms.
///
/// A cell is busy when the loaded grid says so. Couple sales pass both
/// members into that grid load; this widget does not change the math.
class PtScheduleGridSection extends StatelessWidget {
  const PtScheduleGridSection({super.key, required this.state});

  final SellPtState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SellPtCubit>();
    final theme = Theme.of(context);
    final product = state.product;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(PtStrings.stepSlot, style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(PtStrings.gridHint, style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        if (!state.canLoadGrid)
          Card(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.5,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      product == null
                          ? 'Select a PT package and choose training days above to view available trainers and hours.'
                          : 'Choose at least one training day above to view available trainers and hours.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (state.gridStatus == LoadStatus.loading)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading trainer availability schedule...'),
                ],
              ),
            ),
          )
        else if (state.gridStatus == LoadStatus.failure)
          AppErrorView(
            message: state.failure == null
                ? ''
                : failureMessage(state.failure!),
            onRetry: cubit.loadGrid,
          )
        else if (state.grid != null)
          PtScheduleGridView(
            grid: state.grid!,
            selectedTrainerId: state.trainerId,
            selectedSlot: state.slotStart,
            onSelect: cubit.selectSlot,
          ),
      ],
    );
  }
}
