import 'package:equatable/equatable.dart';

/// Gallery photo for a member (screen 07: Documents & Photos).
///
/// [objectKey] is the media storage key (wire `photo_url`) — resolve via
/// [SignedMediaResolver], never treat as a durable URL (FR-MEDIA-003).
class MemberPhoto extends Equatable {
  const MemberPhoto({
    required this.id,
    required this.memberId,
    required this.objectKey,
    this.isCurrentAvatar = false,
    this.capturedAt,
  });

  final int id;
  final int memberId;
  final String objectKey;
  final bool isCurrentAvatar;
  final DateTime? capturedAt;

  @override
  List<Object?> get props => [
    id,
    memberId,
    objectKey,
    isCurrentAvatar,
    capturedAt,
  ];
}
