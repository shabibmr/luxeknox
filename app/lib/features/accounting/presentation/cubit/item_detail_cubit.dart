import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/item.dart';
import '../../domain/usecases/get_item_usecase.dart';

const Object _sentinel = Object();

/// [item] may be set while [status] is `failure`: the cached item stays
/// visible and [failure] drives an error banner.
class ItemDetailState extends Equatable {
  const ItemDetailState({
    this.status = LoadStatus.initial,
    this.item,
    this.failure,
  });

  final LoadStatus status;
  final Item? item;
  final Failure? failure;

  ItemDetailState copyWith({
    LoadStatus? status,
    Object? item = _sentinel,
    Object? failure = _sentinel,
  }) {
    return ItemDetailState(
      status: status ?? this.status,
      item: identical(item, _sentinel) ? this.item : item as Item?,
      failure:
          identical(failure, _sentinel) ? this.failure : failure as Failure?,
    );
  }

  @override
  List<Object?> get props => [status, item, failure];
}

@injectable
class ItemDetailCubit extends Cubit<ItemDetailState> {
  ItemDetailCubit(this._getItem) : super(const ItemDetailState());

  final GetItemUseCase _getItem;

  /// Emits [initialItem] at once (when given), then refreshes from the API.
  /// A failed refresh keeps the cached item and surfaces [ItemDetailState.failure].
  Future<void> load(int id, {Item? initialItem}) async {
    if (initialItem != null) {
      emit(
        ItemDetailState(status: LoadStatus.success, item: initialItem),
      );
    } else {
      emit(state.copyWith(status: LoadStatus.loading, failure: null));
    }

    final result = await _getItem(id);
    if (isClosed) return;

    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (item) => emit(
        ItemDetailState(status: LoadStatus.success, item: item),
      ),
    );
  }
}
