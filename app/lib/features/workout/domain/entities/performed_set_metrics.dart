import 'package:equatable/equatable.dart';

/// Value object representing performed set metrics.
/// Target metrics live on plan exercises only and are never sent with set logs/updates.
class PerformedSetMetrics extends Equatable {
  const PerformedSetMetrics({
    this.repsCompleted,
    this.weightLiftedKg,
    this.rpeScore,
    this.actualRir,
    this.actualDurationSeconds,
    this.isCompleted,
    this.notes,
  });

  final int? repsCompleted;
  final num? weightLiftedKg;
  final num? rpeScore;
  final num? actualRir;
  final int? actualDurationSeconds;
  final bool? isCompleted;
  final String? notes;

  PerformedSetMetrics copyWith({
    int? repsCompleted,
    num? weightLiftedKg,
    num? rpeScore,
    num? actualRir,
    int? actualDurationSeconds,
    bool? isCompleted,
    String? notes,
  }) {
    return PerformedSetMetrics(
      repsCompleted: repsCompleted ?? this.repsCompleted,
      weightLiftedKg: weightLiftedKg ?? this.weightLiftedKg,
      rpeScore: rpeScore ?? this.rpeScore,
      actualRir: actualRir ?? this.actualRir,
      actualDurationSeconds:
          actualDurationSeconds ?? this.actualDurationSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    repsCompleted,
    weightLiftedKg,
    rpeScore,
    actualRir,
    actualDurationSeconds,
    isCompleted,
    notes,
  ];
}
