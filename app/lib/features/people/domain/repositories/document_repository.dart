import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/media/document_access.dart';
import '../entities/member_document.dart';
import '../entities/member_photo.dart';

/// Member documents & photos gallery (screen 07). The implementation
/// composes `MediaUploader` for [uploadDocument] / [uploadPhoto]: request a
/// signed PUT, upload the bytes, then link the resulting object key via the
/// People/Health API.
abstract class DocumentRepository {
  Future<Either<Failure, List<MemberDocument>>> listDocuments(int memberId);

  Future<Either<Failure, MemberDocument>> uploadDocument({
    required int memberId,
    required DocumentPurpose purpose,
    required String title,
    required Uint8List bytes,
    required String contentType,
    void Function(int sent, int total)? onProgress,
  });

  Future<Either<Failure, void>> deleteDocument(int memberId, int documentId);

  /// Cancels an in-flight media PUT (upload retry/cancel UX).
  void cancelUpload();

  Future<Either<Failure, List<MemberPhoto>>> listPhotos(int memberId);

  Future<Either<Failure, MemberPhoto>> uploadPhoto({
    required int memberId,
    required Uint8List bytes,
    required String contentType,
    void Function(int sent, int total)? onProgress,
  });

  Future<Either<Failure, MemberPhoto>> setAvatar({
    required int memberId,
    required int photoId,
  });
}
