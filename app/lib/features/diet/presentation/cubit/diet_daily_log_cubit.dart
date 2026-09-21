import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/diet_adherence.dart';
import '../../domain/entities/diet_log.dart';
import '../../domain/usecases/list_diet_logs_usecase.dart';
import '../../domain/usecases/list_diet_plans_usecase.dart';
import '../../domain/usecases/record_diet_log_usecase.dart';

enum DietDailyLogStatus { initial, loading, ready, saving, saved, failure }

class DietDailyLogState extends Equatable {
  const DietDailyLogState({
    required this.memberId,
    required this.date,
    this.caloriesConsumed,
    this.targetCalories,
    this.dietPlanId,
    this.adherenceScore,
    this.waterIntakeMl = 0,
    this.memberNotes = '',
    this.status = DietDailyLogStatus.initial,
    this.errorMessage,
    this.savedLog,
  });

  final String memberId;
  final DateTime date;
  final num? caloriesConsumed;
  final num? targetCalories;
  final String? dietPlanId;
  final num? adherenceScore;
  final int waterIntakeMl;
  final String memberNotes;
  final DietDailyLogStatus status;
  final String? errorMessage;
  final DietLog? savedLog;

  DietDailyLogState copyWith({
    String? memberId,
    DateTime? date,
    num? caloriesConsumed,
    num? targetCalories,
    String? dietPlanId,
    num? adherenceScore,
    int? waterIntakeMl,
    String? memberNotes,
    DietDailyLogStatus? status,
    String? errorMessage,
    DietLog? savedLog,
  }) {
    return DietDailyLogState(
      memberId: memberId ?? this.memberId,
      date: date ?? this.date,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      targetCalories: targetCalories ?? this.targetCalories,
      dietPlanId: dietPlanId ?? this.dietPlanId,
      adherenceScore: adherenceScore ?? this.adherenceScore,
      waterIntakeMl: waterIntakeMl ?? this.waterIntakeMl,
      memberNotes: memberNotes ?? this.memberNotes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      savedLog: savedLog ?? this.savedLog,
    );
  }

  @override
  List<Object?> get props => [
    memberId,
    date,
    caloriesConsumed,
    targetCalories,
    dietPlanId,
    adherenceScore,
    waterIntakeMl,
    memberNotes,
    status,
    errorMessage,
    savedLog,
  ];
}

@injectable
class DietDailyLogCubit extends Cubit<DietDailyLogState> {
  DietDailyLogCubit(
    this._recordDietLog,
    this._listDietLogs,
    this._listDietPlans,
  ) : super(
          DietDailyLogState(
            memberId: '',
            date: DateTime.now(),
          ),
        );

  final RecordDietLogUseCase _recordDietLog;
  final ListDietLogsUseCase _listDietLogs;
  final ListDietPlansUseCase _listDietPlans;

  Future<void> init(String memberId, {DateTime? date}) async {
    final effectiveDate = date ?? DateTime.now();
    emit(
      state.copyWith(
        memberId: memberId,
        date: effectiveDate,
        status: DietDailyLogStatus.loading,
        errorMessage: null,
      ),
    );

    // 1. Fetch active diet plan for target calories & plan ID if available
    num? planCalorieTarget;
    String? activePlanId;
    final planResult = await _listDietPlans(
      ListDietPlansParams(memberId: memberId),
    );
    planResult.fold(
      (_) {},
      (page) {
        final active = page.items.where((p) => p.status.name == 'active').firstOrNull;
        if (active != null) {
          activePlanId = active.id;
          planCalorieTarget = active.dailyCalorieTarget;
        }
      },
    );

    // 2. Fetch existing log for effectiveDate
    final logResult = await _listDietLogs(
      ListDietLogsParams(
        memberId: memberId,
        limit: 100,
      ),
    );


    DietLog? existing;
    logResult.fold(
      (_) {},
      (page) {
        existing = page.items.where((l) {
          return l.loggedDate.year == effectiveDate.year &&
              l.loggedDate.month == effectiveDate.month &&
              l.loggedDate.day == effectiveDate.day;
        }).firstOrNull;
      },
    );

    if (existing != null) {
      emit(
        state.copyWith(
          caloriesConsumed: existing!.totalCaloriesConsumed,
          waterIntakeMl: existing!.waterIntakeMl ?? 0,
          memberNotes: existing!.memberNotes ?? '',
          adherenceScore: existing!.adherenceScore,
          dietPlanId: existing!.dietPlanId ?? activePlanId,
          targetCalories: planCalorieTarget,
          status: DietDailyLogStatus.ready,
        ),
      );
    } else {
      emit(
        state.copyWith(
          dietPlanId: activePlanId,
          targetCalories: planCalorieTarget,
          waterIntakeMl: 0,
          memberNotes: '',
          caloriesConsumed: null,
          adherenceScore: null,
          status: DietDailyLogStatus.ready,
        ),
      );
    }
  }

  void updateDate(DateTime newDate) {
    init(state.memberId, date: newDate);
  }

  void updateCalories(num calories) {
    num? adherence;
    if (state.targetCalories != null && state.targetCalories! > 0) {
      adherence = computeDietAdherence(
        caloriesConsumed: calories,
        targetCalories: state.targetCalories!,
      );
    }
    emit(
      state.copyWith(
        caloriesConsumed: calories,
        adherenceScore: adherence,
      ),
    );
  }

  void updateWater(int ml) {
    emit(state.copyWith(waterIntakeMl: ml.clamp(0, 10000)));
  }

  void addWater(int deltaMl) {
    updateWater(state.waterIntakeMl + deltaMl);
  }

  void updateNotes(String notes) {
    emit(state.copyWith(memberNotes: notes));
  }

  void updateAdherence(num adherence) {
    emit(state.copyWith(adherenceScore: adherence.clamp(0, 100)));
  }

  Future<void> save() async {
    if (state.memberId.isEmpty) return;
    emit(state.copyWith(status: DietDailyLogStatus.saving));

    final result = await _recordDietLog(
      RecordDietLogParams(
        memberId: state.memberId,
        date: state.date,
        dietPlanId: state.dietPlanId,
        totalCaloriesConsumed: state.caloriesConsumed,
        adherenceScore: state.adherenceScore,
        waterIntakeMl: state.waterIntakeMl,
        memberNotes: state.memberNotes.trim().isEmpty ? null : state.memberNotes.trim(),
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: DietDailyLogStatus.failure,
          errorMessage: failureMessage(failure),
        ),
      ),
      (saved) => emit(
        state.copyWith(
          status: DietDailyLogStatus.saved,
          savedLog: saved,
        ),
      ),
    );
  }
}
