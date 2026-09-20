import 'package:app/core/media/document_access.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canAccessDocument (BR-HEALTH-001)', () {
    test('trainer is denied for id_proof', () {
      expect(
        canAccessDocument(
          role: UserType.trainer,
          purpose: DocumentPurpose.idProof,
        ),
        isFalse,
      );
    });

    test('trainer is denied for waiver', () {
      expect(
        canAccessDocument(
          role: UserType.trainer,
          purpose: DocumentPurpose.waiver,
        ),
        isFalse,
      );
    });

    test('trainer is allowed for medical_cert', () {
      expect(
        canAccessDocument(
          role: UserType.trainer,
          purpose: DocumentPurpose.medicalCert,
        ),
        isTrue,
      );
    });

    test('admin is allowed for id_proof', () {
      expect(
        canAccessDocument(
          role: UserType.admin,
          purpose: DocumentPurpose.idProof,
        ),
        isTrue,
      );
    });

    test('member is allowed for their own id_proof', () {
      expect(
        canAccessDocument(
          role: UserType.member,
          purpose: DocumentPurpose.idProof,
        ),
        isTrue,
      );
    });
  });
}
