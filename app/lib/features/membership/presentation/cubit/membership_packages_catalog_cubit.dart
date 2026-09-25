import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership_product.dart';
import '../../domain/usecases/get_membership_products_usecase.dart';

part 'membership_packages_catalog_cubit.freezed.dart';

@freezed
abstract class MembershipPackagesCatalogState
    with _$MembershipPackagesCatalogState {
  const factory MembershipPackagesCatalogState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MembershipProduct>[]) List<MembershipProduct> items,
    Failure? failure,
  }) = _MembershipPackagesCatalogState;
}

@injectable
class MembershipPackagesCatalogCubit
    extends Cubit<MembershipPackagesCatalogState> {
  MembershipPackagesCatalogCubit(this._getProducts)
    : super(const MembershipPackagesCatalogState());

  final GetMembershipProductsUseCase _getProducts;

  Future<void> load() async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _getProducts(const GetMembershipProductsParams());
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          items: page.items,
        ),
      ),
    );
  }
}
