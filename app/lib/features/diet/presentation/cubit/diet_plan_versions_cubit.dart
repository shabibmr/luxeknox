import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/diet_plan_version.dart';
import '../../domain/usecases/list_diet_plan_versions_usecase.dart';

part 'diet_plan_versions_cubit.freezed.dart';

@freezed
abstract class DietPlanVersionsState with _$DietPlanVersionsState {
  const factory DietPlanVersionsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<DietPlanVersion>[]) List<DietPlanVersion> versions,
    String? expandedId,
    Failure? failure,
  }) = _DietPlanVersionsState;
}

@injectable
class DietPlanVersionsCubit extends Cubit<DietPlanVersionsState> {
  DietPlanVersionsCubit(this._listVersions) : super(const DietPlanVersionsState());

  final ListDietPlanVersionsUseCase _listVersions;

  Future<void> load(String planId) async {
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
      ),
    );
    final result = await _listVersions(planId);
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (versions) => emit(
        state.copyWith(
          status: LoadStatus.success,
          failure: null,
          versions: versions,
          expandedId: null,
        ),
      ),
    );
  }

  void toggleExpanded(String versionId) {
    if (state.status != LoadStatus.success && state.versions.isEmpty) return;
    final next = state.expandedId == versionId ? null : versionId;
    emit(state.copyWith(expandedId: next));
  }
}
