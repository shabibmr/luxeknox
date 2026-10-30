import 'package:built_collection/built_collection.dart';
import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/lifestyle_intake.dart';

LifestylePriorityDomain _domainFromApi(api.LifestylePriorityPriorityEnum e) {
  return switch (e) {
    api.LifestylePriorityPriorityEnum.sleep => LifestylePriorityDomain.sleep,
    api.LifestylePriorityPriorityEnum.nutrition =>
      LifestylePriorityDomain.nutrition,
    api.LifestylePriorityPriorityEnum.activity =>
      LifestylePriorityDomain.activity,
    api.LifestylePriorityPriorityEnum.recovery =>
      LifestylePriorityDomain.recovery,
    _ => throw FormatException('Unknown LifestylePriorityPriorityEnum: $e'),
  };
}

api.LifestylePriorityPriorityEnum _domainToApi(LifestylePriorityDomain d) {
  return switch (d) {
    LifestylePriorityDomain.sleep => api.LifestylePriorityPriorityEnum.sleep,
    LifestylePriorityDomain.nutrition =>
      api.LifestylePriorityPriorityEnum.nutrition,
    LifestylePriorityDomain.activity =>
      api.LifestylePriorityPriorityEnum.activity,
    LifestylePriorityDomain.recovery =>
      api.LifestylePriorityPriorityEnum.recovery,
  };
}

ActivityLevel? _activityFromApi(String? s) {
  if (s == null) return null;
  return switch (s) {
    'sedentary' => ActivityLevel.sedentary,
    'light' => ActivityLevel.light,
    'moderate' => ActivityLevel.moderate,
    'high' => ActivityLevel.high,
    _ => throw FormatException('Unknown ActivityLevel: $s'),
  };
}

LifestyleIntake lifestyleIntakeFromApi(api.LifestyleIntake i) {
  return LifestyleIntake(
    id: i.id,
    memberId: i.memberId,
    activityLevel: _activityFromApi(i.activityLevel),
    trainingHistory: i.trainingHistory,
    currentPainDiscomfort: i.currentPainDiscomfort,
    // The server returns the decimal column as a string, e.g. "7.5".
    sleepHoursTypical: i.sleepHoursTypical == null
        ? null
        : double.tryParse(i.sleepHoursTypical!),
    stressLevel: i.stressLevel,
    workActivityDemands: i.workActivityDemands,
    typicalDailySteps: i.typicalDailySteps,
    nutritionApproach: i.nutritionApproach,
    hydrationHabits: i.hydrationHabits,
    recoveryHabits: i.recoveryHabits,
    otherNotes: i.otherNotes,
    priorities: [
      for (final p in i.lifestylePriorities ?? const <api.LifestylePriority>[])
        LifestylePriority(
          domain: _domainFromApi(p.priority),
          currentStatus: p.currentStatus,
          firstAction: p.firstAction,
        ),
    ],
    conductedByTrainerId: i.conductedByTrainerId,
    createdAt: i.createdAt,
    updatedAt: i.updatedAt,
  );
}

api.LifestyleIntakeWrite lifestyleIntakeToApi(LifestyleIntakeInput i) {
  return api.LifestyleIntakeWrite(
    (b) => b
      ..activityLevel = i.activityLevel?.name
      ..trainingHistory = i.trainingHistory
      ..currentPainDiscomfort = i.currentPainDiscomfort
      ..sleepHoursTypical = i.sleepHoursTypical
      ..stressLevel = i.stressLevel
      ..workActivityDemands = i.workActivityDemands
      ..typicalDailySteps = i.typicalDailySteps
      ..nutritionApproach = i.nutritionApproach
      ..hydrationHabits = i.hydrationHabits
      ..recoveryHabits = i.recoveryHabits
      ..otherNotes = i.otherNotes
      ..conductedByTrainerId = i.conductedByTrainerId
      ..lifestylePriorities = ListBuilder<api.LifestylePriority>([
        for (final p in i.priorities)
          api.LifestylePriority(
            (pb) => pb
              ..priority = _domainToApi(p.domain)
              ..currentStatus = p.currentStatus
              ..firstAction = p.firstAction,
          ),
      ]),
  );
}
