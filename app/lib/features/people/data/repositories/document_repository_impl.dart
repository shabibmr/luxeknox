import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/media/document_access.dart';
import '../../../../core/media/media_purpose.dart';
import '../../../../core/media/media_uploader.dart';
import '../../domain/entities/member_document.dart';
import '../../domain/entities/member_photo.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/people_mapper.dart';

MediaPurpose _mediaPurposeFor(DocumentPurpose purpose) {
  return switch (purpose) {
    DocumentPurpose.idProof => MediaPurpose.idProof,
    DocumentPurpose.waiver => MediaPurpose.waiver,
    DocumentPurpose.medicalCert => MediaPurpose.medicalCert,
    DocumentPurpose.receiptPdf => MediaPurpose.receiptPdf,
    DocumentPurpose.progressPhoto => MediaPurpose.progressPhoto,
  };
}

@LazySingleton(as: DocumentRepository)
class DocumentRepositoryImpl implements DocumentRepository {
  DocumentRepositoryImpl(this._remote, this._uploader);

  final ProfileRemoteDataSource _remote;
  final MediaUploader _uploader;

  @override
  Future<Either<Failure, List<MemberDocument>>> listDocuments(
    int memberId,
  ) async {
    try {
      final page = await _remote.listDocuments(memberId);
      return Right(page.data.map(memberDocumentFromApi).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MemberDocument>> uploadDocument({
    required int memberId,
    required DocumentPurpose purpose,
    required String title,
    required Uint8List bytes,
    required String contentType,
    void Function(int sent, int total)? onProgress,
  }) async {
    final uploadResult = await _uploader.upload(
      bytes: bytes,
      contentType: contentType,
      purpose: _mediaPurposeFor(purpose),
      onProgress: onProgress,
    );
    return uploadResult.fold(Left.new, (objectKey) async {
      try {
        final created = await _remote.createDocument(
          memberId,
          memberDocumentWrite(
            purpose: purpose,
            objectKey: objectKey,
            title: title,
            fileSize: bytes.lengthInBytes,
          ),
        );
        return Right(memberDocumentFromApi(created));
      } catch (e) {
        return Left(mapThrownToFailure(e));
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteDocument(
    int memberId,
    int documentId,
  ) async {
    try {
      await _remote.deleteDocument(memberId, documentId);
      return const Right(null);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  void cancelUpload() => _uploader.cancel();

  @override
  Future<Either<Failure, List<MemberPhoto>>> listPhotos(int memberId) async {
    try {
      final page = await _remote.listPhotos(memberId);
      return Right(page.data.map(memberPhotoFromApi).toList());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, MemberPhoto>> uploadPhoto({
    required int memberId,
    required Uint8List bytes,
    required String contentType,
    void Function(int sent, int total)? onProgress,
  }) async {
    final uploadResult = await _uploader.upload(
      bytes: bytes,
      contentType: contentType,
      purpose: MediaPurpose.progressPhoto,
      onProgress: onProgress,
    );
    return uploadResult.fold(Left.new, (objectKey) async {
      try {
        final created = await _remote.createPhoto(
          memberId,
          memberPhotoWrite(objectKey: objectKey),
        );
        return Right(memberPhotoFromApi(created));
      } catch (e) {
        return Left(mapThrownToFailure(e));
      }
    });
  }

  @override
  Future<Either<Failure, MemberPhoto>> setAvatar({
    required int memberId,
    required int photoId,
  }) async {
    try {
      final photo = await _remote.setAvatar(
        memberId: memberId,
        photoId: photoId,
      );
      return Right(memberPhotoFromApi(photo));
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
