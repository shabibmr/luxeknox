import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/progress_photo.dart';
import '../../domain/helpers/photo_privacy.dart';
import '../../domain/usecases/progress_photos_usecases.dart';

part 'admin_progress_photos_vault_cubit.freezed.dart';

@freezed
abstract class AdminProgressPhotosVaultState
    with _$AdminProgressPhotosVaultState {
  const factory AdminProgressPhotosVaultState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ProgressPhoto>[]) List<ProgressPhoto> photos,
    @Default(false) bool canModerate,
    Failure? failure,
  }) = _AdminProgressPhotosVaultState;
}

@injectable
class AdminProgressPhotosVaultCubit
    extends Cubit<AdminProgressPhotosVaultState> {
  AdminProgressPhotosVaultCubit(this._listAll)
    : super(const AdminProgressPhotosVaultState());

  final ListAllProgressPhotosUseCase _listAll;

  Future<void> load({required bool canModerate}) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        canModerate: canModerate,
      ),
    );
    final result = await _listAll(const ListAllProgressPhotosParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        final visible = filterPhotosForViewer(
          page.items,
          isOwner: false,
          isAssignedTrainer: false,
          canModerate: canModerate,
        );
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            photos: visible,
            canModerate: canModerate,
          ),
        );
      },
    );
  }
}
