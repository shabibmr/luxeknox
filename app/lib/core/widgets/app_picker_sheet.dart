import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../error/failure_messages.dart';
import '../presentation/load_status.dart';
import 'app_picker_cubit.dart';

/// Opens a standardized, keyboard-safe modal bottom sheet powered by [AppPickerCubit].
Future<T?> showAppPagedPickerSheet<T>({
  required BuildContext context,
  required PageFetcher<T> fetcher,
  required Widget Function(BuildContext context, T item) itemBuilder,
  String searchLabel = 'Search',
  Key? searchFieldKey,
  String emptyMessage = 'No results',
  String retryLabel = 'Retry',
  double heightFactor = 0.75,
  Widget? header,
  bool autofocus = false,
  String? initialQuery,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => AppPagedPickerSheet<T>(
      fetcher: fetcher,
      itemBuilder: itemBuilder,
      searchLabel: searchLabel,
      searchFieldKey: searchFieldKey,
      emptyMessage: emptyMessage,
      retryLabel: retryLabel,
      heightFactor: heightFactor,
      header: header,
      autofocus: autofocus,
      initialQuery: initialQuery,
    ),
  );
}

/// Self-contained paged picker sheet that automatically creates and manages an
/// [AppPickerCubit], listening to scroll events to trigger [AppPickerCubit.loadMore].
class AppPagedPickerSheet<T> extends StatefulWidget {
  const AppPagedPickerSheet({
    super.key,
    required this.fetcher,
    required this.itemBuilder,
    this.searchLabel = 'Search',
    this.searchFieldKey,
    this.emptyMessage = 'No results',
    this.retryLabel = 'Retry',
    this.heightFactor = 0.75,
    this.header,
    this.autofocus = false,
    this.initialQuery,
    this.cubit,
  });

  final PageFetcher<T> fetcher;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String searchLabel;
  final Key? searchFieldKey;
  final String emptyMessage;
  final String retryLabel;
  final double heightFactor;
  final Widget? header;
  final bool autofocus;
  final String? initialQuery;
  final AppPickerCubit<T>? cubit;

  @override
  State<AppPagedPickerSheet<T>> createState() => _AppPagedPickerSheetState<T>();
}

class _AppPagedPickerSheetState<T> extends State<AppPagedPickerSheet<T>> {
  late final AppPickerCubit<T> _cubit;
  late final bool _ownsCubit;
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ownsCubit = widget.cubit == null;
    _cubit = widget.cubit ?? AppPickerCubit<T>(fetcher: widget.fetcher);
    _scrollController.addListener(_onScroll);
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
    }
    _cubit.load(query: widget.initialQuery);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    if (_ownsCubit) {
      _cubit.close();
    }
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      _cubit.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPickerCubit<T>, AppPickerState<T>>(
      bloc: _cubit,
      builder: (context, state) {
        return AppPickerSheet<T>(
          searchController: _searchController,
          searchFieldKey: widget.searchFieldKey,
          searchLabel: widget.searchLabel,
          onSearchChanged: _cubit.onSearchChanged,
          onSearchSubmitted: (q) =>
              _cubit.load(query: q.trim().isEmpty ? null : q.trim()),
          isLoading: state.status == LoadStatus.loading && state.items.isEmpty,
          isLoadingMore: state.isLoadingMore,
          items: state.items,
          itemBuilder: widget.itemBuilder,
          errorMessage: state.failure != null && state.items.isEmpty
              ? failureMessage(state.failure!)
              : null,
          onRetry: () => _cubit.load(
            query: _searchController.text.trim().isEmpty
                ? null
                : _searchController.text.trim(),
          ),
          emptyMessage: widget.emptyMessage,
          retryLabel: widget.retryLabel,
          heightFactor: widget.heightFactor,
          header: widget.header,
          autofocus: widget.autofocus,
          scrollController: _scrollController,
        );
      },
    );
  }
}

/// Shared chrome for a "search and pick from a list" bottom sheet: a search
/// field (with optional extra header content, e.g. a filter chip), and a
/// loading/error/empty/list body.
class AppPickerSheet<T> extends StatelessWidget {
  const AppPickerSheet({
    super.key,
    required this.searchController,
    required this.searchLabel,
    this.searchFieldKey,
    this.onSearchSubmitted,
    this.onSearchChanged,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    this.isLoadingMore = false,
    this.errorMessage,
    this.onRetry,
    this.emptyMessage = 'No results',
    this.retryLabel = 'Retry',
    this.heightFactor = 0.75,
    this.header,
    this.autofocus = false,
    this.scrollController,
  });

  final TextEditingController searchController;
  final String searchLabel;
  final Key? searchFieldKey;
  final ValueChanged<String>? onSearchSubmitted;
  final ValueChanged<String>? onSearchChanged;
  final bool isLoading;
  final bool isLoadingMore;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String emptyMessage;
  final String retryLabel;
  final double heightFactor;
  final Widget? header;
  final bool autofocus;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * heightFactor;
    final keyboardPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardPadding),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  TextField(
                    key: searchFieldKey,
                    controller: searchController,
                    autofocus: autofocus,
                    decoration: InputDecoration(
                      labelText: searchLabel,
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.search,
                    onSubmitted: onSearchSubmitted,
                    onChanged: onSearchChanged,
                  ),
                  if (header != null) ...[const SizedBox(height: 8), header!],
                ],
              ),
            ),
            Expanded(child: _buildBody(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: Text(retryLabel)),
          ],
        ),
      );
    }

    if (items.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    final totalCount = items.length + (isLoadingMore ? 1 : 0);

    return Column(
      children: [
        if (errorMessage != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: Text(errorMessage!)),
                if (onRetry != null)
                  TextButton(onPressed: onRetry, child: Text(retryLabel)),
              ],
            ),
          ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: totalCount,
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }
              return itemBuilder(context, items[index]);
            },
          ),
        ),
      ],
    );
  }
}
