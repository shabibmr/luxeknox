import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/app_report_type.dart';
import '../../domain/entities/report_query.dart';
import '../../domain/entities/report_result.dart';
import '../../domain/usecases/export_report_csv_usecase.dart';
import '../../domain/usecases/get_report_usecase.dart';

part 'report_cubit.freezed.dart';

const kReportPageSize = 50;

@freezed
abstract class ReportState with _$ReportState {
  const ReportState._();

  const factory ReportState({
    @Default(LoadStatus.initial) LoadStatus status,
    required ReportQuery query,
    ReportResult? result,
    @Default(0) int pageIndex,
    @Default(false) bool exporting,
    String? exportedCsv,
    Failure? failure,
  }) = _ReportState;

  int get pageCount {
    final rows = result?.rows ?? const <Map<String, dynamic>>[];
    if (rows.isEmpty) return 1;
    return ((rows.length - 1) ~/ kReportPageSize) + 1;
  }

  List<Map<String, dynamic>> get pageRows {
    final rows = result?.rows ?? const <Map<String, dynamic>>[];
    if (rows.isEmpty) return const [];
    final start = pageIndex * kReportPageSize;
    if (start >= rows.length) return const [];
    final end = (start + kReportPageSize).clamp(0, rows.length).toInt();
    return rows.sublist(start, end);
  }
}

@injectable
class ReportCubit extends Cubit<ReportState> {
  ReportCubit(this._getReport, this._exportCsv)
    : super(
        ReportState(
          query: ReportQuery(
            type: AppReportType.members,
            from: DateTime.now().subtract(const Duration(days: 30)),
            to: DateTime.now(),
          ),
        ),
      );

  final GetReportUseCase _getReport;
  final ExportReportCsvUseCase _exportCsv;

  Future<void> load(AppReportType type, {bool trainerOwnLocked = false}) async {
    final now = DateTime.now();
    final query = ReportQuery(
      type: type,
      from: now.subtract(const Duration(days: 30)),
      to: now,
    );
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        query: query,
        failure: null,
        pageIndex: 0,
        exporting: false,
        exportedCsv: null,
      ),
    );
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
    final next = state.query.copyWith(
      from: from,
      to: to,
      productId: productId,
      trainerId: trainerId,
      clearProductId: clearProductId,
      clearTrainerId: clearTrainerId,
    );
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        query: next,
        failure: null,
      ),
    );
    await _fetch(next);
  }

  Future<void> refresh() async {
    final query = state.query;
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    await _fetch(query);
  }

  void setPage(int pageIndex) {
    if (state.result == null) return;
    final last = state.pageCount - 1;
    final clamped = pageIndex < 0
        ? 0
        : pageIndex > last
        ? last
        : pageIndex;
    emit(state.copyWith(pageIndex: clamped, exportedCsv: null));
  }

  Future<String?> exportCsv() async {
    final query = state.query;
    if (state.result != null) {
      emit(
        state.copyWith(
          exporting: true,
          failure: null,
          exportedCsv: null,
        ),
      );
    }
    final result = await _exportCsv(query);
    return result.fold(
      (failure) {
        if (state.result != null) {
          emit(state.copyWith(exporting: false, failure: failure));
        }
        return null;
      },
      (csv) {
        if (state.result != null) {
          emit(
            state.copyWith(
              exporting: false,
              exportedCsv: csv,
              failure: null,
            ),
          );
        }
        return csv;
      },
    );
  }

  Future<void> _fetch(ReportQuery query) async {
    final result = await _getReport(query);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          query: query,
          failure: failure,
        ),
      ),
      (report) => emit(
        state.copyWith(
          status: LoadStatus.success,
          query: query,
          result: report,
          pageIndex: 0,
          failure: null,
          exporting: false,
          exportedCsv: null,
        ),
      ),
    );
  }
}
