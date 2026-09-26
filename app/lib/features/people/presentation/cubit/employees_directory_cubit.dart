import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/usecases/list_employees_usecase.dart';

part 'employees_directory_cubit.freezed.dart';

@freezed
abstract class EmployeesDirectoryState with _$EmployeesDirectoryState {
  const factory EmployeesDirectoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<EmployeeSummary>[]) List<EmployeeSummary> items,
    @Default(false) bool hasMore,
    String? nextCursor,
    String? query,
    @Default('all') String statusFilter,
    @Default(false) bool loadingMore,
    Failure? failure,
  }) = _EmployeesDirectoryState;
}

@injectable
class EmployeesDirectoryCubit extends Cubit<EmployeesDirectoryState> {
  EmployeesDirectoryCubit(this._listEmployees)
    : super(const EmployeesDirectoryState());

  final ListEmployeesUseCase _listEmployees;

  Future<void> load({String? query, String? statusFilter}) async {
    final normalized = _normalizeQuery(query);
    final effectiveStatus = statusFilter ?? state.statusFilter;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        query: normalized,
        statusFilter: effectiveStatus,
        loadingMore: false,
      ),
    );
    final statusParam = effectiveStatus == 'all' ? null : effectiveStatus;
    final result = await _listEmployees(
      ListEmployeesParams(query: normalized, status: statusParam),
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: page.items,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: normalized,
          statusFilter: effectiveStatus,
          loadingMore: false,
          failure: null,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.loadingMore ||
        state.status == LoadStatus.loading) {
      return;
    }
    final query = state.query;
    final cursor = state.nextCursor;
    final statusParam =
        state.statusFilter == 'all' ? null : state.statusFilter;
    emit(
      state.copyWith(
        status: LoadStatus.success,
        loadingMore: true,
        failure: null,
      ),
    );
    final result = await _listEmployees(
      ListEmployeesParams(query: query, status: statusParam, cursor: cursor),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          loadingMore: false,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: [...state.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: query,
          loadingMore: false,
          failure: null,
        ),
      ),
    );
  }

  String? _normalizeQuery(String? query) {
    final trimmed = query?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
