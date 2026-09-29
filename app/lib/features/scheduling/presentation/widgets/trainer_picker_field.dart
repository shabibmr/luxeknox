import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../../people/domain/entities/trainer_summary.dart';
import '../../../people/domain/usecases/list_trainers_usecase.dart';
import '../scheduling_strings.dart';

/// Form field that opens a searchable, paged picker over `GET /trainers`
/// (F2.1). Selection happens in a generic modal search sheet.
class TrainerPickerField extends StatelessWidget {
  const TrainerPickerField({
    super.key,
    required this.onChanged,
    this.value,
    this.listTrainers,
    this.errorText,
    this.enabled = true,
  });

  /// The currently selected trainer, or `null` for none selected.
  final TrainerSummary? value;

  final ValueChanged<TrainerSummary?> onChanged;

  /// External validation error (e.g. "Required"), shown under the field.
  final String? errorText;

  final bool enabled;

  /// Test seam; defaults to the DI-registered [ListTrainersUseCase].
  final ListTrainersUseCase? listTrainers;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: const Key('trainer_picker_field'),
      onTap: enabled ? () => _openPicker(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: SchedulingStrings.trainerFieldLabel,
          errorText: errorText,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          value?.fullName ?? SchedulingStrings.trainerFieldPlaceholder,
          style: value == null
              ? Theme.of(context).inputDecorationTheme.hintStyle
              : null,
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final useCase = listTrainers ?? getIt<ListTrainersUseCase>();
    final selected = await showAppPagedPickerSheet<TrainerSummary>(
      context: context,
      searchLabel: SchedulingStrings.trainerSearchHint,
      searchFieldKey: const Key('trainer_search_field'),
      emptyMessage: SchedulingStrings.trainerFieldEmpty,
      heightFactor: 0.8,
      autofocus: true,
      fetcher: ({cursor, query}) =>
          useCase(ListTrainersParams(query: query, cursor: cursor)),
      itemBuilder: (context, trainer) => ListTile(
        key: Key('trainer_option_${trainer.id}'),
        title: Text(trainer.fullName),
        subtitle: trainer.specializations.isEmpty
            ? null
            : Text(trainer.specializations.join(', ')),
        onTap: () => Navigator.of(context).pop(trainer),
      ),
    );
    if (selected != null) {
      onChanged(selected);
    }
  }
}
