import 'package:luxeknox/core/media/document_access.dart';
import 'package:luxeknox/session/domain/entities/user_type.dart';
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

  group('canAccessMemberMediaParent (FR-MEDIA-003)', () {
    test('admin is always allowed', () {
      expect(
        canAccessMemberMediaParent(
          viewerRole: UserType.admin,
          viewerId: 99,
          parentMemberId: 1,
        ),
        isTrue,
      );
    });

    test('member is allowed for own parent record', () {
      expect(
        canAccessMemberMediaParent(
          viewerRole: UserType.member,
          viewerId: 42,
          parentMemberId: 42,
        ),
        isTrue,
      );
    });

    test('member is denied for another member parent record', () {
      expect(
        canAccessMemberMediaParent(
          viewerRole: UserType.member,
          viewerId: 42,
          parentMemberId: 43,
        ),
        isFalse,
      );
    });

    test('assigned trainer with health capability is allowed', () {
      expect(
        canAccessMemberMediaParent(
          viewerRole: UserType.trainer,
          viewerId: 5,
          parentMemberId: 42,
          isAssignedTrainer: true,
          hasHealthReadCapability: true,
        ),
        isTrue,
      );
    });

    test('unassigned trainer is denied', () {
      expect(
        canAccessMemberMediaParent(
          viewerRole: UserType.trainer,
          viewerId: 5,
          parentMemberId: 42,
          isAssignedTrainer: false,
          hasHealthReadCapability: true,
        ),
        isFalse,
      );
    });

    test('assigned trainer without health capability is denied', () {
      expect(
        canAccessMemberMediaParent(
          viewerRole: UserType.trainer,
          viewerId: 5,
          parentMemberId: 42,
          isAssignedTrainer: true,
          hasHealthReadCapability: false,
        ),
        isFalse,
      );
    });
  });

  group('canDeleteMedia (FR-MEDIA-004)', () {
    test('member cannot delete receipt_pdf', () {
      expect(
        canDeleteMedia(
          viewerRole: UserType.member,
          viewerId: 10,
          parentMemberId: 10,
          purpose: DocumentPurpose.receiptPdf,
        ),
        isFalse,
      );
    });

    test('admin can delete receipt_pdf', () {
      expect(
        canDeleteMedia(
          viewerRole: UserType.admin,
          viewerId: 1,
          parentMemberId: 10,
          purpose: DocumentPurpose.receiptPdf,
        ),
        isTrue,
      );
    });

    test('member can delete own waiver or id proof', () {
      expect(
        canDeleteMedia(
          viewerRole: UserType.member,
          viewerId: 10,
          parentMemberId: 10,
          purpose: DocumentPurpose.idProof,
        ),
        isTrue,
      );
    });

    test('trainer cannot delete member media', () {
      expect(
        canDeleteMedia(
          viewerRole: UserType.trainer,
          viewerId: 5,
          parentMemberId: 10,
          purpose: DocumentPurpose.progressPhoto,
        ),
        isFalse,
      );
    });
  });
}
