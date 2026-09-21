import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
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
          return switch (state) {
            TrainerAvailabilityLoading() => const AppLoading(),
            TrainerAvailabilityFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () {
                final session = context.read<SessionCubit>().state;
                if (session is SessionAuthenticated) {
                  context.read<TrainerAvailabilityCubit>().load(
                    session.principal.profileId,
                  );
                }
              },
            ),
            TrainerAvailabilityLoaded(:final slots) => slots.isEmpty
                ? const AppEmptyView(
                    message: SchedulingStrings.availabilityEmpty,
                  )
                : ListView.builder(
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
                  ),
          };
        },
      ),
    );
  }
}
