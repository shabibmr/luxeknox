import 'dart:typed_data';

import 'package:luxeknox/core/media/document_access.dart';
import 'package:luxeknox/features/people/domain/entities/member_document.dart';
import 'package:luxeknox/features/people/domain/repositories/document_repository.dart';
import 'package:luxeknox/features/people/domain/usecases/delete_document_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/list_documents_usecase.dart';
import 'package:luxeknox/features/people/domain/usecases/upload_document_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockDocumentRepository extends Mock implements DocumentRepository {}

void main() {
  late MockDocumentRepository mockRepository;

  const tDocument = MemberDocument(
    id: 1,
    memberId: 1,
    documentType: DocumentPurpose.medicalCert,
    title: 'Clearance letter',
  );

  final tBytes = Uint8List.fromList([1, 2, 3]);

  setUp(() {
    mockRepository = MockDocumentRepository();
  });

  group('Document UseCases', () {
    test('ListDocumentsUseCase calls repository.listDocuments', () async {
      when(
        () => mockRepository.listDocuments(1),
      ).thenAnswer((_) async => const Right([tDocument]));

      final useCase = ListDocumentsUseCase(mockRepository);
      final result = await useCase(1);

      expect(result, const Right([tDocument]));
      verify(() => mockRepository.listDocuments(1)).called(1);
    });

    test('UploadDocumentUseCase calls repository.uploadDocument', () async {
      when(
        () => mockRepository.uploadDocument(
          memberId: 1,
          purpose: DocumentPurpose.medicalCert,
          title: 'Clearance letter',
          bytes: tBytes,
          contentType: 'application/pdf',
        ),
      ).thenAnswer((_) async => const Right(tDocument));

      final useCase = UploadDocumentUseCase(mockRepository);
      final result = await useCase(
        UploadDocumentParams(
          memberId: 1,
          purpose: DocumentPurpose.medicalCert,
          title: 'Clearance letter',
          bytes: tBytes,
          contentType: 'application/pdf',
        ),
      );

      expect(result, const Right(tDocument));
      verify(
        () => mockRepository.uploadDocument(
          memberId: 1,
          purpose: DocumentPurpose.medicalCert,
          title: 'Clearance letter',
          bytes: tBytes,
          contentType: 'application/pdf',
        ),
      ).called(1);
    });

    test('DeleteDocumentUseCase calls repository.deleteDocument', () async {
      when(
        () => mockRepository.deleteDocument(1, 2),
      ).thenAnswer((_) async => const Right(null));

      final useCase = DeleteDocumentUseCase(mockRepository);
      final result = await useCase(
        const DeleteDocumentParams(memberId: 1, documentId: 2),
      );

      expect(result, const Right(null));
      verify(() => mockRepository.deleteDocument(1, 2)).called(1);
    });
  });
}
