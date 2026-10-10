import 'package:equatable/equatable.dart';

import 'photo_pose.dart';
import 'progress_photo.dart';

/// Pair of photos for one pose across two comparison dates.
class ProgressPhotoPosePair extends Equatable {
  const ProgressPhotoPosePair({this.date1, this.date2});

  final ProgressPhoto? date1;
  final ProgressPhoto? date2;

  @override
  List<Object?> get props => [date1, date2];
}

/// Result of `GET /members/:id/progress-photos/comparison`.
class ProgressPhotoComparison extends Equatable {
  const ProgressPhotoComparison({
    required this.date1,
    required this.date2,
    this.front = const ProgressPhotoPosePair(),
    this.side = const ProgressPhotoPosePair(),
    this.back = const ProgressPhotoPosePair(),
  });

  final DateTime date1;
  final DateTime date2;
  final ProgressPhotoPosePair front;
  final ProgressPhotoPosePair side;
  final ProgressPhotoPosePair back;

  ProgressPhotoPosePair pairFor(PhotoPose pose) {
    return switch (pose) {
      PhotoPose.front => front,
      PhotoPose.side => side,
      PhotoPose.back => back,
    };
  }

  @override
  List<Object?> get props => [date1, date2, front, side, back];
}
