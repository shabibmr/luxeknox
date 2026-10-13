import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/account.dart';
import '../../domain/usecases/create_account_usecase.dart';
import '../../domain/usecases/get_account_usecase.dart';
import '../../domain/usecases/update_account_usecase.dart';

const Object _sentinel = Object();

class AccountFormState extends Equatable {
  const AccountFormState({
    this.status = LoadStatus.initial,
    this.account,
    this.failure,
    this.isSubmitting = false,
  });

  final LoadStatus status;
  final Account? account;
  final Failure? failure;
  final bool isSubmitting;

  AccountFormState copyWith({
    LoadStatus? status,
    Object? account = _sentinel,
    Object? failure = _sentinel,
    bool? isSubmitting,
  }) {
    return AccountFormState(
      status: status ?? this.status,
      account: identical(account, _sentinel)
          ? this.account
          : (account as Account?),
      failure: identical(failure, _sentinel)
          ? this.failure
          : (failure as Failure?),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [status, account, failure, isSubmitting];
}

@injectable
class AccountFormCubit extends Cubit<AccountFormState> {
  AccountFormCubit(
    this._getAccount,
    this._createAccount,
    this._updateAccount,
  ) : super(const AccountFormState());

  final GetAccountUseCase _getAccount;
  final CreateAccountUseCase _createAccount;
  final UpdateAccountUseCase _updateAccount;

  Future<void> load(String id) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));

    final result = await _getAccount(GetAccountParams(id: id));

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (account) => emit(
        state.copyWith(
          status: LoadStatus.success,
          account: account,
          failure: null,
        ),
      ),
    );
  }

  Future<bool> create({
    required String code,
    required String name,
    required String accountType,
    String? parentId,
    bool? isActive,
    bool? isBank,
    bool? isControl,
    String? controlRole,
  }) async {
    emit(state.copyWith(isSubmitting: true, failure: null));

    final result = await _createAccount(
      CreateAccountParams(
        code: code,
        name: name,
        accountType: accountType,
        parentId: parentId,
        isActive: isActive,
        isBank: isBank,
        isControl: isControl,
        controlRole: controlRole,
      ),
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: failure,
            isSubmitting: false,
          ),
        );
        return false;
      },
      (created) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            account: created,
            isSubmitting: false,
            failure: null,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> update({
    required String id,
    String? name,
    String? parentId,
    bool? isActive,
    bool? isBank,
  }) async {
    emit(state.copyWith(isSubmitting: true, failure: null));

    final result = await _updateAccount(
      UpdateAccountParams(
        id: id,
        name: name,
        parentId: parentId,
        isActive: isActive,
        isBank: isBank,
      ),
    );

    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: failure,
            isSubmitting: false,
          ),
        );
        return false;
      },
      (updated) {
        emit(
          state.copyWith(
            status: LoadStatus.success,
            account: updated,
            isSubmitting: false,
            failure: null,
          ),
        );
        return true;
      },
    );
  }

  Future<bool> deactivate(String id) {
    return update(id: id, isActive: false);
  }
}
