import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/pagination/cursor_page.dart';
import '../entities/photo_pose.dart';
import '../entities/progress_photo.dart';
import '../entities/progress_photo_comparison.dart';

abstract class ProgressPhotosRepository {
  Future<Either<Failure, CursorPage<ProgressPhoto>>> listAllPhotos({
    int? limit,
    String? cursor,
    String? pose,
  });

  Future<Either<Failure, CursorPage<ProgressPhoto>>> listPhotos({
    required String memberId,
    String? cursor,
  });

  Future<Either<Failure, ProgressPhotoComparison>> comparePhotos({
    required String memberId,
    required DateTime date1,
    required DateTime date2,
  });

  Future<Either<Failure, ProgressPhoto>> createPhoto({
    required String memberId,
    required String photoUrl,
    required PhotoPose pose,
    DateTime? takenDate,
    bool? isPrivate,
  });

  Future<Either<Failure, Unit>> deletePhoto(String id);
}
