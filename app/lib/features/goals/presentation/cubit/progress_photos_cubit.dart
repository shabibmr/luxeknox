import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/photo_pose.dart';
import '../../domain/entities/progress_photo.dart';
import '../../domain/helpers/photo_privacy.dart';
import '../../domain/usecases/progress_photos_usecases.dart';

part 'progress_photos_cubit.freezed.dart';

@freezed
abstract class ProgressPhotosState with _$ProgressPhotosState {
  const factory ProgressPhotosState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ProgressPhoto>[]) List<ProgressPhoto> photos,
    @Default(false) bool submitting,
    Failure? failure,
  }) = _ProgressPhotosState;
}

@injectable
class ProgressPhotosCubit extends Cubit<ProgressPhotosState> {
  ProgressPhotosCubit(
    this._listPhotos,
    this._createPhoto,
    this._deletePhoto,
  ) : super(const ProgressPhotosState());

  final ListProgressPhotosUseCase _listPhotos;
  final CreateProgressPhotoUseCase _createPhoto;
  final DeleteProgressPhotoUseCase _deletePhoto;

  String? _memberId;
  bool _isOwner = true;
  bool _isAssignedTrainer = false;
  bool _canModerate = false;
  bool _loaded = false;

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
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        submitting: false,
      ),
    );
    final result = await _listPhotos(
      ListProgressPhotosParams(memberId: memberId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          submitting: false,
        ),
      ),
      (page) {
        _loaded = true;
        final filtered = filterPhotosForViewer(
          page.items,
          isOwner: _isOwner,
          isAssignedTrainer: _isAssignedTrainer,
          canModerate: _canModerate,
        );
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            submitting: false,
            photos: filtered,
          ),
        );
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
    if (memberId == null ||
        !_loaded ||
        current.status == LoadStatus.loading ||
        current.submitting) {
      return false;
    }
    emit(
      current.copyWith(
        submitting: true,
        failure: null,
        status: LoadStatus.success,
      ),
    );
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
            status: LoadStatus.failure,
            failure: failure,
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
    if (memberId == null ||
        !_loaded ||
        current.status == LoadStatus.loading ||
        current.submitting) {
      return false;
    }
    emit(
      current.copyWith(
        submitting: true,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _deletePhoto(id);
    return result.fold(
      (failure) {
        emit(
          current.copyWith(
            submitting: false,
            status: LoadStatus.failure,
            failure: failure,
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
