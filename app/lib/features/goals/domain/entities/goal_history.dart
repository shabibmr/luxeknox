import 'package:equatable/equatable.dart';

class GoalHistoryEntry extends Equatable {
  const GoalHistoryEntry({
    required this.id,
    required this.goalId,
    required this.recordedValue,
    required this.recordedDate,
    this.notes,
  });

  final String id;
  final String goalId;
  final num recordedValue;
  final DateTime recordedDate;
  final String? notes;

  @override
  List<Object?> get props => [id, goalId, recordedValue, recordedDate, notes];
}
