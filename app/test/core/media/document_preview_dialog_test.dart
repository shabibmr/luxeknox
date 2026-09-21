import 'package:app/core/media/document_access.dart';
import 'package:app/core/media/document_preview_dialog.dart';
import 'package:app/core/media/signed_media_image.dart';
import 'package:app/core/media/signed_media_resolver.dart';
import 'package:app/session/domain/entities/user_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockSignedMediaResolver extends Mock implements SignedMediaResolver {}

void main() {
  late MockSignedMediaResolver mockResolver;

  setUp(() {
    mockResolver = MockSignedMediaResolver();
  });

  group('DocumentPreviewDialog (FR-MEDIA-003 & BR-HEALTH-001)', () {
    testWidgets('denies access to trainer attempting to view idProof', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DocumentPreviewDialog(
              objectKey: 'id/member_1.jpg',
              title: 'National ID',
              purpose: DocumentPurpose.idProof,
              viewerRole: UserType.trainer,
              resolver: mockResolver,
            ),
          ),
        ),
      );

      expect(find.text('Access Restricted'), findsOneWidget);
      expect(
        find.text('Trainers are not permitted to view identity-proof or waiver files (BR-HEALTH-001).'),
        findsOneWidget,
      );
      verifyZeroInteractions(mockResolver);
    });

    testWidgets('renders document info, open link, and download button for PDF', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DocumentPreviewDialog(
              objectKey: 'certs/med.pdf',
              title: 'Medical Certificate',
              purpose: DocumentPurpose.medicalCert,
              viewerRole: UserType.trainer,
              contentType: 'application/pdf',
              fileSize: 1024 * 1024 * 2, // 2MB
              resolver: mockResolver,
            ),
          ),
        ),
      );

      expect(find.text('Medical Certificate'), findsNWidgets(2)); // Title bar + body
      expect(find.text('Type: medicalCert'), findsOneWidget);
      expect(find.text('Size: 2.0 MB'), findsOneWidget);
      expect(find.text('Open Document'), findsOneWidget);
      expect(find.text('Download Copy'), findsOneWidget);
    });

    testWidgets('renders SignedMediaImage for image document', (tester) async {
      when(() => mockResolver.resolve('photos/checkin.png', forceRefresh: any(named: 'forceRefresh')))
          .thenAnswer((_) async => const Right('https://example.com/photo.png'));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DocumentPreviewDialog(
              objectKey: 'photos/checkin.png',
              title: 'Progress Photo',
              purpose: DocumentPurpose.progressPhoto,
              viewerRole: UserType.member,
              contentType: 'image/png',
              resolver: mockResolver,
            ),
          ),
        ),
      );

      expect(find.byType(SignedMediaImage), findsOneWidget);
    });
  });
}
