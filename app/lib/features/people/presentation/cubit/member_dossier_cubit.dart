import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/assign_trainer_usecase.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/update_member_usecase.dart';

part 'member_dossier_cubit.freezed.dart';

@freezed
abstract class MemberDossierState with _$MemberDossierState {
  const factory MemberDossierState({
    @Default(LoadStatus.initial) LoadStatus status,
    Person? person,
    String? message,
    Failure? failure,
  }) = _MemberDossierState;
}

@injectable
class MemberDossierCubit extends Cubit<MemberDossierState> {
  MemberDossierCubit(this._getMember, this._updateMember, this._assignTrainer)
    : super(const MemberDossierState());

  final GetMemberUseCase _getMember;
  final UpdateMemberUseCase _updateMember;
  final AssignTrainerUseCase _assignTrainer;

  Future<void> load(int memberId) async {
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, message: null),
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
        ),
      ),
    );
  }

  Future<void> save(Person person) async {
    final result = await _updateMember(person);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          person: updated,
          message: 'saved',
          failure: null,
        ),
      ),
    );
  }

  Future<void> assignTrainer({
    required int memberId,
    required int trainerId,
  }) async {
    final result = await _assignTrainer(
      AssignTrainerParams(memberId: memberId, trainerId: trainerId),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          message: null,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: LoadStatus.success,
          person: updated,
          message: 'assigned',
          failure: null,
        ),
      ),
    );
  }
}
