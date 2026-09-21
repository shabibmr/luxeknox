import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/employee_summary.dart';
import '../../domain/usecases/list_employees_usecase.dart';

sealed class EmployeesDirectoryState extends Equatable {
  const EmployeesDirectoryState();

  @override
  List<Object?> get props => [];
}

final class EmployeesDirectoryLoading extends EmployeesDirectoryState {
  const EmployeesDirectoryLoading();
}

final class EmployeesDirectoryLoaded extends EmployeesDirectoryState {
  const EmployeesDirectoryLoaded({
    required this.items,
    required this.hasMore,
    this.nextCursor,
    this.query,
    this.loadingMore = false,
  });

  final List<EmployeeSummary> items;
  final bool hasMore;
  final String? nextCursor;
  final String? query;
  final bool loadingMore;

  @override
  List<Object?> get props => [items, hasMore, nextCursor, query, loadingMore];
}

final class EmployeesDirectoryFailure extends EmployeesDirectoryState {
  const EmployeesDirectoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class EmployeesDirectoryCubit extends Cubit<EmployeesDirectoryState> {
  EmployeesDirectoryCubit(this._listEmployees)
    : super(const EmployeesDirectoryLoading());

  final ListEmployeesUseCase _listEmployees;
  String? _query;

  Future<void> load({String? query}) async {
    _query = query?.trim().isEmpty == true ? null : query?.trim();
    emit(const EmployeesDirectoryLoading());
    final result = await _listEmployees(ListEmployeesParams(query: _query));
    result.fold(
      (failure) => emit(EmployeesDirectoryFailure(_message(failure))),
      (page) => emit(
        EmployeesDirectoryLoaded(
          items: page.items,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: _query,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! EmployeesDirectoryLoaded ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(
      EmployeesDirectoryLoaded(
        items: current.items,
        hasMore: current.hasMore,
        nextCursor: current.nextCursor,
        query: current.query,
        loadingMore: true,
      ),
    );
    final result = await _listEmployees(
      ListEmployeesParams(query: current.query, cursor: current.nextCursor),
    );
    result.fold(
      (failure) => emit(EmployeesDirectoryFailure(_message(failure))),
      (page) => emit(
        EmployeesDirectoryLoaded(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: current.query,
        ),
      ),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
