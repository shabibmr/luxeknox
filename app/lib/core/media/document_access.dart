import '../../session/domain/entities/user_type.dart';

/// Purpose of a member document/photo, per `MemberDocument`/`MemberPhoto`
/// (screens 05/07). Narrower than [MediaPurpose] — only the purposes that
/// can appear in the People documents & photos gallery.
enum DocumentPurpose { idProof, waiver, medicalCert, receiptPdf, progressPhoto }

/// Purposes BR-HEALTH-001 forbids trainers from ever seeing or fetching.
const _identityProofDocumentPurposes = {
  DocumentPurpose.idProof,
  DocumentPurpose.waiver,
};

/// Encodes BR-HEALTH-001: trainers must never be shown or fetch
/// identity-proof / waiver files, regardless of the parent member's
/// row-level scope. Gate by purpose + role here, not just by the
/// `health.read` capability, so a trainer legitimately scoped to a client
/// still cannot reach these two purposes.
bool canAccessDocument({
  required UserType role,
  required DocumentPurpose purpose,
}) {
  if (role == UserType.trainer &&
      _identityProofDocumentPurposes.contains(purpose)) {
    return false;
  }
  return true;
}

/// Evaluates row-level parent access for media associated with a member (FR-MEDIA-003).
///
/// Ensures trainers only access data for members assigned to them, members only
/// access their own records, and admins have broad access.
bool canAccessMemberMediaParent({
  required UserType viewerRole,
  required int viewerId,
  required int parentMemberId,
  bool isAssignedTrainer = false,
  bool hasHealthReadCapability = true,
}) {
  if (viewerRole == UserType.admin) return true;
  if (viewerRole == UserType.member) return viewerId == parentMemberId;
  if (viewerRole == UserType.trainer) {
    return isAssignedTrainer && hasHealthReadCapability;
  }
  return false;
}

/// Evaluates whether the current actor may delete a media item (FR-MEDIA-004).
///
/// Receipt PDFs are never member-deletable.
bool canDeleteMedia({
  required UserType viewerRole,
  required int viewerId,
  required int parentMemberId,
  required DocumentPurpose purpose,
}) {
  if (purpose == DocumentPurpose.receiptPdf && viewerRole == UserType.member) {
    return false;
  }
  if (viewerRole == UserType.admin) return true;
  if (viewerRole == UserType.member) return viewerId == parentMemberId;
  return false;
}

