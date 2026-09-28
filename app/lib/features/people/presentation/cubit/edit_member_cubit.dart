import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/update_member_usecase.dart';

part 'edit_member_cubit.freezed.dart';

@freezed
abstract class EditMemberState with _$EditMemberState {
  const factory EditMemberState({
    @Default(LoadStatus.initial) LoadStatus status,
    Person? person,
    @Default(false) bool saving,
    @Default(false) bool saved,
    Failure? failure,
  }) = _EditMemberState;
}

@injectable
class EditMemberCubit extends Cubit<EditMemberState> {
  EditMemberCubit(this._getMember, this._updateMember)
    : super(const EditMemberState());

  final GetMemberUseCase _getMember;
  final UpdateMemberUseCase _updateMember;

  Future<void> load(int memberId) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        saving: false,
        saved: false,
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
          saving: false,
          saved: false,
        ),
      ),
    );
  }

  Future<void> save(Person person) async {
    if (state.person == null) return;
    emit(state.copyWith(saving: true, saved: false, failure: null));
    final result = await _updateMember(person);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          saving: false,
          saved: false,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          person: updated,
          saving: false,
          saved: true,
          failure: null,
        ),
      ),
    );
  }
}
