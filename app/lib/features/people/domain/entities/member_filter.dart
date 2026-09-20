import 'package:equatable/equatable.dart';

/// Mirrors `FoodFilter`/`ExerciseFilter`. Used by the admin Members list and
/// by a trainer's assigned-clients view (`assignedTrainerId`).
class MemberFilter extends Equatable {
  final String? query;
  final int? assignedTrainerId;

  const MemberFilter({this.query, this.assignedTrainerId});

  bool get isEmpty => query == null && assignedTrainerId == null;

  @override
  List<Object?> get props => [query, assignedTrainerId];
}
