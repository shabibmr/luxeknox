import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/extensions/capability_extension.dart';
import '../../domain/entities/food_filter.dart';
import '../bloc/food_list_bloc.dart';
import '../bloc/food_list_event.dart';
import '../bloc/food_list_state.dart';
import '../foods_strings.dart';
import '../widgets/food_filter_sheet.dart';
import '../widgets/food_list_item.dart';
import 'food_detail_screen.dart';
import 'food_form_screen.dart';

/// Food Library screen (screen 36). Member and trainer get browse-only;
/// admin also sees the add button. At 840dp and above, selecting a food
/// shows it in a side pane instead of pushing (mirrors exercises K11).
class FoodLibraryScreen extends StatelessWidget {
  const FoodLibraryScreen({super.key});

  static const double _masterDetailBreakpoint = 840;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FoodListBloc>()..add(const FoodListStarted()),
      child: const _FoodLibraryView(),
    );
  }
}

class _FoodLibraryView extends StatefulWidget {
  const _FoodLibraryView();

  @override
  State<_FoodLibraryView> createState() => _FoodLibraryViewState();
}

class _FoodLibraryViewState extends State<_FoodLibraryView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  String? _selectedFoodId;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<FoodListBloc>().add(const FoodListNextPageRequested());
    }
  }

  Future<void> _openFilterSheet(FoodFilter current) async {
    final result = await FoodFilterSheet.show(context, current);
    if (!mounted || result == null) return;
    context.read<FoodListBloc>().add(FoodListFilterChanged(result));
  }

  void _selectFood(String id, bool isWide) {
    if (isWide) {
      setState(() => _selectedFoodId = id);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => FoodDetailScreen(foodId: id)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCreate = context.can('foods.create');

    return Scaffold(
      appBar: AppBar(
        title: const Text(FoodStrings.libraryTitle),
        actions: [
          if (canCreate)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: FoodStrings.addTooltip,
              onPressed: () async {
                final created = await Navigator.of(context).push<bool>(
                  MaterialPageRoute<bool>(
                    builder: (_) => const FoodFormScreen(),
                  ),
                );
                if (created == true && context.mounted) {
                  context.read<FoodListBloc>().add(const FoodListRefreshed());
                }
              },
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide =
              constraints.maxWidth >= FoodLibraryScreen._masterDetailBreakpoint;

          final listPane = _FoodListPane(
            searchController: _searchController,
            scrollController: _scrollController,
            onOpenFilters: _openFilterSheet,
            onSelectFood: (id) => _selectFood(id, isWide),
            selectedFoodId: isWide ? _selectedFoodId : null,
          );

          if (!isWide) return listPane;

          return Row(
            children: [
              SizedBox(width: 400, child: listPane),
              const VerticalDivider(width: 1),
              Expanded(
                child: _selectedFoodId == null
                    ? const Center(child: Text(FoodStrings.selectFood))
                    : FoodDetailScreen(
                        key: ValueKey(_selectedFoodId),
                        foodId: _selectedFoodId!,
                        embedded: true,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FoodListPane extends StatelessWidget {
  const _FoodListPane({
    required this.searchController,
    required this.scrollController,
    required this.onOpenFilters,
    required this.onSelectFood,
    required this.selectedFoodId,
  });

  final TextEditingController searchController;
  final ScrollController scrollController;
  final void Function(FoodFilter current) onOpenFilters;
  final void Function(String id) onSelectFood;
  final String? selectedFoodId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: FoodStrings.searchHint,
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) => context.read<FoodListBloc>().add(
                    FoodListSearchChanged(query),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              BlocSelector<FoodListBloc, FoodListState, FoodFilter>(
                selector: (state) => state.filter,
                builder: (context, filter) => IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: filter.isEmpty
                        ? null
                        : Theme.of(context).colorScheme.primary,
                  ),
                  tooltip: FoodStrings.filterTooltip,
                  onPressed: () => onOpenFilters(filter),
                ),
              ),
            ],
          ),
        ),
        BlocSelector<FoodListBloc, FoodListState, FoodFilter>(
          selector: (state) => state.filter,
          builder: (context, filter) {
            if (filter.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Wrap(
                spacing: 8,
                children: [
                  if (filter.isVerified != null)
                    Chip(
                      label: const Text(FoodStrings.verifiedOnly),
                      onDeleted: () => context.read<FoodListBloc>().add(
                        FoodListFilterChanged(
                          filter.copyWith(isVerified: null),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        Expanded(
          child: BlocBuilder<FoodListBloc, FoodListState>(
            builder: (context, state) {
              if (state.status == FoodListStatus.loading &&
                  state.items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == FoodListStatus.failure &&
                  state.items.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          failureMessage(state.failure!),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context.read<FoodListBloc>().add(
                            const FoodListRefreshed(),
                          ),
                          child: const Text(FoodStrings.retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state.status == FoodListStatus.success &&
                  state.items.isEmpty) {
                return const Center(child: Text(FoodStrings.noneFound));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  final bloc = context.read<FoodListBloc>();
                  bloc.add(const FoodListRefreshed());
                  await bloc.stream.firstWhere(
                    (s) => s.status != FoodListStatus.loading,
                  );
                },
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: state.items.length + (state.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.items.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    }
                    final food = state.items[index];
                    return Container(
                      color: food.id == selectedFoodId
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      child: FoodListItem(
                        food: food,
                        onTap: () => onSelectFood(food.id),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
