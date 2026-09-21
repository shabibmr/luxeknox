import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/diet_plan_version.dart';
import '../../domain/usecases/list_diet_plan_versions_usecase.dart';

sealed class DietPlanVersionsState extends Equatable {
  const DietPlanVersionsState();

  @override
  List<Object?> get props => [];
}

final class DietPlanVersionsLoading extends DietPlanVersionsState {
  const DietPlanVersionsLoading();
}

final class DietPlanVersionsLoaded extends DietPlanVersionsState {
  const DietPlanVersionsLoaded(this.versions, {this.expandedId});

  final List<DietPlanVersion> versions;
  final String? expandedId;

  @override
  List<Object?> get props => [versions, expandedId];
}

final class DietPlanVersionsFailure extends DietPlanVersionsState {
  const DietPlanVersionsFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class DietPlanVersionsCubit extends Cubit<DietPlanVersionsState> {
  DietPlanVersionsCubit(this._listVersions)
      : super(const DietPlanVersionsLoading());

  final ListDietPlanVersionsUseCase _listVersions;

  Future<void> load(String planId) async {
    emit(const DietPlanVersionsLoading());
    final result = await _listVersions(planId);
    result.fold(
      (failure) => emit(DietPlanVersionsFailure(failureMessage(failure))),
      (versions) => emit(DietPlanVersionsLoaded(versions)),
    );
  }

  void toggleExpanded(String versionId) {
    final current = state;
    if (current is! DietPlanVersionsLoaded) return;
    final next = current.expandedId == versionId ? null : versionId;
    emit(DietPlanVersionsLoaded(current.versions, expandedId: next));
  }
}
