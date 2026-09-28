import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/bloc/event_transformers.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/member_filter.dart';
import '../../domain/entities/profile_summary.dart';
import '../../domain/usecases/list_members_usecase.dart';

part 'members_directory_bloc.freezed.dart';

sealed class MembersDirectoryEvent extends Equatable {
  const MembersDirectoryEvent();

  @override
  List<Object?> get props => [];
}

final class MembersDirectoryStarted extends MembersDirectoryEvent {
  const MembersDirectoryStarted();
}

final class MembersDirectoryQueryChanged extends MembersDirectoryEvent {
  const MembersDirectoryQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class MembersDirectoryLoadMoreRequested extends MembersDirectoryEvent {
  const MembersDirectoryLoadMoreRequested();
}

@freezed
abstract class MembersDirectoryState with _$MembersDirectoryState {
  const factory MembersDirectoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<ProfileSummary>[]) List<ProfileSummary> items,
    @Default(false) bool hasMore,
    String? nextCursor,
    String? query,
    @Default(false) bool loadingMore,
    Failure? failure,
  }) = _MembersDirectoryState;
}

@injectable
class MembersDirectoryBloc
    extends Bloc<MembersDirectoryEvent, MembersDirectoryState> {
  MembersDirectoryBloc(this._listMembers)
    : super(const MembersDirectoryState()) {
    on<MembersDirectoryStarted>(_onStarted);
    on<MembersDirectoryQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
    on<MembersDirectoryLoadMoreRequested>(_onLoadMore);
  }

  final ListMembersUseCase _listMembers;

  Future<void> _onStarted(
    MembersDirectoryStarted event,
    Emitter<MembersDirectoryState> emit,
  ) async {
    await _fetch(emit, query: state.query, append: false);
  }

  Future<void> _onQueryChanged(
    MembersDirectoryQueryChanged event,
    Emitter<MembersDirectoryState> emit,
  ) async {
    await _fetch(emit, query: _normalizeQuery(event.query), append: false);
  }

  Future<void> _onLoadMore(
    MembersDirectoryLoadMoreRequested event,
    Emitter<MembersDirectoryState> emit,
  ) async {
    if (!state.hasMore ||
        state.loadingMore ||
        state.status == LoadStatus.loading) {
      return;
    }
    await _fetch(
      emit,
      query: state.query,
      cursor: state.nextCursor,
      append: true,
    );
  }

  Future<void> _fetch(
    Emitter<MembersDirectoryState> emit, {
    required String? query,
    String? cursor,
    required bool append,
  }) async {
    if (append) {
      emit(
        state.copyWith(
          status: LoadStatus.success,
          loadingMore: true,
          failure: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: LoadStatus.loading,
          failure: null,
          query: query,
          loadingMore: false,
        ),
      );
    }

    final result = await _listMembers(
      ListMembersParams(
        filter: MemberFilter(query: query),
        cursor: cursor,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoadStatus.failure,
          failure: failure,
          loadingMore: false,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: LoadStatus.success,
          items: append ? [...state.items, ...page.items] : page.items,
          hasMore: page.hasMore,
          nextCursor: page.nextCursor,
          query: query,
          loadingMore: false,
          failure: null,
        ),
      ),
    );
  }

  String? _normalizeQuery(String? query) {
    final trimmed = query?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
