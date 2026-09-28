import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/diet_log.dart';
import '../../domain/usecases/list_diet_logs_usecase.dart';

part 'diet_history_cubit.freezed.dart';

enum DietDateRange { all, last7Days, last30Days }

@freezed
abstract class DietHistoryState with _$DietHistoryState {
  const factory DietHistoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<DietLog>[]) List<DietLog> logs,
    @Default(DietDateRange.all) DietDateRange selectedRange,
    num? averageAdherenceScore,
    num? averageCaloriesConsumed,
    int? averageWaterIntakeMl,
    @Default(0) int totalLoggedDays,
    Failure? failure,
  }) = _DietHistoryState;
}

@injectable
class DietHistoryCubit extends Cubit<DietHistoryState> {
  DietHistoryCubit(this._listDietLogs) : super(const DietHistoryState());

  final ListDietLogsUseCase _listDietLogs;
  DietDateRange _range = DietDateRange.all;
  List<DietLog> _allLogs = const [];

  Future<void> load({
    required String? memberId,
    DietDateRange range = DietDateRange.all,
  }) async {
    _range = range;
    if (memberId == null || memberId.isEmpty) {
      // Client guard: there is no repository [Failure] for a missing id.
      emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: const BusinessRuleFailure(
            'Member ID is required to view diet history.',
          ),
        ),
      );
      return;
    }

    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _listDietLogs(
      ListDietLogsParams(
        memberId: memberId,
        limit: 100,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        _allLogs = page.items;
        _emitFiltered(_allLogs, _range);
      },
    );
  }

  void setRange(DietDateRange range) {
    _range = range;
    _emitFiltered(_allLogs, _range);
  }

  void _emitFiltered(List<DietLog> logs, DietDateRange range) {
    final now = DateTime.now();
    final filtered = logs.where((l) {
      if (range == DietDateRange.last7Days) {
        return l.loggedDate.isAfter(now.subtract(const Duration(days: 7)));
      } else if (range == DietDateRange.last30Days) {
        return l.loggedDate.isAfter(now.subtract(const Duration(days: 30)));
      }
      return true;
    }).toList();

    final sorted = List<DietLog>.from(filtered)
      ..sort((a, b) => b.loggedDate.compareTo(a.loggedDate));

    num? avgAdherence;
    num? avgCalories;
    int? avgWater;

    final adherenceItems = sorted
        .where((l) => l.adherenceScore != null)
        .toList();
    if (adherenceItems.isNotEmpty) {
      final sum = adherenceItems.fold<num>(
        0,
        (acc, l) => acc + l.adherenceScore!,
      );
      avgAdherence = sum / adherenceItems.length;
    }

    final calorieItems = sorted
        .where((l) => l.totalCaloriesConsumed != null)
        .toList();
    if (calorieItems.isNotEmpty) {
      final sum = calorieItems.fold<num>(
        0,
        (acc, l) => acc + l.totalCaloriesConsumed!,
      );
      avgCalories = sum / calorieItems.length;
    }

    final waterItems = sorted
        .where((l) => l.waterIntakeMl != null && l.waterIntakeMl! > 0)
        .toList();
    if (waterItems.isNotEmpty) {
      final sum = waterItems.fold<int>(0, (acc, l) => acc + l.waterIntakeMl!);
      avgWater = (sum / waterItems.length).round();
    }

    emit(
      state.copyWith(
        status: LoadStatus.success,
        failure: null,
        logs: sorted,
        selectedRange: range,
        averageAdherenceScore: avgAdherence,
        averageCaloriesConsumed: avgCalories,
        averageWaterIntakeMl: avgWater,
        totalLoggedDays: sorted.length,
      ),
    );
  }
}
