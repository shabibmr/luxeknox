import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/set_avatar_usecase.dart';
import '../../domain/usecases/update_member_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';

part 'edit_profile_cubit.freezed.dart';

@freezed
abstract class EditProfileState with _$EditProfileState {
  const factory EditProfileState({
    @Default(LoadStatus.initial) LoadStatus status,
    Person? person,
    String? message,
    @Default(false) bool isSaving,
    @Default(false) bool isUploadingAvatar,
    Failure? failure,
  }) = _EditProfileState;
}

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(
    this._getMember,
    this._updateMember,
    this._setAvatar,
    this._uploadPhoto,
  ) : super(const EditProfileState());

  final GetMemberUseCase _getMember;
  final UpdateMemberUseCase _updateMember;
  final SetAvatarUseCase _setAvatar;
  final UploadPhotoUseCase _uploadPhoto;

  int? _memberId;

  Future<void> load(int memberId) async {
    _memberId = memberId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        message: null,
        isSaving: false,
        isUploadingAvatar: false,
      ),
    );
    final result = await _getMember(memberId);
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (person) => emit(
        state.copyWith(
          status: LoadStatus.success,
          person: person,
          failure: null,
          message: null,
          isSaving: false,
          isUploadingAvatar: false,
        ),
      ),
    );
  }

  Future<void> save(Person person) async {
    if (state.person != null) {
      emit(state.copyWith(isSaving: true, message: null, failure: null));
    }
    final result = await _updateMember(person);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          isSaving: false,
          message: null,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          person: updated,
          message: 'saved',
          failure: null,
          isSaving: false,
          isUploadingAvatar: false,
        ),
      ),
    );
  }

  Future<void> setAvatar(int photoId) async {
    final memberId = _memberId;
    if (memberId == null) return;
    if (state.person != null) {
      emit(
        state.copyWith(isUploadingAvatar: true, message: null, failure: null),
      );
    }
    final result = await _setAvatar(
      SetAvatarParams(memberId: memberId, photoId: photoId),
    );
    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          isUploadingAvatar: false,
          isSaving: false,
          message: null,
        ),
      ),
      (_) async {
        final reload = await _getMember(memberId);
        reload.fold(
          (failure) => emit(
            state.copyWith(
              status: LoadStatus.failure,
              failure: failure,
              isUploadingAvatar: false,
              isSaving: false,
              message: null,
            ),
          ),
          (person) => emit(
            state.copyWith(
              status: LoadStatus.success,
              person: person,
              message: 'avatar',
              failure: null,
              isUploadingAvatar: false,
              isSaving: false,
            ),
          ),
        );
      },
    );
  }

  Future<void> uploadAndSetAvatar({
    required Uint8List bytes,
    required String contentType,
  }) async {
    final memberId = _memberId;
    if (memberId == null) return;
    if (state.person != null) {
      emit(
        state.copyWith(isUploadingAvatar: true, message: null, failure: null),
      );
    }
    final uploadResult = await _uploadPhoto(
      UploadPhotoParams(
        memberId: memberId,
        bytes: bytes,
        contentType: contentType,
      ),
    );
    await uploadResult.fold(
      (failure) async => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          isUploadingAvatar: false,
          isSaving: false,
          message: null,
        ),
      ),
      (photo) async {
        final setAvatarResult = await _setAvatar(
          SetAvatarParams(memberId: memberId, photoId: photo.id),
        );
        await setAvatarResult.fold(
          (failure) async => emit(
            state.copyWith(
              status: LoadStatus.failure,
              failure: failure,
              isUploadingAvatar: false,
              isSaving: false,
              message: null,
            ),
          ),
          (_) async {
            final reload = await _getMember(memberId);
            reload.fold(
              (failure) => emit(
                state.copyWith(
                  status: LoadStatus.failure,
                  failure: failure,
                  isUploadingAvatar: false,
                  isSaving: false,
                  message: null,
                ),
              ),
              (person) => emit(
                state.copyWith(
                  status: LoadStatus.success,
                  person: person,
                  message: 'avatar',
                  failure: null,
                  isUploadingAvatar: false,
                  isSaving: false,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
