import 'package:built_collection/built_collection.dart';
import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/lifestyle_intake.dart';

LifestylePriorityDomain _domainFromApi(api.LifestylePriorityPriorityEnum e) {
  if (e == api.LifestylePriorityPriorityEnum.sleep) {
    return LifestylePriorityDomain.sleep;
  }
  if (e == api.LifestylePriorityPriorityEnum.nutrition) {
    return LifestylePriorityDomain.nutrition;
  }
  if (e == api.LifestylePriorityPriorityEnum.activity) {
    return LifestylePriorityDomain.activity;
  }
  return LifestylePriorityDomain.recovery;
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
  for (final level in ActivityLevel.values) {
    if (level.name == s) return level;
  }
  return null;
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
