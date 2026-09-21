import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/member_filter.dart';
import '../../domain/entities/profile_summary.dart';
import '../../domain/usecases/list_members_usecase.dart';

sealed class MembersDirectoryState extends Equatable {
  const MembersDirectoryState();

  @override
  List<Object?> get props => [];
}

final class MembersDirectoryLoading extends MembersDirectoryState {
  const MembersDirectoryLoading();
}

final class MembersDirectoryLoaded extends MembersDirectoryState {
  const MembersDirectoryLoaded({
    required this.items,
    required this.hasMore,
    this.nextCursor,
    this.query,
    this.loadingMore = false,
  });

  final List<ProfileSummary> items;
  final bool hasMore;
  final String? nextCursor;
  final String? query;
  final bool loadingMore;

  @override
  List<Object?> get props => [items, hasMore, nextCursor, query, loadingMore];
}

final class MembersDirectoryFailure extends MembersDirectoryState {
  const MembersDirectoryFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

@injectable
class MembersDirectoryCubit extends Cubit<MembersDirectoryState> {
  MembersDirectoryCubit(this._listMembers)
    : super(const MembersDirectoryLoading());

  final ListMembersUseCase _listMembers;
  String? _query;

  Future<void> load({String? query}) async {
    _query = query?.trim().isEmpty == true ? null : query?.trim();
    emit(const MembersDirectoryLoading());
    final result = await _listMembers(
      ListMembersParams(filter: MemberFilter(query: _query)),
    );
    result.fold(
      (failure) => emit(MembersDirectoryFailure(_message(failure))),
      (page) => emit(
        MembersDirectoryLoaded(
          items: page.items,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: _query,
        ),
      ),
    );
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! MembersDirectoryLoaded ||
        !current.hasMore ||
        current.loadingMore) {
      return;
    }
    emit(
      MembersDirectoryLoaded(
        items: current.items,
        hasMore: current.hasMore,
        nextCursor: current.nextCursor,
        query: current.query,
        loadingMore: true,
      ),
    );
    final result = await _listMembers(
      ListMembersParams(
        filter: MemberFilter(query: current.query),
        cursor: current.nextCursor,
      ),
    );
    result.fold(
      (failure) => emit(MembersDirectoryFailure(_message(failure))),
      (page) => emit(
        MembersDirectoryLoaded(
          items: [...current.items, ...page.items],
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: current.query,
        ),
      ),
    );
  }

  String _message(Failure failure) => failureMessage(failure);
}
