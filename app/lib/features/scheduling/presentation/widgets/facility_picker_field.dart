import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/app_catalog_dropdown_field.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/usecases/catalog_usecases.dart';
import '../scheduling_strings.dart';

/// Dropdown field backed by `GET /facilities` (F2.2).
///
/// Facilities are a short, unpaged list, so the whole catalog is loaded once
/// and filtered client-side rather than paged like [TrainerPickerField].
class FacilityPickerField extends StatelessWidget {
  const FacilityPickerField({
    super.key,
    required this.onChanged,
    this.value,
    this.listFacilities,
    this.errorText,
    this.enabled = true,
  });

  /// The currently selected facility, or `null` for none selected.
  final FacilityInfo? value;

  final ValueChanged<FacilityInfo?> onChanged;

  /// External validation error (e.g. "Required"), shown under the field.
  final String? errorText;

  final bool enabled;

  /// Test seam; defaults to the DI-registered [ListFacilitiesUseCase].
  final ListFacilitiesUseCase? listFacilities;

  @override
  Widget build(BuildContext context) {
    return AppCatalogDropdownField<FacilityInfo>(
      fieldKey: const Key('facility_picker_field'),
      label: SchedulingStrings.facilityFieldLabel,
      placeholder: SchedulingStrings.facilityFieldPlaceholder,
      emptyMessage: SchedulingStrings.facilityFieldEmpty,
      value: value,
      errorText: errorText,
      enabled: enabled,
      onChanged: onChanged,
      itemId: (f) => f.id,
      itemLabel: (f) => f.name,
      load: () async {
        final useCase = listFacilities ?? getIt<ListFacilitiesUseCase>();
        final result = await useCase(const NoParams());
        return result.fold(
          (failure) => throw failureMessage(failure),
          (facilities) => facilities,
        );
      },
    );
  }
}
