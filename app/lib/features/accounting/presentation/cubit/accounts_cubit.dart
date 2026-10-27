import 'dart:async';

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
  AccountsCubit(
    this._getAccounts, {
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(const AccountsState());

  final GetAccountsUseCase _getAccounts;
  final Duration debounceDuration;

  Timer? _debounceTimer;
  int _loadEpoch = 0;

  Future<void> load({
    String? accountType,
    bool? isActive,
    String? search,
    bool clearType = false,
    bool clearActive = false,
    bool clearSearch = false,
  }) async {
    _debounceTimer?.cancel();
    final epoch = ++_loadEpoch;

    final nextType = clearType ? null : (accountType ?? state.accountType);
    final nextActive = clearActive ? null : (isActive ?? state.isActive);
    final nextSearch = clearSearch ? null : (search ?? state.search);

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

    if (isClosed || epoch != _loadEpoch) return;

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

  void setSearch(String? search) {
    _debounceTimer?.cancel();
    final next =
        (search == null || search.trim().isEmpty) ? null : search.trim();

    if (debounceDuration == Duration.zero) {
      load(search: next, clearSearch: next == null);
    } else {
      emit(state.copyWith(search: next));
      _debounceTimer = Timer(debounceDuration, () {
        load(search: next, clearSearch: next == null);
      });
    }
  }

  Future<void> clearFilters() {
    return load(clearType: true, clearActive: true, clearSearch: true);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
