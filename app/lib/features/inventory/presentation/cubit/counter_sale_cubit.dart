import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../accounting/domain/entities/item.dart';
import '../../../accounting/domain/usecases/get_items_usecase.dart';
import '../../../payments/domain/entities/payment_method.dart';
import '../../../payments/domain/usecases/get_payment_methods_usecase.dart';
import '../../../people/domain/entities/profile_summary.dart';
import '../../../people/domain/usecases/list_members_usecase.dart';
import '../../domain/entities/counter_sale.dart';
import '../../domain/entities/create_counter_sale_input.dart';
import '../../domain/qty_compare.dart';
import '../../domain/sale_line.dart';
import '../../domain/sale_line_charge.dart';
import '../../domain/usecases/create_counter_sale_usecase.dart';

const Object _sentinel = Object();

enum CounterSaleStep { catalog, buyer, tender, success }

class CounterSaleState extends Equatable {
  const CounterSaleState({
    this.status = LoadStatus.initial,
    this.catalog = const [],
    this.search,
    this.lines = const [],
    this.failure,
    this.step = CounterSaleStep.catalog,
    this.paymentMethods = const [],
    this.paymentMethodsStatus = LoadStatus.initial,
    this.selectedPaymentMethodId,
    this.splitMode = false,
    this.splitAmounts = const {},
    this.memberId,
    this.member,
    this.buyerName,
    this.confirming = false,
    this.confirmError,
    this.postedSale,
  });

  final LoadStatus status;
  final List<Item> catalog;
  final String? search;
  final List<SaleLine> lines;
  final Failure? failure;
  final CounterSaleStep step;
  final List<PaymentMethod> paymentMethods;
  final LoadStatus paymentMethodsStatus;
  final String? selectedPaymentMethodId;

  /// When true, the cashier is settling with Split (not a payment method).
  final bool splitMode;

  /// Typed Split amounts keyed by payment method id. Blank/zero are omitted
  /// on confirm. Values are raw field text until confirm.
  final Map<String, String> splitAmounts;
  final int? memberId;

  /// Member chosen on the buyer step. Never set together with [buyerName].
  final ProfileSummary? member;
  final String? buyerName;
  final bool confirming;
  final String? confirmError;
  final CounterSale? postedSale;

  String get amountDue => sumCharges(lines.map((l) => l.charge));

  bool get canContinue => lines.isNotEmpty && step == CounterSaleStep.catalog;

  bool get hasOverOnHandLine => lines.any(_lineExceedsOnHand);

  /// Positive Split amounts only (blank/zero omitted).
  List<({String methodId, String amount})> get positiveSplitTenders {
    final out = <({String methodId, String amount})>[];
    for (final method in paymentMethods) {
      final raw = splitAmounts[method.id] ?? '';
      if (isBlankOrZeroMoney(raw)) continue;
      final parsed = parseMoneyInput(raw);
      if (parsed == null) continue;
      if (compareMoney(parsed, '0.00') <= 0) continue;
      out.add((methodId: method.id, amount: parsed));
    }
    return out;
  }

  String get splitEnteredTotal =>
      sumCharges(positiveSplitTenders.map((t) => t.amount));

  /// Unpaid remainder of the amount due after typed Split amounts.
  String get splitRemainder => subMoney(amountDue, splitEnteredTotal);

  bool get splitAmountsMatchDue =>
      positiveSplitTenders.length >= 2 &&
      compareMoney(splitEnteredTotal, amountDue) == 0;

  bool get canConfirm {
    if (step != CounterSaleStep.tender) return false;
    if (confirming) return false;
    if (hasOverOnHandLine) return false;
    if (paymentMethods.isEmpty) return false;
    if (splitMode) return splitAmountsMatchDue;
    return selectedPaymentMethodId != null;
  }

  PaymentMethod? get selectedPaymentMethod {
    final id = selectedPaymentMethodId;
    if (id == null) return null;
    for (final method in paymentMethods) {
      if (method.id == id) return method;
    }
    return null;
  }

  CounterSaleState copyWith({
    LoadStatus? status,
    List<Item>? catalog,
    Object? search = _sentinel,
    List<SaleLine>? lines,
    Object? failure = _sentinel,
    CounterSaleStep? step,
    List<PaymentMethod>? paymentMethods,
    LoadStatus? paymentMethodsStatus,
    Object? selectedPaymentMethodId = _sentinel,
    bool? splitMode,
    Map<String, String>? splitAmounts,
    Object? memberId = _sentinel,
    Object? member = _sentinel,
    Object? buyerName = _sentinel,
    bool? confirming,
    Object? confirmError = _sentinel,
    Object? postedSale = _sentinel,
  }) {
    return CounterSaleState(
      status: status ?? this.status,
      catalog: catalog ?? this.catalog,
      search: identical(search, _sentinel) ? this.search : search as String?,
      lines: lines ?? this.lines,
      failure: identical(failure, _sentinel)
          ? this.failure
          : failure as Failure?,
      step: step ?? this.step,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      paymentMethodsStatus: paymentMethodsStatus ?? this.paymentMethodsStatus,
      selectedPaymentMethodId: identical(selectedPaymentMethodId, _sentinel)
          ? this.selectedPaymentMethodId
          : selectedPaymentMethodId as String?,
      splitMode: splitMode ?? this.splitMode,
      splitAmounts: splitAmounts ?? this.splitAmounts,
      memberId: identical(memberId, _sentinel)
          ? this.memberId
          : memberId as int?,
      member: identical(member, _sentinel)
          ? this.member
          : member as ProfileSummary?,
      buyerName: identical(buyerName, _sentinel)
          ? this.buyerName
          : buyerName as String?,
      confirming: confirming ?? this.confirming,
      confirmError: identical(confirmError, _sentinel)
          ? this.confirmError
          : confirmError as String?,
      postedSale: identical(postedSale, _sentinel)
          ? this.postedSale
          : postedSale as CounterSale?,
    );
  }

  @override
  List<Object?> get props => [
    status,
    catalog,
    search,
    lines,
    failure,
    step,
    paymentMethods,
    paymentMethodsStatus,
    selectedPaymentMethodId,
    splitMode,
    splitAmounts,
    memberId,
    member,
    buyerName,
    confirming,
    confirmError,
    postedSale,
  ];
}

bool _lineExceedsOnHand(SaleLine line) {
  final item = line.item;
  if (!item.inventoryTracked) return false;
  final onHand = item.qtyOnHand;
  if (onHand == null || onHand.trim().isEmpty) return false;
  return quantityExceeds(line.quantity, onHand);
}

@injectable
class CounterSaleCubit extends Cubit<CounterSaleState> {
  CounterSaleCubit(
    this._getItems,
    this._getPaymentMethods,
    this._listMembers,
    this._createCounterSale, {
    @ignoreParam this.debounceDuration = const Duration(milliseconds: 300),
  }) : super(const CounterSaleState());

  final GetItemsUseCase _getItems;
  final GetPaymentMethodsUseCase _getPaymentMethods;
  /// Member-pick seam; UI uses [ListMembersUseCase] via the picker.
  // ignore: unused_field
  final ListMembersUseCase _listMembers;
  final CreateCounterSaleUseCase _createCounterSale;
  final Duration debounceDuration;

  Timer? _debounceTimer;
  int _loadEpoch = 0;
  String? _confirmIdempotencyKey;

  /// Exposed for tests that assert idempotency reuse.
  String? get confirmIdempotencyKeyForTest => _confirmIdempotencyKey;

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
      GetItemsParams(isActive: true, search: nextSearch, limit: 50, offset: 0),
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
      load(
        search: trimmed.isEmpty ? null : trimmed,
        clearSearch: trimmed.isEmpty,
      );
    });
  }

  void tapItem(Item item) {
    if (state.step != CounterSaleStep.catalog) return;
    final existingIndex = state.lines.indexWhere((l) => l.item.id == item.id);
    if (existingIndex >= 0) {
      final existing = state.lines[existingIndex];
      final nextQty = _addOne(existing.quantity, item.uomDecimalPlaces);
      final next = List<SaleLine>.of(state.lines);
      next[existingIndex] = existing.copyWithQuantity(nextQty);
      emit(state.copyWith(lines: next, confirmError: null));
      return;
    }
    emit(
      state.copyWith(
        lines: [
          ...state.lines,
          SaleLine(item: item, quantity: _oneUnit(item.uomDecimalPlaces)),
        ],
        confirmError: null,
      ),
    );
  }

  void setLineQuantity(int itemId, String rawQuantity) {
    if (state.step != CounterSaleStep.catalog &&
        state.step != CounterSaleStep.tender) {
      return;
    }
    final index = state.lines.indexWhere((l) => l.item.id == itemId);
    if (index < 0) return;
    final line = state.lines[index];
    final places = line.item.uomDecimalPlaces;
    final normalized = _normalizeQuantity(rawQuantity, places);
    if (normalized == null) return;
    final next = List<SaleLine>.of(state.lines);
    next[index] = line.copyWithQuantity(normalized);
    emit(state.copyWith(lines: next, confirmError: null));
  }

  void removeLine(int itemId) {
    if (state.step != CounterSaleStep.catalog) return;
    emit(
      state.copyWith(
        lines: state.lines.where((l) => l.item.id != itemId).toList(),
        confirmError: null,
      ),
    );
  }

  void openBuyer() {
    if (!state.canContinue) return;
    emit(state.copyWith(step: CounterSaleStep.buyer, confirmError: null));
  }

  /// Picking a Member clears a typed buyer name. The sale never carries both.
  void setMember(int? memberId, {ProfileSummary? member}) {
    emit(
      state.copyWith(
        memberId: memberId,
        member: memberId == null ? null : member,
        buyerName: memberId == null ? state.buyerName : null,
        confirmError: null,
      ),
    );
  }

  /// Typing a buyer name clears the selected Member. Blank text does not.
  void setBuyerName(String? name) {
    final raw = name ?? '';
    final hasName = raw.trim().isNotEmpty;
    emit(
      state.copyWith(
        buyerName: hasName ? raw : null,
        memberId: hasName ? null : state.memberId,
        member: hasName ? null : state.member,
        confirmError: null,
      ),
    );
  }

  Future<void> goToTender() async {
    final fromBuyer =
        state.step == CounterSaleStep.buyer && state.lines.isNotEmpty;
    final retry =
        state.step == CounterSaleStep.tender && state.lines.isNotEmpty;
    if (!fromBuyer && !retry && !state.canContinue) return;
    emit(
      state.copyWith(
        step: CounterSaleStep.tender,
        paymentMethodsStatus: LoadStatus.loading,
        // Keep splitMode / splitAmounts when returning from buyer.
        selectedPaymentMethodId: state.splitMode
            ? null
            : state.selectedPaymentMethodId,
        confirmError: null,
      ),
    );
    await _loadPaymentMethods();
  }

  void backToCatalog() {
    if (state.step == CounterSaleStep.tender) {
      emit(
        state.copyWith(
          step: CounterSaleStep.buyer,
          // Keep Split amounts and mode across back.
          confirmError: null,
        ),
      );
      return;
    }
    if (state.step != CounterSaleStep.buyer) return;
    emit(state.copyWith(step: CounterSaleStep.catalog, confirmError: null));
  }

  void selectPaymentMethod(String paymentMethodId) {
    if (state.step != CounterSaleStep.tender) return;
    emit(
      state.copyWith(
        selectedPaymentMethodId: paymentMethodId,
        splitMode: false,
        confirmError: null,
      ),
    );
  }

  /// Opens Split. Not a payment method. Amounts start empty (nothing filled).
  void openSplit() {
    if (state.step != CounterSaleStep.tender) return;
    if (state.paymentMethods.isEmpty) return;
    emit(
      state.copyWith(
        splitMode: true,
        selectedPaymentMethodId: null,
        splitAmounts: const {},
        confirmError: null,
      ),
    );
  }

  /// Leaves Split and returns to single-method buttons. Keeps typed amounts.
  void leaveSplit() {
    if (state.step != CounterSaleStep.tender || !state.splitMode) return;
    emit(
      state.copyWith(
        splitMode: false,
        selectedPaymentMethodId: null,
        confirmError: null,
      ),
    );
  }

  void setSplitAmount(String paymentMethodId, String raw) {
    if (state.step != CounterSaleStep.tender || !state.splitMode) return;
    final next = Map<String, String>.of(state.splitAmounts);
    next[paymentMethodId] = raw;
    emit(state.copyWith(splitAmounts: next, confirmError: null));
  }

  Future<void> confirm() async {
    if (!state.canConfirm) return;

    final List<CreateCounterSaleTenderInput> tenders;
    if (state.splitMode) {
      final built = <CreateCounterSaleTenderInput>[];
      for (final row in state.positiveSplitTenders) {
        final id = int.tryParse(row.methodId);
        if (id == null) {
          emit(state.copyWith(confirmError: 'Invalid payment method'));
          return;
        }
        built.add(
          CreateCounterSaleTenderInput(
            paymentMethodId: id,
            amount: row.amount,
          ),
        );
      }
      tenders = built;
    } else {
      final method = state.selectedPaymentMethod;
      if (method == null) return;
      final methodId = int.tryParse(method.id);
      if (methodId == null) {
        emit(state.copyWith(confirmError: 'Invalid payment method'));
        return;
      }
      tenders = [
        CreateCounterSaleTenderInput(
          paymentMethodId: methodId,
          amount: state.amountDue,
        ),
      ];
    }

    _confirmIdempotencyKey ??= newIdempotencyKey();
    emit(state.copyWith(confirming: true, confirmError: null));

    final buyer = state.buyerName?.trim();
    final input = CreateCounterSaleInput(
      memberId: state.memberId,
      buyerName: (buyer == null || buyer.isEmpty) ? null : buyer,
      lines: [
        for (final line in state.lines)
          CreateCounterSaleLineInput(
            itemId: line.item.id,
            quantity: line.quantity,
          ),
      ],
      tenders: tenders,
      idempotencyKey: _confirmIdempotencyKey,
    );

    final result = await _createCounterSale(input);
    result.fold(
      (failure) => emit(
        state.copyWith(
          confirming: false,
          confirmError: failureMessage(failure),
        ),
      ),
      (sale) {
        _confirmIdempotencyKey = null;
        emit(
          state.copyWith(
            confirming: false,
            confirmError: null,
            postedSale: sale,
            step: CounterSaleStep.success,
          ),
        );
      },
    );
  }

  /// Clears the open sale back to an empty catalog grid.
  void startNewSale() {
    _confirmIdempotencyKey = null;
    emit(
      CounterSaleState(
        status: state.status,
        catalog: state.catalog,
        search: state.search,
      ),
    );
  }

  /// Drops the in-memory sale when leaving the screen before confirm.
  void discardOpenSale() {
    if (state.step == CounterSaleStep.success) return;
    _confirmIdempotencyKey = null;
    emit(
      CounterSaleState(
        status: state.status,
        catalog: state.catalog,
        search: state.search,
      ),
    );
  }

  Future<void> _loadPaymentMethods() async {
    final result = await _getPaymentMethods(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          paymentMethodsStatus: LoadStatus.failure,
          paymentMethods: const [],
          confirmError: failureMessage(failure),
        ),
      ),
      (methods) {
        final active = methods.where((m) => m.isActive).toList();
        emit(
          state.copyWith(
            paymentMethodsStatus: LoadStatus.success,
            paymentMethods: active,
            confirmError: null,
          ),
        );
      },
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
    final current =
        _normalizeQuantity(quantity, decimalPlaces) ?? _oneUnit(decimalPlaces);
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
    final frac = parts.length > 1
        ? parts[1].padRight(scale, '0').substring(0, scale)
        : ''.padRight(scale, '0');
    return whole * _pow10(scale) + (int.tryParse(frac) ?? 0);
  }

  static String _fromScaled(int units, int scale) {
    final whole = units ~/ _pow10(scale);
    final frac = (units % _pow10(scale)).toString().padLeft(scale, '0');
    return '$whole.$frac';
  }
}
