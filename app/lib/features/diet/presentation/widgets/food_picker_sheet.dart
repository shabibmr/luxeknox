import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../../foods/domain/entities/food.dart';
import '../cubit/food_picker_cubit.dart';
import '../diet_strings.dart';

/// Modal sheet: search foods via [FoodPickerCubit], tap to select.
/// Hides unverified foods from Members (BR-DIET-002), and shows
/// verified status badges for all foods.
Future<Food?> showFoodPickerSheet(
  BuildContext context, {
  bool? verifiedOnly,
}) {
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
    _searchController.dispose();
    super.dispose();
  }

  void _load() {
    context.read<FoodPickerCubit>().load(search: _searchController.text);
  }

  List<Food> _visibleItems(List<Food> items) {
    if (_verifiedOnly) {
      return items.where((f) => f.isVerified).toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.75;
    final theme = Theme.of(context);

    return SizedBox(
      height: height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: DietStrings.searchFoods,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _load(),
                ),
                if (!_isMember) ...[
                  const SizedBox(height: 8),
                  Row(
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
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<FoodPickerCubit, FoodPickerState>(
              builder: (context, state) {
                final visible = _visibleItems(state.items);

                if (state.status == LoadStatus.loading &&
                    state.items.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == LoadStatus.failure &&
                    state.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(failureMessage(state.failure!)),
                        TextButton(
                          onPressed: _load,
                          child: const Text(DietStrings.retry),
                        ),
                      ],
                    ),
                  );
                }

                if (visible.isEmpty) {
                  return const Center(child: Text(DietStrings.noFoods));
                }

                return Column(
                  children: [
                    if (state.status == LoadStatus.failure &&
                        state.failure != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(failureMessage(state.failure!)),
                            ),
                            TextButton(
                              onPressed: _load,
                              child: const Text(DietStrings.retry),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final food = visible[index];
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
                                    child: Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                  )
                                else
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    margin: const EdgeInsets.only(left: 6),
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme
                                          .surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      DietStrings.unverifiedBadge,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: subtitle.isEmpty
                                ? null
                                : Text(subtitle),
                            onTap: () => Navigator.of(context).pop(food),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
