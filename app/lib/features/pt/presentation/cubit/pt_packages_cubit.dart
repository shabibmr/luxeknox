import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/pt_product.dart';
import '../../domain/usecases/pt_usecases.dart';

part 'pt_packages_cubit.freezed.dart';

@freezed
abstract class PtPackagesState with _$PtPackagesState {
  const factory PtPackagesState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<PtProduct>[]) List<PtProduct> items,
    @Default(false) bool saving,
    String? message,
    Failure? failure,
  }) = _PtPackagesState;
}

/// Admin catalog of Personal Training packages (list + create/edit/archive).
@injectable
class PtPackagesCubit extends Cubit<PtPackagesState> {
  PtPackagesCubit(this._getProducts, this._saveProduct)
    : super(const PtPackagesState());

  final GetPtProductsUseCase _getProducts;
  final SavePtProductUseCase _saveProduct;

  Future<void> load() async {
    emit(
      state.copyWith(status: LoadStatus.loading, failure: null, message: null),
    );
    final result = await _getProducts(const NoParams());
    if (isClosed) return;
    result.fold(
      (failure) =>
          emit(state.copyWith(status: LoadStatus.failure, failure: failure)),
      (items) => emit(state.copyWith(status: LoadStatus.success, items: items)),
    );
  }

  /// Returns true on success so the form can close.
  Future<bool> save(PtProduct product) async {
    emit(state.copyWith(saving: true, failure: null, message: null));
    final result = await _saveProduct(product);
    if (isClosed) return false;
    return result.fold(
      (failure) {
        emit(state.copyWith(saving: false, failure: failure));
        return false;
      },
      (saved) {
        final items = [
          for (final p in state.items)
            if (p.id != saved.id) p,
          saved,
        ]..sort((a, b) => a.name.compareTo(b.name));
        emit(state.copyWith(saving: false, items: items, message: 'saved'));
        return true;
      },
    );
  }

  Future<void> setActive(PtProduct product, bool active) =>
      save(product.copyWith(isActive: active));
}
