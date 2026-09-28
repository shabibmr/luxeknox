import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/member_photo.dart';
import '../../domain/usecases/list_photos_usecase.dart';
import '../../domain/usecases/set_avatar_usecase.dart';
import '../../domain/usecases/upload_document_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';

part 'photos_cubit.freezed.dart';

@freezed
abstract class PhotosState with _$PhotosState {
  const PhotosState._();

  const factory PhotosState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MemberPhoto>[]) List<MemberPhoto> photos,
    @Default(false) bool uploading,
    double? uploadProgress,
    String? uploadError,
    Uint8List? pendingBytes,
    String? pendingContentType,
    String? message,
    Failure? failure,
  }) = _PhotosState;

  bool get canRetry => pendingBytes != null && pendingContentType != null;
}

class PhotosCubit extends Cubit<PhotosState> {
  PhotosCubit(this._list, this._upload, this._cancelUpload, this._setAvatar)
    : super(const PhotosState());

  final ListPhotosUseCase _list;
  final UploadPhotoUseCase _upload;
  final CancelDocumentUploadUseCase _cancelUpload;
  final SetAvatarUseCase _setAvatar;

  int? _memberId;

  Future<void> load(int memberId) async {
    _memberId = memberId;
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, message: null),
    );
    final result = await _list(memberId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (photos) => emit(
        state.copyWith(
          status: LoadStatus.success,
          photos: photos,
          failure: null,
          message: null,
          uploading: false,
          uploadProgress: null,
          uploadError: null,
          pendingBytes: null,
          pendingContentType: null,
        ),
      ),
    );
  }

  Future<void> upload({
    required Uint8List bytes,
    required String contentType,
  }) async {
    final memberId = _memberId;
    if (memberId == null) return;

    emit(
      state.copyWith(
        uploading: true,
        uploadProgress: 0,
        uploadError: null,
        pendingBytes: bytes,
        pendingContentType: contentType,
        message: null,
      ),
    );

    final result = await _upload(
      UploadPhotoParams(
        memberId: memberId,
        bytes: bytes,
        contentType: contentType,
        onProgress: (sent, total) {
          if (total <= 0) return;
          if (state.uploading) {
            emit(
              state.copyWith(
                uploadProgress: sent / total,
                pendingBytes: bytes,
                pendingContentType: contentType,
              ),
            );
          }
        },
      ),
    );

    await result.fold((failure) async {
      emit(
        state.copyWith(
          uploading: false,
          uploadProgress: null,
          uploadError: failureMessage(failure),
          pendingBytes: bytes,
          pendingContentType: contentType,
        ),
      );
    }, (_) async => load(memberId));
  }

  Future<void> retryUpload() async {
    if (!state.canRetry) return;
    await upload(
      bytes: state.pendingBytes!,
      contentType: state.pendingContentType!,
    );
  }

  void cancelUpload() {
    _cancelUpload();
    emit(
      state.copyWith(
        uploading: false,
        uploadProgress: null,
        uploadError: 'Upload cancelled.',
        pendingBytes: null,
        pendingContentType: null,
      ),
    );
  }

  Future<void> setAsAvatar(int photoId) async {
    final memberId = _memberId;
    if (memberId == null) return;
    final result = await _setAvatar(
      SetAvatarParams(memberId: memberId, photoId: photoId),
    );
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (_) async {
        await load(memberId);
        if (state.status == LoadStatus.success) {
          emit(state.copyWith(message: 'avatar'));
        }
      },
    );
  }
}
