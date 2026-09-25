import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../cubit/trainer_availability_cubit.dart';
import '../scheduling_strings.dart';

class TrainerAvailabilityScreen extends StatelessWidget {
  const TrainerAvailabilityScreen({super.key, this.trainerId});

  final String? trainerId;

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>().state;
    final id = trainerId ??
        (session is SessionAuthenticated ? session.principal.profileId : null);
    if (id == null) {
      return const Scaffold(
        body: AppErrorView(message: 'Not signed in as a trainer.'),
      );
    }
    return BlocProvider(
      create: (_) => getIt<TrainerAvailabilityCubit>()..load(id),
      child: const _TrainerAvailabilityBody(),
    );
  }
}

class _TrainerAvailabilityBody extends StatelessWidget {
  const _TrainerAvailabilityBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(SchedulingStrings.availabilityTitle)),
      body: BlocBuilder<TrainerAvailabilityCubit, TrainerAvailabilityState>(
        builder: (context, state) {
          final slots = state.slots;
          if (state.status == LoadStatus.loading && !state.hasLoaded) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !state.hasLoaded) {
            return AppErrorView(
              message: state.failure == null
                  ? 'Something went wrong'
                  : failureMessage(state.failure!),
              onRetry: () {
                final session = context.read<SessionCubit>().state;
                if (session is SessionAuthenticated) {
                  context.read<TrainerAvailabilityCubit>().load(
                    session.principal.profileId,
                  );
                }
              },
            );
          }
          if (slots.isEmpty) {
            return const AppEmptyView(
              message: SchedulingStrings.availabilityEmpty,
            );
          }
          return ListView.builder(
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      return ListTile(
                        title: Text(
                          slot.dayOfWeek == null
                              ? (slot.overrideDate?.toIso8601String().split('T').first ??
                                  'Slot')
                              : 'Day ${slot.dayOfWeek}',
                        ),
                        subtitle: Text(
                          '${slot.startTime ?? '?'} – ${slot.endTime ?? '?'}'
                          '${slot.isAvailable ? '' : ' (blocked)'}',
                        ),
                      );
                    },
          );
        },
      ),
    );
  }
}
