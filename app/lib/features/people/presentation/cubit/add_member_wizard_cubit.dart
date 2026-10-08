import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/new_member_input.dart';
import '../people_strings.dart';
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
    if (state.step == 0) {
      if (state.input.firstName.trim().isEmpty) {
        emit(state.copyWith(error: PeopleStrings.firstNameRequired));
        return;
      }
      if (state.input.lastName.trim().isEmpty) {
        emit(state.copyWith(error: PeopleStrings.lastNameRequired));
        return;
      }
      if (!_hasGender) {
        emit(state.copyWith(error: PeopleStrings.genderRequired));
        return;
      }
    } else if (state.step == 1) {
      if (!_hasContactInfo) {
        emit(state.copyWith(error: PeopleStrings.emailOrPhoneRequired));
        return;
      }
      final email = state.input.email?.trim() ?? '';
      if (email.isNotEmpty && !_isValidEmail(email)) {
        emit(state.copyWith(error: PeopleStrings.invalidEmail));
        return;
      }
    }
    emit(state.copyWith(step: state.step + 1, clearError: true));
  }

  void previousStep() {
    if (state.step <= 0) return;
    emit(state.copyWith(step: state.step - 1, clearError: true));
  }

  bool get _hasGender => (state.input.gender?.trim() ?? '').isNotEmpty;

  bool get _hasContactInfo {
    final hasEmail = (state.input.email?.trim() ?? '').isNotEmpty;
    final hasPhone = (state.input.phoneNumber?.trim() ?? '').isNotEmpty;
    return hasEmail || hasPhone;
  }

  static bool _isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(email);
  }

  Future<void> submit() async {
    if (state.input.firstName.trim().isEmpty) {
      emit(state.copyWith(error: PeopleStrings.firstNameRequired));
      return;
    }
    if (state.input.lastName.trim().isEmpty) {
      emit(state.copyWith(error: PeopleStrings.lastNameRequired));
      return;
    }
    if (!_hasGender) {
      emit(state.copyWith(error: PeopleStrings.genderRequired));
      return;
    }
    if (!_hasContactInfo) {
      emit(state.copyWith(error: PeopleStrings.emailOrPhoneRequired));
      return;
    }
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
