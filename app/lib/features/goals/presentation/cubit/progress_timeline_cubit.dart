import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/usecases/goals_usecases.dart';
import '../../domain/usecases/measurements_usecases.dart';

part 'progress_timeline_cubit.freezed.dart';

enum ProgressTimelineKind { goalCheckIn, measurementSession }

class ProgressTimelineEntry {
  const ProgressTimelineEntry({
    required this.id,
    required this.kind,
    required this.at,
    required this.title,
    this.subtitle,
  });

  final String id;
  final ProgressTimelineKind kind;
  final DateTime at;
  final String title;
  final String? subtitle;
}

@freezed
abstract class ProgressTimelineState with _$ProgressTimelineState {
  const factory ProgressTimelineState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ProgressTimelineEntry>[]) List<ProgressTimelineEntry> items,
    Failure? failure,
  }) = _ProgressTimelineState;
}

@injectable
class ProgressTimelineCubit extends Cubit<ProgressTimelineState> {
  ProgressTimelineCubit(this._listGoals, this._listMeasurements)
    : super(const ProgressTimelineState());

  final ListMemberGoalsUseCase _listGoals;
  final ListMeasurementsUseCase _listMeasurements;

  String? _memberId;

  Future<void> load(String memberId) async {
    _memberId = memberId;
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final goalsResult = await _listGoals(MemberIdParams(memberId));
    final sessionsResult = await _listMeasurements(
      ListMeasurementsParams(memberId: memberId, limit: 100),
    );

    Failure? failure;
    final items = <ProgressTimelineEntry>[];

    goalsResult.fold((f) => failure = f, (page) {
      for (final goal in page.items) {
        final metricName = goal.metric?.name ?? 'Goal';
        for (final entry in goal.history) {
          items.add(
            ProgressTimelineEntry(
              id: 'goal-${entry.id}',
              kind: ProgressTimelineKind.goalCheckIn,
              at: entry.recordedDate,
              title: metricName,
              subtitle: entry.notes?.trim().isEmpty == true
                  ? '${entry.recordedValue}'
                  : '${entry.recordedValue}'
                        '${entry.notes == null || entry.notes!.trim().isEmpty ? '' : ' · ${entry.notes}'}',
            ),
          );
        }
      }
    });

    sessionsResult.fold(
      (f) => failure ??= f,
      (page) {
        for (final session in page.items) {
          final valueCount = session.values.length;
          items.add(
            ProgressTimelineEntry(
              id: 'meas-${session.id}',
              kind: ProgressTimelineKind.measurementSession,
              at: session.recordedAt,
              title: 'Measurement',
              subtitle: valueCount == 0
                  ? session.notes
                  : '$valueCount metric${valueCount == 1 ? '' : 's'}'
                        '${session.notes == null || session.notes!.trim().isEmpty ? '' : ' · ${session.notes}'}',
            ),
          );
        }
      },
    );

    if (failure != null && items.isEmpty) {
      emit(state.copyWith(status: LoadStatus.failure, failure: failure));
      return;
    }

    items.sort((a, b) => b.at.compareTo(a.at));
    emit(
      state.copyWith(
        status: LoadStatus.success,
        items: items,
        failure: null,
      ),
    );
  }

  Future<void> retry() async {
    final id = _memberId;
    if (id != null) await load(id);
  }
}
