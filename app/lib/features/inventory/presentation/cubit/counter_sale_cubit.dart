import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../accounting/domain/entities/item.dart';
import '../../../accounting/domain/usecases/get_items_usecase.dart';
import '../../domain/counter_sale_money.dart';

class CounterSaleState extends Equatable {
  const CounterSaleState({
    this.status = LoadStatus.initial,
    this.items = const [],
    this.search = '',
    this.failure,
  });

  final LoadStatus status;
  final List<Item> items;
  final String search;
  final Failure? failure;

  CounterSaleState copyWith({
    LoadStatus? status,
    List<Item>? items,
    String? search,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return CounterSaleState(
      status: status ?? this.status,
      items: items ?? this.items,
      search: search ?? this.search,
      failure: clearFailure ? null : (failure ?? this.failure),
    );
  }

  @override
  List<Object?> get props => [status, items, search, failure];
}

/// Catalog step of Counter Sale: search + grid of sellable items.
@injectable
class CounterSaleCubit extends Cubit<CounterSaleState> {
  CounterSaleCubit(
    this._getItems, {
    @ignoreParam this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(const CounterSaleState());

  final GetItemsUseCase _getItems;
  final Duration debounceDuration;
  Timer? _debounceTimer;
  int _loadEpoch = 0;

  Future<void> load() => _reload();

  void search(String query) {
    _debounceTimer?.cancel();
    final next = query.trim();
    emit(state.copyWith(search: next, clearFailure: true));
    _debounceTimer = Timer(debounceDuration, () {
      unawaited(_reload());
    });
  }

  Future<void> _reload() async {
    final epoch = ++_loadEpoch;
    emit(state.copyWith(status: LoadStatus.loading, clearFailure: true));
    final result = await _getItems(
      GetItemsParams(
        isActive: true,
        search: state.search.isEmpty ? null : state.search,
      ),
    );
    if (isClosed || epoch != _loadEpoch) return;
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        final sellable = page.items
            .where(
              (item) =>
                  item.isActive &&
                  item.saleRate != null &&
                  item.saleRate!.trim().isNotEmpty,
            )
            .toList();
        emit(
          state.copyWith(
            status: LoadStatus.success,
            items: sellable,
            clearFailure: true,
          ),
        );
      },
    );
  }

  /// Charge for one unit of [item], including tax when the item has a rate.
  String unitChargeFor(Item item) {
    final rate = item.saleRate;
    if (rate == null || rate.trim().isEmpty) return '0.00';
    return unitCharge(saleRate: rate, taxRatePercent: item.taxRatePercent);
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
