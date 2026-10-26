import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../payments/domain/entities/payment_method.dart';
import '../../../payments/domain/usecases/get_payment_methods_usecase.dart';
import '../../../people/domain/entities/profile_summary.dart';
import '../../domain/entities/membership.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/entities/membership_replacement_preview.dart';
import '../../domain/usecases/create_membership_usecase.dart';
import '../../domain/usecases/get_membership_products_usecase.dart';
import '../../domain/usecases/get_replacement_preview_usecase.dart';

part 'create_membership_cubit.freezed.dart';

@freezed
abstract class CreateMembershipState with _$CreateMembershipState {
  const factory CreateMembershipState({
    @Default(LoadStatus.initial) LoadStatus status,
    Failure? failure,
    @Default(<MembershipProduct>[]) List<MembershipProduct> products,
    @Default(<PaymentMethod>[]) List<PaymentMethod> paymentMethods,
    ProfileSummary? selectedMember,
    String? selectedMemberId,
    String? selectedProductId,
    String? selectedPaymentMethodId,
    DateTime? startDate,
    String? lockerNumber,
    @Default(false) bool autoRenew,
    @Default(false) bool submitting,
    String? fieldError,
    String? submitError,
    Membership? created,

    /// Couple packages only: the second member being sold the package.
    ProfileSummary? selectedPartner,

    /// What selling the couple package would replace for the partner; null
    /// when the partner has nothing to replace.
    MembershipReplacementPreview? partnerReplacement,
    @Default(false) bool replaceConfirmed,
    @Default(false) bool checkingPartner,

    /// "Discount for remaining days" as a decimal string (FR-API-005),
    /// pre-filled from [MembershipReplacementPreview.suggestedCredit].
    String? discountAmount,

    /// Day the money was received; defaults to today.
    DateTime? paymentDate,
  }) = _CreateMembershipState;

  const CreateMembershipState._();

  MembershipProduct? get selectedProduct {
    for (final p in products) {
      if (p.id == selectedProductId) return p;
    }
    return null;
  }

  /// Same rule as the API: start date plus the package duration.
  DateTime? get endDate {
    final start = startDate;
    final product = selectedProduct;
    if (start == null || product == null) return null;
    return DateTime(start.year, start.month, start.day + product.durationDays);
  }

  bool get isCoupleSelected => selectedProduct?.isCouple ?? false;
}

@injectable
class CreateMembershipCubit extends Cubit<CreateMembershipState> {
  CreateMembershipCubit(
    this._createMembership,
    this._getProducts,
    this._getPaymentMethods,
    this._getReplacementPreview,
  ) : super(const CreateMembershipState());

  final CreateMembershipUseCase _createMembership;
  final GetMembershipProductsUseCase _getProducts;
  final GetPaymentMethodsUseCase _getPaymentMethods;
  final GetReplacementPreviewUseCase _getReplacementPreview;

  /// Set for the whole [submitted] call so a second submit is ignored
  /// while one is running (the old droppable event).
  var _submitInFlight = false;

  Future<void> started({String? memberId}) async {
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, created: null),
    );

    final productsFuture = _getProducts(const GetMembershipProductsParams());
    final methodsFuture = _getPaymentMethods(const NoParams());
    final productsResult = await productsFuture;
    final methodsResult = await methodsFuture;
    if (isClosed) return;

    Failure? failure;
    List<MembershipProduct> products = const [];
    productsResult.fold((f) => failure = f, (page) => products = page.items);
    if (failure != null) {
      emit(state.copyWith(status: LoadStatus.failure, failure: failure));
      return;
    }

    List<PaymentMethod> paymentMethods = const [];
    methodsResult.fold((f) => failure = f, (items) {
      paymentMethods = items.where((m) => m.isActive).toList();
    });
    if (failure != null) {
      emit(state.copyWith(status: LoadStatus.failure, failure: failure));
      return;
    }

    final activeProducts = products.where((p) => p.isActive).toList();
    emit(
      state.copyWith(
        status: LoadStatus.success,
        failure: null,
        products: activeProducts.isEmpty ? products : activeProducts,
        paymentMethods: paymentMethods,
        selectedPaymentMethodId: paymentMethods.length == 1
            ? paymentMethods.first.id
            : state.selectedPaymentMethodId,
        selectedMemberId: memberId ?? state.selectedMemberId,
        selectedMember: memberId != null ? null : state.selectedMember,
        startDate: state.startDate ?? DateTime.now(),
        paymentDate: state.paymentDate ?? DateTime.now(),
      ),
    );
  }

  void memberSelected(ProfileSummary member) {
    if (state.submitting) return;
    emit(
      state.copyWith(
        selectedMember: member,
        selectedMemberId: member.id.toString(),
        fieldError: null,
        submitError: null,
      ),
    );
  }

  void productSelected(String productId) {
    if (state.submitting) return;
    final wasCouple = state.isCoupleSelected;
    final next = state.copyWith(
      selectedProductId: productId,
      fieldError: null,
      submitError: null,
    );
    // The partner, the replacement preview and the discount only make sense
    // for the package type they were picked under.
    emit(next.isCoupleSelected == wasCouple ? next : _clearPartner(next));
  }

  /// Drops the partner and everything derived from it (preview, confirmation,
  /// discount).
  CreateMembershipState _clearPartner(CreateMembershipState s) => s.copyWith(
    selectedPartner: null,
    partnerReplacement: null,
    replaceConfirmed: false,
    checkingPartner: false,
    discountAmount: null,
  );

  Future<void> partnerSelected(ProfileSummary partner) async {
    if (state.submitting) return;
    emit(
      _clearPartner(state).copyWith(
        selectedPartner: partner,
        checkingPartner: true,
        fieldError: null,
        submitError: null,
      ),
    );

    final result = await _getReplacementPreview(partner.id.toString());
    if (isClosed) return;
    // The partner was changed or cleared while the preview was loading.
    if (state.selectedPartner?.id != partner.id) return;

    result.fold(
      (failure) => emit(
        _clearPartner(state).copyWith(submitError: failureMessage(failure)),
      ),
      (preview) => emit(
        state.copyWith(
          partnerReplacement: preview,
          checkingPartner: false,
          discountAmount: preview?.suggestedCredit,
        ),
      ),
    );
  }

  void replaceConfirmed(bool confirmed) {
    if (state.submitting || state.partnerReplacement == null) return;
    if (confirmed) {
      emit(state.copyWith(replaceConfirmed: true, fieldError: null));
      return;
    }
    emit(_clearPartner(state).copyWith(fieldError: null));
  }

  void discountChanged(String discountAmount) {
    if (state.submitting) return;
    final value = discountAmount.trim();
    emit(
      state.copyWith(
        discountAmount: value.isEmpty ? null : value,
        fieldError: null,
      ),
    );
  }

  void paymentDateChanged(DateTime paymentDate) {
    if (state.submitting) return;
    // A sale recorded for an earlier day starts then; start date can still be adjusted after.
    emit(
      state.copyWith(
        paymentDate: paymentDate,
        startDate: paymentDate,
        fieldError: null,
      ),
    );
  }

  void paymentMethodSelected(String paymentMethodId) {
    if (state.submitting) return;
    emit(
      state.copyWith(
        selectedPaymentMethodId: paymentMethodId,
        fieldError: null,
        submitError: null,
      ),
    );
  }

  void startDateChanged(DateTime startDate) {
    if (state.submitting) return;
    emit(state.copyWith(startDate: startDate, fieldError: null));
  }

  void lockerChanged(String lockerNumber) {
    if (state.submitting) return;
    emit(state.copyWith(lockerNumber: lockerNumber));
  }

  void autoRenewChanged(bool autoRenew) {
    if (state.submitting) return;
    emit(state.copyWith(autoRenew: autoRenew));
  }

  Future<void> submitted() async {
    if (_submitInFlight) return;
    _submitInFlight = true;
    try {
      final memberId = state.selectedMemberId;
      final productId = state.selectedProductId;
      final paymentMethodId = state.selectedPaymentMethodId;
      final startDate = state.startDate;
      if (memberId == null || memberId.isEmpty) {
        emit(state.copyWith(fieldError: 'Select a member'));
        return;
      }
      if (productId == null || productId.isEmpty) {
        emit(state.copyWith(fieldError: 'Select a package'));
        return;
      }
      if (startDate == null) {
        emit(state.copyWith(fieldError: 'Pick a start date'));
        return;
      }
      if (paymentMethodId == null || paymentMethodId.isEmpty) {
        emit(state.copyWith(fieldError: 'Select a payment method'));
        return;
      }

      final isCouple = state.isCoupleSelected;
      final partner = state.selectedPartner;
      final preview = state.partnerReplacement;
      final discount = state.discountAmount;
      if (isCouple) {
        if (state.checkingPartner) {
          emit(state.copyWith(fieldError: "Checking the partner's membership"));
          return;
        }
        if (partner == null) {
          emit(
            state.copyWith(
              fieldError: 'Select a partner for the couple package',
            ),
          );
          return;
        }
        if (partner.id.toString() == memberId) {
          emit(
            state.copyWith(fieldError: 'Partner must be a different member'),
          );
          return;
        }
        if (preview != null && preview.isCouple) {
          emit(
            state.copyWith(
              fieldError: 'Partner already has a couple membership',
            ),
          );
          return;
        }
        if (preview != null && !state.replaceConfirmed) {
          emit(
            state.copyWith(
              fieldError: "Confirm replacing the partner's current membership",
            ),
          );
          return;
        }
      }
      if (discount != null && !_discountInRange(discount)) {
        emit(
          state.copyWith(
            fieldError: 'Discount must be between 0 and the package price',
          ),
        );
        return;
      }

      final locker = state.lockerNumber?.trim();
      final params = CreateMembershipParams(
        memberId: memberId,
        productId: productId,
        startDate: startDate,
        paymentMethodId: paymentMethodId,
        lockerNumber: locker == null || locker.isEmpty ? null : locker,
        autoRenew: state.autoRenew,
        partnerMemberId: isCouple ? partner!.id.toString() : null,
        replacePartnerMembership: isCouple && preview != null ? true : null,
        discountAmount: discount,
        paymentDate: state.paymentDate,
      );

      emit(
        state.copyWith(
          submitting: true,
          fieldError: null,
          submitError: null,
          created: null,
        ),
      );
      final result = await _createMembership(params);
      if (isClosed) return;
      result.fold(
        (failure) => emit(
          state.copyWith(
            submitting: false,
            submitError: failureMessage(failure),
          ),
        ),
        (membership) => emit(
          state.copyWith(
            submitting: false,
            submitError: null,
            created: membership,
          ),
        ),
      );
    } finally {
      _submitInFlight = false;
    }
  }

  static final _moneyFormat = RegExp(r'^\d+(\.\d{1,2})?$');

  /// 0 <= discount <= package price, compared in integer cents. The string is
  /// what gets sent (FR-API-005).
  bool _discountInRange(String discount) {
    if (!_moneyFormat.hasMatch(discount)) return false;
    final value = _toCents(discount);
    final price = _toCents(state.selectedProduct?.basePrice ?? '');
    if (value == null || price == null) return false;
    return value >= 0 && value <= price;
  }

  static int? _toCents(String raw) {
    if (!_moneyFormat.hasMatch(raw)) return null;
    final parts = raw.split('.');
    final whole = int.tryParse(parts[0]);
    if (whole == null) return null;
    final frac = parts.length > 1 ? parts[1].padRight(2, '0') : '00';
    final fracInt = int.tryParse(frac);
    if (fracInt == null) return null;
    return whole * 100 + fracInt;
  }
}
