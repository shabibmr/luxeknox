import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../people/domain/entities/trainer_summary.dart';
import '../../../people/domain/usecases/get_assigned_trainer_usecase.dart';
import '../../domain/entities/open_slot.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/entities/schedule_session.dart';
import '../../domain/open_slots_calculator.dart';
import '../../domain/usecases/catalog_usecases.dart';
import '../../domain/usecases/schedule_usecases.dart';

part 'open_slots_cubit.freezed.dart';

@freezed
abstract class OpenSlotsState with _$OpenSlotsState {
  const factory OpenSlotsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(false) bool hasLoaded,
    TrainerSummary? trainer,
    @Default(false) bool missingTrainer,
    @Default(<BookableOpenSlot>[]) List<BookableOpenSlot> slots,
    DateTime? selectedDay,
    @Default(<DateTime>[]) List<DateTime> days,
    Failure? failure,
    /// Set when a book attempt hit 409 so the UI can show a stale-slot message.
    @Default(false) bool staleSlot,
  }) = _OpenSlotsState;
}

@injectable
class OpenSlotsCubit extends Cubit<OpenSlotsState> {
  OpenSlotsCubit(
    this._getAssignedTrainer,
    this._getAvailability,
    this._listSchedules,
  ) : super(const OpenSlotsState());

  final GetAssignedTrainerUseCase _getAssignedTrainer;
  final GetTrainerAvailabilityUseCase _getAvailability;
  final ListSchedulesUseCase _listSchedules;

  static const int _horizonDays = 14;

  String? _memberId;

  Future<void> load(String memberId) async {
    _memberId = memberId;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        staleSlot: false,
        missingTrainer: false,
      ),
    );

    final memberInt = int.tryParse(memberId);
    if (memberInt == null) {
      emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: const ValidationFailure(['Invalid member id']),
        ),
      );
      return;
    }

    final trainerResult = await _getAssignedTrainer(memberInt);
    TrainerSummary? trainer;
    final trainerFailed = trainerResult.fold(
      (f) {
        emit(state.copyWith(status: LoadStatus.failure, failure: f));
        return true;
      },
      (t) {
        trainer = t;
        return false;
      },
    );
    if (trainerFailed) return;

    if (trainer == null) {
      emit(
        state.copyWith(
          status: LoadStatus.success,
          hasLoaded: true,
          missingTrainer: true,
          trainer: null,
          slots: const [],
          days: const [],
          selectedDay: null,
        ),
      );
      return;
    }

    await _loadSlotsForTrainer(trainer!);
  }

  Future<void> refresh() async {
    final memberId = _memberId;
    if (memberId == null) return;
    await load(memberId);
  }

  /// Re-fetch slots after a booking conflict (409).
  Future<void> refreshAfterStaleSlot() async {
    final trainer = state.trainer;
    if (trainer == null) {
      final memberId = _memberId;
      if (memberId != null) await load(memberId);
      return;
    }
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        staleSlot: true,
      ),
    );
    await _loadSlotsForTrainer(trainer, keepStale: true);
  }

  void selectDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    emit(state.copyWith(selectedDay: normalized, staleSlot: false));
  }

  List<BookableOpenSlot> slotsForSelectedDay() {
    final day = state.selectedDay;
    if (day == null) return const [];
    return state.slots.where((s) {
      return s.start.year == day.year &&
          s.start.month == day.month &&
          s.start.day == day.day;
    }).toList();
  }

  Future<void> _loadSlotsForTrainer(
    TrainerSummary trainer, {
    bool keepStale = false,
  }) async {
    final trainerId = trainer.id.toString();

    final now = DateTime.now();
    final from = DateTime(now.year, now.month, now.day);
    final to = from.add(const Duration(days: _horizonDays));

    final availabilityResult = await _getAvailability(trainerId);
    List<TrainerAvailabilitySlot>? availability;
    final availFailed = availabilityResult.fold(
      (f) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: f,
            trainer: trainer,
          ),
        );
        return true;
      },
      (slots) {
        availability = slots;
        return false;
      },
    );
    if (availFailed) return;

    final schedulesResult = await _listSchedules(
      ListSchedulesParams(
        from: from,
        to: to,
        trainerId: trainerId,
        limit: 100,
      ),
    );
    List<ScheduleSession>? sessions;
    final schedulesFailed = schedulesResult.fold(
      (f) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: f,
            trainer: trainer,
          ),
        );
        return true;
      },
      (page) {
        sessions = page.items;
        return false;
      },
    );
    if (schedulesFailed) return;

    final bookable = OpenSlotsCalculator.matchBookableSessions(
      availability: availability!,
      sessions: sessions!,
      trainerId: trainerId,
    );

    final days = <DateTime>[
      for (var i = 0; i < _horizonDays; i++) from.add(Duration(days: i)),
    ];

    final preferredDay = state.selectedDay;
    final selected = preferredDay != null &&
            days.any(
              (d) =>
                  d.year == preferredDay.year &&
                  d.month == preferredDay.month &&
                  d.day == preferredDay.day,
            )
        ? DateTime(preferredDay.year, preferredDay.month, preferredDay.day)
        : days.first;

    emit(
      state.copyWith(
        status: LoadStatus.success,
        hasLoaded: true,
        failure: null,
        trainer: trainer,
        missingTrainer: false,
        slots: bookable,
        days: days,
        selectedDay: selected,
        staleSlot: keepStale,
      ),
    );
  }
}
