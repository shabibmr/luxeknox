import 'package:equatable/equatable.dart';

/// Represents the permissions (capabilities) available to the authenticated user.
class Capabilities extends Equatable {
  /// List of permission slugs (e.g. 'exercises.update', 'exercises.create').
  final List<String> slugs;

  const Capabilities({required this.slugs});

  /// Check if the user has the specified permission.
  bool can(String slug) => slugs.contains(slug);

  @override
  List<Object?> get props => [slugs];
}
