import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/usecases/get_membership_products_usecase.dart';
import '../../domain/usecases/get_membership_usecase.dart';
import '../../domain/usecases/renew_membership_usecase.dart';

part 'membership_renew_cubit.freezed.dart';

@freezed
abstract class MembershipRenewState with _$MembershipRenewState {
  const factory MembershipRenewState({
    @Default(LoadStatus.initial) LoadStatus status,
    Membership? membership,
    @Default(<MembershipProduct>[]) List<MembershipProduct> products,
    String? selectedProductId,
    @Default('') String reason,
    Failure? failure,
    @Default(false) bool isSubmitting,
    @Default(false) bool success,
    @Default(false) bool isConflict,
  }) = _MembershipRenewState;
}

@injectable
class MembershipRenewCubit extends Cubit<MembershipRenewState> {
  MembershipRenewCubit(
    this._getMembership,
    this._getProducts,
    this._renew,
  ) : super(const MembershipRenewState());

  final GetMembershipUseCase _getMembership;
  final GetMembershipProductsUseCase _getProducts;
  final RenewMembershipUseCase _renew;

  Future<void> load(String membershipId) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getMembership(membershipId);
    if (isClosed) return;

    await result.fold(
      (failure) async => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (membership) async {
        final productsResult = await _getProducts(const GetMembershipProductsParams());
        if (isClosed) return;
        productsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: LoadStatus.success,
              membership: membership,
              selectedProductId: membership.productId,
            ),
          ),
          (page) => emit(
            state.copyWith(
              status: LoadStatus.success,
              membership: membership,
              products: page.items,
              selectedProductId: membership.productId,
            ),
          ),
        );
      },
    );
  }

  void onProductChanged(String? productId) {
    emit(state.copyWith(selectedProductId: productId));
  }

  void onReasonChanged(String reason) {
    emit(state.copyWith(reason: reason));
  }

  Future<bool> submit() async {
    final membership = state.membership;
    if (membership == null || state.isSubmitting) return false;

    emit(state.copyWith(isSubmitting: true, failure: null, isConflict: false));

    final result = await _renew(
      MembershipActionParams(
        membershipId: membership.id,
        rowVersion: membership.rowVersion,
        productId: state.selectedProductId,
        reason: state.reason.trim().isEmpty ? null : state.reason.trim(),
      ),
    );

    if (isClosed) return false;

    return result.fold(
      (failure) {
        final isConflict = failure is ConflictFailure;
        emit(
          state.copyWith(
            isSubmitting: false,
            failure: failure,
            isConflict: isConflict,
          ),
        );
        if (isConflict) {
          load(membership.id);
        }
        return false;
      },
      (updatedMembership) {
        emit(
          state.copyWith(
            isSubmitting: false,
            success: true,
            membership: updatedMembership,
          ),
        );
        return true;
      },
    );
  }
}
