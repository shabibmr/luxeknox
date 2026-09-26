import 'package:luxeknox/core/media/document_access.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canAccessDocument (BR-HEALTH-001)', () {
    test('trainer cannot access idProof or waiver', () {
      expect(
        canAccessDocument(
          role: UserType.trainer,
          purpose: DocumentPurpose.idProof,
        ),
        isFalse,
      );
      expect(
        canAccessDocument(
          role: UserType.trainer,
          purpose: DocumentPurpose.waiver,
        ),
        isFalse,
      );
    });

    test('trainer can access medicalCert and progressPhoto', () {
      expect(
        canAccessDocument(
          role: UserType.trainer,
          purpose: DocumentPurpose.medicalCert,
        ),
        isTrue,
      );
      expect(
        canAccessDocument(
          role: UserType.trainer,
          purpose: DocumentPurpose.progressPhoto,
        ),
        isTrue,
      );
    });

    test('admin and member can access identity documents', () {
      for (final role in [UserType.admin, UserType.member, UserType.employee]) {
        expect(
          canAccessDocument(role: role, purpose: DocumentPurpose.idProof),
          isTrue,
        );
        expect(
          canAccessDocument(role: role, purpose: DocumentPurpose.waiver),
          isTrue,
        );
      }
    });
  });
}
