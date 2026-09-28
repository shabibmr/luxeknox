import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/event_transformers.dart';
import '../../../../core/error/failure_messages.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../people/domain/entities/profile_summary.dart';
import '../../../people/domain/usecases/list_members_usecase.dart';
import '../../domain/entities/membership.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/usecases/create_membership_usecase.dart';
import '../../domain/usecases/get_membership_products_usecase.dart';

part 'create_membership_bloc.freezed.dart';

@freezed
abstract class CreateMembershipState with _$CreateMembershipState {
  const factory CreateMembershipState({
    @Default(LoadStatus.initial) LoadStatus status,
    Failure? failure,
    @Default(<MembershipProduct>[]) List<MembershipProduct> products,
    @Default(<ProfileSummary>[]) List<ProfileSummary> members,
    String? selectedMemberId,
    String? selectedProductId,
    DateTime? startDate,
    String? lockerNumber,
    @Default(false) bool autoRenew,
    @Default(false) bool submitting,
    String? fieldError,
    String? submitError,
    Membership? created,
  }) = _CreateMembershipState;
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
  const CreateMembershipMemberSelected(this.memberId);

  final String memberId;

  @override
  List<Object?> get props => [memberId];
}

final class CreateMembershipProductSelected extends CreateMembershipEvent {
  const CreateMembershipProductSelected(this.productId);

  final String productId;

  @override
  List<Object?> get props => [productId];
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

final class CreateMembershipSubmitted extends CreateMembershipEvent {
  const CreateMembershipSubmitted();
}

@injectable
class CreateMembershipBloc
    extends Bloc<CreateMembershipEvent, CreateMembershipState> {
  CreateMembershipBloc(
    this._createMembership,
    this._getProducts,
    this._listMembers,
  ) : super(const CreateMembershipState()) {
    on<CreateMembershipStarted>(_onStarted);
    on<CreateMembershipMemberSelected>(_onMemberSelected);
    on<CreateMembershipProductSelected>(_onProductSelected);
    on<CreateMembershipStartDateChanged>(_onStartDateChanged);
    on<CreateMembershipLockerChanged>(_onLockerChanged);
    on<CreateMembershipAutoRenewChanged>(_onAutoRenewChanged);
    on<CreateMembershipSubmitted>(
      _onSubmitted,
      transformer: droppable(),
    );
  }

  final CreateMembershipUseCase _createMembership;
  final GetMembershipProductsUseCase _getProducts;
  final ListMembersUseCase _listMembers;

  Future<void> _onStarted(
    CreateMembershipStarted event,
    Emitter<CreateMembershipState> emit,
  ) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        created: null,
      ),
    );

    final productsResult = await _getProducts(
      const GetMembershipProductsParams(),
    );
    if (isClosed) return;

    Failure? failure;
    List<MembershipProduct> products = const [];
    productsResult.fold((f) => failure = f, (page) => products = page.items);
    if (failure != null) {
      emit(state.copyWith(status: LoadStatus.failure, failure: failure));
      return;
    }

    List<ProfileSummary> members = state.members;
    if (event.memberId == null) {
      final membersResult = await _listMembers(const ListMembersParams());
      if (isClosed) return;
      membersResult.fold((f) => failure = f, (page) => members = page.items);
      if (failure != null) {
        emit(state.copyWith(status: LoadStatus.failure, failure: failure));
        return;
      }
    }

    final activeProducts = products.where((p) => p.isActive).toList();
    emit(
      state.copyWith(
        status: LoadStatus.success,
        failure: null,
        products: activeProducts.isEmpty ? products : activeProducts,
        members: members,
        selectedMemberId: event.memberId ?? state.selectedMemberId,
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
        selectedMemberId: event.memberId,
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
    emit(
      state.copyWith(
        selectedProductId: event.productId,
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

    final locker = state.lockerNumber?.trim();
    final params = CreateMembershipParams(
      memberId: memberId,
      productId: productId,
      startDate: startDate,
      lockerNumber: locker == null || locker.isEmpty ? null : locker,
      autoRenew: state.autoRenew,
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
  }
}
