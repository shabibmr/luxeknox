import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/fund_transfer.dart';
import '../../domain/usecases/get_fund_transfer_usecase.dart';
import '../../domain/usecases/post_fund_transfer_usecase.dart';

const Object _sentinel = Object();

class FundTransferDetailState extends Equatable {
  const FundTransferDetailState({
    this.status = LoadStatus.initial,
    this.transfer,
    this.isPosting = false,
    this.failure,
    this.postSuccess = false,
  });

  final LoadStatus status;
  final FundTransfer? transfer;
  final bool isPosting;
  final Failure? failure;
  final bool postSuccess;

  FundTransferDetailState copyWith({
    LoadStatus? status,
    Object? transfer = _sentinel,
    bool? isPosting,
    Object? failure = _sentinel,
    bool? postSuccess,
  }) {
    return FundTransferDetailState(
      status: status ?? this.status,
      transfer: identical(transfer, _sentinel)
          ? this.transfer
          : (transfer as FundTransfer?),
      isPosting: isPosting ?? this.isPosting,
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      postSuccess: postSuccess ?? this.postSuccess,
    );
  }

  @override
  List<Object?> get props => [
        status,
        transfer,
        isPosting,
        failure,
        postSuccess,
      ];
}

@injectable
class FundTransferDetailCubit extends Cubit<FundTransferDetailState> {
  FundTransferDetailCubit(
    this._getFundTransfer,
    this._postFundTransfer,
  ) : super(const FundTransferDetailState());

  final GetFundTransferUseCase _getFundTransfer;
  final PostFundTransferUseCase _postFundTransfer;

  Future<void> load(String id) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getFundTransfer(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (transfer) => emit(
        state.copyWith(
          status: LoadStatus.success,
          transfer: transfer,
          failure: null,
        ),
      ),
    );
  }

  void setTransfer(FundTransfer transfer) {
    emit(
      state.copyWith(
        status: LoadStatus.success,
        transfer: transfer,
        failure: null,
      ),
    );
  }

  Future<bool> post() async {
    final currentTransfer = state.transfer;
    if (currentTransfer == null) return false;

    emit(
      state.copyWith(
        isPosting: true,
        failure: null,
        postSuccess: false,
      ),
    );

    final result = await _postFundTransfer(currentTransfer.id);

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isPosting: false,
            failure: failure,
            postSuccess: false,
          ),
        );
        return false;
      },
      (postedTransfer) {
        emit(
          state.copyWith(
            isPosting: false,
            status: LoadStatus.success,
            transfer: postedTransfer,
            postSuccess: true,
            failure: null,
          ),
        );
        return true;
      },
    );
  }
}
