import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../people/domain/entities/profile_summary.dart';
import '../../../people/domain/usecases/list_members_usecase.dart';
import '../../domain/entities/membership.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/usecases/create_membership_usecase.dart';
import '../../domain/usecases/get_membership_products_usecase.dart';

sealed class CreateMembershipState extends Equatable {
  const CreateMembershipState();

  @override
  List<Object?> get props => [];
}

final class CreateMembershipLoadingCatalog extends CreateMembershipState {
  const CreateMembershipLoadingCatalog();
}

final class CreateMembershipFormState extends CreateMembershipState {
  const CreateMembershipFormState({
    required this.products,
    this.members = const [],
    this.selectedMemberId,
    this.selectedProductId,
    this.startDate,
    this.lockerNumber,
    this.autoRenew = false,
    this.submitting = false,
    this.fieldError,
    this.submitError,
    this.created,
  });

  final List<MembershipProduct> products;
  final List<ProfileSummary> members;
  final String? selectedMemberId;
  final String? selectedProductId;
  final DateTime? startDate;
  final String? lockerNumber;
  final bool autoRenew;
  final bool submitting;
  final String? fieldError;
  final String? submitError;
  final Membership? created;

  CreateMembershipFormState copyWith({
    List<MembershipProduct>? products,
    List<ProfileSummary>? members,
    String? selectedMemberId,
    String? selectedProductId,
    DateTime? startDate,
    String? lockerNumber,
    bool? autoRenew,
    bool? submitting,
    String? fieldError,
    String? submitError,
    Membership? created,
    bool clearFieldError = false,
    bool clearSubmitError = false,
    bool clearCreated = false,
  }) {
    return CreateMembershipFormState(
      products: products ?? this.products,
      members: members ?? this.members,
      selectedMemberId: selectedMemberId ?? this.selectedMemberId,
      selectedProductId: selectedProductId ?? this.selectedProductId,
      startDate: startDate ?? this.startDate,
      lockerNumber: lockerNumber ?? this.lockerNumber,
      autoRenew: autoRenew ?? this.autoRenew,
      submitting: submitting ?? this.submitting,
      fieldError: clearFieldError ? null : (fieldError ?? this.fieldError),
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      created: clearCreated ? null : (created ?? this.created),
    );
  }

  @override
  List<Object?> get props => [
    products,
    members,
    selectedMemberId,
    selectedProductId,
    startDate,
    lockerNumber,
    autoRenew,
    submitting,
    fieldError,
    submitError,
    created,
  ];
}

final class CreateMembershipBootstrapFailure extends CreateMembershipState {
  const CreateMembershipBootstrapFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class CreateMembershipCubit extends Cubit<CreateMembershipState> {
  CreateMembershipCubit(
    this._createMembership,
    this._getProducts,
    this._listMembers,
  ) : super(const CreateMembershipLoadingCatalog());

  final CreateMembershipUseCase _createMembership;
  final GetMembershipProductsUseCase _getProducts;
  final ListMembersUseCase _listMembers;

  String? _presetMemberId;

  Future<void> bootstrap({String? memberId}) async {
    _presetMemberId = memberId;
    emit(const CreateMembershipLoadingCatalog());
    final productsResult = await _getProducts(
      const GetMembershipProductsParams(),
    );
    final membersResult = memberId == null
        ? await _listMembers(const ListMembersParams())
        : null;

    Failure? bootstrapFailure;
    List<MembershipProduct> products = const [];
    List<ProfileSummary> members = const [];

    productsResult.fold(
      (f) => bootstrapFailure = f,
      (page) => products = page.items,
    );
    if (bootstrapFailure != null) {
      emit(CreateMembershipBootstrapFailure(failureMessage(bootstrapFailure!)));
      return;
    }
    if (membersResult != null) {
      membersResult.fold(
        (f) => bootstrapFailure = f,
        (page) => members = page.items,
      );
      if (bootstrapFailure != null) {
        emit(
          CreateMembershipBootstrapFailure(failureMessage(bootstrapFailure!)),
        );
        return;
      }
    }

    final activeProducts = products.where((p) => p.isActive).toList();
    emit(
      CreateMembershipFormState(
        products: activeProducts.isEmpty ? products : activeProducts,
        members: members,
        selectedMemberId: memberId,
        startDate: DateTime.now(),
      ),
    );
  }

  void selectMember(String memberId) {
    final current = state;
    if (current is! CreateMembershipFormState || current.submitting) return;
    emit(
      current.copyWith(
        selectedMemberId: memberId,
        clearFieldError: true,
        clearSubmitError: true,
      ),
    );
  }

  void selectProduct(String productId) {
    final current = state;
    if (current is! CreateMembershipFormState || current.submitting) return;
    emit(
      current.copyWith(
        selectedProductId: productId,
        clearFieldError: true,
        clearSubmitError: true,
      ),
    );
  }

  void setStartDate(DateTime date) {
    final current = state;
    if (current is! CreateMembershipFormState || current.submitting) return;
    emit(current.copyWith(startDate: date, clearFieldError: true));
  }

  void setLockerNumber(String? value) {
    final current = state;
    if (current is! CreateMembershipFormState || current.submitting) return;
    emit(current.copyWith(lockerNumber: value));
  }

  void setAutoRenew(bool value) {
    final current = state;
    if (current is! CreateMembershipFormState || current.submitting) return;
    emit(current.copyWith(autoRenew: value));
  }

  Future<void> submit() async {
    final current = state;
    if (current is! CreateMembershipFormState || current.submitting) return;

    final memberId = current.selectedMemberId ?? _presetMemberId;
    final productId = current.selectedProductId;
    final startDate = current.startDate;
    if (memberId == null || memberId.isEmpty) {
      emit(current.copyWith(fieldError: 'Select a member'));
      return;
    }
    if (productId == null || productId.isEmpty) {
      emit(current.copyWith(fieldError: 'Select a package'));
      return;
    }
    if (startDate == null) {
      emit(current.copyWith(fieldError: 'Pick a start date'));
      return;
    }

    emit(
      current.copyWith(
        submitting: true,
        clearFieldError: true,
        clearSubmitError: true,
      ),
    );
    final result = await _createMembership(
      CreateMembershipParams(
        memberId: memberId,
        productId: productId,
        startDate: startDate,
        lockerNumber: current.lockerNumber?.trim().isEmpty == true
            ? null
            : current.lockerNumber?.trim(),
        autoRenew: current.autoRenew,
      ),
    );
    result.fold(
      (failure) => emit(
        current.copyWith(
          submitting: false,
          submitError: failureMessage(failure),
        ),
      ),
      (membership) => emit(
        current.copyWith(submitting: false, created: membership),
      ),
    );
  }
}
