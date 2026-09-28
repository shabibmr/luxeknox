import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/new_trainer_input.dart';
import '../../domain/entities/trainer_profile.dart';
import '../../domain/usecases/create_trainer_usecase.dart';
import '../people_strings.dart';

class TrainerFormState extends Equatable {
  const TrainerFormState({
    this.input = const NewTrainerInput(email: ''),
    this.submitting = false,
    this.created,
    this.error,
  });

  final NewTrainerInput input;
  final bool submitting;
  final TrainerProfile? created;
  final String? error;

  bool get isDirty => input != const NewTrainerInput(email: '');

  TrainerFormState copyWith({
    NewTrainerInput? input,
    bool? submitting,
    TrainerProfile? created,
    String? error,
    bool clearError = false,
    bool clearCreated = false,
  }) {
    return TrainerFormState(
      input: input ?? this.input,
      submitting: submitting ?? this.submitting,
      created: clearCreated ? null : (created ?? this.created),
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [input, submitting, created, error];
}

@injectable
class TrainerFormCubit extends Cubit<TrainerFormState> {
  TrainerFormCubit(this._createTrainer) : super(const TrainerFormState());

  final CreateTrainerUseCase _createTrainer;

  void updateInput(NewTrainerInput Function(NewTrainerInput) update) {
    emit(state.copyWith(input: update(state.input), clearError: true));
  }

  void addSpecialization(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (state.input.specializations.contains(trimmed)) return;
    updateInput(
      (input) => input.copyWith(
        specializations: [...input.specializations, trimmed],
      ),
    );
  }

  void removeSpecialization(String value) {
    updateInput(
      (input) => input.copyWith(
        specializations: input.specializations
            .where((s) => s != value)
            .toList(),
      ),
    );
  }

  /// Returns false when a submit is already in flight (double-submit guard).
  Future<bool> submit() async {
    if (state.submitting) return false;

    final validationError = _validate(state.input);
    if (validationError != null) {
      emit(state.copyWith(error: validationError));
      return false;
    }

    emit(state.copyWith(submitting: true, clearError: true, clearCreated: true));
    final result = await _createTrainer(state.input);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(submitting: false, error: _message(failure)));
        return false;
      },
      (profile) {
        emit(state.copyWith(submitting: false, created: profile));
        return true;
      },
    );
  }

  String? _validate(NewTrainerInput input) {
    if (input.firstName.trim().isEmpty) {
      return PeopleStrings.firstNameRequired;
    }
    if (input.lastName.trim().isEmpty) {
      return PeopleStrings.lastNameRequired;
    }
    if (input.email.trim().isEmpty) {
      return PeopleStrings.emailRequired;
    }
    final password = input.password?.trim() ?? '';
    if (password.isEmpty) {
      return PeopleStrings.passwordRequired;
    }
    return null;
  }

  String _message(Failure failure) => failureMessage(failure);
}
