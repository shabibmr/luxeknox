import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/medical_record.dart';
import '../../domain/usecases/create_medical_record_usecase.dart';
import '../../domain/usecases/delete_medical_record_usecase.dart';
import '../../domain/usecases/list_medical_records_usecase.dart';
import '../../domain/usecases/update_medical_record_usecase.dart';
import '../cubit/medical_history_cubit.dart';
import '../people_strings.dart';

class MedicalHistoryScreen extends StatelessWidget {
  const MedicalHistoryScreen({super.key, required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedicalHistoryCubit(
        getIt<ListMedicalRecordsUseCase>(),
        getIt<CreateMedicalRecordUseCase>(),
        getIt<UpdateMedicalRecordUseCase>(),
        getIt<DeleteMedicalRecordUseCase>(),
      )..load(memberId),
      child: _MedicalHistoryBody(memberId: memberId),
    );
  }
}

class _MedicalHistoryBody extends StatelessWidget {
  const _MedicalHistoryBody({required this.memberId});

  final int memberId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(PeopleStrings.medicalHistory),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: PeopleStrings.add,
            onPressed: () => _showEditor(context),
          ),
        ],
      ),
      body: BlocBuilder<MedicalHistoryCubit, MedicalHistoryState>(
        builder: (context, state) {
          return switch (state) {
            MedicalHistoryLoading() => const AppLoading(),
            MedicalHistoryFailure(:final message) => AppErrorView(
              message: message,
              onRetry: () =>
                  context.read<MedicalHistoryCubit>().load(memberId),
            ),
            MedicalHistoryLoaded(:final records) => records.isEmpty
                ? AppEmptyView(
                    message: PeopleStrings.emptyMedical,
                    action: () => _showEditor(context),
                    actionLabel: PeopleStrings.add,
                  )
                : ListView.separated(
                    itemCount: records.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return ListTile(
                        title: Text(record.title),
                        subtitle: Text(
                          [
                            if (record.clearanceStatus != null)
                              record.clearanceStatus,
                            if (record.description != null) record.description,
                          ].whereType<String>().join(' · '),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => context
                              .read<MedicalHistoryCubit>()
                              .remove(record.id),
                        ),
                        onTap: () => _showEditor(context, existing: record),
                      );
                    },
                  ),
          };
        },
      ),
    );
  }

  Future<void> _showEditor(
    BuildContext context, {
    MedicalRecord? existing,
  }) async {
    final title = TextEditingController(text: existing?.title ?? '');
    final description = TextEditingController(text: existing?.description);
    final clearance = TextEditingController(text: existing?.clearanceStatus);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          existing == null ? PeopleStrings.add : PeopleStrings.save,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                labelText: PeopleStrings.recordTitle,
              ),
            ),
            TextField(
              controller: description,
              decoration: const InputDecoration(
                labelText: PeopleStrings.description,
              ),
            ),
            TextField(
              controller: clearance,
              decoration: const InputDecoration(
                labelText: PeopleStrings.clearanceStatus,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(PeopleStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(PeopleStrings.save),
          ),
        ],
      ),
    );
    if (saved != true || !context.mounted) return;
    final record = MedicalRecord(
      id: existing?.id ?? 0,
      memberId: memberId,
      title: title.text.trim(),
      description: description.text.trim().isEmpty
          ? null
          : description.text.trim(),
      clearanceStatus: clearance.text.trim().isEmpty
          ? null
          : clearance.text.trim(),
    );
    final cubit = context.read<MedicalHistoryCubit>();
    if (existing == null) {
      await cubit.add(record);
    } else {
      await cubit.save(record);
    }
  }
}
