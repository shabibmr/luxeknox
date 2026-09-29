import 'package:flutter/material.dart';

/// Shared chrome for a "search and pick from a list" bottom sheet: a search
/// field (with optional extra header content, e.g. a filter chip), and a
/// loading/error/empty/list body.
///
/// This owns rendering only. State (search debouncing, cubit/bloc wiring,
/// filtering) stays with the caller, which is expected to rebuild this
/// widget (typically from inside its own `BlocBuilder`) as that state
/// changes.
class AppPickerSheet<T> extends StatelessWidget {
  const AppPickerSheet({
    super.key,
    required this.searchController,
    required this.searchLabel,
    required this.onSearchSubmitted,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    this.errorMessage,
    this.onRetry,
    this.emptyMessage = 'No results',
    this.retryLabel = 'Retry',
    this.heightFactor = 0.75,
    this.header,
    this.autofocus = false,
  });

  final TextEditingController searchController;
  final String searchLabel;
  final ValueChanged<String> onSearchSubmitted;
  final bool isLoading;
  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String emptyMessage;
  final String retryLabel;
  final double heightFactor;
  final Widget? header;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * heightFactor;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  autofocus: autofocus,
                  decoration: InputDecoration(
                    labelText: searchLabel,
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: onSearchSubmitted,
                ),
                if (header != null) ...[
                  const SizedBox(height: 8),
                  header!,
                ],
              ],
            ),
          ),
          Expanded(child: _buildBody(context)),
        ],
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
            itemCount: items.length,
            itemBuilder: (context, index) =>
                itemBuilder(context, items[index]),
          ),
        ),
      ],
    );
  }
}
