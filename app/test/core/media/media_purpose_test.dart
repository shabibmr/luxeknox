import 'package:luxeknox/core/media/media_purpose.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MediaPurpose (FR-MEDIA-002 & ADR-0008)', () {
    test('all purpose definitions match ADR-0008 specifications', () {
      expect(MediaPurpose.avatar.maxSizeBytes, equals(5 * 1024 * 1024));
      expect(MediaPurpose.avatar.wireValue, equals('avatar'));
      expect(MediaPurpose.avatar.allowedMimeTypes, containsAll(['image/jpeg', 'image/png', 'image/webp']));

      expect(MediaPurpose.idProof.maxSizeBytes, equals(10 * 1024 * 1024));
      expect(MediaPurpose.idProof.wireValue, equals('id_proof'));
      expect(MediaPurpose.idProof.allowedMimeTypes, containsAll(['image/jpeg', 'image/png', 'application/pdf']));

      expect(MediaPurpose.waiver.maxSizeBytes, equals(10 * 1024 * 1024));
      expect(MediaPurpose.waiver.wireValue, equals('waiver'));
      expect(MediaPurpose.waiver.allowedMimeTypes, containsAll(['application/pdf', 'image/jpeg', 'image/png']));

      expect(MediaPurpose.medicalCert.maxSizeBytes, equals(10 * 1024 * 1024));
      expect(MediaPurpose.medicalCert.wireValue, equals('medical_cert'));
      expect(MediaPurpose.medicalCert.allowedMimeTypes, containsAll(['application/pdf', 'image/jpeg', 'image/png']));

      expect(MediaPurpose.progressPhoto.maxSizeBytes, equals(8 * 1024 * 1024));
      expect(MediaPurpose.progressPhoto.wireValue, equals('progress_photo'));
      expect(MediaPurpose.progressPhoto.allowedMimeTypes, containsAll(['image/jpeg', 'image/png', 'image/webp']));

      expect(MediaPurpose.exerciseMedia.maxSizeBytes, equals(50 * 1024 * 1024));
      expect(MediaPurpose.exerciseMedia.wireValue, equals('exercise_media'));
      expect(
        MediaPurpose.exerciseMedia.allowedMimeTypes,
        containsAll(['image/gif', 'image/jpeg', 'image/png', 'video/mp4']),
      );

      expect(MediaPurpose.receiptPdf.maxSizeBytes, equals(5 * 1024 * 1024));
      expect(MediaPurpose.receiptPdf.wireValue, equals('receipt_pdf'));
      expect(MediaPurpose.receiptPdf.allowedMimeTypes, contains('application/pdf'));
    });

    test('maxSizeBytesFormatted displays human readable string', () {
      expect(MediaPurpose.avatar.maxSizeBytesFormatted, equals('5 MB'));
      expect(MediaPurpose.progressPhoto.maxSizeBytesFormatted, equals('8 MB'));
      expect(MediaPurpose.exerciseMedia.maxSizeBytesFormatted, equals('50 MB'));
    });

    test('identityProofPurposes contains only idProof and waiver', () {
      expect(
        identityProofPurposes,
        equals({MediaPurpose.idProof, MediaPurpose.waiver}),
      );
    });
  });
}
