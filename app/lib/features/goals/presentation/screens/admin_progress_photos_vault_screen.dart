import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/admin_progress_photos_vault_cubit.dart';
import '../goals_strings.dart';

/// Gym-wide progress photos vault.
/// Private photos are filtered in the cubit unless `progress_photos.moderate`.
/// Cubit is provided on the GoRoute (ADR-0006 §8).
class AdminProgressPhotosVaultScreen extends StatelessWidget {
  const AdminProgressPhotosVaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(GoalsStrings.adminPhotosVaultTitle)),
      body:
          BlocBuilder<
            AdminProgressPhotosVaultCubit,
            AdminProgressPhotosVaultState
          >(
            builder: (context, state) {
              final showData =
                  state.status == LoadStatus.success ||
                  state.photos.isNotEmpty;
              if (state.status == LoadStatus.loading && !showData) {
                return const AppLoading();
              }
              if (state.status == LoadStatus.failure && !showData) {
                return AppErrorView(
                  message: failureMessage(state.failure!),
                  onRetry: () => context
                      .read<AdminProgressPhotosVaultCubit>()
                      .load(canModerate: state.canModerate),
                );
              }
              if (state.photos.isEmpty) {
                return const AppEmptyView(
                  message: GoalsStrings.adminPhotosVaultEmpty,
                );
              }
              return ListView.separated(
                itemCount: state.photos.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final photo = state.photos[index];
                  return ListTile(
                    leading: photo.isPrivate
                        ? const Icon(Icons.lock_outline)
                        : const Icon(Icons.image_outlined),
                    title: Text('Member #${photo.memberId}'),
                    subtitle: Text(
                      '${GoalsStrings.poseLabelFor(photo.pose)} · '
                      '${GoalsStrings.calendarDate(photo.takenDate)}'
                      '${photo.isPrivate ? ' · ${GoalsStrings.privateLabel}' : ''}',
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}
