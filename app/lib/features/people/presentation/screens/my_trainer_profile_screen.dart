import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/trainer_summary.dart';
import '../../domain/usecases/get_assigned_trainer_usecase.dart';
import '../cubit/my_trainer_profile_cubit.dart';
import '../people_strings.dart';

class MyTrainerProfileScreen extends StatelessWidget {
  const MyTrainerProfileScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyTrainerProfileCubit(
        getIt<GetAssignedTrainerUseCase>(),
      )..load(memberId),
      child: _MyTrainerProfileBody(memberId: memberId),
    );
  }
}

class _MyTrainerProfileBody extends StatelessWidget {
  const _MyTrainerProfileBody({required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.myTrainerTitle)),
      body: BlocBuilder<MyTrainerProfileCubit, MyTrainerProfileState>(
        builder: (context, state) {
          return switch (state) {
            MyTrainerProfileLoading() => const AppLoading(),
            MyTrainerProfileFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<MyTrainerProfileCubit>().load(memberId),
            ),
            MyTrainerProfileLoaded(:final trainer) => trainer == null
                ? const AppEmptyView(
                    message: PeopleStrings.noAssignedTrainer,
                  )
                : _TrainerProfileContent(trainer: trainer),
          };
        },
      ),
    );
  }
}

class _TrainerProfileContent extends StatelessWidget {
  const _TrainerProfileContent({required this.trainer});

  final TrainerSummary trainer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  trainer.fullName.isNotEmpty
                      ? trainer.fullName[0].toUpperCase()
                      : 'T',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                trainer.fullName,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Chip(
                visualDensity: VisualDensity.compact,
                label: Text(
                  trainer.isActive ? 'Active' : 'Inactive',
                  style: theme.textTheme.labelSmall,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (trainer.rating != null) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.star, color: Colors.amber),
                    title: const Text(PeopleStrings.rating),
                    trailing: Text(
                      trainer.rating!.toStringAsFixed(1),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const Divider(),
                ],
                if (trainer.hourlyRate != null &&
                    trainer.hourlyRate!.isNotEmpty) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.attach_money),
                    title: const Text(PeopleStrings.hourlyRate),
                    trailing: Text(
                      trainer.hourlyRate!,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const Divider(),
                ],
                if (trainer.assignedActiveCount != null) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.people_outline),
                    title: const Text(PeopleStrings.activeClients),
                    trailing: Text(
                      '${trainer.assignedActiveCount}${trainer.maxClientsCapacity != null ? ' / ${trainer.maxClientsCapacity}' : ''}',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  const Divider(),
                ],
                const SizedBox(height: 8),
                Text(
                  PeopleStrings.specializations,
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                if (trainer.specializations.isEmpty)
                  Text(
                    'No specializations listed.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: trainer.specializations
                        .map(
                          (s) => Chip(
                            label: Text(s),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () => context.push(Routes.memberScheduleBookPt),
          icon: const Icon(Icons.calendar_month),
          label: const Text(PeopleStrings.bookSession),
        ),
      ],
    );
  }
}
