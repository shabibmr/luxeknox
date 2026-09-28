import 'package:api_client/api_client.dart' as api;

import '../../domain/entities/diet_log.dart';

extension DietLogModelMapper on api.DietLog {
  DietLog toDomain() {
    return DietLog(
      id: id.toString(),
      memberId: memberId.toString(),
      loggedDate: loggedDate.toDateTime(),
      dietPlanId: dietPlanId?.toString(),
      totalCaloriesConsumed: totalCaloriesConsumed,
      adherenceScore: adherenceScore,
      waterIntakeMl: waterIntakeMl,
      memberNotes: memberNotes,
    );
  }
}

api.DietLogWrite toDietLogWrite({
  String? dietPlanId,
  num? totalCaloriesConsumed,
  num? adherenceScore,
  int? waterIntakeMl,
  String? memberNotes,
}) {
  return api.DietLogWrite(
    (b) => b
      ..dietPlanId = dietPlanId == null ? null : int.tryParse(dietPlanId)
      ..totalCaloriesConsumed = totalCaloriesConsumed
      ..adherenceScore = adherenceScore
      ..waterIntakeMl = waterIntakeMl
      ..memberNotes = memberNotes,
  );
}
