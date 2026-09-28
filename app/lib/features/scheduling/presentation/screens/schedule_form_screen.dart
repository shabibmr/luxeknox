import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_loading.dart';
import '../cubit/schedule_form_cubit.dart';
import '../scheduling_strings.dart';
import '../widgets/date_time_range_field.dart';
import '../widgets/facility_picker_field.dart';
import '../widgets/schedule_type_picker_field.dart';
import '../widgets/trainer_picker_field.dart';

class ScheduleFormScreen extends StatelessWidget {
  const ScheduleFormScreen.create({
    super.key,
    this.initialStart,
    this.cubit,
  })  : scheduleId = null,
        mode = ScheduleFormMode.create;

  const ScheduleFormScreen.edit({
    super.key,
    required this.scheduleId,
    this.cubit,
  })  : initialStart = null,
        mode = ScheduleFormMode.edit;

  final String? scheduleId;
  final DateTime? initialStart;
  final ScheduleFormMode mode;
  final ScheduleFormCubit? cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScheduleFormCubit>(
      create: (_) {
        final instance = cubit ?? getIt<ScheduleFormCubit>();
        if (mode == ScheduleFormMode.create) {
          instance.initCreate(initialStart: initialStart);
        } else if (scheduleId != null) {
          instance.initEdit(scheduleId!);
        }
        return instance;
      },
      child: const _ScheduleFormBody(),
    );
  }
}

class _ScheduleFormBody extends StatefulWidget {
  const _ScheduleFormBody();

  @override
  State<_ScheduleFormBody> createState() => _ScheduleFormBodyState();
}

class _ScheduleFormBodyState extends State<_ScheduleFormBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _capacityController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _capacityController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _capacityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _syncControllers(ScheduleFormState state) {
    if (_titleController.text != state.draft.title) {
      _titleController.text = state.draft.title;
    }
    final capacityText = state.draft.maxCapacity?.toString() ?? '';
    if (_capacityController.text != capacityText) {
      _capacityController.text = capacityText;
    }
    final notesText = state.draft.notes ?? '';
    if (_notesController.text != notesText) {
      _notesController.text = notesText;
    }
  }

  Future<bool> _onWillPop(BuildContext context, ScheduleFormState state) async {
    if (!state.isDirty || state.submitting) return true;

    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(SchedulingStrings.unsavedChangesTitle),
        content: const Text(SchedulingStrings.unsavedChangesMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text(SchedulingStrings.discard),
          ),
        ],
      ),
    );

    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleFormCubit, ScheduleFormState>(
      listenWhen: (prev, current) =>
          prev.savedSession != current.savedSession ||
          (current.error != null && prev.error != current.error),
      listener: (context, state) {
        if (state.savedSession != null) {
          final msg = state.isCreate
              ? SchedulingStrings.scheduleCreatedSuccess
              : SchedulingStrings.scheduleUpdatedSuccess;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
          Navigator.of(context).pop(true);
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) {
        _syncControllers(state);

        final titleText = state.isCreate
            ? SchedulingStrings.createScheduleTitle
            : SchedulingStrings.editScheduleTitle;

        return PopScope(
          canPop: !state.isDirty || state.submitting,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldPop = await _onWillPop(context, state);
            if (shouldPop && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(titleText),
            ),
            body: state.initialLoading
                ? const AppLoading()
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (!state.isCreate &&
                            state.loadedSession?.isRecurring == true) ...[
                          Card(
                            key: const Key('recurring_session_edit_banner'),
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  const Icon(Icons.repeat, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${SchedulingStrings.recurringSeries} • ${SchedulingStrings.editThisSessionOnly}',
                                      style:
                                          Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (state.isConflict) ...[
                          Card(
                            color: Theme.of(context).colorScheme.errorContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      SchedulingStrings.rowVersionConflict,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onErrorContainer,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: state.scheduleId == null
                                        ? null
                                        : () => context
                                            .read<ScheduleFormCubit>()
                                            .initEdit(state.scheduleId!),
                                    child: const Text('Reload'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                        ScheduleTypePickerField(
                          value: state.draft.scheduleType,
                          onChanged: (type) {
                            context.read<ScheduleFormCubit>().updateDraft(
                                  (d) => d.copyWith(
                                    scheduleType: type,
                                    clearScheduleType: type == null,
                                  ),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('schedule_title_field'),
                          controller: _titleController,
                          decoration: const InputDecoration(
                            labelText: SchedulingStrings.titleLabel,
                            hintText: SchedulingStrings.titlePlaceholder,
                          ),
                          onChanged: (val) {
                            context.read<ScheduleFormCubit>().updateDraft(
                                  (d) => d.copyWith(title: val),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        TrainerPickerField(
                          value: state.draft.trainer,
                          onChanged: (trainer) {
                            context.read<ScheduleFormCubit>().updateDraft(
                                  (d) => d.copyWith(
                                    trainer: trainer,
                                    clearTrainer: trainer == null,
                                  ),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        FacilityPickerField(
                          value: state.draft.facility,
                          onChanged: (facility) {
                            context.read<ScheduleFormCubit>().updateDraft(
                                  (d) => d.copyWith(
                                    facility: facility,
                                    clearFacility: facility == null,
                                  ),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        DateTimeRangeField(
                          start: state.draft.start,
                          end: state.draft.end,
                          onStartChanged: (start) {
                            context.read<ScheduleFormCubit>().updateDraft(
                                  (d) => d.copyWith(start: start),
                                );
                          },
                          onEndChanged: (end) {
                            context.read<ScheduleFormCubit>().updateDraft(
                                  (d) => d.copyWith(end: end),
                                );
                          },
                        ),
                        if (state.isCreate) ...[
                          const SizedBox(height: 16),
                          InkWell(
                            key: const Key('schedule_recur_until_field'),
                            onTap: () async {
                              final initial = state.draft.recurUntil ??
                                  state.draft.start ??
                                  DateTime.now();
                              final first =
                                  state.draft.start ?? DateTime(2000);
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: initial.isBefore(first)
                                    ? first
                                    : initial,
                                firstDate: first,
                                lastDate: DateTime(2100),
                              );
                              if (picked != null && context.mounted) {
                                context.read<ScheduleFormCubit>().updateDraft(
                                      (d) => d.copyWith(recurUntil: picked),
                                    );
                              }
                            },
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: SchedulingStrings.repeatUntilLabel,
                                hintText:
                                    SchedulingStrings.repeatUntilPlaceholder,
                                suffixIcon: state.draft.recurUntil != null
                                    ? IconButton(
                                        key: const Key(
                                          'schedule_recur_until_clear_button',
                                        ),
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          context
                                              .read<ScheduleFormCubit>()
                                              .updateDraft(
                                                (d) => d.copyWith(
                                                  clearRecurUntil: true,
                                                ),
                                              );
                                        },
                                      )
                                    : const Icon(Icons.calendar_month),
                                errorText:
                                    state.draft.validate()['recurUntil'],
                              ),
                              child: Text(
                                state.draft.recurUntil == null
                                    ? SchedulingStrings.repeatUntilPlaceholder
                                    : DateFormat.yMMMd().format(
                                        state.draft.recurUntil!,
                                      ),
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('schedule_capacity_field'),
                          controller: _capacityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: SchedulingStrings.capacityLabel,
                            hintText: SchedulingStrings.capacityLabel,
                          ),
                          onChanged: (val) {
                            final cap = int.tryParse(val.trim());
                            context.read<ScheduleFormCubit>().updateDraft(
                                  (d) => d.copyWith(
                                    maxCapacity: cap,
                                    clearMaxCapacity: cap == null,
                                  ),
                                );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('schedule_notes_field'),
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: SchedulingStrings.notesLabel,
                            hintText: SchedulingStrings.notesPlaceholder,
                          ),
                          onChanged: (val) {
                            context.read<ScheduleFormCubit>().updateDraft(
                                  (d) => d.copyWith(
                                    notes: val.trim().isEmpty ? null : val,
                                    clearNotes: val.trim().isEmpty,
                                  ),
                                );
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          key: const Key('schedule_form_submit_button'),
                          onPressed: state.submitting
                              ? null
                              : () =>
                                  context.read<ScheduleFormCubit>().submit(),
                          child: Text(
                            state.submitting
                                ? SchedulingStrings.submitting
                                : (state.isCreate
                                    ? SchedulingStrings.createScheduleSubmit
                                    : SchedulingStrings.updateScheduleSubmit),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
