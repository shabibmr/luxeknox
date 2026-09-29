import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/app_catalog_dropdown_field.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/usecases/catalog_usecases.dart';
import '../scheduling_strings.dart';

/// Dropdown field backed by `GET /schedule-types` (F2.3).
///
/// Schedule types are a short, unpaged list, so the whole catalog is loaded
/// once, mirroring [FacilityPickerField].
class ScheduleTypePickerField extends StatelessWidget {
  const ScheduleTypePickerField({
    super.key,
    required this.onChanged,
    this.value,
    this.listScheduleTypes,
    this.errorText,
    this.enabled = true,
  });

  /// The currently selected schedule type, or `null` for none selected.
  final ScheduleTypeInfo? value;

  final ValueChanged<ScheduleTypeInfo?> onChanged;

  /// External validation error (e.g. "Required"), shown under the field.
  final String? errorText;

  final bool enabled;

  /// Test seam; defaults to the DI-registered [ListScheduleTypesUseCase].
  final ListScheduleTypesUseCase? listScheduleTypes;

  @override
  Widget build(BuildContext context) {
    return AppCatalogDropdownField<ScheduleTypeInfo>(
      fieldKey: const Key('schedule_type_picker_field'),
      label: SchedulingStrings.scheduleTypeFieldLabel,
      placeholder: SchedulingStrings.scheduleTypeFieldPlaceholder,
      emptyMessage: SchedulingStrings.scheduleTypeFieldEmpty,
      value: value,
      errorText: errorText,
      enabled: enabled,
      onChanged: onChanged,
      itemId: (t) => t.id,
      itemLabel: (t) => t.name,
      load: () async {
        final useCase =
            listScheduleTypes ?? getIt<ListScheduleTypesUseCase>();
        final result = await useCase(const NoParams());
        return result.fold(
          (failure) => throw failureMessage(failure),
          (scheduleTypes) => scheduleTypes,
        );
      },
    );
  }
}
