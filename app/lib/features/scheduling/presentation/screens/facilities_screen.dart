import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
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
        listenWhen: (p, n) => n is FacilitiesLoaded && n.message != null,
        listener: (context, state) {
          if (state is FacilitiesLoaded && state.message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message!)));
          }
        },
        builder: (context, state) {
          return switch (state) {
            FacilitiesLoading() => const AppLoading(),
            FacilitiesFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<FacilitiesCubit>().load(),
            ),
            FacilitiesLoaded(:final items) => items.isEmpty
                ? const AppEmptyView(message: SchedulingStrings.facilitiesEmpty)
                : ListView.builder(
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
                  ),
          };
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
