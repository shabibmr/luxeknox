import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/media/document_access.dart';
import '../entities/member_document.dart';

/// Member documents & photos gallery (screen 07). The implementation
/// (Phase W) composes `MediaUploader` for [uploadDocument]: request a
/// signed PUT, upload the bytes, then link the resulting object key to the
/// member via the People API.
abstract class DocumentRepository {
  Future<Either<Failure, List<MemberDocument>>> listDocuments(int memberId);

  Future<Either<Failure, MemberDocument>> uploadDocument({
    required int memberId,
    required DocumentPurpose purpose,
    required String title,
    required Uint8List bytes,
    required String contentType,
  });

  Future<Either<Failure, void>> deleteDocument(int memberId, int documentId);
}
