import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/new_member_input.dart';
import '../../domain/entities/person.dart';
import '../../domain/usecases/create_member_usecase.dart';

class AddMemberWizardState extends Equatable {
  const AddMemberWizardState({
    this.input = const NewMemberInput(),
    this.step = 0,
    this.submitting = false,
    this.created,
    this.error,
  });

  final NewMemberInput input;
  final int step;
  final bool submitting;
  final Person? created;
  final String? error;

  static const stepCount = 3;

  AddMemberWizardState copyWith({
    NewMemberInput? input,
    int? step,
    bool? submitting,
    Person? created,
    String? error,
    bool clearError = false,
  }) {
    return AddMemberWizardState(
      input: input ?? this.input,
      step: step ?? this.step,
      submitting: submitting ?? this.submitting,
      created: created ?? this.created,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [input, step, submitting, created, error];
}

@injectable
class AddMemberWizardCubit extends Cubit<AddMemberWizardState> {
  AddMemberWizardCubit(this._createMember)
    : super(const AddMemberWizardState());

  final CreateMemberUseCase _createMember;

  void updateInput(NewMemberInput Function(NewMemberInput) update) {
    emit(state.copyWith(input: update(state.input), clearError: true));
  }

  void nextStep() {
    if (state.step >= AddMemberWizardState.stepCount - 1) return;
    emit(state.copyWith(step: state.step + 1, clearError: true));
  }

  void previousStep() {
    if (state.step <= 0) return;
    emit(state.copyWith(step: state.step - 1, clearError: true));
  }

  Future<void> submit() async {
    emit(state.copyWith(submitting: true, clearError: true));
    final result = await _createMember(state.input);
    result.fold(
      (failure) =>
          emit(state.copyWith(submitting: false, error: _message(failure))),
      (person) => emit(state.copyWith(submitting: false, created: person)),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
