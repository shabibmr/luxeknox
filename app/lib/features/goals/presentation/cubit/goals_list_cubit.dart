import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/member_goal.dart';
import '../../domain/usecases/goals_usecases.dart';

sealed class GoalsListState extends Equatable {
  const GoalsListState();

  @override
  List<Object?> get props => [];
}

final class GoalsListLoading extends GoalsListState {
  const GoalsListLoading();
}

final class GoalsListLoaded extends GoalsListState {
  const GoalsListLoaded(this.items);

  final List<MemberGoal> items;

  @override
  List<Object?> get props => [items];
}

final class GoalsListFailure extends GoalsListState {
  const GoalsListFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class GoalsListCubit extends Cubit<GoalsListState> {
  GoalsListCubit(this._listGoals) : super(const GoalsListLoading());

  final ListMemberGoalsUseCase _listGoals;

  Future<void> load(String memberId) async {
    emit(const GoalsListLoading());
    final result = await _listGoals(MemberIdParams(memberId));
    result.fold(
      (failure) => emit(GoalsListFailure(failureMessage(failure))),
      (page) => emit(GoalsListLoaded(page.items)),
    );
  }
}
