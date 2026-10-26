import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/idempotency/idempotency_key.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../payments/domain/entities/payment_method.dart';
import '../../../payments/domain/usecases/get_payment_methods_usecase.dart';
import '../../../people/domain/entities/person.dart';
import '../../../people/domain/usecases/get_member_usecase.dart';
import '../../domain/entities/pt_product.dart';
import '../../domain/entities/pt_schedule_grid.dart';
import '../../domain/entities/pt_subscription.dart';
import '../../domain/repositories/pt_repository.dart';
import '../../domain/usecases/pt_usecases.dart';
import '../pt_strings.dart';

part 'sell_pt_cubit.freezed.dart';

/// Client-side partner eligibility for a couple PT sale.
sealed class SellPtPartnerCheck {
  const SellPtPartnerCheck();
}

final class SellPtPartnerCheckLoading extends SellPtPartnerCheck {
  const SellPtPartnerCheckLoading();
}

final class SellPtPartnerCheckOk extends SellPtPartnerCheck {
  const SellPtPartnerCheckOk();
}

final class SellPtPartnerCheckBlocked extends SellPtPartnerCheck {
  const SellPtPartnerCheckBlocked(this.message);
  final String message;
}

@freezed
abstract class SellPtState with _$SellPtState {
  const factory SellPtState({
    @Default(LoadStatus.initial) LoadStatus status,
    required int memberId,
    String? memberName,
    Person? member,

    /// Set when re-planning (reassign trainer / change slot) an existing PT.
    PtSubscription? replanning,
    @Default(<PtProduct>[]) List<PtProduct> products,
    @Default(<PaymentMethod>[]) List<PaymentMethod> paymentMethods,
    PtProduct? product,
    DateTime? startDate,
    @Default(<int>[]) List<int> weekdays,
    @Default(LoadStatus.initial) LoadStatus gridStatus,
    PtScheduleGrid? grid,
    int? trainerId,
    String? slotStart,
    String? paymentMethodId,
    String? discount,
    String? reason,

    /// Couple packages only: the second member on the sale.
    Person? partner,
    SellPtPartnerCheck? partnerCheck,
    @Default(false) bool submitting,
    PtSubscription? result,
    Failure? failure,
  }) = _SellPtState;

  const SellPtState._();

  bool get isReplan => replanning != null;

  bool get isCoupleSelected => product?.isCouple ?? false;

  /// How many days a week the member trains is chosen per member, not fixed
  /// by the package — any count from 1 to 7 is valid.
  bool get weekdaysChosen => product != null && weekdays.isNotEmpty;

  bool get canLoadGrid =>
      product != null && startDate != null && weekdaysChosen;

  bool get slotChosen => trainerId != null && slotStart != null;

  /// Re-plan already has a linked pair; only new couple sales need a partner.
  bool get partnerReady =>
      isReplan ||
      !isCoupleSelected ||
      (partner != null && partnerCheck is SellPtPartnerCheckOk);

  /// A re-plan is only submittable when the trainer, weekdays or hour differ
  /// from the existing subscription; otherwise there is nothing to apply.
  bool get replanChanged {
    final r = replanning;
    if (r == null) return true;
    final a = [...weekdays]..sort();
    final b = [...r.weekdays]..sort();
    final slot = slotStart;
    return trainerId != r.trainerId ||
        a.join(',') != b.join(',') ||
        (slot == null ? null : ptSlotKey(slot)) != ptSlotKey(r.slotStart);
  }

  /// Sale only: empty is fine; otherwise unsigned ≤2 decimals within 0..price.
  bool get discountInRange {
    if (isReplan) return true;
    final d = discount;
    if (d == null || d.isEmpty) return true;
    if (!_discountMoneyFormat.hasMatch(d)) return false;
    final cents = _moneyToCents(d);
    final priceCents = _moneyToCents(product?.basePrice ?? '');
    if (cents == null || priceCents == null) return false;
    return cents >= 0 && cents <= priceCents;
  }

  /// Sale only: price minus a valid discount; the full price while the
  /// discount is empty or invalid.
  String get payableAmount {
    final price = product?.basePrice ?? '';
    final priceCents = _moneyToCents(price);
    if (priceCents == null) return price;
    final d = discount;
    final cents = (d == null || !discountInRange) ? 0 : _moneyToCents(d) ?? 0;
    final net = priceCents - cents;
    return '${net ~/ 100}.${(net % 100).toString().padLeft(2, '0')}';
  }

  bool get canSubmit =>
      !submitting &&
      canLoadGrid &&
      slotChosen &&
      partnerReady &&
      (isReplan ? replanChanged : paymentMethodId != null && discountInRange);
}

final _discountMoneyFormat = RegExp(r'^\d+(\.\d{1,2})?$');

int? _moneyToCents(String raw) {
  if (!_discountMoneyFormat.hasMatch(raw)) return null;
  final parts = raw.split('.');
  final whole = int.tryParse(parts[0]);
  if (whole == null) return null;
  final frac = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
  final fracInt = int.tryParse(frac);
  if (fracInt == null) return null;
  return whole * 100 + fracInt;
}

/// Drives the "Add Personal Training" flow (package → weekdays → grid → pay)
/// and, with [SellPtCubit.initReplan], the mid-PT trainer/slot change.
@injectable
class SellPtCubit extends Cubit<SellPtState> {
  SellPtCubit(
    this._getProducts,
    this._getPaymentMethods,
    this._getGrid,
    this._purchase,
    this._replan, [
    this._getMember,
    this._getPtSummary,
  ]) : super(const SellPtState(memberId: 0));

  final GetPtProductsUseCase _getProducts;
  final GetPaymentMethodsUseCase _getPaymentMethods;
  final GetPtScheduleGridUseCase _getGrid;
  final PurchasePtUseCase _purchase;
  final ReplanPtUseCase _replan;
  final GetMemberUseCase? _getMember;
  final GetMemberPtSummaryUseCase? _getPtSummary;

  Future<void> Function()? _lastInit;

  /// One key per sale intent: a retry of an identical request (e.g. after a
  /// timeout) reuses it so the server replays the first result instead of
  /// rejecting the duplicate. Any change to the request mints a new key.
  PurchasePtParams? _lastPurchase;
  String? _purchaseKey;

  /// Re-runs whichever init (sell or re-plan) last started this cubit.
  Future<void> retry() => _lastInit?.call() ?? Future.value();

  Future<void> init(int memberId, {String? memberName}) async {
    _lastInit = () => init(memberId, memberName: memberName);
    emit(
      SellPtState(
        memberId: memberId,
        memberName: memberName,
        status: LoadStatus.loading,
        startDate: _today(),
      ),
    );
    final productsFuture = _getProducts(const NoParams());
    final methodsFuture = _getPaymentMethods(const NoParams());
    final memberFuture = _getMember?.call(memberId);

    final products = await productsFuture;
    final methods = await methodsFuture;
    final memberResult = memberFuture != null ? await memberFuture : null;

    if (isClosed) return;

    Person? person;
    String? resolvedName = memberName;
    if (memberResult != null) {
      memberResult.fold((_) => null, (p) {
        person = p;
        resolvedName ??= p.fullName;
      });
    }

    // A sale cannot proceed without payment methods, so a failed load is
    // surfaced (with retry) rather than shown as "none configured".
    final loadFailure = products.fold<Failure?>(
      (f) => f,
      (_) => methods.fold<Failure?>((f) => f, (_) => null),
    );
    if (loadFailure != null) {
      emit(state.copyWith(status: LoadStatus.failure, failure: loadFailure));
      return;
    }

    products.fold((_) => null, (items) {
      final active = items.where((p) => p.isActive).toList();
      final paymentMethods = methods.fold(
        (_) => <PaymentMethod>[],
        (m) => m.where((x) => x.isActive).toList(),
      );
      emit(
        state.copyWith(
          status: LoadStatus.success,
          products: active,
          paymentMethods: paymentMethods,
          paymentMethodId: paymentMethods.length == 1
              ? paymentMethods.first.id
              : null,
          member: person,
          memberName: resolvedName,
        ),
      );
    });
  }

  /// Re-plan an existing PT from [effectiveDate]; package and period are fixed,
  /// trainer / weekdays / hour can change.
  Future<void> initReplan(
    PtSubscription subscription,
    List<PtProduct> products, {
    String? memberName,
  }) async {
    _lastInit = () =>
        initReplan(subscription, products, memberName: memberName);
    var available = products;
    var product = available
        .where((p) => p.id == subscription.ptProductId)
        .firstOrNull;
    if (product == null) {
      // The caller's list may be empty (its fetch failed) or stale.
      emit(
        SellPtState(
          memberId: subscription.memberId,
          memberName: memberName,
          status: LoadStatus.loading,
          replanning: subscription,
        ),
      );
      final fetched = await _getProducts(const NoParams());
      if (isClosed) return;
      available = fetched.getOrElse((_) => available);
      product = available
          .where((p) => p.id == subscription.ptProductId)
          .firstOrNull;
      if (product == null) {
        emit(
          state.copyWith(
            status: LoadStatus.failure,
            failure: fetched.fold((f) => f, (_) => const NotFoundFailure()),
          ),
        );
        return;
      }
    }
    final today = _today();
    final effective = subscription.startDate.isAfter(today)
        ? subscription.startDate
        : today;
    emit(
      SellPtState(
        memberId: subscription.memberId,
        memberName: memberName,
        status: LoadStatus.success,
        replanning: subscription,
        products: available,
        product: product,
        startDate: effective,
        weekdays: [...subscription.weekdays],
        trainerId: subscription.trainerId,
        slotStart: subscription.slotStart,
      ),
    );
    if (_getMember != null) {
      final res = await _getMember(subscription.memberId);
      if (!isClosed) {
        res.fold(
          (_) => null,
          (p) => emit(
            state.copyWith(
              member: p,
              memberName: state.memberName ?? p.fullName,
            ),
          ),
        );
      }
    }
    await loadGrid();
  }

  void selectProduct(PtProduct product) {
    final typeChanged = state.product?.packageType != product.packageType;
    emit(
      state.copyWith(
        product: product,
        grid: null,
        trainerId: null,
        slotStart: null,
        partner: typeChanged ? null : state.partner,
        partnerCheck: typeChanged ? null : state.partnerCheck,
      ),
    );
    _maybeLoadGrid();
  }

  /// Sets the couple partner and checks open-PT eligibility.
  Future<void> selectPartner(Person? partner) async {
    if (partner == null) {
      emit(
        state.copyWith(
          partner: null,
          partnerCheck: null,
          grid: null,
          trainerId: null,
          slotStart: null,
        ),
      );
      _maybeLoadGrid();
      return;
    }
    if (partner.id == state.memberId) {
      emit(
        state.copyWith(
          partner: partner,
          partnerCheck: const SellPtPartnerCheckBlocked(
            PtStrings.partnerSameAsMember,
          ),
          grid: null,
          trainerId: null,
          slotStart: null,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        partner: partner,
        partnerCheck: const SellPtPartnerCheckLoading(),
        grid: null,
        trainerId: null,
        slotStart: null,
      ),
    );
    _maybeLoadGrid();

    final summaryFuture = _getPtSummary?.call(partner.id);
    final summaryResult = summaryFuture != null ? await summaryFuture : null;
    if (isClosed || state.partner?.id != partner.id) return;

    final blocked = _partnerBlockMessage(partner, summaryResult);
    emit(
      state.copyWith(
        partnerCheck: blocked == null
            ? const SellPtPartnerCheckOk()
            : SellPtPartnerCheckBlocked(blocked),
      ),
    );
  }

  /// A partner with an open PT blocks the sale. No membership check: PT
  /// includes a gym membership, so a partner without one is bundled one.
  String? _partnerBlockMessage(
    Person partner,
    Either<Failure, MemberPtSummary>? summaryResult,
  ) {
    if (summaryResult == null) return null;
    final open = summaryResult.fold<PtSubscription?>(
      (_) => null,
      (s) => s.current,
    );
    if (open == null) return null;
    final until = DateFormat('dd MMM').format(open.endDate);
    return PtStrings.partnerHasOpenPt(partner.fullName, until);
  }

  void setStartDate(DateTime date) {
    emit(
      state.copyWith(
        startDate: DateTime(date.year, date.month, date.day),
        grid: null,
        trainerId: null,
        slotStart: null,
      ),
    );
    _maybeLoadGrid();
  }

  void toggleWeekday(int day) {
    if (state.product == null) return;
    final days = [...state.weekdays];
    if (days.contains(day)) {
      days.remove(day);
    } else if (days.length < 7) {
      days.add(day);
    } else {
      return;
    }
    days.sort();
    emit(
      state.copyWith(
        weekdays: days,
        grid: null,
        trainerId: null,
        slotStart: null,
      ),
    );
    _maybeLoadGrid();
  }

  void _maybeLoadGrid() {
    if (state.canLoadGrid) loadGrid();
  }

  Future<void> loadGrid() async {
    if (!state.canLoadGrid) return;
    emit(state.copyWith(gridStatus: LoadStatus.loading, failure: null));
    final params = _gridParams();
    final result = await _getGrid(params);
    // The selection changed while this request was in flight: its grid belongs
    // to a different query, and a newer load (or none) is responsible now.
    if (isClosed || !state.canLoadGrid || params != _gridParams()) return;
    result.fold(
      (failure) => emit(
        state.copyWith(gridStatus: LoadStatus.failure, failure: failure),
      ),
      (grid) => emit(
        state.copyWith(
          gridStatus: LoadStatus.success,
          grid: grid,
          failure: null,
        ),
      ),
    );
  }

  GetPtScheduleGridParams _gridParams() => GetPtScheduleGridParams(
    memberId: state.memberId,
    ptProductId: state.product!.id,
    startDate: state.startDate!,
    weekdays: state.weekdays,
    partnerMemberId: state.isCoupleSelected ? state.partner?.id : null,
    excludeSubscriptionId: state.replanning?.id,
  );

  void selectSlot(int trainerId, String slotStart) {
    final cell = state.grid?.cell(trainerId, slotStart);
    if (cell == null || cell.status != PtGridCellStatus.free) return;
    emit(state.copyWith(trainerId: trainerId, slotStart: slotStart));
  }

  void setPaymentMethod(String? id) =>
      emit(state.copyWith(paymentMethodId: id));

  void setDiscount(String? value) => emit(
    state.copyWith(
      discount: (value == null || value.trim().isEmpty) ? null : value.trim(),
    ),
  );

  void setReason(String? value) => emit(
    state.copyWith(
      reason: (value == null || value.trim().isEmpty) ? null : value.trim(),
    ),
  );

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emit(state.copyWith(submitting: true, failure: null));
    final replanning = state.replanning;
    final Either<Failure, PtSubscription> result;
    try {
      result = replanning != null
          ? await _replan(
              ReplanPtParams(
                subscription: replanning,
                trainerId: state.trainerId!,
                weekdays: state.weekdays,
                slotStart: state.slotStart!,
                effectiveDate: state.startDate!,
                reason: state.reason,
              ),
            )
          : await _purchase(_purchaseParams());
    } catch (_) {
      // An unexpected throw must not leave the screen spinning forever.
      if (!isClosed) {
        emit(
          state.copyWith(submitting: false, failure: const UnknownFailure()),
        );
      }
      return;
    }
    if (isClosed) return;
    result.fold(
      (failure) => emit(state.copyWith(submitting: false, failure: failure)),
      (sub) => emit(state.copyWith(submitting: false, result: sub)),
    );
  }

  PurchasePtParams _purchaseParams() {
    final base = PurchasePtParams(
      memberId: state.memberId,
      ptProductId: state.product!.id,
      trainerId: state.trainerId!,
      startDate: state.startDate!,
      weekdays: state.weekdays,
      slotStart: state.slotStart!,
      payment: PtPayment(
        paymentMethodId: int.parse(state.paymentMethodId!),
        discountAmount: state.discount,
      ),
      partnerMemberId: state.isCoupleSelected ? state.partner?.id : null,
    );
    if (base != _lastPurchase || _purchaseKey == null) {
      _purchaseKey = newIdempotencyKey();
    }
    _lastPurchase = base;
    return PurchasePtParams(
      memberId: base.memberId,
      ptProductId: base.ptProductId,
      trainerId: base.trainerId,
      startDate: base.startDate,
      weekdays: base.weekdays,
      slotStart: base.slotStart,
      payment: base.payment,
      partnerMemberId: base.partnerMemberId,
      idempotencyKey: _purchaseKey,
    );
  }

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
