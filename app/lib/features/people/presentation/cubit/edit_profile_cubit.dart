import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/set_avatar_usecase.dart';
import '../../domain/usecases/update_member_usecase.dart';
import '../../domain/usecases/upload_photo_usecase.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

final class EditProfileLoading extends EditProfileState {
  const EditProfileLoading();
}

final class EditProfileLoaded extends EditProfileState {
  const EditProfileLoaded(
    this.person, {
    this.message,
    this.isSaving = false,
    this.isUploadingAvatar = false,
  });

  final Person person;
  final String? message;
  final bool isSaving;
  final bool isUploadingAvatar;

  EditProfileLoaded copyWith({
    Person? person,
    String? message,
    bool? isSaving,
    bool? isUploadingAvatar,
  }) {
    return EditProfileLoaded(
      person ?? this.person,
      message: message,
      isSaving: isSaving ?? this.isSaving,
      isUploadingAvatar: isUploadingAvatar ?? this.isUploadingAvatar,
    );
  }

  @override
  List<Object?> get props => [person, message, isSaving, isUploadingAvatar];
}

final class EditProfileFailure extends EditProfileState {
  const EditProfileFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(
    this._getMember,
    this._updateMember,
    this._setAvatar,
    this._uploadPhoto,
  ) : super(const EditProfileLoading());

  final GetMemberUseCase _getMember;
  final UpdateMemberUseCase _updateMember;
  final SetAvatarUseCase _setAvatar;
  final UploadPhotoUseCase _uploadPhoto;

  int? _memberId;

  Future<void> load(int memberId) async {
    _memberId = memberId;
    emit(const EditProfileLoading());
    final result = await _getMember(memberId);
    result.fold(
      (failure) => emit(EditProfileFailure(failureMessage(failure))),
      (person) => emit(EditProfileLoaded(person)),
    );
  }

  Future<void> save(Person person) async {
    final current = state;
    if (current is EditProfileLoaded) {
      emit(current.copyWith(isSaving: true, message: null));
    }
    final result = await _updateMember(person);
    result.fold(
      (failure) => emit(EditProfileFailure(failureMessage(failure))),
      (updated) => emit(EditProfileLoaded(updated, message: 'saved')),
    );
  }

  Future<void> setAvatar(int photoId) async {
    final memberId = _memberId;
    if (memberId == null) return;
    final current = state;
    if (current is EditProfileLoaded) {
      emit(current.copyWith(isUploadingAvatar: true, message: null));
    }
    final result = await _setAvatar(
      SetAvatarParams(memberId: memberId, photoId: photoId),
    );
    await result.fold(
      (failure) async => emit(EditProfileFailure(failureMessage(failure))),
      (_) async {
        final reload = await _getMember(memberId);
        reload.fold(
          (failure) => emit(EditProfileFailure(failureMessage(failure))),
          (person) => emit(EditProfileLoaded(person, message: 'avatar')),
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
    final current = state;
    if (current is EditProfileLoaded) {
      emit(current.copyWith(isUploadingAvatar: true, message: null));
    }
    final uploadResult = await _uploadPhoto(
      UploadPhotoParams(
        memberId: memberId,
        bytes: bytes,
        contentType: contentType,
      ),
    );
    await uploadResult.fold(
      (failure) async => emit(EditProfileFailure(failureMessage(failure))),
      (photo) async {
        final setAvatarResult = await _setAvatar(
          SetAvatarParams(memberId: memberId, photoId: photo.id),
        );
        await setAvatarResult.fold(
          (failure) async => emit(EditProfileFailure(failureMessage(failure))),
          (_) async {
            final reload = await _getMember(memberId);
            reload.fold(
              (failure) => emit(EditProfileFailure(failureMessage(failure))),
              (person) => emit(EditProfileLoaded(person, message: 'avatar')),
            );
          },
        );
      },
    );
  }
}
