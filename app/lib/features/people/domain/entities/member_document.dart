import 'package:equatable/equatable.dart';

import '../../../../core/media/document_access.dart';

/// Mirrors `MemberDocument` (screen 07: Documents & Photos Gallery).
///
/// [objectKey] is the media object storage key — resolved to a short-lived
/// signed URL via `SignedMediaResolver`/`SignedFileLink`, never a raw URL
/// (FR-MEDIA-003). [documentType] reuses `DocumentPurpose` from
/// `core/media` so BR-HEALTH-001's `canAccessDocument` gate can be applied
/// directly to a fetched [MemberDocument] without a second enum.
class MemberDocument extends Equatable {
  final int id;
  final int memberId;
  final DocumentPurpose documentType;
  final String? title;
  final String? objectKey;
  final int? fileSize;
  final int? verifiedByUserId;
  final DateTime? verifiedAt;

  const MemberDocument({
    required this.id,
    required this.memberId,
    required this.documentType,
    this.title,
    this.objectKey,
    this.fileSize,
    this.verifiedByUserId,
    this.verifiedAt,
  });

  bool get isVerified => verifiedAt != null;

  @override
  List<Object?> get props => [
    id,
    memberId,
    documentType,
    title,
    objectKey,
    fileSize,
    verifiedByUserId,
    verifiedAt,
  ];
}
