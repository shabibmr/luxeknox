import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/expense_voucher.dart';
import '../../domain/usecases/get_expense_usecase.dart';
import '../../domain/usecases/post_expense_usecase.dart';

const Object _sentinel = Object();

class ExpenseDetailState extends Equatable {
  const ExpenseDetailState({
    this.status = LoadStatus.initial,
    this.expense,
    this.isPosting = false,
    this.failure,
    this.postSuccess,
  });

  final LoadStatus status;
  final ExpenseVoucher? expense;
  final bool isPosting;
  final Failure? failure;
  final ExpenseVoucher? postSuccess;

  ExpenseDetailState copyWith({
    LoadStatus? status,
    Object? expense = _sentinel,
    bool? isPosting,
    Object? failure = _sentinel,
    Object? postSuccess = _sentinel,
  }) {
    return ExpenseDetailState(
      status: status ?? this.status,
      expense: identical(expense, _sentinel)
          ? this.expense
          : (expense as ExpenseVoucher?),
      isPosting: isPosting ?? this.isPosting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      postSuccess: identical(postSuccess, _sentinel)
          ? this.postSuccess
          : (postSuccess as ExpenseVoucher?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        expense,
        isPosting,
        failure,
        postSuccess,
      ];
}

@injectable
class ExpenseDetailCubit extends Cubit<ExpenseDetailState> {
  ExpenseDetailCubit(
    this._getExpense,
    this._postExpense,
  ) : super(const ExpenseDetailState());

  final GetExpenseUseCase _getExpense;
  final PostExpenseUseCase _postExpense;

  Future<void> load(String id) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getExpense(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (expense) => emit(
        state.copyWith(
          status: LoadStatus.success,
          expense: expense,
          failure: null,
        ),
      ),
    );
  }

  void setExpense(ExpenseVoucher expense) {
    emit(
      state.copyWith(
        status: LoadStatus.success,
        expense: expense,
        failure: null,
      ),
    );
  }

  Future<bool> post() async {
    final current = state.expense;
    if (current == null) return false;

    emit(state.copyWith(isPosting: true, failure: null, postSuccess: null));

    final result = await _postExpense(current.id);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isPosting: false,
            failure: failure,
          ),
        );
        return false;
      },
      (postedExpense) {
        emit(
          state.copyWith(
            isPosting: false,
            expense: postedExpense,
            postSuccess: postedExpense,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
