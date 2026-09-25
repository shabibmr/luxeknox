import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/presentation/load_status.dart';
import '../../domain/entities/membership.dart';
import '../../domain/usecases/get_memberships_usecase.dart';

part 'memberships_directory_cubit.freezed.dart';

enum MembershipDirectoryFilter {
  all,
  active,
  expiringSoon,
  expired,
  frozen,
  cancelled,
}

@freezed
abstract class MembershipsDirectoryState with _$MembershipsDirectoryState {
  const factory MembershipsDirectoryState({
    @Default(LoadStatus.initial) LoadStatus status,
    @Default(<Membership>[]) List<Membership> items,
    @Default(MembershipDirectoryFilter.all) MembershipDirectoryFilter filter,
    Failure? failure,
  }) = _MembershipsDirectoryState;
}

@injectable
class MembershipsDirectoryCubit extends Cubit<MembershipsDirectoryState> {
  MembershipsDirectoryCubit(this._getMemberships)
    : super(const MembershipsDirectoryState());

  final GetMembershipsUseCase _getMemberships;

  static const int expiringWithinDays = 30;

  Future<void> load({MembershipDirectoryFilter? filter}) async {
    final next = filter ?? state.filter;
    emit(
      state.copyWith(
        status: LoadStatus.loading,
        failure: null,
        filter: next,
      ),
    );
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
    if (isClosed) return;
    result.fold(
      (failure) => emit(
        state.copyWith(status: LoadStatus.failure, failure: failure),
      ),
      (page) {
        final items = next == MembershipDirectoryFilter.expiringSoon
            ? page.items
                  .where((m) => m.daysUntilExpiry <= expiringWithinDays)
                  .toList()
            : page.items;
        emit(
          state.copyWith(
            status: LoadStatus.success,
            failure: null,
            items: items,
            filter: next,
          ),
        );
      },
    );
  }

  Future<void> setFilter(MembershipDirectoryFilter filter) =>
      load(filter: filter);
}
