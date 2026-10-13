import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/account.dart';
import '../../domain/usecases/get_accounts_usecase.dart';

part 'accounts_cubit.freezed.dart';

@freezed
abstract class AccountsState with _$AccountsState {
  const factory AccountsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<Account>[]) List<Account> accounts,
    String? accountType,
    bool? isActive,
    String? search,
    Failure? failure,
  }) = _AccountsState;
}

@injectable
class AccountsCubit extends Cubit<AccountsState> {
  AccountsCubit(this._getAccounts) : super(const AccountsState());

  final GetAccountsUseCase _getAccounts;

  Future<void> load({
    String? accountType,
    bool? isActive,
    String? search,
    bool clearType = false,
    bool clearActive = false,
  }) async {
    final nextType = clearType ? null : (accountType ?? state.accountType);
    final nextActive = clearActive ? null : (isActive ?? state.isActive);
    final nextSearch = search ?? state.search;

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        accountType: nextType,
        isActive: nextActive,
        search: nextSearch,
        failure: null,
      ),
    );

    final result = await _getAccounts(
      GetAccountsParams(
        accountType: nextType,
        isActive: nextActive,
        search: nextSearch,
        limit: 100,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          accounts: page.items,
          failure: null,
        ),
      ),
    );
  }

  Future<void> filterByType(String? accountType) {
    return load(accountType: accountType, clearType: accountType == null);
  }

  Future<void> filterByActive(bool? isActive) {
    return load(isActive: isActive, clearActive: isActive == null);
  }

  Future<void> setSearch(String? search) {
    return load(search: search);
  }

  Future<void> clearFilters() {
    return load(clearType: true, clearActive: true, search: '');
  }
}
