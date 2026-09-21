import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/assign_trainer_usecase.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/update_member_usecase.dart';

sealed class MemberDossierState extends Equatable {
  const MemberDossierState();

  @override
  List<Object?> get props => [];
}

final class MemberDossierLoading extends MemberDossierState {
  const MemberDossierLoading();
}

final class MemberDossierLoaded extends MemberDossierState {
  const MemberDossierLoaded(this.person, {this.message});

  final Person person;
  final String? message;

  @override
  List<Object?> get props => [person, message];
}

final class MemberDossierFailure extends MemberDossierState {
  const MemberDossierFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class MemberDossierCubit extends Cubit<MemberDossierState> {
  MemberDossierCubit(
    this._getMember,
    this._updateMember,
    this._assignTrainer,
  ) : super(const MemberDossierLoading());

  final GetMemberUseCase _getMember;
  final UpdateMemberUseCase _updateMember;
  final AssignTrainerUseCase _assignTrainer;

  Future<void> load(int memberId) async {
    emit(const MemberDossierLoading());
    final result = await _getMember(memberId);
    result.fold(
      (failure) => emit(MemberDossierFailure(_message(failure))),
      (person) => emit(MemberDossierLoaded(person)),
    );
  }

  Future<void> save(Person person) async {
    final result = await _updateMember(person);
    result.fold(
      (failure) => emit(MemberDossierFailure(_message(failure))),
      (updated) => emit(MemberDossierLoaded(updated, message: 'saved')),
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
      (failure) => emit(MemberDossierFailure(_message(failure))),
      (updated) => emit(MemberDossierLoaded(updated, message: 'assigned')),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
