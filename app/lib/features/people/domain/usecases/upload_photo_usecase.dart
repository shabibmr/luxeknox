import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/member_photo.dart';
import '../repositories/document_repository.dart';

class UploadPhotoParams extends Equatable {
  const UploadPhotoParams({
    required this.memberId,
    required this.bytes,
    required this.contentType,
    this.onProgress,
  });

  final int memberId;
  final Uint8List bytes;
  final String contentType;
  final void Function(int sent, int total)? onProgress;

  @override
  List<Object?> get props => [memberId, bytes, contentType];
}

@lazySingleton
class UploadPhotoUseCase implements UseCase<MemberPhoto, UploadPhotoParams> {
  const UploadPhotoUseCase(this._repository);

  final DocumentRepository _repository;

  @override
  Future<Either<Failure, MemberPhoto>> call(UploadPhotoParams params) {
    return _repository.uploadPhoto(
      memberId: params.memberId,
      bytes: params.bytes,
      contentType: params.contentType,
      onProgress: params.onProgress,
    );
  }
}
