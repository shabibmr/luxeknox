import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/health_info.dart';
import '../../domain/usecases/create_health_record_usecase.dart';
import '../../domain/usecases/list_health_history_usecase.dart';
import '../cubit/health_history_cubit.dart';
import '../people_strings.dart';

class HealthDetailScreen extends StatelessWidget {
  const HealthDetailScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HealthHistoryCubit(
        getIt<ListHealthHistoryUseCase>(),
        getIt<CreateHealthRecordUseCase>(),
      )..load(memberId),
      child: _HealthDetailBody(memberId: memberId),
    );
  }
}

class _HealthDetailBody extends StatelessWidget {
  const _HealthDetailBody({required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(PeopleStrings.health)),
      body: BlocConsumer<HealthHistoryCubit, HealthHistoryState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(PeopleStrings.healthSaved)),
            );
          } else if (state.status == LoadStatus.failure &&
              state.records.isNotEmpty &&
              state.failure != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(failureMessage(state.failure!))),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<HealthHistoryCubit>();
          if (cubit.current == null && state.status == LoadStatus.failure) {
            return AppErrorView(
              message: failureMessage(state.failure!),
              onRetry: () => cubit.load(memberId),
            );
          }
          final current = cubit.current;
          if (current == null) {
            return const AppLoading();
          }
          return _HealthForm(
            key: ValueKey((current.id, current.recordedAt)),
            info: current,
            canGoPrevious: cubit.canGoPrevious,
            canGoNext: cubit.canGoNext,
          );
        },
      ),
    );
  }
}

class _HealthForm extends StatefulWidget {
  const _HealthForm({
    super.key,
    required this.info,
    required this.canGoPrevious,
    required this.canGoNext,
  });

  final HealthInfo info;
  final bool canGoPrevious;
  final bool canGoNext;

  @override
  State<_HealthForm> createState() => _HealthFormState();
}

class _HealthFormState extends State<_HealthForm> {
  late final _blood = TextEditingController(text: widget.info.bloodGroup);
  late final _height = TextEditingController(
    text: widget.info.heightCm?.toString() ?? '',
  );
  late final _weight = TextEditingController(
    text: widget.info.baselineWeightKg?.toString() ?? '',
  );
  late final _allergies = TextEditingController(text: widget.info.allergies);
  late final _diet = TextEditingController(
    text: widget.info.dietaryPreferences,
  );
  late final _physician = TextEditingController(
    text: widget.info.physicianName,
  );
  late final _physicianPhone = TextEditingController(
    text: widget.info.physicianPhone,
  );

  @override
  void dispose() {
    _blood.dispose();
    _height.dispose();
    _weight.dispose();
    _allergies.dispose();
    _diet.dispose();
    _physician.dispose();
    _physicianPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (widget.info.id == 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              PeopleStrings.emptyHealth,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.canGoPrevious
                  ? () => context.read<HealthHistoryCubit>().previous()
                  : null,
              child: const Text(PeopleStrings.previous),
            ),
            Text(
              '${PeopleStrings.recordedOn} '
              '${DateFormat.yMMMd().format(widget.info.recordedAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextButton(
              onPressed: widget.canGoNext
                  ? () => context.read<HealthHistoryCubit>().next()
                  : null,
              child: const Text(PeopleStrings.next),
            ),
          ],
        ),
        TextField(
          controller: _blood,
          decoration: const InputDecoration(
            labelText: PeopleStrings.bloodGroup,
          ),
        ),
        TextField(
          controller: _height,
          decoration: const InputDecoration(labelText: PeopleStrings.heightCm),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _weight,
          decoration: const InputDecoration(labelText: PeopleStrings.weightKg),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _allergies,
          decoration: const InputDecoration(labelText: PeopleStrings.allergies),
          maxLines: 2,
        ),
        TextField(
          controller: _diet,
          decoration: const InputDecoration(
            labelText: PeopleStrings.dietaryPreferences,
          ),
          maxLines: 2,
        ),
        TextField(
          controller: _physician,
          decoration: const InputDecoration(
            labelText: PeopleStrings.physicianName,
          ),
        ),
        TextField(
          controller: _physicianPhone,
          decoration: const InputDecoration(
            labelText: PeopleStrings.physicianPhone,
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () {
            context.read<HealthHistoryCubit>().save(
              HealthInfo(
                id: widget.info.id,
                memberId: widget.info.memberId,
                recordedAt: widget.info.recordedAt,
                bloodGroup: _optional(_blood.text),
                heightCm: double.tryParse(_height.text.trim()),
                baselineWeightKg: double.tryParse(_weight.text.trim()),
                allergies: _optional(_allergies.text),
                dietaryPreferences: _optional(_diet.text),
                physicianName: _optional(_physician.text),
                physicianPhone: _optional(_physicianPhone.text),
              ),
            );
          },
          child: const Text(PeopleStrings.save),
        ),
      ],
    );
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
