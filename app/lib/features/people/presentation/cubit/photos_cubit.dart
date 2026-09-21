import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/member_photo.dart';
import '../../domain/usecases/list_photos_usecase.dart';
import '../../domain/usecases/set_avatar_usecase.dart';
import '../../domain/usecases/upload_document_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';

sealed class PhotosState extends Equatable {
  const PhotosState();

  @override
  List<Object?> get props => [];
}

final class PhotosLoading extends PhotosState {
  const PhotosLoading();
}

final class PhotosLoaded extends PhotosState {
  const PhotosLoaded({
    required this.photos,
    this.uploading = false,
    this.uploadProgress,
    this.uploadError,
    this.pendingBytes,
    this.pendingContentType,
    this.message,
  });

  final List<MemberPhoto> photos;
  final bool uploading;
  final double? uploadProgress;
  final String? uploadError;
  final Uint8List? pendingBytes;
  final String? pendingContentType;
  final String? message;

  bool get canRetry => pendingBytes != null && pendingContentType != null;

  @override
  List<Object?> get props => [
    photos,
    uploading,
    uploadProgress,
    uploadError,
    pendingBytes,
    pendingContentType,
    message,
  ];
}

final class PhotosFailure extends PhotosState {
  const PhotosFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class PhotosCubit extends Cubit<PhotosState> {
  PhotosCubit(
    this._list,
    this._upload,
    this._cancelUpload,
    this._setAvatar,
  ) : super(const PhotosLoading());

  final ListPhotosUseCase _list;
  final UploadPhotoUseCase _upload;
  final CancelDocumentUploadUseCase _cancelUpload;
  final SetAvatarUseCase _setAvatar;

  int? _memberId;

  Future<void> load(int memberId) async {
    _memberId = memberId;
    emit(const PhotosLoading());
    final result = await _list(memberId);
    result.fold(
      (failure) => emit(PhotosFailure(_message(failure))),
      (photos) => emit(PhotosLoaded(photos: photos)),
    );
  }

  Future<void> upload({
    required Uint8List bytes,
    required String contentType,
  }) async {
    final memberId = _memberId;
    if (memberId == null) return;

    emit(
      PhotosLoaded(
        photos: _currentPhotos(),
        uploading: true,
        uploadProgress: 0,
        pendingBytes: bytes,
        pendingContentType: contentType,
      ),
    );

    final result = await _upload(
      UploadPhotoParams(
        memberId: memberId,
        bytes: bytes,
        contentType: contentType,
        onProgress: (sent, total) {
          if (total <= 0) return;
          final current = state;
          if (current is PhotosLoaded && current.uploading) {
            emit(
              PhotosLoaded(
                photos: current.photos,
                uploading: true,
                uploadProgress: sent / total,
                pendingBytes: bytes,
                pendingContentType: contentType,
              ),
            );
          }
        },
      ),
    );

    await result.fold(
      (failure) async {
        emit(
          PhotosLoaded(
            photos: _currentPhotos(),
            uploadError: _message(failure),
            pendingBytes: bytes,
            pendingContentType: contentType,
          ),
        );
      },
      (_) async => load(memberId),
    );
  }

  Future<void> retryUpload() async {
    final current = state;
    if (current is! PhotosLoaded || !current.canRetry) return;
    await upload(
      bytes: current.pendingBytes!,
      contentType: current.pendingContentType!,
    );
  }

  void cancelUpload() {
    _cancelUpload();
    emit(
      PhotosLoaded(
        photos: _currentPhotos(),
        uploadError: 'Upload cancelled.',
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
      (failure) async => emit(PhotosFailure(_message(failure))),
      (_) async {
        await load(memberId);
        final current = state;
        if (current is PhotosLoaded) {
          emit(
            PhotosLoaded(
              photos: current.photos,
              message: 'avatar',
            ),
          );
        }
      },
    );
  }

  List<MemberPhoto> _currentPhotos() {
    final current = state;
    return current is PhotosLoaded ? current.photos : const [];
  }

  String _message(Failure failure) => failureMessage(failure);
}
