import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/go_live.dart';
import '../../domain/repositories/accounting_repository.dart';
import '../accounting_strings.dart';

const Object _sentinel = Object();

class GoLiveState extends Equatable {
  const GoLiveState({
    this.status = LoadStatus.initial,
    this.checklist,
    required this.selectedDate,
    this.isActionInProgress = false,
    this.failure,
    this.successMessage,
  });

  final LoadStatus status;
  final GoLiveChecklist? checklist;
  final DateTime selectedDate;
  final bool isActionInProgress;
  final Failure? failure;
  final String? successMessage;

  GoLiveState copyWith({
    LoadStatus? status,
    Object? checklist = _sentinel,
    DateTime? selectedDate,
    bool? isActionInProgress,
    Object? failure = _sentinel,
    Object? successMessage = _sentinel,
  }) {
    return GoLiveState(
      status: status ?? this.status,
      checklist: identical(checklist, _sentinel)
          ? this.checklist
          : (checklist as GoLiveChecklist?),
      selectedDate: selectedDate ?? this.selectedDate,
      isActionInProgress: isActionInProgress ?? this.isActionInProgress,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      successMessage: identical(successMessage, _sentinel)
          ? this.successMessage
          : (successMessage as String?),
    );
  }

  @override
  List<Object?> get props => [
        status,
        checklist,
        selectedDate,
        isActionInProgress,
        failure,
        successMessage,
      ];
}

@injectable
class GoLiveCubit extends Cubit<GoLiveState> {
  GoLiveCubit(
    this._repository, {
    @ignoreParam DateTime? initialDate,
  }) : super(GoLiveState(selectedDate: initialDate ?? DateTime.now()));

  final AccountingRepository _repository;

  Future<void> load({DateTime? goLiveDate}) async {
    final targetDate = goLiveDate ?? state.selectedDate;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        selectedDate: targetDate,
        failure: null,
        successMessage: null,
      ),
    );

    final result = await _repository.getGoLiveChecklist(goLiveDate: targetDate);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (checklist) => emit(
        state.copyWith(
          status: LoadStatus.success,
          checklist: checklist,
          selectedDate: checklist.goLiveDate,
          failure: null,
        ),
      ),
    );
  }

  Future<void> changeDate(DateTime date) async {
    emit(state.copyWith(selectedDate: date));
    await load(goLiveDate: date);
  }

  Future<void> mapPaymentMethod(int paymentMethodId, int? accountId) async {
    emit(
      state.copyWith(
        isActionInProgress: true,
        failure: null,
        successMessage: null,
      ),
    );

    final result = await _repository.mapPaymentMethodAccount(
      paymentMethodId: paymentMethodId,
      accountId: accountId,
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            isActionInProgress: false,
            failure: failure,
          ),
        );
      },
      (mapping) async {
        final reloadResult = await _repository.getGoLiveChecklist(
          goLiveDate: state.selectedDate,
        );

        reloadResult.fold(
          (failure) {
            emit(
              state.copyWith(
                isActionInProgress: false,
                successMessage: AccountingStrings.paymentMethodMappedSuccess,
              ),
            );
          },
          (updatedChecklist) {
            emit(
              state.copyWith(
                isActionInProgress: false,
                checklist: updatedChecklist,
                successMessage: AccountingStrings.paymentMethodMappedSuccess,
                failure: null,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> enablePosting() async {
    emit(
      state.copyWith(
        isActionInProgress: true,
        failure: null,
        successMessage: null,
      ),
    );

    final result = await _repository.enablePosting(
      goLiveDate: state.selectedDate,
    );

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            isActionInProgress: false,
            failure: failure,
          ),
        );
      },
      (success) async {
        final reloadResult = await _repository.getGoLiveChecklist(
          goLiveDate: state.selectedDate,
        );

        reloadResult.fold(
          (failure) {
            emit(
              state.copyWith(
                isActionInProgress: false,
                successMessage: AccountingStrings.postingEnabledSuccess,
              ),
            );
          },
          (updatedChecklist) {
            emit(
              state.copyWith(
                isActionInProgress: false,
                checklist: updatedChecklist,
                successMessage: AccountingStrings.postingEnabledSuccess,
                failure: null,
              ),
            );
          },
        );
      },
    );
  }
}
