import 'package:equatable/equatable.dart';

/// Generic container for paginated data using cursor-based pagination.
///
/// This class holds a page of results along with pagination metadata,
/// enabling efficient retrieval of large datasets.
///
/// Type parameter [T]: The type of items in the current page.
final class CursorPage<T> extends Equatable {
  /// The items in the current page.
  final List<T> items;

  /// The cursor to use when fetching the next page, or null if there are no more pages.
  final String? nextCursor;

  /// Whether more pages are available after this one.
  final bool hasMore;

  const CursorPage({
    required this.items,
    required this.nextCursor,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [items, nextCursor, hasMore];
}
