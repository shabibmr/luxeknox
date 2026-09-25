import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/usecases/create_membership_product_usecase.dart';
import '../../domain/usecases/update_membership_product_usecase.dart';

part 'membership_product_form_cubit.freezed.dart';

@freezed
abstract class MembershipProductFormState with _$MembershipProductFormState {
  const factory MembershipProductFormState({
    @Default(LoadStatus.initial) LoadStatus status,
    Failure? failure,
    MembershipProduct? saved,
  }) = _MembershipProductFormState;
}

@injectable
class MembershipProductFormCubit extends Cubit<MembershipProductFormState> {
  MembershipProductFormCubit(this._create, this._update)
    : super(const MembershipProductFormState());

  final CreateMembershipProductUseCase _create;
  final UpdateMembershipProductUseCase _update;

  Future<void> create(MembershipProduct product) =>
      _save(product, creating: true);

  Future<void> update(MembershipProduct product) =>
      _save(product, creating: false);

  /// Persists [product] with `isActive` forced off. There is no separate
  /// deactivate endpoint — this is `updateProduct`.
  Future<void> deactivate(MembershipProduct product) =>
      _save(product.copyWith(isActive: false), creating: false);

  Future<void> _save(
    MembershipProduct product, {
    required bool creating,
  }) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        saved: null,
      ),
    );
    final result = creating ? await _create(product) : await _update(product);
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          saved: null,
        ),
      ),
      (saved) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          saved: saved,
        ),
      ),
    );
  }
}
