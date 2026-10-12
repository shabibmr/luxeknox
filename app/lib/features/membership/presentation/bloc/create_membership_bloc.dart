import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/event_transformers.dart';
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

part 'create_membership_bloc.freezed.dart';

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
  }) = _CreateMembershipState;

  const CreateMembershipState._();

  MembershipProduct? get selectedProduct {
    for (final p in products) {
      if (p.id == selectedProductId) return p;
    }
    return null;
  }

  bool get isCoupleSelected => selectedProduct?.isCouple ?? false;
}

sealed class CreateMembershipEvent extends Equatable {
  const CreateMembershipEvent();

  @override
  List<Object?> get props => [];
}

final class CreateMembershipStarted extends CreateMembershipEvent {
  const CreateMembershipStarted({this.memberId});

  final String? memberId;

  @override
  List<Object?> get props => [memberId];
}

final class CreateMembershipMemberSelected extends CreateMembershipEvent {
  const CreateMembershipMemberSelected(this.member);

  final ProfileSummary member;

  @override
  List<Object?> get props => [member];
}

final class CreateMembershipProductSelected extends CreateMembershipEvent {
  const CreateMembershipProductSelected(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
}

final class CreateMembershipPaymentMethodSelected
    extends CreateMembershipEvent {
  const CreateMembershipPaymentMethodSelected(this.paymentMethodId);

  final String paymentMethodId;

  @override
  List<Object?> get props => [paymentMethodId];
}

final class CreateMembershipStartDateChanged extends CreateMembershipEvent {
  const CreateMembershipStartDateChanged(this.startDate);

  final DateTime startDate;

  @override
  List<Object?> get props => [startDate];
}

final class CreateMembershipLockerChanged extends CreateMembershipEvent {
  const CreateMembershipLockerChanged(this.lockerNumber);

  final String lockerNumber;

  @override
  List<Object?> get props => [lockerNumber];
}

final class CreateMembershipAutoRenewChanged extends CreateMembershipEvent {
  const CreateMembershipAutoRenewChanged(this.autoRenew);

  final bool autoRenew;

  @override
  List<Object?> get props => [autoRenew];
}

final class CreateMembershipPartnerSelected extends CreateMembershipEvent {
  const CreateMembershipPartnerSelected(this.partner);

  final ProfileSummary partner;

  @override
  List<Object?> get props => [partner];
}

/// Answer to the replace dialog. `false` clears the partner.
final class CreateMembershipReplaceConfirmed extends CreateMembershipEvent {
  const CreateMembershipReplaceConfirmed(this.confirmed);

  final bool confirmed;

  @override
  List<Object?> get props => [confirmed];
}

final class CreateMembershipDiscountChanged extends CreateMembershipEvent {
  const CreateMembershipDiscountChanged(this.discountAmount);

  final String discountAmount;

  @override
  List<Object?> get props => [discountAmount];
}

final class CreateMembershipSubmitted extends CreateMembershipEvent {
  const CreateMembershipSubmitted();
}

@injectable
class CreateMembershipBloc
    extends Bloc<CreateMembershipEvent, CreateMembershipState> {
  CreateMembershipBloc(
    this._createMembership,
    this._getProducts,
    this._getPaymentMethods,
    this._getReplacementPreview,
  ) : super(const CreateMembershipState()) {
    on<CreateMembershipStarted>(_onStarted);
    on<CreateMembershipMemberSelected>(_onMemberSelected);
    on<CreateMembershipProductSelected>(_onProductSelected);
    on<CreateMembershipPaymentMethodSelected>(_onPaymentMethodSelected);
    on<CreateMembershipStartDateChanged>(_onStartDateChanged);
    on<CreateMembershipLockerChanged>(_onLockerChanged);
    on<CreateMembershipAutoRenewChanged>(_onAutoRenewChanged);
    on<CreateMembershipPartnerSelected>(_onPartnerSelected);
    on<CreateMembershipReplaceConfirmed>(_onReplaceConfirmed);
    on<CreateMembershipDiscountChanged>(_onDiscountChanged);
    on<CreateMembershipSubmitted>(_onSubmitted, transformer: droppable());
  }

  final CreateMembershipUseCase _createMembership;
  final GetMembershipProductsUseCase _getProducts;
  final GetPaymentMethodsUseCase _getPaymentMethods;
  final GetReplacementPreviewUseCase _getReplacementPreview;

  Future<void> _onStarted(
    CreateMembershipStarted event,
    Emitter<CreateMembershipState> emit,
  ) async {
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
        selectedMemberId: event.memberId ?? state.selectedMemberId,
        selectedMember: event.memberId != null ? null : state.selectedMember,
        startDate: state.startDate ?? DateTime.now(),
      ),
    );
  }

  void _onMemberSelected(
    CreateMembershipMemberSelected event,
    Emitter<CreateMembershipState> emit,
  ) {
    if (state.submitting) return;
    emit(
      state.copyWith(
        selectedMember: event.member,
        selectedMemberId: event.member.id.toString(),
        fieldError: null,
        submitError: null,
      ),
    );
  }

  void _onProductSelected(
    CreateMembershipProductSelected event,
    Emitter<CreateMembershipState> emit,
  ) {
    if (state.submitting) return;
    final wasCouple = state.isCoupleSelected;
    final next = state.copyWith(
      selectedProductId: event.productId,
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

  Future<void> _onPartnerSelected(
    CreateMembershipPartnerSelected event,
    Emitter<CreateMembershipState> emit,
  ) async {
    if (state.submitting) return;
    final partner = event.partner;
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

  void _onReplaceConfirmed(
    CreateMembershipReplaceConfirmed event,
    Emitter<CreateMembershipState> emit,
  ) {
    if (state.submitting || state.partnerReplacement == null) return;
    if (event.confirmed) {
      emit(state.copyWith(replaceConfirmed: true, fieldError: null));
      return;
    }
    emit(_clearPartner(state).copyWith(fieldError: null));
  }

  void _onDiscountChanged(
    CreateMembershipDiscountChanged event,
    Emitter<CreateMembershipState> emit,
  ) {
    if (state.submitting) return;
    final value = event.discountAmount.trim();
    emit(
      state.copyWith(
        discountAmount: value.isEmpty ? null : value,
        fieldError: null,
      ),
    );
  }

  void _onPaymentMethodSelected(
    CreateMembershipPaymentMethodSelected event,
    Emitter<CreateMembershipState> emit,
  ) {
    if (state.submitting) return;
    emit(
      state.copyWith(
        selectedPaymentMethodId: event.paymentMethodId,
        fieldError: null,
        submitError: null,
      ),
    );
  }

  void _onStartDateChanged(
    CreateMembershipStartDateChanged event,
    Emitter<CreateMembershipState> emit,
  ) {
    if (state.submitting) return;
    emit(state.copyWith(startDate: event.startDate, fieldError: null));
  }

  void _onLockerChanged(
    CreateMembershipLockerChanged event,
    Emitter<CreateMembershipState> emit,
  ) {
    if (state.submitting) return;
    emit(state.copyWith(lockerNumber: event.lockerNumber));
  }

  void _onAutoRenewChanged(
    CreateMembershipAutoRenewChanged event,
    Emitter<CreateMembershipState> emit,
  ) {
    if (state.submitting) return;
    emit(state.copyWith(autoRenew: event.autoRenew));
  }

  Future<void> _onSubmitted(
    CreateMembershipSubmitted event,
    Emitter<CreateMembershipState> emit,
  ) async {
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
          state.copyWith(fieldError: 'Select a partner for the couple package'),
        );
        return;
      }
      if (partner.id.toString() == memberId) {
        emit(state.copyWith(fieldError: 'Partner must be a different member'));
        return;
      }
      if (preview != null && preview.isCouple) {
        emit(
          state.copyWith(fieldError: 'Partner already has a couple membership'),
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
      if (discount != null && !_discountInRange(discount)) {
        emit(
          state.copyWith(
            fieldError: 'Discount must be between 0 and the package price',
          ),
        );
        return;
      }
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
      discountAmount: isCouple ? discount : null,
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
        state.copyWith(submitting: false, submitError: failureMessage(failure)),
      ),
      (membership) => emit(
        state.copyWith(
          submitting: false,
          submitError: null,
          created: membership,
        ),
      ),
    );
  }

  static final _moneyFormat = RegExp(r'^\d+(\.\d+)?$');

  /// 0 <= discount <= package price. Parsed only to compare; the string is
  /// what gets sent (FR-API-005).
  bool _discountInRange(String discount) {
    // double.tryParse also accepts "1e2" and "+5", which the API rejects.
    if (!_moneyFormat.hasMatch(discount)) return false;
    final value = double.tryParse(discount);
    final price = double.tryParse(state.selectedProduct?.basePrice ?? '');
    if (value == null || price == null) return false;
    return value >= 0 && value <= price;
  }
}
