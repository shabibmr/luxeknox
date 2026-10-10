import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/photo_pose.dart';
import '../entities/progress_photo.dart';
import '../entities/progress_photo_comparison.dart';
import '../repositories/progress_photos_repository.dart';

class ListAllProgressPhotosParams extends Equatable {
  const ListAllProgressPhotosParams({
    this.limit,
    this.cursor,
    this.pose,
  });

  final int? limit;
  final String? cursor;
  final String? pose;

  @override
  List<Object?> get props => [limit, cursor, pose];
}

@lazySingleton
class ListAllProgressPhotosUseCase
    implements
        UseCase<CursorPage<ProgressPhoto>, ListAllProgressPhotosParams> {
  const ListAllProgressPhotosUseCase(this._repository);

  final ProgressPhotosRepository _repository;

  @override
  Future<Either<Failure, CursorPage<ProgressPhoto>>> call(
    ListAllProgressPhotosParams params,
  ) {
    return _repository.listAllPhotos(
      limit: params.limit,
      cursor: params.cursor,
      pose: params.pose,
    );
  }
}

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
  List<Object?> get props => [memberId, photoUrl, pose, takenDate, isPrivate];
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

class CompareProgressPhotosParams extends Equatable {
  const CompareProgressPhotosParams({
    required this.memberId,
    required this.date1,
    required this.date2,
  });

  final String memberId;
  final DateTime date1;
  final DateTime date2;

  @override
  List<Object?> get props => [memberId, date1, date2];
}

@lazySingleton
class CompareProgressPhotosUseCase
    implements
        UseCase<ProgressPhotoComparison, CompareProgressPhotosParams> {
  const CompareProgressPhotosUseCase(this._repository);

  final ProgressPhotosRepository _repository;

  @override
  Future<Either<Failure, ProgressPhotoComparison>> call(
    CompareProgressPhotosParams params,
  ) {
    return _repository.comparePhotos(
      memberId: params.memberId,
      date1: params.date1,
      date2: params.date2,
    );
  }
}
