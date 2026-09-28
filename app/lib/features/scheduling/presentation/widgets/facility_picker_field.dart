import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/picker_field_states.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/usecases/catalog_usecases.dart';
import '../scheduling_strings.dart';

/// Dropdown field backed by `GET /facilities` (F2.2).
///
/// Facilities are a short, unpaged list, so the whole catalog is loaded once
/// and filtered client-side rather than paged like [TrainerPickerField].
class FacilityPickerField extends StatefulWidget {
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
  State<FacilityPickerField> createState() => _FacilityPickerFieldState();
}

class _FacilityPickerFieldState extends State<FacilityPickerField> {
  late final ListFacilitiesUseCase _listFacilities =
      widget.listFacilities ?? getIt<ListFacilitiesUseCase>();

  bool _loading = true;
  String? _loadError;
  List<FacilityInfo> _facilities = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    final result = await _listFacilities(const NoParams());
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _loadError = failureMessage(failure);
      }),
      (facilities) => setState(() {
        _loading = false;
        _facilities = facilities;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const PickerFieldSkeleton(
        label: SchedulingStrings.facilityFieldLabel,
      );
    }
    if (_loadError != null) {
      return PickerFieldRetry(
        label: SchedulingStrings.facilityFieldLabel,
        message: _loadError!,
        onRetry: _load,
      );
    }
    if (_facilities.isEmpty) {
      return const InputDecorator(
        decoration: InputDecoration(
          labelText: SchedulingStrings.facilityFieldLabel,
        ),
        child: Text(SchedulingStrings.facilityFieldEmpty),
      );
    }
    return DropdownButtonFormField<String>(
      key: const Key('facility_picker_field'),
      initialValue: widget.value?.id,
      decoration: InputDecoration(
        labelText: SchedulingStrings.facilityFieldLabel,
        errorText: widget.errorText,
      ),
      hint: const Text(SchedulingStrings.facilityFieldPlaceholder),
      items: [
        for (final facility in _facilities)
          DropdownMenuItem(value: facility.id, child: Text(facility.name)),
      ],
      onChanged: widget.enabled
          ? (id) => widget.onChanged(
              id == null
                  ? null
                  : _facilities.firstWhere((f) => f.id == id),
            )
          : null,
    );
  }
}
