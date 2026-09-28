import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/map_thrown.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../../domain/entities/photo_pose.dart';
import '../../domain/entities/progress_photo.dart';
import '../../domain/repositories/progress_photos_repository.dart';
import '../datasources/goals_remote_datasource.dart';
import '../models/goals_mappers.dart';

@LazySingleton(as: ProgressPhotosRepository)
class ProgressPhotosRepositoryImpl implements ProgressPhotosRepository {
  ProgressPhotosRepositoryImpl(this._remote);

  final GoalsRemoteDataSource _remote;

  int? _parseId(String id) => int.tryParse(id);

  @override
  Future<Either<Failure, CursorPage<ProgressPhoto>>> listPhotos({
    required String memberId,
    String? cursor,
  }) async {
    final intId = _parseId(memberId);
    if (intId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      // Generated GOALApi.listProgressPhotos has no cursor yet; ignore client cursor.
      final page = await _remote.listProgressPhotos(memberId: intId);
      return Right(
        CursorPage(
          items: page.data.map((p) => p.toDomain()).toList(),
          nextCursor: page.meta.nextCursor,
          hasMore: page.meta.hasMore,
        ),
      );
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, ProgressPhoto>> createPhoto({
    required String memberId,
    required String photoUrl,
    required PhotoPose pose,
    DateTime? takenDate,
    bool? isPrivate,
  }) async {
    final intId = _parseId(memberId);
    if (intId == null) {
      return const Left(ValidationFailure(['Invalid member id']));
    }
    try {
      final created = await _remote.createProgressPhoto(
        intId,
        toProgressPhotoWrite(
          photoUrl: photoUrl,
          pose: pose,
          takenDate: takenDate,
          isPrivate: isPrivate,
        ),
      );
      return Right(created.toDomain());
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deletePhoto(String id) async {
    final intId = _parseId(id);
    if (intId == null) return const Left(NotFoundFailure());
    try {
      await _remote.deleteProgressPhoto(intId);
      return const Right(unit);
    } catch (e) {
      return Left(mapThrownToFailure(e));
    }
  }
}
