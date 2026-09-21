import 'package:equatable/equatable.dart';

class DietLog extends Equatable {
  final String id;
  final String memberId;
  final DateTime loggedDate;
  final String? dietPlanId;
  final num? totalCaloriesConsumed;
  final num? adherenceScore;
  final int? waterIntakeMl;
  final String? memberNotes;

  const DietLog({
    required this.id,
    required this.memberId,
    required this.loggedDate,
    this.dietPlanId,
    this.totalCaloriesConsumed,
    this.adherenceScore,
    this.waterIntakeMl,
    this.memberNotes,
  });

  DietLog copyWith({
    String? id,
    String? memberId,
    DateTime? loggedDate,
    String? dietPlanId,
    num? totalCaloriesConsumed,
    num? adherenceScore,
    int? waterIntakeMl,
    String? memberNotes,
  }) {
    return DietLog(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      loggedDate: loggedDate ?? this.loggedDate,
      dietPlanId: dietPlanId ?? this.dietPlanId,
      totalCaloriesConsumed:
          totalCaloriesConsumed ?? this.totalCaloriesConsumed,
      adherenceScore: adherenceScore ?? this.adherenceScore,
      waterIntakeMl: waterIntakeMl ?? this.waterIntakeMl,
      memberNotes: memberNotes ?? this.memberNotes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    memberId,
    loggedDate,
    dietPlanId,
    totalCaloriesConsumed,
    adherenceScore,
    waterIntakeMl,
    memberNotes,
  ];
}
