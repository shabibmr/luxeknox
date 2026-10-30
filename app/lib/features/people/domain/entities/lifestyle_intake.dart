import 'package:equatable/equatable.dart';

/// Mirrors `LifestylePriorityPriorityEnum`. The server requires exactly one
/// [LifestylePriority] per domain.
enum LifestylePriorityDomain { sleep, nutrition, activity, recovery }

/// One row of the "top lifestyle priorities" table: where the member is now
/// and the first action agreed for [domain].
class LifestylePriority extends Equatable {
  final LifestylePriorityDomain domain;
  final String currentStatus;
  final String firstAction;

  const LifestylePriority({
    required this.domain,
    required this.currentStatus,
    required this.firstAction,
  });

  @override
  List<Object?> get props => [domain, currentStatus, firstAction];
}

/// Mirrors `LifestyleIntake` (member lifestyle & habits consultation).
class LifestyleIntake extends Equatable {
  final int id;
  final int memberId;
  final String? activityLevel;
  final String? trainingHistory;
  final String? currentPainDiscomfort;
  final double? sleepHoursTypical;

  /// 1 (calm) to 10 (very stressed).
  final int stressLevel;
  final String? workActivityDemands;
  final int? typicalDailySteps;
  final String? nutritionApproach;
  final String? hydrationHabits;
  final String? recoveryHabits;
  final String? otherNotes;
  final List<LifestylePriority> priorities;
  final int? conductedByTrainerId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const LifestyleIntake({
    required this.id,
    required this.memberId,
    required this.stressLevel,
    required this.priorities,
    required this.createdAt,
    this.activityLevel,
    this.trainingHistory,
    this.currentPainDiscomfort,
    this.sleepHoursTypical,
    this.workActivityDemands,
    this.typicalDailySteps,
    this.nutritionApproach,
    this.hydrationHabits,
    this.recoveryHabits,
    this.otherNotes,
    this.conductedByTrainerId,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    memberId,
    activityLevel,
    trainingHistory,
    currentPainDiscomfort,
    sleepHoursTypical,
    stressLevel,
    workActivityDemands,
    typicalDailySteps,
    nutritionApproach,
    hydrationHabits,
    recoveryHabits,
    otherNotes,
    priorities,
    conductedByTrainerId,
    createdAt,
    updatedAt,
  ];
}

/// Create-or-replace payload for [memberId]'s lifestyle intake.
class LifestyleIntakeInput extends Equatable {
  static const minStress = 1;
  static const maxStress = 10;

  final int memberId;
  final int stressLevel;
  final List<LifestylePriority> priorities;
  final String? activityLevel;
  final String? trainingHistory;
  final String? currentPainDiscomfort;

  /// At most one decimal place.
  final double? sleepHoursTypical;
  final String? workActivityDemands;
  final int? typicalDailySteps;
  final String? nutritionApproach;
  final String? hydrationHabits;
  final String? recoveryHabits;
  final String? otherNotes;

  /// Ignored by the server when a trainer is the signed-in actor.
  final int? conductedByTrainerId;

  const LifestyleIntakeInput({
    required this.memberId,
    required this.stressLevel,
    required this.priorities,
    this.activityLevel,
    this.trainingHistory,
    this.currentPainDiscomfort,
    this.sleepHoursTypical,
    this.workActivityDemands,
    this.typicalDailySteps,
    this.nutritionApproach,
    this.hydrationHabits,
    this.recoveryHabits,
    this.otherNotes,
    this.conductedByTrainerId,
  });

  @override
  List<Object?> get props => [
    memberId,
    stressLevel,
    priorities,
    activityLevel,
    trainingHistory,
    currentPainDiscomfort,
    sleepHoursTypical,
    workActivityDemands,
    typicalDailySteps,
    nutritionApproach,
    hydrationHabits,
    recoveryHabits,
    otherNotes,
    conductedByTrainerId,
  ];
}
