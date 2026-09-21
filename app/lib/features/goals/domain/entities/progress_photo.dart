import 'package:equatable/equatable.dart';

import 'photo_pose.dart';

class ProgressPhoto extends Equatable {
  const ProgressPhoto({
    required this.id,
    required this.memberId,
    required this.photoUrl,
    required this.pose,
    this.takenDate,
    this.isPrivate = false,
  });

  final String id;
  final String memberId;
  final String photoUrl;
  final PhotoPose pose;
  final DateTime? takenDate;
  final bool isPrivate;

  @override
  List<Object?> get props => [
    id,
    memberId,
    photoUrl,
    pose,
    takenDate,
    isPrivate,
  ];
}
