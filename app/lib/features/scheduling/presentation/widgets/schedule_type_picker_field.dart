import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/widgets/picker_field_states.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/usecases/catalog_usecases.dart';
import '../scheduling_strings.dart';

/// Dropdown field backed by `GET /schedule-types` (F2.3).
///
/// Schedule types are a short, unpaged list, so the whole catalog is loaded
/// once, mirroring [FacilityPickerField].
class ScheduleTypePickerField extends StatefulWidget {
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
  State<ScheduleTypePickerField> createState() =>
      _ScheduleTypePickerFieldState();
}

class _ScheduleTypePickerFieldState extends State<ScheduleTypePickerField> {
  late final ListScheduleTypesUseCase _listScheduleTypes =
      widget.listScheduleTypes ?? getIt<ListScheduleTypesUseCase>();

  bool _loading = true;
  String? _loadError;
  List<ScheduleTypeInfo> _scheduleTypes = const [];

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
    final result = await _listScheduleTypes(const NoParams());
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _loadError = failureMessage(failure);
      }),
      (scheduleTypes) => setState(() {
        _loading = false;
        _scheduleTypes = scheduleTypes;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const PickerFieldSkeleton(
        label: SchedulingStrings.scheduleTypeFieldLabel,
      );
    }
    if (_loadError != null) {
      return PickerFieldRetry(
        label: SchedulingStrings.scheduleTypeFieldLabel,
        message: _loadError!,
        onRetry: _load,
      );
    }
    if (_scheduleTypes.isEmpty) {
      return const InputDecorator(
        decoration: InputDecoration(
          labelText: SchedulingStrings.scheduleTypeFieldLabel,
        ),
        child: Text(SchedulingStrings.scheduleTypeFieldEmpty),
      );
    }
    return DropdownButtonFormField<String>(
      key: const Key('schedule_type_picker_field'),
      initialValue: widget.value?.id,
      decoration: InputDecoration(
        labelText: SchedulingStrings.scheduleTypeFieldLabel,
        errorText: widget.errorText,
      ),
      hint: const Text(SchedulingStrings.scheduleTypeFieldPlaceholder),
      items: [
        for (final type in _scheduleTypes)
          DropdownMenuItem(value: type.id, child: Text(type.name)),
      ],
      onChanged: widget.enabled
          ? (id) => widget.onChanged(
              id == null ? null : _scheduleTypes.firstWhere((t) => t.id == id),
            )
          : null,
    );
  }
}
