import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/app_report_type.dart';
import '../../domain/entities/report_query.dart';
import '../../domain/entities/report_result.dart';
import '../../domain/usecases/export_report_csv_usecase.dart';
import '../../domain/usecases/get_report_usecase.dart';

const kReportPageSize = 50;

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

final class ReportLoading extends ReportState {
  const ReportLoading(this.query);

  final ReportQuery query;

  @override
  List<Object?> get props => [query];
}

final class ReportLoaded extends ReportState {
  const ReportLoaded({
    required this.query,
    required this.result,
    this.pageIndex = 0,
    this.exporting = false,
    this.exportedCsv,
    this.actionError,
  });

  final ReportQuery query;
  final ReportResult result;
  final int pageIndex;
  final bool exporting;
  final String? exportedCsv;
  final String? actionError;

  int get pageCount {
    if (result.rows.isEmpty) return 1;
    return ((result.rows.length - 1) ~/ kReportPageSize) + 1;
  }

  List<Map<String, dynamic>> get pageRows {
    if (result.rows.isEmpty) return const [];
    final start = pageIndex * kReportPageSize;
    if (start >= result.rows.length) return const [];
    final end = (start + kReportPageSize).clamp(0, result.rows.length);
    return result.rows.sublist(start, end);
  }

  ReportLoaded copyWith({
    ReportQuery? query,
    ReportResult? result,
    int? pageIndex,
    bool? exporting,
    String? exportedCsv,
    String? actionError,
    bool clearExport = false,
    bool clearActionError = false,
  }) {
    return ReportLoaded(
      query: query ?? this.query,
      result: result ?? this.result,
      pageIndex: pageIndex ?? this.pageIndex,
      exporting: exporting ?? this.exporting,
      exportedCsv: clearExport ? null : (exportedCsv ?? this.exportedCsv),
      actionError:
          clearActionError ? null : (actionError ?? this.actionError),
    );
  }

  @override
  List<Object?> get props => [
    query,
    result,
    pageIndex,
    exporting,
    exportedCsv,
    actionError,
  ];
}

final class ReportFailure extends ReportState {
  const ReportFailure(this.message, this.query);

  final String message;
  final ReportQuery query;

  @override
  List<Object?> get props => [message, query];
}

@injectable
class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this._getReport, this._exportCsv)
    : super(
        ReportLoading(
          ReportQuery(
            type: AppReportType.members,
            from: DateTime.now().subtract(const Duration(days: 30)),
            to: DateTime.now(),
          ),
        ),
      );

  final GetReportUseCase _getReport;
  final ExportReportCsvUseCase _exportCsv;

  ReportQuery get _query {
    final s = state;
    return switch (s) {
      ReportLoading(:final query) => query,
      ReportLoaded(:final query) => query,
      ReportFailure(:final query) => query,
    };
  }

  Future<void> load(AppReportType type, {bool trainerOwnLocked = false}) async {
    final now = DateTime.now();
    final query = ReportQuery(
      type: type,
      from: now.subtract(const Duration(days: 30)),
      to: now,
    );
    emit(ReportLoading(query));
    await _fetch(query);
  }

  Future<void> applyFilters({
    DateTime? from,
    DateTime? to,
    String? productId,
    String? trainerId,
    bool clearProductId = false,
    bool clearTrainerId = false,
  }) async {
    final next = _query.copyWith(
      from: from,
      to: to,
      productId: productId,
      trainerId: trainerId,
      clearProductId: clearProductId,
      clearTrainerId: clearTrainerId,
    );
    emit(ReportLoading(next));
    await _fetch(next);
  }

  Future<void> refresh() async {
    emit(ReportLoading(_query));
    await _fetch(_query);
  }

  void setPage(int pageIndex) {
    final current = state;
    if (current is! ReportLoaded) return;
    final clamped = pageIndex.clamp(0, current.pageCount - 1);
    emit(current.copyWith(pageIndex: clamped, clearExport: true));
  }

  Future<String?> exportCsv() async {
    final current = state;
    final query = _query;
    if (current is ReportLoaded) {
      emit(current.copyWith(exporting: true, clearActionError: true, clearExport: true));
    }
    final result = await _exportCsv(query);
    return result.fold(
      (failure) {
        final message = failureMessage(failure);
        final s = state;
        if (s is ReportLoaded) {
          emit(s.copyWith(exporting: false, actionError: message));
        }
        return null;
      },
      (csv) {
        final s = state;
        if (s is ReportLoaded) {
          emit(s.copyWith(exporting: false, exportedCsv: csv));
        }
        return csv;
      },
    );
  }

  Future<void> _fetch(ReportQuery query) async {
    final result = await _getReport(query);
    result.fold(
      (failure) => emit(ReportFailure(failureMessage(failure), query)),
      (report) => emit(
        ReportLoaded(query: query, result: report, pageIndex: 0),
      ),
    );
  }
}
