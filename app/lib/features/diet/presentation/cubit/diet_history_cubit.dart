import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/diet_log.dart';
import '../../domain/usecases/list_diet_logs_usecase.dart';

enum DietDateRange { all, last7Days, last30Days }

sealed class DietHistoryState extends Equatable {
  const DietHistoryState();

  @override
  List<Object?> get props => [];
}

final class DietHistoryLoading extends DietHistoryState {
  const DietHistoryLoading();
}

final class DietHistoryLoaded extends DietHistoryState {
  const DietHistoryLoaded({
    required this.logs,
    required this.selectedRange,
    this.averageAdherenceScore,
    this.averageCaloriesConsumed,
    this.averageWaterIntakeMl,
    required this.totalLoggedDays,
  });

  final List<DietLog> logs;
  final DietDateRange selectedRange;
  final num? averageAdherenceScore;
  final num? averageCaloriesConsumed;
  final int? averageWaterIntakeMl;
  final int totalLoggedDays;

  @override
  List<Object?> get props => [
    logs,
    selectedRange,
    averageAdherenceScore,
    averageCaloriesConsumed,
    averageWaterIntakeMl,
    totalLoggedDays,
  ];
}

final class DietHistoryFailure extends DietHistoryState {
  const DietHistoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class DietHistoryCubit extends Cubit<DietHistoryState> {
  DietHistoryCubit(this._listDietLogs) : super(const DietHistoryLoading());

  final ListDietLogsUseCase _listDietLogs;
  DietDateRange _range = DietDateRange.all;
  List<DietLog> _allLogs = const [];

  Future<void> load({
    required String? memberId,
    DietDateRange range = DietDateRange.all,
  }) async {
    _range = range;
    if (memberId == null || memberId.isEmpty) {
      emit(const DietHistoryFailure('Member ID is required to view diet history.'));
      return;
    }

    emit(const DietHistoryLoading());

    final result = await _listDietLogs(
      ListDietLogsParams(
        memberId: memberId,
        limit: 100,
      ),
    );

    result.fold(
      (failure) => emit(DietHistoryFailure(failureMessage(failure))),
      (page) {
        _allLogs = page.items;
        _emitLoaded(_allLogs, _range);
      },
    );
  }

  void setRange(DietDateRange range) {
    _range = range;
    _emitLoaded(_allLogs, _range);
  }

  void _emitLoaded(List<DietLog> logs, DietDateRange range) {
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

    final adherenceItems = sorted.where((l) => l.adherenceScore != null).toList();
    if (adherenceItems.isNotEmpty) {
      final sum = adherenceItems.fold<num>(0, (acc, l) => acc + l.adherenceScore!);
      avgAdherence = sum / adherenceItems.length;
    }

    final calorieItems = sorted.where((l) => l.totalCaloriesConsumed != null).toList();
    if (calorieItems.isNotEmpty) {
      final sum = calorieItems.fold<num>(0, (acc, l) => acc + l.totalCaloriesConsumed!);
      avgCalories = sum / calorieItems.length;
    }

    final waterItems = sorted.where((l) => l.waterIntakeMl != null && l.waterIntakeMl! > 0).toList();
    if (waterItems.isNotEmpty) {
      final sum = waterItems.fold<int>(0, (acc, l) => acc + l.waterIntakeMl!);
      avgWater = (sum / waterItems.length).round();
    }

    emit(
      DietHistoryLoaded(
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
