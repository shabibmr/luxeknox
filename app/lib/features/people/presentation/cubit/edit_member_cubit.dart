import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/get_member_usecase.dart';
import '../../domain/usecases/update_member_usecase.dart';

sealed class EditMemberState extends Equatable {
  const EditMemberState();

  @override
  List<Object?> get props => [];
}

final class EditMemberLoading extends EditMemberState {
  const EditMemberLoading();
}

final class EditMemberLoaded extends EditMemberState {
  const EditMemberLoaded(
    this.person, {
    this.saving = false,
    this.saved = false,
  });

  final Person person;
  final bool saving;
  final bool saved;

  @override
  List<Object?> get props => [person, saving, saved];
}

final class EditMemberFailure extends EditMemberState {
  const EditMemberFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class EditMemberCubit extends Cubit<EditMemberState> {
  EditMemberCubit(this._getMember, this._updateMember)
    : super(const EditMemberLoading());

  final GetMemberUseCase _getMember;
  final UpdateMemberUseCase _updateMember;

  Future<void> load(int memberId) async {
    emit(const EditMemberLoading());
    final result = await _getMember(memberId);
    result.fold(
      (failure) => emit(EditMemberFailure(_message(failure))),
      (person) => emit(EditMemberLoaded(person)),
    );
  }

  Future<void> save(Person person) async {
    final current = state;
    if (current is! EditMemberLoaded) return;
    emit(EditMemberLoaded(current.person, saving: true));
    final result = await _updateMember(person);
    result.fold(
      (failure) => emit(EditMemberFailure(_message(failure))),
      (updated) => emit(EditMemberLoaded(updated, saved: true)),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
