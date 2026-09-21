import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/photo_pose.dart';
import '../../domain/entities/progress_photo.dart';
import '../../domain/helpers/photo_privacy.dart';
import '../../domain/usecases/progress_photos_usecases.dart';

sealed class ProgressPhotosState extends Equatable {
  const ProgressPhotosState();

  @override
  List<Object?> get props => [];
}

final class ProgressPhotosLoading extends ProgressPhotosState {
  const ProgressPhotosLoading();
}

final class ProgressPhotosLoaded extends ProgressPhotosState {
  const ProgressPhotosLoaded({
    required this.photos,
    this.submitting = false,
    this.error,
  });

  final List<ProgressPhoto> photos;
  final bool submitting;
  final String? error;

  ProgressPhotosLoaded copyWith({
    List<ProgressPhoto>? photos,
    bool? submitting,
    String? error,
  }) {
    return ProgressPhotosLoaded(
      photos: photos ?? this.photos,
      submitting: submitting ?? this.submitting,
      error: error,
    );
  }

  @override
  List<Object?> get props => [photos, submitting, error];
}

final class ProgressPhotosFailure extends ProgressPhotosState {
  const ProgressPhotosFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class ProgressPhotosCubit extends Cubit<ProgressPhotosState> {
  ProgressPhotosCubit(
    this._listPhotos,
    this._createPhoto,
    this._deletePhoto,
  ) : super(const ProgressPhotosLoading());

  final ListProgressPhotosUseCase _listPhotos;
  final CreateProgressPhotoUseCase _createPhoto;
  final DeleteProgressPhotoUseCase _deletePhoto;

  String? _memberId;
  bool _isOwner = true;
  bool _isAssignedTrainer = false;
  bool _canModerate = false;

  Future<void> load(
    String memberId, {
    required bool isOwner,
    required bool isAssignedTrainer,
    required bool canModerate,
  }) async {
    _memberId = memberId;
    _isOwner = isOwner;
    _isAssignedTrainer = isAssignedTrainer;
    _canModerate = canModerate;
    emit(const ProgressPhotosLoading());
    final result = await _listPhotos(
      ListProgressPhotosParams(memberId: memberId),
    );
    result.fold(
      (failure) => emit(ProgressPhotosFailure(failureMessage(failure))),
      (page) {
        final filtered = filterPhotosForViewer(
          page.items,
          isOwner: _isOwner,
          isAssignedTrainer: _isAssignedTrainer,
          canModerate: _canModerate,
        );
        emit(ProgressPhotosLoaded(photos: filtered));
      },
    );
  }

  Future<bool> addPhoto({
    required String photoUrl,
    required PhotoPose pose,
    DateTime? takenDate,
    bool isPrivate = false,
  }) async {
    final memberId = _memberId;
    final current = state;
    if (memberId == null || current is! ProgressPhotosLoaded) return false;
    emit(current.copyWith(submitting: true, error: null));
    final result = await _createPhoto(
      CreateProgressPhotoParams(
        memberId: memberId,
        photoUrl: photoUrl,
        pose: pose,
        takenDate: takenDate,
        isPrivate: isPrivate,
      ),
    );
    return result.fold(
      (failure) {
        emit(
          current.copyWith(
            submitting: false,
            error: failureMessage(failure),
          ),
        );
        return false;
      },
      (_) async {
        await load(
          memberId,
          isOwner: _isOwner,
          isAssignedTrainer: _isAssignedTrainer,
          canModerate: _canModerate,
        );
        return true;
      },
    );
  }

  Future<bool> removePhoto(String id) async {
    final memberId = _memberId;
    final current = state;
    if (memberId == null || current is! ProgressPhotosLoaded) return false;
    emit(current.copyWith(submitting: true, error: null));
    final result = await _deletePhoto(id);
    return result.fold(
      (failure) {
        emit(
          current.copyWith(
            submitting: false,
            error: failureMessage(failure),
          ),
        );
        return false;
      },
      (_) async {
        await load(
          memberId,
          isOwner: _isOwner,
          isAssignedTrainer: _isAssignedTrainer,
          canModerate: _canModerate,
        );
        return true;
      },
    );
  }
}
