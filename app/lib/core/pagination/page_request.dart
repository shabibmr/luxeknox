import 'package:equatable/equatable.dart';

/// Cursor + limit request parameters for list endpoints.
///
/// Pair with [CursorPage] responses. Default [limit] matches common API
/// catalogue queries; callers may override per screen.
final class PageRequest extends Equatable {
  static const int defaultLimit = 20;

  /// Opaque cursor from a previous [CursorPage.nextCursor], or null for page 1.
  final String? cursor;

  /// Maximum items to return for this page.
  final int limit;

  const PageRequest({
    this.cursor,
    this.limit = defaultLimit,
  });

  PageRequest copyWith({
    String? cursor,
    int? limit,
    bool clearCursor = false,
  }) {
    return PageRequest(
      cursor: clearCursor ? null : (cursor ?? this.cursor),
      limit: limit ?? this.limit,
    );
  }

  /// Query-map helper for Dio / generated clients.
  Map<String, dynamic> toQueryParameters() {
    return {
      if (cursor != null && cursor!.isNotEmpty) 'cursor': cursor,
      'limit': limit,
    };
  }

  @override
  List<Object?> get props => [cursor, limit];
}
