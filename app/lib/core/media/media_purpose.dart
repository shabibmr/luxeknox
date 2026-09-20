/// Mirrors the OpenAPI `MediaUploadRequest.purpose` enum (`/media/uploads`).
///
/// Each purpose carries the client-side size/MIME limits enforced by
/// [MediaUploader] before any bytes leave the device (FR-MEDIA-002).
enum MediaPurpose {
  exerciseMedia('exercise_media', _imageMimeTypes, 10 * 1024 * 1024),
  avatar('avatar', _imageMimeTypes, 5 * 1024 * 1024),
  progressPhoto('progress_photo', _imageMimeTypes, 10 * 1024 * 1024),
  idProof('id_proof', _documentMimeTypes, 15 * 1024 * 1024),
  waiver('waiver', _documentMimeTypes, 15 * 1024 * 1024),
  medicalCert('medical_cert', _documentMimeTypes, 15 * 1024 * 1024),
  receiptPdf('receipt_pdf', _pdfMimeTypes, 15 * 1024 * 1024);

  const MediaPurpose(this.wireValue, this.allowedMimeTypes, this.maxSizeBytes);

  /// The wire value sent as `MediaUploadRequest.purpose`.
  final String wireValue;

  /// MIME types accepted for this purpose.
  final Set<String> allowedMimeTypes;

  /// Maximum upload size, in bytes, accepted for this purpose.
  final int maxSizeBytes;
}

const _imageMimeTypes = {'image/jpeg', 'image/png', 'image/webp'};
const _documentMimeTypes = {'image/jpeg', 'image/png', 'application/pdf'};
const _pdfMimeTypes = {'application/pdf'};

/// Purposes that identify or verify a person (BR-HEALTH-001).
///
/// Trainers must never see or fetch files uploaded for these purposes —
/// only [DocumentAccess.canAccess] is authoritative; this set exists so
/// callers can label a purpose without importing session/role types here.
const identityProofPurposes = {MediaPurpose.idProof, MediaPurpose.waiver};
