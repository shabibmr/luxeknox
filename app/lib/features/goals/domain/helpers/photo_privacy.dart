import '../entities/progress_photo.dart';

/// Filters photos for the current viewer (FR-GOAL-012).
/// Private photos are visible to the owner, assigned trainer, or moderators.
List<ProgressPhoto> filterPhotosForViewer(
  Iterable<ProgressPhoto> photos, {
  required bool isOwner,
  required bool isAssignedTrainer,
  required bool canModerate,
}) {
  return photos.where((p) {
    if (!p.isPrivate) return true;
    return isOwner || isAssignedTrainer || canModerate;
  }).toList();
}
