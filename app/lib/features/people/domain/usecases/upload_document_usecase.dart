import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/media/document_access.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/member_document.dart';
import '../repositories/document_repository.dart';

class UploadDocumentParams extends Equatable {
  const UploadDocumentParams({
    required this.memberId,
    required this.purpose,
    required this.title,
    required this.bytes,
    required this.contentType,
  });

  final int memberId;
  final DocumentPurpose purpose;
  final String title;
  final Uint8List bytes;
  final String contentType;

  @override
  List<Object?> get props => [memberId, purpose, title, bytes, contentType];
}

@lazySingleton
class UploadDocumentUseCase
    implements UseCase<MemberDocument, UploadDocumentParams> {
  const UploadDocumentUseCase(this._repository);

  final DocumentRepository _repository;

  @override
  Future<Either<Failure, MemberDocument>> call(UploadDocumentParams params) {
    return _repository.uploadDocument(
      memberId: params.memberId,
      purpose: params.purpose,
      title: params.title,
      bytes: params.bytes,
      contentType: params.contentType,
    );
  }
}
