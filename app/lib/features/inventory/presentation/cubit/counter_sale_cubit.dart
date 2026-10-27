import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../accounting/domain/entities/item.dart';
import '../../../accounting/domain/usecases/get_items_usecase.dart';
import '../../domain/sale_line.dart';
import '../../domain/sale_line_charge.dart';

const Object _sentinel = Object();

class CounterSaleState extends Equatable {
  const CounterSaleState({
    this.status = LoadStatus.initial,
    this.catalog = const [],
    this.search,
    this.lines = const [],
    this.failure,
  });

  final LoadStatus status;
  final List<Item> catalog;
  final String? search;
  final List<SaleLine> lines;
  final Failure? failure;

  String get amountDue => sumCharges(lines.map((l) => l.charge));

  bool get canContinue => lines.isNotEmpty;

  CounterSaleState copyWith({
    LoadStatus? status,
    List<Item>? catalog,
    Object? search = _sentinel,
    List<SaleLine>? lines,
    Object? failure = _sentinel,
  }) {
    return CounterSaleState(
      status: status ?? this.status,
      catalog: catalog ?? this.catalog,
      search: identical(search, _sentinel) ? this.search : search as String?,
      lines: lines ?? this.lines,
      failure:
          identical(failure, _sentinel) ? this.failure : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [status, catalog, search, lines, failure];
}

@injectable
class CounterSaleCubit extends Cubit<CounterSaleState> {
  CounterSaleCubit(
    this._getItems, {
    this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(const CounterSaleState());

  final GetItemsUseCase _getItems;
  final Duration debounceDuration;

  Timer? _debounceTimer;
  int _loadEpoch = 0;

  Future<void> load({String? search, bool clearSearch = false}) async {
    _debounceTimer?.cancel();
    final epoch = ++_loadEpoch;
    final nextSearch = clearSearch ? null : (search ?? state.search);

    emit(
      state.copyWith(
        status: LoadStatus.loading,
        search: nextSearch,
        failure: null,
      ),
    );

    final result = await _getItems(
      GetItemsParams(
        isActive: true,
        search: nextSearch,
        limit: 50,
        offset: 0,
      ),
    );

    if (epoch != _loadEpoch) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          catalog: const [],
        ),
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
            catalog: sellable,
            failure: null,
          ),
        );
      },
    );
  }

  void searchCatalog(String query) {
    _debounceTimer?.cancel();
    final trimmed = query.trim();
    _debounceTimer = Timer(debounceDuration, () {
      load(search: trimmed.isEmpty ? null : trimmed, clearSearch: trimmed.isEmpty);
    });
  }

  void tapItem(Item item) {
    final existingIndex = state.lines.indexWhere((l) => l.item.id == item.id);
    if (existingIndex >= 0) {
      final existing = state.lines[existingIndex];
      final nextQty = _addOne(existing.quantity, item.uomDecimalPlaces);
      final next = List<SaleLine>.of(state.lines);
      next[existingIndex] = existing.copyWithQuantity(nextQty);
      emit(state.copyWith(lines: next));
      return;
    }
    emit(
      state.copyWith(
        lines: [
          ...state.lines,
          SaleLine(item: item, quantity: _oneUnit(item.uomDecimalPlaces)),
        ],
      ),
    );
  }

  /// Sets a line quantity. Piece items (0 places) keep whole numbers.
  /// Weighed items accept up to [Item.uomDecimalPlaces] decimals.
  /// Invalid input is ignored. Empty / zero removes nothing — use [removeLine].
  void setLineQuantity(int itemId, String rawQuantity) {
    final index = state.lines.indexWhere((l) => l.item.id == itemId);
    if (index < 0) return;
    final line = state.lines[index];
    final places = line.item.uomDecimalPlaces;
    final normalized = _normalizeQuantity(rawQuantity, places);
    if (normalized == null) return;
    final next = List<SaleLine>.of(state.lines);
    next[index] = line.copyWithQuantity(normalized);
    emit(state.copyWith(lines: next));
  }

  void removeLine(int itemId) {
    emit(
      state.copyWith(
        lines: state.lines.where((l) => l.item.id != itemId).toList(),
      ),
    );
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }

  static String _oneUnit(int decimalPlaces) {
    if (decimalPlaces <= 0) return '1';
    return '1.${'0' * decimalPlaces}';
  }

  static String _addOne(String quantity, int decimalPlaces) {
    final current = _normalizeQuantity(quantity, decimalPlaces) ?? _oneUnit(decimalPlaces);
    if (decimalPlaces <= 0) {
      final n = int.tryParse(current) ?? 1;
      return (n + 1).toString();
    }
    final scale = _pow10(decimalPlaces);
    final units = _toScaled(current, decimalPlaces) + scale;
    return _fromScaled(units, decimalPlaces);
  }

  static String? _normalizeQuantity(String raw, int decimalPlaces) {
    final value = raw.trim();
    if (value.isEmpty) return null;
    if (decimalPlaces <= 0) {
      if (!RegExp(r'^\d+$').hasMatch(value)) return null;
      final n = int.tryParse(value);
      if (n == null || n <= 0) return null;
      return n.toString();
    }
    if (!RegExp('^\\d+(\\.\\d{0,$decimalPlaces})?\$').hasMatch(value)) {
      return null;
    }
    final number = double.tryParse(value);
    if (number == null || number <= 0) return null;
    return number.toStringAsFixed(decimalPlaces);
  }

  static int _pow10(int n) {
    var r = 1;
    for (var i = 0; i < n; i++) {
      r *= 10;
    }
    return r;
  }

  static int _toScaled(String value, int scale) {
    final parts = value.split('.');
    final whole = int.parse(parts[0]);
    final frac = parts.length > 1 ? parts[1].padRight(scale, '0').substring(0, scale) : ''.padRight(scale, '0');
    return whole * _pow10(scale) + (int.tryParse(frac) ?? 0);
  }

  static String _fromScaled(int units, int scale) {
    final whole = units ~/ _pow10(scale);
    final frac = (units % _pow10(scale)).toString().padLeft(scale, '0');
    return '$whole.$frac';
  }
}
