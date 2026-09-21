import 'package:flutter/material.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../session/domain/entities/user_type.dart';
import '../../../../session/presentation/session_cubit.dart';
import '../../../foods/domain/entities/food.dart';
import '../../../foods/domain/entities/food_filter.dart';
import '../../../foods/domain/usecases/get_foods_usecase.dart';
import '../diet_strings.dart';

/// Modal sheet: search foods via [GetFoodsUseCase], tap to select.
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

class FoodPickerSheet extends StatefulWidget {
  const FoodPickerSheet({super.key, this.verifiedOnly});

  final bool? verifiedOnly;

  @override
  State<FoodPickerSheet> createState() => _FoodPickerSheetState();
}

class _FoodPickerSheetState extends State<FoodPickerSheet> {
  final _searchController = TextEditingController();
  late final GetFoodsUseCase _getFoods = getIt<GetFoodsUseCase>();

  List<Food> _items = const [];
  bool _loading = true;
  String? _error;
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
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({String? search}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await _getFoods(
      GetFoodsParams(
        filter: FoodFilter(
          query: (search == null || search.isEmpty) ? null : search,
        ),
      ),
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failureMessage(failure);
        _items = const [];
      }),
      (page) => setState(() {
        _loading = false;
        _items = page.items;
      }),
    );
  }

  List<Food> get _visibleItems {
    if (_verifiedOnly) {
      return _items.where((f) => f.isVerified).toList();
    }
    return _items;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.75;
    final theme = Theme.of(context);
    final visible = _visibleItems;

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
                  onSubmitted: (value) => _load(search: value.trim()),
                ),
                if (!_isMember) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FilterChip(
                        avatar: Icon(
                          _verifiedOnly ? Icons.verified : Icons.verified_outlined,
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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!),
                            TextButton(
                              onPressed: () => _load(
                                search: _searchController.text.trim(),
                              ),
                              child: const Text(DietStrings.retry),
                            ),
                          ],
                        ),
                      )
                    : visible.isEmpty
                        ? const Center(child: Text(DietStrings.noFoods))
                        : ListView.builder(
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
                          ),
          ),
        ],
      ),
    );
  }
}
