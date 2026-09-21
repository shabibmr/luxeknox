import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failure_messages.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/get_memberships_usecase.dart';

enum MembershipDirectoryFilter {
  all,
  active,
  expiringSoon,
  expired,
  frozen,
  cancelled,
}

sealed class MembershipsDirectoryState extends Equatable {
  const MembershipsDirectoryState();

  @override
  List<Object?> get props => [];
}

final class MembershipsDirectoryLoading extends MembershipsDirectoryState {
  const MembershipsDirectoryLoading({
    this.filter = MembershipDirectoryFilter.all,
  });

  final MembershipDirectoryFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class MembershipsDirectoryLoaded extends MembershipsDirectoryState {
  const MembershipsDirectoryLoaded({
    required this.items,
    required this.filter,
  });

  final List<Membership> items;
  final MembershipDirectoryFilter filter;

  @override
  List<Object?> get props => [items, filter];
}

final class MembershipsDirectoryFailure extends MembershipsDirectoryState {
  const MembershipsDirectoryFailure(this.message, {required this.filter});

  final String message;
  final MembershipDirectoryFilter filter;

  @override
  List<Object?> get props => [message, filter];
}

@injectable
class MembershipsDirectoryCubit extends Cubit<MembershipsDirectoryState> {
  MembershipsDirectoryCubit(this._getMemberships)
    : super(
        const MembershipsDirectoryLoading(
          filter: MembershipDirectoryFilter.all,
        ),
      );

  final GetMembershipsUseCase _getMemberships;

  static const int expiringWithinDays = 30;

  MembershipDirectoryFilter get _filter {
    final s = state;
    return switch (s) {
      MembershipsDirectoryLoading(:final filter) => filter,
      MembershipsDirectoryLoaded(:final filter) => filter,
      MembershipsDirectoryFailure(:final filter) => filter,
    };
  }

  Future<void> load({MembershipDirectoryFilter? filter}) async {
    final next = filter ?? _filter;
    emit(MembershipsDirectoryLoading(filter: next));
    final apiStatus = switch (next) {
      MembershipDirectoryFilter.all => null,
      MembershipDirectoryFilter.active => 'active',
      MembershipDirectoryFilter.expiringSoon => 'active',
      MembershipDirectoryFilter.expired => 'expired',
      MembershipDirectoryFilter.frozen => 'frozen',
      MembershipDirectoryFilter.cancelled => 'cancelled',
    };
    final result = await _getMemberships(
      GetMembershipsParams(status: apiStatus),
    );
    result.fold(
      (failure) => emit(
        MembershipsDirectoryFailure(
          failureMessage(failure),
          filter: next,
        ),
      ),
      (page) {
        final items = next == MembershipDirectoryFilter.expiringSoon
            ? page.items
                  .where((m) => m.daysUntilExpiry <= expiringWithinDays)
                  .toList()
            : page.items;
        emit(MembershipsDirectoryLoaded(items: items, filter: next));
      },
    );
  }

  Future<void> setFilter(MembershipDirectoryFilter filter) =>
      load(filter: filter);
}
