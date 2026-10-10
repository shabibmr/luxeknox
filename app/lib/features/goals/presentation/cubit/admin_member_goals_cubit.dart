import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/usecases/goals_usecases.dart';

part 'admin_member_goals_cubit.freezed.dart';

@freezed
abstract class AdminMemberGoalsState with _$AdminMemberGoalsState {
  const factory AdminMemberGoalsState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<MemberGoal>[]) List<MemberGoal> items,
    Failure? failure,
  }) = _AdminMemberGoalsState;
}

@injectable
class AdminMemberGoalsCubit extends Cubit<AdminMemberGoalsState> {
  AdminMemberGoalsCubit(this._listAllGoals)
    : super(const AdminMemberGoalsState());

  final ListAllGoalsUseCase _listAllGoals;

  Future<void> load({String? status}) async {
    emit(state.copyWith(status: LoadStatus.loading, failure: null));
    final result = await _listAllGoals(
      ListAllGoalsParams(status: status),
    );
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
