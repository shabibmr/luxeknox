import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/facilities_cubit.dart';
import '../scheduling_strings.dart';

class FacilitiesScreen extends StatelessWidget {
  const FacilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FacilitiesCubit>()..load(),
      child: const _FacilitiesBody(),
    );
  }
}

class _FacilitiesBody extends StatelessWidget {
  const _FacilitiesBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(SchedulingStrings.facilitiesTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<FacilitiesCubit, FacilitiesState>(
        listenWhen: (previous, current) =>
            current.hasLoaded &&
            current.failure != null &&
            current.failure != previous.failure,
        listener: (context, state) {
          final failure = state.failure;
          if (failure == null) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failureMessage(failure))),
          );
        },
        builder: (context, state) {
          final items = state.items;
          if (state.status == LoadStatus.loading && !state.hasLoaded) {
            return const AppLoading();
          }
          if (state.status == LoadStatus.failure && !state.hasLoaded) {
            return AppErrorView(
              message: state.failure == null
                  ? 'Something went wrong'
                  : failureMessage(state.failure!),
              onRetry: () => context.read<FacilitiesCubit>().load(),
            );
          }
          if (items.isEmpty) {
            return const AppEmptyView(
              message: SchedulingStrings.facilitiesEmpty,
            );
          }
          return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final facility = items[index];
                      return ListTile(
                        title: Text(facility.name),
                        subtitle: Text(
                          [
                            if (facility.capacity != null)
                              'Cap ${facility.capacity}',
                            if (facility.locationDetails != null)
                              facility.locationDetails!,
                            facility.isActive ? 'Active' : 'Inactive',
                          ].join(' · '),
                        ),
                      );
                    },
          );
        },
      ),
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    final nameController = TextEditingController();
    final capacityController = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(SchedulingStrings.addFacility),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: SchedulingStrings.facilityNameLabel,
              ),
            ),
            TextField(
              controller: capacityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: SchedulingStrings.capacityLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      final name = nameController.text.trim();
      if (name.isEmpty) return;
      await context.read<FacilitiesCubit>().create(
        name: name,
        capacity: int.tryParse(capacityController.text.trim()),
      );
    }
  }
}
