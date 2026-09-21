import 'package:app/features/goals/domain/entities/photo_pose.dart';
import 'package:app/features/goals/domain/entities/progress_photo.dart';
import 'package:app/features/goals/domain/helpers/photo_privacy.dart';
import 'package:flutter_test/flutter_test.dart';

ProgressPhoto photo({required String id, required bool isPrivate}) {
  return ProgressPhoto(
    id: id,
    memberId: '1',
    photoUrl: 'https://example.com/$id.jpg',
    pose: PhotoPose.front,
    isPrivate: isPrivate,
  );
}

void main() {
  final photos = [
    photo(id: 'pub', isPrivate: false),
    photo(id: 'priv', isPrivate: true),
  ];

  test('owner sees private', () {
    final filtered = filterPhotosForViewer(
      photos,
      isOwner: true,
      isAssignedTrainer: false,
      canModerate: false,
    );
    expect(filtered.map((p) => p.id), ['pub', 'priv']);
  });

  test('assigned trainer sees private', () {
    final filtered = filterPhotosForViewer(
      photos,
      isOwner: false,
      isAssignedTrainer: true,
      canModerate: false,
    );
    expect(filtered.map((p) => p.id), ['pub', 'priv']);
  });

  test('moderator sees private', () {
    final filtered = filterPhotosForViewer(
      photos,
      isOwner: false,
      isAssignedTrainer: false,
      canModerate: true,
    );
    expect(filtered.map((p) => p.id), ['pub', 'priv']);
  });

  test('unrelated viewer hides private', () {
    final filtered = filterPhotosForViewer(
      photos,
      isOwner: false,
      isAssignedTrainer: false,
      canModerate: false,
    );
    expect(filtered.map((p) => p.id), ['pub']);
  });
}
