import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/widgets/app_picker_form_field.dart';
import '../../../../core/widgets/app_picker_sheet.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../../foods/domain/entities/food.dart';
import '../../../foods/presentation/screens/food_form_screen.dart';
import '../cubit/food_picker_cubit.dart';
import '../diet_strings.dart';

/// Modal sheet: search foods via [FoodPickerCubit], tap to select.
/// Hides unverified foods from Members (BR-DIET-002), and shows
/// verified status badges for all foods.
Future<Food?> showFoodPickerSheet(BuildContext context, {bool? verifiedOnly}) {
  return showModalBottomSheet<Food>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => FoodPickerSheet(verifiedOnly: verifiedOnly),
  );
}

class FoodPickerSheet extends StatelessWidget {
  const FoodPickerSheet({super.key, this.verifiedOnly});

  final bool? verifiedOnly;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FoodPickerCubit>()..load(),
      child: _FoodPickerView(verifiedOnly: verifiedOnly),
    );
  }
}

class _FoodPickerView extends StatefulWidget {
  const _FoodPickerView({this.verifiedOnly});

  final bool? verifiedOnly;

  @override
  State<_FoodPickerView> createState() => _FoodPickerViewState();
}

class _FoodPickerViewState extends State<_FoodPickerView> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  late bool _verifiedOnly;
  bool _isMember = false;

  @override
  void initState() {
    super.initState();
    final sessionState = getIt<SessionCubit>().state;
    if (sessionState is SessionAuthenticated) {
      _isMember = sessionState.principal.userType == UserType.member;
    }
    // Members must always see verified only (BR-DIET-002)
    _verifiedOnly = widget.verifiedOnly ?? _isMember;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _load([String? text]) {
    context.read<FoodPickerCubit>().load(
      search: text ?? _searchController.text,
    );
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _load(value);
      }
    });
  }

  Future<void> _createFood() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const FoodFormScreen()),
    );
    if (created == true && mounted) _load();
  }

  List<Food> _visibleItems(List<Food> items) {
    if (_verifiedOnly) {
      return items.where((f) => f.isVerified).toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<FoodPickerCubit, FoodPickerState>(
      builder: (context, state) {
        final visible = _visibleItems(state.items);

        return AppPickerSheet<Food>(
          searchController: _searchController,
          searchLabel: DietStrings.searchFoods,
          onSearchChanged: _onSearchChanged,
          onSearchSubmitted: (_) => _load(),
          isLoading: state.status == LoadStatus.loading,
          items: visible,
          errorMessage: state.status == LoadStatus.failure
              ? failureMessage(state.failure!)
              : null,
          onRetry: _load,
          emptyMessage: DietStrings.noFoods,
          retryLabel: DietStrings.retry,
          header: _isMember
              ? null
              : Row(
                  children: [
                    FilterChip(
                      avatar: Icon(
                        _verifiedOnly
                            ? Icons.verified
                            : Icons.verified_outlined,
                        size: 16,
                        color: _verifiedOnly ? Colors.blue : null,
                      ),
                      label: const Text(DietStrings.verifiedOnlyToggle),
                      selected: _verifiedOnly,
                      onSelected: (val) {
                        setState(() {
                          _verifiedOnly = val;
                        });
                      },
                    ),
                    const Spacer(),
                    if (context.can('diet.create'))
                      TextButton.icon(
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text(DietStrings.createFood),
                        onPressed: _createFood,
                      ),
                  ],
                ),
          itemBuilder: (context, food) {
            final subtitle = [
              if (food.calories != null)
                '${food.calories!.toStringAsFixed(0)} kcal',
              food.servingUnit,
            ].where((s) => s.isNotEmpty).join(' · ');

            return ListTile(
              title: Row(
                children: [
                  Expanded(child: Text(food.name)),
                  if (food.isVerified)
                    const Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: Icon(Icons.verified, size: 16, color: Colors.blue),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      margin: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        DietStrings.unverifiedBadge,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
              subtitle: subtitle.isEmpty ? null : Text(subtitle),
              onTap: () => Navigator.of(context).pop(food),
            );
          },
        );
      },
    );
  }
}

/// A form field widget for selecting a food item.
class FoodPickerField extends StatelessWidget {
  const FoodPickerField({
    super.key,
    this.selectedFood,
    this.onChanged,
    this.verifiedOnly,
    this.enabled = true,
  });

  final Food? selectedFood;
  final ValueChanged<Food?>? onChanged;
  final bool? verifiedOnly;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppPickerFormField<Food>(
      value: selectedFood,
      labelText: 'Food',
      hintText: 'Select food',
      labelBuilder: (food) => food.name,
      enabled: enabled,
      onPick: (ctx) => showFoodPickerSheet(ctx, verifiedOnly: verifiedOnly),
      onChanged: onChanged ?? (_) {},
    );
  }
}
