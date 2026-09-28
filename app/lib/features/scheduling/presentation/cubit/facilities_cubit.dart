import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/schedule_catalog.dart';
import '../../domain/usecases/catalog_usecases.dart';

part 'facilities_cubit.freezed.dart';

@freezed
abstract class FacilitiesState with _$FacilitiesState {
  const factory FacilitiesState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<FacilityInfo>[]) List<FacilityInfo> items,
    /// True after a successful list, so an empty catalog is still data.
    @Default(false) bool hasLoaded,
    @Default(false) bool creating,
    Failure? failure,
  }) = _FacilitiesState;
}

@injectable
class FacilitiesCubit extends Cubit<FacilitiesState> {
  FacilitiesCubit(this._list, this._create) : super(const FacilitiesState());

  final ListFacilitiesUseCase _list;
  final CreateFacilityUseCase _create;

  Future<void> load() async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        creating: false,
      ),
    );
    final result = await _list(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (items) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          items: items,
          hasLoaded: true,
          creating: false,
        ),
      ),
    );
  }

  Future<void> create({
    required String name,
    int? capacity,
    String? locationDetails,
  }) async {
    if (!state.hasLoaded || state.creating) return;
    final items = state.items;
    emit(
      state.copyWith(
        creating: true,
        failure: null,
        status: LoadStatus.success,
      ),
    );
    final result = await _create(
      CreateFacilityParams(
        name: name,
        capacity: capacity,
        locationDetails: locationDetails,
        isActive: true,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          creating: false,
          items: items,
        ),
      ),
      (_) => load(),
    );
  }
}
