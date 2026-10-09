import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/workout_plan.dart';
import '../../domain/entities/workout_plan_exercise.dart';
import '../../domain/entities/workout_plan_status.dart';
import '../../domain/usecases/get_workout_plan_usecase.dart';
import '../../domain/usecases/list_workout_plans_usecase.dart';

class TodaysWorkoutState extends Equatable {
  const TodaysWorkoutState({
    this.status = LoadStatus.initial,
    this.activePlan,
    this.availableDays = const [],
    this.selectedDay = 1,
    this.exercisesForDay = const [],
    this.failure,
  });

  final LoadStatus status;
  final WorkoutPlan? activePlan;
  final List<int> availableDays;
  final int selectedDay;
  final List<WorkoutPlanExercise> exercisesForDay;
  final Failure? failure;

  bool get hasActivePlan => activePlan != null;

  TodaysWorkoutState copyWith({
    LoadStatus? status,
    WorkoutPlan? activePlan,
    bool clearActivePlan = false,
    List<int>? availableDays,
    int? selectedDay,
    List<WorkoutPlanExercise>? exercisesForDay,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return TodaysWorkoutState(
      status: status ?? this.status,
      activePlan: clearActivePlan ? null : (activePlan ?? this.activePlan),
      availableDays: availableDays ?? this.availableDays,
      selectedDay: selectedDay ?? this.selectedDay,
      exercisesForDay: exercisesForDay ?? this.exercisesForDay,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [
    status,
    activePlan,
    availableDays,
    selectedDay,
    exercisesForDay,
    failure,
  ];
}

@injectable
class TodaysWorkoutCubit extends Cubit<TodaysWorkoutState> {
  TodaysWorkoutCubit(this._listPlans, this._getPlan)
      : super(const TodaysWorkoutState());

  final ListWorkoutPlansUseCase _listPlans;
  final GetWorkoutPlanUseCase _getPlan;

  String? _memberId;

  Future<void> load({required String memberId}) async {
    _memberId = memberId;
    emit(state.copyWith(status: LoadStatus.loading, clearFailure: true));

    final listResult = await _listPlans(
      ListWorkoutPlansParams(memberId: memberId, isTemplate: false, limit: 20),
    );

    await listResult.fold(
      (failure) async {
        emit(state.copyWith(status: LoadStatus.failure, failure: failure));
      },
      (page) async {
        final activePlans = page.items
            .where((p) => p.status == WorkoutPlanStatus.active)
            .toList();

        final sourcePlan = activePlans.isNotEmpty
            ? activePlans.first
            : (page.items.isNotEmpty ? page.items.first : null);

        if (sourcePlan == null) {
          emit(
            state.copyWith(
              status: LoadStatus.success,
              clearActivePlan: true,
              availableDays: const [],
              exercisesForDay: const [],
              selectedDay: 1,
            ),
          );
          return;
        }

        final detailResult = await _getPlan(sourcePlan.id);
        detailResult.fold(
          (failure) => emit(
            state.copyWith(status: LoadStatus.failure, failure: failure),
          ),
          (fullPlan) {
            final days = fullPlan.exercises
                .map((e) => e.dayNumber)
                .toSet()
                .toList()
              ..sort();

            final targetDay = days.isNotEmpty ? days.first : 1;
            final dayExercises = _filterExercises(fullPlan.exercises, targetDay);

            emit(
              state.copyWith(
                status: LoadStatus.success,
                activePlan: fullPlan,
                availableDays: days,
                selectedDay: targetDay,
                exercisesForDay: dayExercises,
              ),
            );
          },
        );
      },
    );
  }

  void selectDay(int dayNumber) {
    final plan = state.activePlan;
    if (plan == null) return;
    final dayExercises = _filterExercises(plan.exercises, dayNumber);
    emit(
      state.copyWith(
        selectedDay: dayNumber,
        exercisesForDay: dayExercises,
      ),
    );
  }

  Future<void> refresh() async {
    final id = _memberId;
    if (id != null) {
      await load(memberId: id);
    }
  }

  static List<WorkoutPlanExercise> _filterExercises(
    List<WorkoutPlanExercise> all,
    int day,
  ) {
    final list = all.where((e) => e.dayNumber == day).toList();
    list.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
    return list;
  }
}
