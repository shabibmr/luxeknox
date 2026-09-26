import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../people/domain/entities/trainer_summary.dart';
import '../../../people/domain/usecases/get_trainer_usecase.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/entities/schedule_form_draft.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/usecases/catalog_usecases.dart';
import '../../domain/usecases/schedule_usecases.dart';
import '../scheduling_strings.dart';

enum ScheduleFormMode { create, edit }

class ScheduleFormState extends Equatable {
  const ScheduleFormState({
    this.mode = ScheduleFormMode.create,
    this.scheduleId,
    this.draft = const ScheduleFormDraft(),
    this.loadedSession,
    this.initialLoading = false,
    this.submitting = false,
    this.savedSession,
    this.error,
    this.isConflict = false,
  });

  final ScheduleFormMode mode;
  final String? scheduleId;
  final ScheduleFormDraft draft;
  final ScheduleSession? loadedSession;
  final bool initialLoading;
  final bool submitting;
  final ScheduleSession? savedSession;
  final String? error;
  final bool isConflict;

  bool get isCreate => mode == ScheduleFormMode.create;

  bool get isDirty {
    if (mode == ScheduleFormMode.create) {
      return draft != const ScheduleFormDraft();
    }
    final session = loadedSession;
    if (session == null) return false;

    return draft.title != session.title ||
        draft.scheduleType?.id != session.scheduleTypeId ||
        draft.facility?.id != session.facilityId ||
        draft.trainer?.id.toString() != session.trainerId ||
        draft.start != session.startTime ||
        draft.end != session.endTime ||
        draft.maxCapacity != session.maxCapacity ||
        draft.notes != session.notes;
  }

  ScheduleFormState copyWith({
    ScheduleFormMode? mode,
    String? scheduleId,
    ScheduleFormDraft? draft,
    ScheduleSession? loadedSession,
    bool? initialLoading,
    bool? submitting,
    ScheduleSession? savedSession,
    String? error,
    bool? isConflict,
    bool clearError = false,
    bool clearSavedSession = false,
    bool clearScheduleId = false,
    bool clearLoadedSession = false,
  }) {
    return ScheduleFormState(
      mode: mode ?? this.mode,
      scheduleId: clearScheduleId ? null : (scheduleId ?? this.scheduleId),
      draft: draft ?? this.draft,
      loadedSession:
          clearLoadedSession ? null : (loadedSession ?? this.loadedSession),
      initialLoading: initialLoading ?? this.initialLoading,
      submitting: submitting ?? this.submitting,
      savedSession:
          clearSavedSession ? null : (savedSession ?? this.savedSession),
      error: clearError ? null : (error ?? this.error),
      isConflict: isConflict ?? this.isConflict,
    );
  }

  @override
  List<Object?> get props => [
        mode,
        scheduleId,
        draft,
        loadedSession,
        initialLoading,
        submitting,
        savedSession,
        error,
        isConflict,
      ];
}

@injectable
class ScheduleFormCubit extends Cubit<ScheduleFormState> {
  ScheduleFormCubit(
    this._createSchedule,
    this._updateSchedule,
    this._getSchedule,
    this._listScheduleTypes,
    this._listFacilities,
    this._getTrainer,
  ) : super(const ScheduleFormState());

  final CreateScheduleUseCase _createSchedule;
  final UpdateScheduleUseCase _updateSchedule;
  final GetScheduleUseCase _getSchedule;
  final ListScheduleTypesUseCase _listScheduleTypes;
  final ListFacilitiesUseCase _listFacilities;
  final GetTrainerUseCase _getTrainer;

  void initCreate({DateTime? initialStart}) {
    final start = initialStart ?? DateTime.now();
    final end = start.add(const Duration(hours: 1));
    emit(
      state.copyWith(
        mode: ScheduleFormMode.create,
        clearScheduleId: true,
        clearLoadedSession: true,
        clearSavedSession: true,
        clearError: true,
        isConflict: false,
        draft: ScheduleFormDraft(start: start, end: end),
      ),
    );
  }

  Future<void> initEdit(String scheduleId) async {
    emit(
      state.copyWith(
        mode: ScheduleFormMode.edit,
        scheduleId: scheduleId,
        initialLoading: true,
        clearError: true,
        clearSavedSession: true,
        clearLoadedSession: true,
        isConflict: false,
      ),
    );

    final sessionResult = await _getSchedule(scheduleId);
    if (isClosed) return;

    await sessionResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            initialLoading: false,
            error: failureMessage(failure),
          ),
        );
      },
      (session) async {
        final typesResult = await _listScheduleTypes(const NoParams());
        final facilitiesResult = await _listFacilities(const NoParams());

        ScheduleTypeInfo? selectedType;
        typesResult.fold((_) {}, (types) {
          try {
            selectedType =
                types.firstWhere((t) => t.id == session.scheduleTypeId);
          } catch (_) {
            selectedType = ScheduleTypeInfo(
              id: session.scheduleTypeId,
              name: session.scheduleTypeId,
            );
          }
        });

        FacilityInfo? selectedFacility;
        if (session.facilityId != null) {
          facilitiesResult.fold((_) {}, (facilities) {
            try {
              selectedFacility =
                  facilities.firstWhere((f) => f.id == session.facilityId);
            } catch (_) {
              selectedFacility = FacilityInfo(
                id: session.facilityId!,
                name: session.facilityId!,
                isActive: true,
              );
            }
          });
        }

        TrainerSummary? selectedTrainer;
        if (session.trainerId != null) {
          final intId = int.tryParse(session.trainerId!);
          if (intId != null) {
            final trainerResult = await _getTrainer(intId);
            trainerResult.fold(
              (_) {
                selectedTrainer = TrainerSummary(
                  id: intId,
                  userId: intId,
                  fullName: 'Trainer #$intId',
                );
              },
              (profile) {
                selectedTrainer = TrainerSummary(
                  id: profile.id,
                  userId: profile.userId,
                  fullName: profile.fullName,
                  specializations: profile.specializations,
                );
              },
            );
          }
        }

        if (isClosed) return;

        final draft = ScheduleFormDraft(
          scheduleType: selectedType,
          facility: selectedFacility,
          trainer: selectedTrainer,
          title: session.title,
          start: session.startTime,
          end: session.endTime,
          maxCapacity: session.maxCapacity,
          notes: session.notes,
        );

        emit(
          state.copyWith(
            initialLoading: false,
            loadedSession: session,
            draft: draft,
          ),
        );
      },
    );
  }

  void updateDraft(ScheduleFormDraft Function(ScheduleFormDraft) update) {
    emit(
      state.copyWith(
        draft: update(state.draft),
        clearError: true,
        isConflict: false,
      ),
    );
  }

  Future<bool> submit() async {
    if (state.submitting) return false;

    final errors = state.draft.validate();
    if (errors.isNotEmpty) {
      emit(state.copyWith(error: errors.values.first));
      return false;
    }

    if (state.mode == ScheduleFormMode.create) {
      return _submitCreate();
    }
    return _submitEdit();
  }

  Future<bool> _submitCreate() async {
    emit(
      state.copyWith(
        submitting: true,
        clearError: true,
        clearSavedSession: true,
      ),
    );
    final input = state.draft.toCreateInput();
    final result = await _createSchedule(input);
    if (isClosed) return false;

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            submitting: false,
            error: failureMessage(failure),
          ),
        );
        return false;
      },
      (session) {
        emit(state.copyWith(submitting: false, savedSession: session));
        return true;
      },
    );
  }

  Future<bool> _submitEdit() async {
    final scheduleId = state.scheduleId;
    final session = state.loadedSession;
    if (scheduleId == null || session == null) {
      emit(state.copyWith(error: 'Schedule not found.'));
      return false;
    }

    emit(
      state.copyWith(
        submitting: true,
        clearError: true,
        clearSavedSession: true,
        isConflict: false,
      ),
    );

    final input = state.draft.toCreateInput(rowVersion: session.rowVersion);
    final result = await _updateSchedule(
      UpdateScheduleParams(id: scheduleId, input: input),
    );
    if (isClosed) return false;

    return result.fold(
      (failure) {
        final isConflict = failure is ConflictFailure;
        emit(
          state.copyWith(
            submitting: false,
            isConflict: isConflict,
            error: isConflict
                ? SchedulingStrings.rowVersionConflict
                : failureMessage(failure),
          ),
        );
        return false;
      },
      (updatedSession) {
        emit(
          state.copyWith(
            submitting: false,
            savedSession: updatedSession,
            loadedSession: updatedSession,
          ),
        );
        return true;
      },
    );
  }
}
