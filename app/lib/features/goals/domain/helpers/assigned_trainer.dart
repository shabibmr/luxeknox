/// True when the signed-in trainer's profile id is this member's assigned trainer.
bool resolveIsAssignedTrainer({
  required bool isTrainerPrincipal,
  required String? sessionProfileId,
  required int? assignedTrainerId,
}) {
  if (!isTrainerPrincipal) return false;
  if (sessionProfileId == null || sessionProfileId.isEmpty) return false;
  if (assignedTrainerId == null) return false;
  return assignedTrainerId.toString() == sessionProfileId;
}
