import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/payment.dart';
import '../../domain/usecases/get_outstanding_payments_usecase.dart';

sealed class OutstandingDuesState extends Equatable {
  const OutstandingDuesState();

  @override
  List<Object?> get props => [];
}

final class OutstandingDuesLoading extends OutstandingDuesState {
  const OutstandingDuesLoading();
}

final class OutstandingDuesLoaded extends OutstandingDuesState {
  const OutstandingDuesLoaded(this.items);

  final List<Payment> items;

  @override
  List<Object?> get props => [items];
}

final class OutstandingDuesFailure extends OutstandingDuesState {
  const OutstandingDuesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class OutstandingDuesCubit extends Cubit<OutstandingDuesState> {
  OutstandingDuesCubit(this._getOutstanding)
    : super(const OutstandingDuesLoading());

  final GetOutstandingPaymentsUseCase _getOutstanding;

  Future<void> load() async {
    emit(const OutstandingDuesLoading());
    final result = await _getOutstanding(
      const GetOutstandingPaymentsParams(),
    );
    result.fold(
      (failure) => emit(OutstandingDuesFailure(failureMessage(failure))),
      (page) => emit(OutstandingDuesLoaded(page.items)),
    );
  }
}
