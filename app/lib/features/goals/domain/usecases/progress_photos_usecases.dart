import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/photo_pose.dart';
import '../entities/progress_photo.dart';
import '../repositories/progress_photos_repository.dart';

class ListProgressPhotosParams extends Equatable {
  const ListProgressPhotosParams({required this.memberId, this.cursor});

  final String memberId;
  final String? cursor;

  @override
  List<Object?> get props => [memberId, cursor];
}

@lazySingleton
class ListProgressPhotosUseCase
    implements UseCase<CursorPage<ProgressPhoto>, ListProgressPhotosParams> {
  const ListProgressPhotosUseCase(this._repository);

  final ProgressPhotosRepository _repository;

  @override
  Future<Either<Failure, CursorPage<ProgressPhoto>>> call(
    ListProgressPhotosParams params,
  ) {
    return _repository.listPhotos(
      memberId: params.memberId,
      cursor: params.cursor,
    );
  }
}

class CreateProgressPhotoParams extends Equatable {
  const CreateProgressPhotoParams({
    required this.memberId,
    required this.photoUrl,
    required this.pose,
    this.takenDate,
    this.isPrivate,
  });

  final String memberId;
  final String photoUrl;
  final PhotoPose pose;
  final DateTime? takenDate;
  final bool? isPrivate;

  @override
  List<Object?> get props => [
    memberId,
    photoUrl,
    pose,
    takenDate,
    isPrivate,
  ];
}

@lazySingleton
class CreateProgressPhotoUseCase
    implements UseCase<ProgressPhoto, CreateProgressPhotoParams> {
  const CreateProgressPhotoUseCase(this._repository);

  final ProgressPhotosRepository _repository;

  @override
  Future<Either<Failure, ProgressPhoto>> call(
    CreateProgressPhotoParams params,
  ) {
    return _repository.createPhoto(
      memberId: params.memberId,
      photoUrl: params.photoUrl,
      pose: params.pose,
      takenDate: params.takenDate,
      isPrivate: params.isPrivate,
    );
  }
}

@lazySingleton
class DeleteProgressPhotoUseCase implements UseCase<Unit, String> {
  const DeleteProgressPhotoUseCase(this._repository);

  final ProgressPhotosRepository _repository;

  @override
  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deletePhoto(id);
  }
}
